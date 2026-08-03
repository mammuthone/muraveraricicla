import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
  ];

  /// No description provided for @appSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Raccolta differenziata'**
  String get appSubtitle;

  /// No description provided for @navToday.
  ///
  /// In it, this message translates to:
  /// **'Oggi'**
  String get navToday;

  /// No description provided for @navCalendar.
  ///
  /// In it, this message translates to:
  /// **'Calendario'**
  String get navCalendar;

  /// No description provided for @navEcocentri.
  ///
  /// In it, this message translates to:
  /// **'Ecocentri'**
  String get navEcocentri;

  /// No description provided for @navGuide.
  ///
  /// In it, this message translates to:
  /// **'Guida'**
  String get navGuide;

  /// No description provided for @todayLabel.
  ///
  /// In it, this message translates to:
  /// **'OGGI'**
  String get todayLabel;

  /// No description provided for @noCollection.
  ///
  /// In it, this message translates to:
  /// **'Nessuna raccolta'**
  String get noCollection;

  /// No description provided for @nextCollections.
  ///
  /// In it, this message translates to:
  /// **'Prossime raccolte'**
  String get nextCollections;

  /// No description provided for @reminderSection.
  ///
  /// In it, this message translates to:
  /// **'Promemoria'**
  String get reminderSection;

  /// No description provided for @exposureRule.
  ///
  /// In it, this message translates to:
  /// **'Esponi i rifiuti entro le 06:00 del mattino, oppure la sera prima dopo le 22:00.'**
  String get exposureRule;

  /// No description provided for @exposureRuleShort.
  ///
  /// In it, this message translates to:
  /// **'Esponi entro le 06:00 del mattino, oppure la sera prima dopo le 22:00.'**
  String get exposureRuleShort;

  /// No description provided for @unofficialApp.
  ///
  /// In it, this message translates to:
  /// **'App non ufficiale'**
  String get unofficialApp;

  /// No description provided for @unofficialAppNote.
  ///
  /// In it, this message translates to:
  /// **'Non affiliata al Comune di Muravera né a COSIR. I dati sono trascritti dal calendario cartaceo: in caso di dubbio fa fede quello ufficiale.'**
  String get unofficialAppNote;

  /// No description provided for @legend.
  ///
  /// In it, this message translates to:
  /// **'Legenda'**
  String get legend;

  /// No description provided for @noCollectionPlanned.
  ///
  /// In it, this message translates to:
  /// **'Nessuna raccolta prevista.'**
  String get noCollectionPlanned;

  /// Iniziali dei sette giorni da lunedì a domenica, separate da virgola
  ///
  /// In it, this message translates to:
  /// **'L,M,M,G,V,S,D'**
  String get weekdayInitials;

  /// No description provided for @wasteUmido.
  ///
  /// In it, this message translates to:
  /// **'Umido'**
  String get wasteUmido;

  /// No description provided for @wasteUmidoSub.
  ///
  /// In it, this message translates to:
  /// **'Organico'**
  String get wasteUmidoSub;

  /// No description provided for @wasteUmidoWhere.
  ///
  /// In it, this message translates to:
  /// **'Apposito contenitore, nel sacchetto compostabile'**
  String get wasteUmidoWhere;

  /// No description provided for @wasteUmidoWhat.
  ///
  /// In it, this message translates to:
  /// **'Frutta, verdura, uova, pesce e i suoi residui, crostacei, gusci di cozze e vongole, carne e piccoli ossi, pane, pasta, riso, resti di pietanze, scarti di cucina e alimenti avariati, fondi di caffè, filtri di thè e camomilla, tovaglioli e fazzoletti di carta con residui di cibo, escrementi e lettiere di piccoli animali domestici (se compostabili, a base di argilla, segatura, trucioli, sabbia naturale). Piccole quantità di residui vegetali e fiori recisi, ceneri spente di caminetti, piatti, bicchieri e altri imballaggi compostabili.'**
  String get wasteUmidoWhat;

  /// No description provided for @wasteSecco.
  ///
  /// In it, this message translates to:
  /// **'Secco'**
  String get wasteSecco;

  /// No description provided for @wasteSeccoSub.
  ///
  /// In it, this message translates to:
  /// **'Indifferenziato'**
  String get wasteSeccoSub;

  /// No description provided for @wasteSeccoWhere.
  ///
  /// In it, this message translates to:
  /// **'Apposito contenitore, nel sacchetto semi trasparente'**
  String get wasteSeccoWhere;

  /// No description provided for @wasteSeccoWhat.
  ///
  /// In it, this message translates to:
  /// **'Involucri con residui alimentari (es. di macellerie, pescherie, rosticcerie), gomma, cassette musicali, videocassette, cd e dvd, posate di plastica, penne, piccoli oggetti in plastica e bakelite, accessori per i capelli e per l\'igiene personale (spazzolini per i denti, spazzole e pettini per i capelli, pinze, fermagli), carta carbone, carta plastificata, calze di nylon, sacchi di juta, stracci non più riutilizzabili, garze di medicazione, cerotti e siringhe, aghi, pannolini, traverse, assorbenti, carta igienica e carta assorbente usata, cosmetici, piume di materiali di origine sintetica. Piatti, tazze e tazzine in ceramica e cocci in genere, specchi rotti. Polveri dell\'aspirapolvere e delle pulizie domestiche, piccoli oggetti in legno verniciato, mozziconi di sigarette, tutti gli oggetti formati da più di una materia (escluso il tetrapak) in cui risulti impossibile la separazione.'**
  String get wasteSeccoWhat;

  /// No description provided for @wastePlastica.
  ///
  /// In it, this message translates to:
  /// **'Plastica'**
  String get wastePlastica;

  /// No description provided for @wastePlasticaSub.
  ///
  /// In it, this message translates to:
  /// **'Imballaggi in plastica'**
  String get wastePlasticaSub;

  /// No description provided for @wastePlasticaWhere.
  ///
  /// In it, this message translates to:
  /// **'Apposito contenitore, nel sacchetto semi trasparente'**
  String get wastePlasticaWhere;

  /// No description provided for @wastePlasticaWhat.
  ///
  /// In it, this message translates to:
  /// **'Bottiglie d\'acqua in plastica, succhi, latte, contenitori di yogurt, creme di formaggio e dessert, cibo per animali, contenitori per detersivi e flaconi per l\'igiene. Buste, sacchetti e contenitori per alimenti (brioches, patatine, surgelati, pasta, riso, carne e pesce), cellophane. Vaschette porta uova, vaschette e imballaggi in polistirolo, reti per frutta e verdura. Cassette per frutta e verdura (1 pezzo per ciascuna giornata di raccolta per utenza domestica). Taniche e bidoni puliti, piatti e bicchieri in plastica, grucce appendi abiti.'**
  String get wastePlasticaWhat;

  /// No description provided for @wasteCarta.
  ///
  /// In it, this message translates to:
  /// **'Carta'**
  String get wasteCarta;

  /// No description provided for @wasteCartaSub.
  ///
  /// In it, this message translates to:
  /// **'Carta e cartone'**
  String get wasteCartaSub;

  /// No description provided for @wasteCartaWhere.
  ///
  /// In it, this message translates to:
  /// **'Apposito contenitore, in scatole di cartone o sacchetti di carta'**
  String get wasteCartaWhere;

  /// No description provided for @wasteCartaWhat.
  ///
  /// In it, this message translates to:
  /// **'Giornali, riviste, volantini pubblicitari, scatole di cartone, scatole per alimenti (es. riso, pasta, zucchero), cartoni per pizza, carta da fotocopie usata, libri e quaderni, contenitori in tetrapak (es. brick di latte, succhi di frutta, passata di pomodoro).'**
  String get wasteCartaWhat;

  /// No description provided for @wasteVetro.
  ///
  /// In it, this message translates to:
  /// **'Vetro e lattine'**
  String get wasteVetro;

  /// No description provided for @wasteVetroSub.
  ///
  /// In it, this message translates to:
  /// **'Vetro e alluminio'**
  String get wasteVetroSub;

  /// No description provided for @wasteVetroWhere.
  ///
  /// In it, this message translates to:
  /// **'Apposito contenitore senza sacchetto (vetro e alluminio insieme)'**
  String get wasteVetroWhere;

  /// No description provided for @wasteVetroWhat.
  ///
  /// In it, this message translates to:
  /// **'Bottiglie, damigiane, boccioni, vasi, bicchieri e barattoli di vetro. Lattine per bevande, vaschette food, stagnola (es. coperchi dello yogurt), scatole per alimenti (tonno, carne, pesce, legumi, pomodori pelati), vaschette (per dolci, surgelati e alimenti vari), tubetti (concentrato di pomodoro, maionese, pasta d\'acciughe), tubetti cosmesi, tappi e capsule in alluminio, bombolette spray di panna, deodoranti, lacche, schiuma da barba.'**
  String get wasteVetroWhat;

  /// No description provided for @sheetWhere.
  ///
  /// In it, this message translates to:
  /// **'Dove'**
  String get sheetWhere;

  /// No description provided for @sheetWhat.
  ///
  /// In it, this message translates to:
  /// **'Cosa conferire'**
  String get sheetWhat;

  /// No description provided for @guideTitle.
  ///
  /// In it, this message translates to:
  /// **'Come differenziare'**
  String get guideTitle;

  /// No description provided for @howToDeliver.
  ///
  /// In it, this message translates to:
  /// **'Come conferire'**
  String get howToDeliver;

  /// No description provided for @howToDeliver1.
  ///
  /// In it, this message translates to:
  /// **'Conferire i rifiuti nei giorni indicati nel calendario, entro le ore 06:00 del mattino o in alternativa la sera prima dopo le ore 22:00.'**
  String get howToDeliver1;

  /// No description provided for @howToDeliver2.
  ///
  /// In it, this message translates to:
  /// **'Conferire l\'umido all\'interno del contenitore marrone da esterno, nell\'apposito sacchetto compostabile.'**
  String get howToDeliver2;

  /// No description provided for @howToDeliver3.
  ///
  /// In it, this message translates to:
  /// **'Conferire la carta all\'interno del contenitore, in scatole di cartone o sacchi di carta: non utilizzare sacchetti in plastica.'**
  String get howToDeliver3;

  /// No description provided for @howToDeliver4.
  ///
  /// In it, this message translates to:
  /// **'Conferire vetro/alluminio congiuntamente, senza sacchetto, all\'interno del mastello verde.'**
  String get howToDeliver4;

  /// No description provided for @whyNotCollected.
  ///
  /// In it, this message translates to:
  /// **'Perché non hanno ritirato i miei rifiuti?'**
  String get whyNotCollected;

  /// No description provided for @whyNotCollected1.
  ///
  /// In it, this message translates to:
  /// **'All\'interno della busta/contenitore ci sono rifiuti non conformi.'**
  String get whyNotCollected1;

  /// No description provided for @whyNotCollected2.
  ///
  /// In it, this message translates to:
  /// **'I rifiuti non sono stati conferiti o esposti correttamente, violando le prescrizioni impartite attraverso il calendario.'**
  String get whyNotCollected2;

  /// No description provided for @whyNotCollected3.
  ///
  /// In it, this message translates to:
  /// **'Il rifiuto non è stato conferito nella fascia oraria prevista.'**
  String get whyNotCollected3;

  /// No description provided for @bookableServices.
  ///
  /// In it, this message translates to:
  /// **'Servizi su prenotazione'**
  String get bookableServices;

  /// No description provided for @bookableServicesIntro.
  ///
  /// In it, this message translates to:
  /// **'Accessibili telefonando al numero verde o alla rete fissa, dal lunedì al sabato dalle 09:00 alle 14:00.'**
  String get bookableServicesIntro;

  /// No description provided for @bookableService1.
  ///
  /// In it, this message translates to:
  /// **'Raccolta a domicilio di ex-RUP (pile, medicinali scaduti, bombolette e contenitori etichettati T e/o F) — una volta al mese'**
  String get bookableService1;

  /// No description provided for @bookableService2.
  ///
  /// In it, this message translates to:
  /// **'Raccolta a domicilio di rifiuti ingombranti — una volta alla settimana'**
  String get bookableService2;

  /// No description provided for @bookableService3.
  ///
  /// In it, this message translates to:
  /// **'Raccolta a domicilio di pannolini e tessili sanitari (aggiuntivo rispetto al secco) — una volta alla settimana'**
  String get bookableService3;

  /// No description provided for @bookableService4.
  ///
  /// In it, this message translates to:
  /// **'Raccolta a domicilio di toner, cartucce e nastri per stampanti — una volta alla settimana da giugno a settembre, una volta ogni due settimane da gennaio a maggio e da ottobre a dicembre'**
  String get bookableService4;

  /// No description provided for @bookableService5.
  ///
  /// In it, this message translates to:
  /// **'Raccolta a domicilio di sfalci — una volta alla settimana'**
  String get bookableService5;

  /// No description provided for @bookableService6.
  ///
  /// In it, this message translates to:
  /// **'Raccolta a domicilio di oli vegetali — una volta alla settimana'**
  String get bookableService6;

  /// No description provided for @bookableService7.
  ///
  /// In it, this message translates to:
  /// **'Raccolta a domicilio aggiuntiva del rifiuto umido-organico — una volta alla settimana da giugno a settembre'**
  String get bookableService7;

  /// No description provided for @bulky.
  ///
  /// In it, this message translates to:
  /// **'Ingombranti'**
  String get bulky;

  /// No description provided for @bulkyText.
  ///
  /// In it, this message translates to:
  /// **'Puoi prenotare il ritiro dei rifiuti ingombranti inviando una mail a ingombranti@cosir.org o collegandoti a ingombranti.cosir.org. Le prenotazioni online vengono convalidate solo dopo il contatto di un operatore. È possibile conferire massimo 5 ingombranti per volta.'**
  String get bulkyText;

  /// No description provided for @contacts.
  ///
  /// In it, this message translates to:
  /// **'Contatti'**
  String get contacts;

  /// No description provided for @contactGreenNumber.
  ///
  /// In it, this message translates to:
  /// **'Numero verde (da rete fissa)'**
  String get contactGreenNumber;

  /// No description provided for @contactLandline.
  ///
  /// In it, this message translates to:
  /// **'Rete fissa (da fisso e mobile)'**
  String get contactLandline;

  /// No description provided for @contactAutospurgo.
  ///
  /// In it, this message translates to:
  /// **'Autospurgo (servizio a pagamento)'**
  String get contactAutospurgo;

  /// No description provided for @contactEmergency.
  ///
  /// In it, this message translates to:
  /// **'Pronto intervento'**
  String get contactEmergency;

  /// No description provided for @contactEmail.
  ///
  /// In it, this message translates to:
  /// **'Email'**
  String get contactEmail;

  /// No description provided for @contactBulkyEmail.
  ///
  /// In it, this message translates to:
  /// **'Ingombranti'**
  String get contactBulkyEmail;

  /// No description provided for @contactWebsite.
  ///
  /// In it, this message translates to:
  /// **'Sito'**
  String get contactWebsite;

  /// No description provided for @showBoth.
  ///
  /// In it, this message translates to:
  /// **'Vedi entrambi'**
  String get showBoth;

  /// No description provided for @directions.
  ///
  /// In it, this message translates to:
  /// **'Indicazioni stradali'**
  String get directions;

  /// No description provided for @whatYouCanBring.
  ///
  /// In it, this message translates to:
  /// **'Cosa puoi conferire'**
  String get whatYouCanBring;

  /// No description provided for @tariNote.
  ///
  /// In it, this message translates to:
  /// **'Possono usufruire degli ecocentri esclusivamente gli utenti del Comune di Muravera regolarmente iscritti al ruolo TA.RI.'**
  String get tariNote;

  /// No description provided for @ecoItem1.
  ///
  /// In it, this message translates to:
  /// **'Sfalci e potature (residui vegetali da pulizia giardini e orti, legna e segatura non trattata, foglie)'**
  String get ecoItem1;

  /// No description provided for @ecoItem2.
  ///
  /// In it, this message translates to:
  /// **'Oli vegetali (olio alimentare da frittura)'**
  String get ecoItem2;

  /// No description provided for @ecoItem3.
  ///
  /// In it, this message translates to:
  /// **'Toner e nastri per stampanti'**
  String get ecoItem3;

  /// No description provided for @ecoItem4.
  ///
  /// In it, this message translates to:
  /// **'Batterie di automobili'**
  String get ecoItem4;

  /// No description provided for @ecoItem5.
  ///
  /// In it, this message translates to:
  /// **'Indumenti usati (abbigliamento in buono stato, coperte, tendaggi, lenzuola, asciugamani)'**
  String get ecoItem5;

  /// No description provided for @ecoItem6.
  ///
  /// In it, this message translates to:
  /// **'Inerti (calcinacci, piastrelle, sanitari, di sola provenienza domestica e non pericolosi)'**
  String get ecoItem6;

  /// No description provided for @ecoItem7.
  ///
  /// In it, this message translates to:
  /// **'Ingombranti'**
  String get ecoItem7;

  /// No description provided for @ecoMuraveraName.
  ///
  /// In it, this message translates to:
  /// **'Ecocentro Muravera'**
  String get ecoMuraveraName;

  /// No description provided for @ecoMuraveraAddress.
  ///
  /// In it, this message translates to:
  /// **'Via dei Platani, Muravera'**
  String get ecoMuraveraAddress;

  /// No description provided for @ecoCostaReiName.
  ///
  /// In it, this message translates to:
  /// **'Ecocentro Costa Rei'**
  String get ecoCostaReiName;

  /// No description provided for @ecoCostaReiAddress.
  ///
  /// In it, this message translates to:
  /// **'Loc. Piscina Rei, presso il vecchio depuratore'**
  String get ecoCostaReiAddress;

  /// No description provided for @periodOctApr.
  ///
  /// In it, this message translates to:
  /// **'Ottobre – Aprile'**
  String get periodOctApr;

  /// No description provided for @periodMaySep.
  ///
  /// In it, this message translates to:
  /// **'Maggio – Settembre'**
  String get periodMaySep;

  /// No description provided for @periodFerragosto.
  ///
  /// In it, this message translates to:
  /// **'Settimana di Ferragosto'**
  String get periodFerragosto;

  /// No description provided for @periodSantoStefano.
  ///
  /// In it, this message translates to:
  /// **'Settimana di Santo Stefano'**
  String get periodSantoStefano;

  /// No description provided for @periodPasquetta.
  ///
  /// In it, this message translates to:
  /// **'Settimana di Pasquetta'**
  String get periodPasquetta;

  /// No description provided for @schedMonSat.
  ///
  /// In it, this message translates to:
  /// **'{time} dal lunedì al sabato'**
  String schedMonSat(String time);

  /// No description provided for @schedSunday.
  ///
  /// In it, this message translates to:
  /// **'{time} la domenica'**
  String schedSunday(String time);

  /// No description provided for @schedMonSun.
  ///
  /// In it, this message translates to:
  /// **'{time} dal lunedì alla domenica'**
  String schedMonSun(String time);

  /// No description provided for @schedMonSunNoThu.
  ///
  /// In it, this message translates to:
  /// **'{time} dal lunedì alla domenica, chiusura il giovedì'**
  String schedMonSunNoThu(String time);

  /// No description provided for @schedTueThu.
  ///
  /// In it, this message translates to:
  /// **'{time} martedì e giovedì'**
  String schedTueThu(String time);

  /// No description provided for @settings.
  ///
  /// In it, this message translates to:
  /// **'Impostazioni'**
  String get settings;

  /// No description provided for @remindEveningBefore.
  ///
  /// In it, this message translates to:
  /// **'Avvisami la sera prima'**
  String get remindEveningBefore;

  /// No description provided for @remindSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Una notifica per ogni giornata di raccolta'**
  String get remindSubtitle;

  /// No description provided for @reminderTime.
  ///
  /// In it, this message translates to:
  /// **'Orario'**
  String get reminderTime;

  /// No description provided for @reminderTimeHelp.
  ///
  /// In it, this message translates to:
  /// **'Orario del promemoria'**
  String get reminderTimeHelp;

  /// No description provided for @reminderNote.
  ///
  /// In it, this message translates to:
  /// **'I promemoria vengono ripianificati a ogni avvio dell\'app. Se l\'app resta chiusa a lungo potresti ricevere solo i primi avvisi in programma.'**
  String get reminderNote;

  /// No description provided for @permissionDenied.
  ///
  /// In it, this message translates to:
  /// **'Permesso negato. Attiva le notifiche per questa app nelle impostazioni di sistema.'**
  String get permissionDenied;

  /// No description provided for @languageSection.
  ///
  /// In it, this message translates to:
  /// **'Lingua'**
  String get languageSection;

  /// No description provided for @languageSystem.
  ///
  /// In it, this message translates to:
  /// **'Lingua del dispositivo'**
  String get languageSystem;

  /// No description provided for @dataSection.
  ///
  /// In it, this message translates to:
  /// **'Dati'**
  String get dataSection;

  /// No description provided for @dataSource.
  ///
  /// In it, this message translates to:
  /// **'Calendario COSIR \"Comune di Muravera — Costa Rei utenze domestiche\", giugno 2026 – maggio 2027.'**
  String get dataSource;

  /// No description provided for @notifChannelName.
  ///
  /// In it, this message translates to:
  /// **'Promemoria raccolta'**
  String get notifChannelName;

  /// No description provided for @notifChannelDesc.
  ///
  /// In it, this message translates to:
  /// **'Avviso la sera prima di ogni giornata di raccolta differenziata'**
  String get notifChannelDesc;

  /// No description provided for @notifTitle.
  ///
  /// In it, this message translates to:
  /// **'Domani si conferisce'**
  String get notifTitle;

  /// No description provided for @chooseZoneTitle.
  ///
  /// In it, this message translates to:
  /// **'Dove ti trovi?'**
  String get chooseZoneTitle;

  /// No description provided for @chooseZoneSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Serve per mostrarti il calendario giusto. Puoi cambiarlo quando vuoi dalle impostazioni.'**
  String get chooseZoneSubtitle;

  /// No description provided for @chooseUserType.
  ///
  /// In it, this message translates to:
  /// **'Tipo di utenza'**
  String get chooseUserType;

  /// No description provided for @zoneSection.
  ///
  /// In it, this message translates to:
  /// **'Zona'**
  String get zoneSection;

  /// No description provided for @changeZone.
  ///
  /// In it, this message translates to:
  /// **'Cambia zona'**
  String get changeZone;

  /// No description provided for @confirm.
  ///
  /// In it, this message translates to:
  /// **'Conferma'**
  String get confirm;

  /// No description provided for @zoneA.
  ///
  /// In it, this message translates to:
  /// **'Zona A'**
  String get zoneA;

  /// No description provided for @zoneADesc.
  ///
  /// In it, this message translates to:
  /// **'Centro abitato di Muravera, settore A'**
  String get zoneADesc;

  /// No description provided for @zoneB.
  ///
  /// In it, this message translates to:
  /// **'Zona B'**
  String get zoneB;

  /// No description provided for @zoneBDesc.
  ///
  /// In it, this message translates to:
  /// **'Centro abitato di Muravera, settore B'**
  String get zoneBDesc;

  /// No description provided for @zoneCostaRei.
  ///
  /// In it, this message translates to:
  /// **'Costa Rei'**
  String get zoneCostaRei;

  /// No description provided for @zoneCostaReiDesc.
  ///
  /// In it, this message translates to:
  /// **'Costa Rei e Piscina Rei'**
  String get zoneCostaReiDesc;

  /// No description provided for @zoneRurale.
  ///
  /// In it, this message translates to:
  /// **'Comprensorio rurale'**
  String get zoneRurale;

  /// No description provided for @zoneRuraleDesc.
  ///
  /// In it, this message translates to:
  /// **'Case sparse e campagna'**
  String get zoneRuraleDesc;

  /// No description provided for @userDomestic.
  ///
  /// In it, this message translates to:
  /// **'utenze domestiche'**
  String get userDomestic;

  /// No description provided for @userNonDomestic.
  ///
  /// In it, this message translates to:
  /// **'utenze non domestiche'**
  String get userNonDomestic;

  /// No description provided for @sameCalendarBothTypes.
  ///
  /// In it, this message translates to:
  /// **'In questa zona il calendario è lo stesso per utenze domestiche e non domestiche.'**
  String get sameCalendarBothTypes;

  /// No description provided for @rateApp.
  ///
  /// In it, this message translates to:
  /// **'Valuta l\'app'**
  String get rateApp;

  /// No description provided for @rateAppSub.
  ///
  /// In it, this message translates to:
  /// **'Una recensione sullo store aiuta chi cerca l\'app'**
  String get rateAppSub;

  /// No description provided for @aboutSection.
  ///
  /// In it, this message translates to:
  /// **'Info'**
  String get aboutSection;

  /// No description provided for @updateReady.
  ///
  /// In it, this message translates to:
  /// **'Aggiornamento pronto'**
  String get updateReady;

  /// No description provided for @updateInstall.
  ///
  /// In it, this message translates to:
  /// **'Riavvia'**
  String get updateInstall;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
