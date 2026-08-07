# Scaletta di pubblicazione

Stato: `[ ]` da fare · `[~]` fatto parzialmente · `[x]` fatto

---

## 0. Blocchi da sciogliere prima di tutto

Nessuno di questi è un problema tecnico: sono autorizzazioni. Vanno chiuse
prima di caricare, perché sia Apple sia Google rimuovono le app che sembrano
ufficiali senza esserlo.

- [x] ~~Identificativo dell'app~~: ora è `com.sardinialabs.muraveraricicla`.
      Non cambiarlo più dopo il primo caricamento: su entrambi gli store è
      definitivo.
- [x] ~~Stemma del Comune~~: rimosso. Al suo posto l'icona dell'app, che non
      richiede autorizzazioni.
- [ ] **Foto della hero** (`assets/images/hero_costa_rei.jpg`): presa dal sito
      del Comune. Serve autorizzazione o sostituzione con foto propria/licenza
      libera. Va comunque sostituita: è 600×336, troppo piccola.
- [ ] **Dati COSIR**: comunicare a COSIR/Comune che l'app esiste. L'app dichiara
      già di non essere ufficiale (pulsante "?" in home, sezione nella Guida),
      ma un ok scritto evita rimozioni su segnalazione.
- [ ] **Nome pubblico dell'app**: ancora "Muravera Ricicla" in
      `ios/Runner/Info.plist` e `android/app/src/main/AndroidManifest.xml`.
      Rimasto in sospeso.

---

## 1. Preparazione comune

- [x] Icona 1024×1024 generata (`tool/gen_icon.py` → `assets/icon/icon.png`)
- [x] Icone di lancio generate per iOS e Android (`flutter_launcher_icons`)
- [x] Versione `1.0.0+1` in `pubspec.yaml`
- [ ] Rileggere i testi store in `store/` (5 lingue)
- [~] Privacy policy: pagina pronta in `docs/privacy.html`, già sul repo. Manca
      **abilitare GitHub Pages** (impostazioni del repo → Pages → branch `main`,
      cartella `/docs`). L'URL sarà
      `https://mammuthone.github.io/muraveraricicla/privacy.html`
- [x] Schermata di avvio animata (`lib/widgets/logo_animato.dart`)
- [x] `ReviewService.appStoreId` = `6799002753`

### Cosa dichiarare sulla privacy

L'app **non raccoglie né trasmette dati personali**. Da dichiarare comunque:

| Aspetto | Situazione |
| --- | --- |
| Account | nessuno |
| Analytics / crash reporting | nessuno |
| Dati salvati | solo in locale: zona, lingua, orario promemoria |
| Rete | solo le tile della mappa da `tile.openstreetmap.org` |
| Permessi | notifiche (facoltativo, chiesto solo se attivi i promemoria) |
| Posizione | **non richiesta** — la mappa non centra sull'utente |
| Pubblicità | nessuna |

---

## 2. iOS — App Store

### Account e firma
- [ ] Apple Developer Program attivo (99 €/anno)
- [x] App ID `com.sardinialabs.muraveraricicla` registrato
- [x] App creata su App Store Connect — Apple ID `6799002753`
- [ ] Certificato di distribuzione e provisioning profile
- [ ] App creata su App Store Connect

### Progetto
- [x] Team di firma `3JFT6Q8DM2`
- [x] Deployment target 15.0, anche nel Podfile
- [x] `PrivacyInfo.xcprivacy` nel target Runner, verificato dentro Runner.app
- [ ] Descrizione d'uso delle notifiche non serve (le chiede il sistema), ma
      verifica che non restino chiavi inutili in `Info.plist`
- [x] Solo iPhone (`TARGETED_DEVICE_FAMILY = 1`): niente screenshot iPad
- [x] Launch image e sfondo dello storyboard al posto del placeholder Flutter

### Screenshot
Obbligatori per **6.9"** (1320×2868 o 1290×2796). Simulatore: **iPhone 17 Pro Max**.

```
tool/screenshots.sh <udid-iphone-17-pro-max> store/screenshots/ios it
```

- [x] Italiano: 4 schermate 1320×2868 in `store/screenshots/ios/it/`
- [ ] en, fr, de, es se vuoi schede localizzate (facoltativo)

I simulatori iOS **non supportano la modalità release**: gli screenshot si
catturano in debug. Il banner non compare perché `debugShowCheckedModeBanner`
è già disattivato.

### Caricamento
- [ ] `flutter build ipa --release`
- [ ] Upload con Transporter o `xcrun altool`
- [ ] Compilare la scheda in App Store Connect con i testi di `store/`
- [ ] Rispondere al questionario privacy ("Data Not Collected")
- [ ] Inviare in revisione. Nelle note per il revisore **scrivi esplicitamente
      che l'app non è ufficiale e che i dati vengono dal calendario pubblico
      COSIR**, allegando il link ai PDF. Evita il rifiuto per Guideline 5.2.1
      (uso di marchi di terzi).

---

## 3. Android — Google Play

### Account e firma
- [x] Account Google Play Console: **SardiniaLab**, con app già in produzione
- [x] Verifica dello sviluppatore completata. L'obbligo dei 20 tester per 14
      giorni **non si applica**: riguarda solo gli account personali che non
      hanno mai pubblicato. Si può andare in produzione diretto.
- [ ] Keystore di upload creato e messo al sicuro (fuori dal repo)
- [ ] Play App Signing attivo

### Progetto
- [x] Firma di release cablata: legge `android/key.properties`. Senza quel file
      la release resta firmata in debug, quindi non caricabile — è voluto
- [x] `proguard-rules.pro` con le regole per `flutter_local_notifications`
      (usa Gson via reflection: senza le regole le notifiche si rompono in
      release, non in debug)
- [x] Minify e shrink attivi sulla release
- [ ] Verificare che `targetSdk` sia quello richiesto da Play per il 2026
      (ora eredita da Flutter: compileSdk 36, minSdk 24)
- [ ] `RECEIVE_BOOT_COMPLETED` e `POST_NOTIFICATIONS` già dichiarati e usati
- [ ] `SCHEDULE_EXACT_ALARM` **non** è dichiarato ed è corretto così: i
      promemoria usano `inexactAllowWhileIdle`, che non lo richiede e non ha
      bisogno di giustificazione a Google

### Grafica
- [x] **Feature graphic 1024×500** e **icona 512×512** generate in
      `store/graphics/` (`tool/gen_store_graphics.py`)
- [x] Screenshot telefono in `store/screenshots/android/it/` — 4 schermate a
      1080×2400, catturate dall'emulatore in italiano, zona Costa Rei

### Dati per la scheda Play
| Campo | Valore |
| --- | --- |
| Nome app | Muravera Ricicla |
| Nome pacchetto | `com.sardinialabs.muraveraricicla` |
| Lingua predefinita | Italiano – it-IT |
| Tipo | App, senza costi |
| Categoria | Strumenti (o Stile di vita) |

### Caricamento
- [x] `flutter build appbundle --release` →
      `build/app/outputs/bundle/release/app-release.aab` (43 MB; il download per
      l'utente è circa 16 MB, gli split per ABI lo riducono)
- [ ] L'aggiornamento in-app funziona **solo** su build installate dal Play
      Store: in debug e da sideload `checkForUpdate` fallisce sempre. Si prova
      dal canale di test interno, non in locale.
- [ ] Caricare su closed testing, poi produzione
- [ ] Compilare **Data safety**: "No data collected", "No data shared"
- [ ] Compilare il questionario sui contenuti (classificazione PEGI/IARC)
- [ ] Indicare la categoria: *Strumenti* o *Stile di vita*

---

## 4. Dopo la pubblicazione

- [ ] Il calendario copre **giugno 2026 – maggio 2027**. Da maggio 2027 l'app
      mostra "nessuna raccolta" per sempre. Serve un promemoria a **aprile 2027**
      per rigenerare gli asset dai nuovi PDF con `tool/parse_pdf.py`.
- [ ] Valutare se caricare i calendari da rete invece che come asset, così un
      aggiornamento dei dati non richiede una nuova versione sugli store.
