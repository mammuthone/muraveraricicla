#!/usr/bin/env python3
"""Estrae il calendario raccolta da un PDF COSIR (muravera.cosir.org).

I PDF sono depliant a 2 pagine con 12 colonne mensili: 4 sulla prima pagina
(giugno–settembre) e 8 sulla seconda (ottobre–maggio). Ogni riga di una colonna
è "<giorno> <iniziale giorno settimana> <frazioni>".

Uso: parse_pdf.py <file.pdf> <anno-iniziale> > calendario.json
"""
import json
import re
import sys

import pdfplumber

MESI = [
    "GIUGNO", "LUGLIO", "AGOSTO", "SETTEMBRE", "OTTOBRE", "NOVEMBRE",
    "DICEMBRE", "GENNAIO", "FEBBRAIO", "MARZO", "APRILE", "MAGGIO",
]

# Il calendario copre giugno dell'anno N fino a maggio dell'anno N+1.
OFFSET_ANNO = {m: (0 if i < 7 else 1) for i, m in enumerate(MESI)}
NUMERO_MESE = {
    "GIUGNO": 6, "LUGLIO": 7, "AGOSTO": 8, "SETTEMBRE": 9, "OTTOBRE": 10,
    "NOVEMBRE": 11, "DICEMBRE": 12, "GENNAIO": 1, "FEBBRAIO": 2, "MARZO": 3,
    "APRILE": 4, "MAGGIO": 5,
}

FRAZIONI = {
    "UMIDO": "UM", "UM.": "UM", "UMIDO-ORGANICO": "UM",
    "SECCO": "SE",
    "PLASTICA": "PL", "PLAST.": "PL", "PLASTICHE": "PL",
    "CARTA": "CA", "CARTONE": "CA",
    "VETRO": "VL", "VETR.": "VL", "VET.": "VL",
    "LATTINE": "VL", "LATT.": "VL", "LAT.": "VL", "LATTIN.": "VL",
    "ALLUMINIO": "VL",
}

GIORNI_SETTIMANA = {"L", "M", "G", "V", "S", "D"}
TOLLERANZA_RIGA = 3.5   # punti: parole entro questa distanza stanno sulla stessa riga


def colonne(page):
    """(nome mese, inizio, fine) per ogni colonna della pagina.

    Le intestazioni dei mesi sono l'ancora più affidabile: sono in corpo grande
    e presenti una per colonna. I bordi si ricavano a metà strada fra due
    intestazioni consecutive.
    """
    intestazioni = [
        w for w in page.extract_words()
        if w["text"].upper() in NUMERO_MESE and w["bottom"] - w["top"] >= 13
    ]

    # Il titolo è stampato due volte (ombra): tiene una sola occorrenza per mese.
    uniche = []
    for w in sorted(intestazioni, key=lambda w: w["x0"]):
        centro = (w["x0"] + w["x1"]) / 2
        if uniche and centro - uniche[-1][1] < 40:
            continue
        uniche.append((w["text"].upper(), centro))

    # I bordi reali vengono dai numeri dei giorni: le intestazioni sono centrate
    # sulla colonna, mentre le righe sono allineate a sinistra e più strette.
    numeri = sorted(
        w["x0"] for w in page.extract_words()
        if re.fullmatch(r"(\d{1,2})(?:[LMGVSD][A-Z.]*)?", w["text"].upper())
        and 1 <= int(re.match(r"\d{1,2}", w["text"]).group()) <= 31
    )
    gruppi = []
    for x in numeri:
        # I numeri a una e due cifre cadono su due x0 vicini: stessa colonna.
        if gruppi and x - gruppi[-1][0] <= 25:
            gruppi[-1].append(x)
        else:
            gruppi.append([x])
    # Intestazioni e colonne di numeri sono entrambe ordinate da sinistra a
    # destra e in pari numero: si accoppiano per posizione. Cercare il gruppo
    # "più vicino" farebbe contendere la stessa colonna a due mesi adiacenti.
    # I gruppi in eccesso sono numeri sparsi nelle note a piè di pagina.
    gruppi = sorted(sorted(gruppi, key=len, reverse=True)[: len(uniche)])
    if len(gruppi) != len(uniche):
        raise SystemExit(
            f"colonne incoerenti: {len(uniche)} intestazioni, {len(gruppi)} colonne"
        )

    bordi = [(mese, min(g)) for (mese, _), g in zip(uniche, gruppi)]

    out = []
    for i, (mese, inizio) in enumerate(bordi):
        fine = bordi[i + 1][1] - 15 if i + 1 < len(bordi) else page.width
        out.append((mese, inizio - 15, fine))
    return out


def righe(parole):
    """Raggruppa le parole in righe usando la coordinata verticale."""
    out = []
    for w in sorted(parole, key=lambda w: (w["top"], w["x0"])):
        if out and abs(w["top"] - out[-1][0]) <= TOLLERANZA_RIGA:
            out[-1][1].append(w)
        else:
            out.append([w["top"], [w]])
    return [sorted(ws, key=lambda w: w["x0"]) for _, ws in out]


def leggi_pagina(page, bordi):
    """Ritorna [(mese, {giorno: [codici]})], una voce per colonna.

    Le righe si costruiscono dentro una sola colonna alla volta: raggruppare
    l'intera pagina farebbe incatenare righe di colonne diverse.
    """
    parole = page.extract_words()
    risultati = []

    for mese, inizio, fine in bordi:
        colonna = [w for w in parole if inizio <= w["x0"] < fine]

        giorni = {}
        for riga in righe(colonna):
            testi = normalizza([w["text"] for w in riga])
            if len(testi) < 2 or not re.fullmatch(r"\d{1,2}", testi[0]):
                continue
            giorno = int(testi[0])
            if not 1 <= giorno <= 31 or testi[1] not in GIORNI_SETTIMANA:
                continue

            codici = []
            for t in testi[2:]:
                c = FRAZIONI.get(t.rstrip(","))
                if c and c not in codici:
                    codici.append(c)
            if codici:
                giorni[giorno] = codici
        risultati.append((mese, giorni))

    return risultati


def normalizza(testi):
    """Stacca i token che il PDF incolla per mancanza di spazio tipografico.

    "9 M SECCO" può uscire come "9", "MSECCO" e "1 G UMIDO" come "1G", "UMIDO".
    """
    out = []
    for t in testi:
        t = t.upper()
        # "1G" -> "1", "G"
        m = re.fullmatch(r"(\d{1,2})([LMGVSD][A-Z.]*)", t)
        if m:
            out.append(m.group(1))
            t = m.group(2)
        # "MSECCO" -> "M", "SECCO". Solo se il resto è davvero una frazione,
        # altrimenti "VETRO" verrebbe letto come V + ETRO.
        m = re.fullmatch(r"([LMGVSD])([A-Z][A-Z.]*)", t)
        if t not in FRAZIONI and m and m.group(2) in FRAZIONI:
            out.extend(m.groups())
        else:
            out.append(t)
    return out


def main():
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    percorso, anno = sys.argv[1], int(sys.argv[2])

    per_mese = {}
    with pdfplumber.open(percorso) as pdf:
        for page in pdf.pages:
            for mese, giorni in leggi_pagina(page, colonne(page)):
                per_mese[mese] = giorni

    mancanti = [m for m in MESI if m not in per_mese]
    if mancanti:
        print(f"ATTENZIONE: colonne non trovate: {mancanti}", file=sys.stderr)

    out = {}
    for mese, giorni in per_mese.items():
        y = anno + OFFSET_ANNO[mese]
        m = NUMERO_MESE[mese]
        for d, codici in sorted(giorni.items()):
            out[f"{y:04d}-{m:02d}-{d:02d}"] = codici

    print(f"{len(out)} giornate di raccolta estratte", file=sys.stderr)
    json.dump(dict(sorted(out.items())), sys.stdout, ensure_ascii=False, indent=0,
              separators=(",", ":"))


if __name__ == "__main__":
    main()
