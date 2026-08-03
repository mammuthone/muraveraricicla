#!/usr/bin/env python3
"""Genera la grafica richiesta dal Play Store in store/graphics/.

- feature_graphic.png 1024×500 (obbligatoria)
- icon_512.png 512×512

Uso: gen_store_graphics.py
"""
import pathlib

from PIL import Image, ImageDraw, ImageFont

SFONDO_ALTO = (18, 69, 94)
SFONDO_BASSO = (7, 24, 35)
BIANCO = (255, 255, 255)
TURCHESE = (43, 179, 224)

CANDIDATI_FONT = [
    "/System/Library/Fonts/Supplemental/Arial Bold.ttf",
    "/System/Library/Fonts/Helvetica.ttc",
    "/Library/Fonts/Arial Bold.ttf",
]


def font(dimensione):
    for percorso in CANDIDATI_FONT:
        if pathlib.Path(percorso).exists():
            try:
                return ImageFont.truetype(percorso, dimensione)
            except OSError:
                continue
    return ImageFont.load_default(dimensione)


def main():
    out = pathlib.Path("store/graphics")
    out.mkdir(parents=True, exist_ok=True)

    icona = Image.open("assets/icon/icon.png")
    icona.resize((512, 512), Image.LANCZOS).save(out / "icon_512.png")

    larghezza, altezza = 1024, 500
    img = Image.new("RGB", (larghezza, altezza))
    d = ImageDraw.Draw(img)

    # Sfondo diagonale: più chiaro in alto a sinistra, dove sta il simbolo.
    for y in range(altezza):
        for blocco in range(0, larghezza, 8):
            t = min(1.0, (blocco / larghezza * 0.6 + y / altezza * 0.7))
            d.rectangle(
                [blocco, y, blocco + 8, y + 1],
                fill=tuple(
                    round(a + (b - a) * t)
                    for a, b in zip(SFONDO_ALTO, SFONDO_BASSO)
                ),
            )

    # Simbolo a sinistra, senza cornice: il quadrato dell'icona qui stonerebbe.
    lato = 300
    simbolo = icona.resize((lato, lato), Image.LANCZOS).convert("RGB")
    maschera = Image.new("L", (lato, lato), 0)
    ImageDraw.Draw(maschera).ellipse([0, 0, lato, lato], fill=255)
    img.paste(simbolo, (72, (altezza - lato) // 2), maschera)

    x = 72 + lato + 64
    d.text((x, 178), "MURAVERA", font=font(74), fill=BIANCO)
    d.text((x, 262), "Raccolta differenziata", font=font(38), fill=TURCHESE)

    img.save(out / "feature_graphic.png")
    print(f"scritti {out}/feature_graphic.png e icon_512.png")


if __name__ == "__main__":
    main()
