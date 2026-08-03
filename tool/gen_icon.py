#!/usr/bin/env python3
"""Genera l'icona dell'app: assets/icon/icon.png (1024×1024).

Simbolo del riciclo su fondo blu-turchese, la stessa palette dell'app. Niente
stemma comunale: l'icona non deve far pensare a un'app ufficiale del Comune.

Uso: gen_icon.py
"""
import math
import pathlib

from PIL import Image, ImageDraw

LATO = 1024
SCALA = 4  # disegna in grande e riduce: antialiasing a mano

SFONDO_ALTO = (18, 69, 94)
SFONDO_BASSO = (7, 24, 35)
TURCHESE = (43, 179, 224)
VERDE = (25, 195, 166)


def sfondo(lato):
    img = Image.new("RGB", (lato, lato))
    d = ImageDraw.Draw(img)
    for y in range(lato):
        t = y / lato
        # Curva morbida: il colore chiaro resta concentrato in alto.
        t = t ** 0.85
        d.line(
            [(0, y), (lato, y)],
            fill=tuple(
                round(a + (b - a) * t) for a, b in zip(SFONDO_ALTO, SFONDO_BASSO)
            ),
        )
    return img


def freccia(d, lato, angolo_gradi, colore):
    """Un braccio del simbolo del riciclo: arco spesso + punta triangolare."""
    centro = lato / 2
    raggio = lato * 0.30
    spessore = round(lato * 0.088)

    inizio = angolo_gradi + 12
    fine = angolo_gradi + 96
    d.arc(
        [centro - raggio, centro - raggio, centro + raggio, centro + raggio],
        start=inizio,
        end=fine,
        fill=colore,
        width=spessore,
    )

    # Punta all'estremità dell'arco, tangente alla circonferenza.
    a = math.radians(fine)
    px, py = centro + raggio * math.cos(a), centro + raggio * math.sin(a)
    tang = a + math.pi / 2
    lung = spessore * 1.5
    larg = spessore * 1.15
    d.polygon(
        [
            (px + lung * math.cos(tang), py + lung * math.sin(tang)),
            (px + larg * math.cos(a), py + larg * math.sin(a)),
            (px - larg * math.cos(a), py - larg * math.sin(a)),
        ],
        fill=colore,
    )


def main():
    lato = LATO * SCALA
    img = sfondo(lato)
    d = ImageDraw.Draw(img)

    # Tre bracci a 120°, sfumati da turchese a verde per dare profondità.
    for i, angolo in enumerate((-90, 30, 150)):
        t = i / 2
        colore = tuple(round(a + (b - a) * t) for a, b in zip(TURCHESE, VERDE))
        freccia(d, lato, angolo, colore)

    img = img.resize((LATO, LATO), Image.LANCZOS)

    out = pathlib.Path("assets/icon")
    out.mkdir(parents=True, exist_ok=True)
    img.save(out / "icon.png")

    # Variante per il foreground adattivo Android: soggetto più piccolo,
    # il sistema ne ritaglia i bordi.
    fg = Image.new("RGBA", (LATO, LATO), (0, 0, 0, 0))
    contenuto = img.resize((round(LATO * 0.62),) * 2, Image.LANCZOS)
    mask = Image.new("L", contenuto.size, 0)
    ImageDraw.Draw(mask).ellipse([0, 0, *contenuto.size], fill=255)
    fg.paste(contenuto, ((LATO - contenuto.width) // 2,) * 2, mask)
    fg.save(out / "icon_foreground.png")

    print("scritti assets/icon/icon.png e icon_foreground.png")


if __name__ == "__main__":
    main()
