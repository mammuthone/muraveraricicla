#!/usr/bin/env bash
# Cattura gli screenshot per App Store e Play Store.
#
# Uso:
#   tool/screenshots.sh <udid-simulatore> <cartella-output> [lingua]
#
# Lo script avvia l'app, poi si ferma a ogni schermata e aspetta INVIO: naviga
# tu sul simulatore e premi INVIO per scattare. Le tab non sono pilotabili da
# riga di comando, quindi la navigazione resta manuale.
#
# Dimensioni richieste dagli store (agosto 2026):
#   App Store  — 6.9" (1320×2868 o 1290×2796) obbligatorio; 6.5" consigliato;
#                iPad 13" obbligatorio solo se l'app supporta iPad.
#   Play Store — telefono: min 1080 px sul lato lungo, 2 screenshot minimo,
#                8 massimo. Più feature graphic 1024×500.

set -euo pipefail

UDID="${1:?serve l'udid del simulatore (xcrun simctl list devices)}"
OUT="${2:?serve la cartella di output}"
LINGUA="${3:-it}"

SCHERMATE=(oggi calendario ecocentri guida impostazioni)

mkdir -p "$OUT/$LINGUA"

echo "Avvio dell'app su $UDID…"
flutter run -d "$UDID" --release &
FLUTTER_PID=$!
trap 'kill $FLUTTER_PID 2>/dev/null || true' EXIT

echo "Attendo l'avvio, poi imposta la lingua $LINGUA nelle impostazioni dell'app."
read -rp "Premi INVIO quando l'app è pronta… "

for nome in "${SCHERMATE[@]}"; do
  read -rp "Vai su '$nome' e premi INVIO per scattare… "
  xcrun simctl io "$UDID" screenshot "$OUT/$LINGUA/$nome.png"
  echo "  → $OUT/$LINGUA/$nome.png"
done

echo
echo "Fatto. Screenshot in $OUT/$LINGUA:"
ls -1 "$OUT/$LINGUA"
