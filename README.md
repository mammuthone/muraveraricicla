# Muravera Ricicla

App del calendario raccolta differenziata del Comune di Muravera (gestore COSIR).

## Sezioni

| Sezione | Contenuto |
| --- | --- |
| **Scelta zona** | Primo avvio: zona + tipo di utenza. Determina quale calendario caricare |
| **Oggi** | Cosa si conferisce oggi + le prossime 6 raccolte |
| **Calendario** | Griglia mensile giugno 2026 → maggio 2027, dettaglio per giorno |
| **Ecocentri** | Mappa con i due ecocentri, orari stagionali, indicazioni stradali |
| **Guida** | Cosa va in ogni frazione, come conferire, servizi su prenotazione, contatti |
| **Impostazioni** | Cambio zona, promemoria la sera prima, scelta della lingua |

Le chip delle frazioni sono tappabili ovunque: aprono la scheda della guida in
un bottom sheet.

Lingue: italiano, inglese, francese, tedesco, spagnolo (`lib/l10n/*.arb`).

Nessuna ricerca per via: il calendario è per zona, non per strada.

## Dati

COSIR pubblica **sei** calendari 2026-2027. Sono tutti in app, i PDF sorgente in
`tool/pdf/`:

| Zona | Utenze domestiche | Utenze non domestiche | Giornate |
| --- | --- | --- | --- |
| Zona A | calendario unico | calendario unico | 304 |
| Zona B | calendario unico | calendario unico | 304 |
| Costa Rei | `cal_costa_rei_ud` | `cal_costa_rei_und` | 215 / 234 |
| Comprensorio rurale | `cal_rurale_ud` | `cal_rurale_und` | 200 / 221 |

Gli asset si rigenerano dai PDF con `tool/parse_pdf.py` (richiede `pdfplumber`):

```
tool/parse_pdf.py tool/pdf/Costa-Rei-UD.pdf 2026 > assets/json/cal_costa_rei_ud.json
```

Codici frazione: `UM` umido, `SE` secco, `PL` plastica, `CA` carta,
`VL` vetro e lattine.

Il parser è stato validato confrontando l'estrazione di `Costa-Rei-UD` con una
trascrizione manuale del calendario cartaceo: identiche giorno per giorno.
Confermato anche che **lunedì 30 novembre 2026 non ha raccolta** — è così anche
nel PDF ufficiale, non è un difetto della stampa.

### Da verificare

- **Coordinate degli ecocentri** (`lib/data/ecocentri.dart`) sono approssimate a
  partire dagli indirizzi, non rilevate sul posto.
- **Confini di Zona A e Zona B**: le descrizioni ("settore A", "settore B") sono
  segnaposto. Serve la mappa delle zone dal Comune per spiegare all'utente quale
  scegliere.

## Risorse di terze parti

| File | Origine | Stato |
| --- | --- | --- |
| `assets/images/hero_costa_rei.jpg` | Carousel di `comunedimuravera.it` | **da autorizzare** |
| `tool/pdf/*.pdf` | `muravera.cosir.org` | fonte dati, non inclusa nel bundle |

Prima della pubblicazione servono:

1. Autorizzazione per la **foto**, oppure sostituzione con una foto propria o con
   licenza libera. Quella attuale è comunque a bassa risoluzione (600×336) e va
   sostituita con almeno 1600 px di larghezza.
2. Conferma da COSIR/Comune che l'app possa essere pubblicata come iniziativa
   non ufficiale. L'app lo dichiara già in home (pulsante "?") e nella Guida.

## Sviluppo

```
flutter pub get
flutter run
```
