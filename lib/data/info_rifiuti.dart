import '../l10n/app_localizations.dart';

List<String> comeConferire(AppLocalizations l) => [
  l.howToDeliver1,
  l.howToDeliver2,
  l.howToDeliver3,
  l.howToDeliver4,
];

List<String> perchePersoRitiro(AppLocalizations l) => [
  l.whyNotCollected1,
  l.whyNotCollected2,
  l.whyNotCollected3,
];

List<String> serviziSuPrenotazione(AppLocalizations l) => [
  l.bookableService1,
  l.bookableService2,
  l.bookableService3,
  l.bookableService4,
  l.bookableService5,
  l.bookableService6,
  l.bookableService7,
];

class Contatto {
  const Contatto(this.etichetta, this.valore, this.schema);
  final String etichetta;
  final String valore;
  final String schema;
}

List<Contatto> contatti(AppLocalizations l) => [
  Contatto(l.contactGreenNumber, '800 069 960', 'tel'),
  Contatto(l.contactLandline, '070 684415', 'tel'),
  Contatto(l.contactAutospurgo, '800 260 062', 'tel'),
  Contatto(l.contactEmergency, '348 5817879', 'tel'),
  Contatto(l.contactEmail, 'info@cosir.org', 'mailto'),
  Contatto(l.contactBulkyEmail, 'ingombranti@cosir.org', 'mailto'),
  Contatto(l.contactWebsite, 'muravera.cosir.org', 'https'),
];
