import 'package:latlong2/latlong.dart';

import '../l10n/app_localizations.dart';

class OrarioEcocentro {
  const OrarioEcocentro(this.periodo, this.orari);
  final String periodo;
  final List<String> orari;
}

class Ecocentro {
  const Ecocentro({
    required this.nome,
    required this.indirizzo,
    required this.posizione,
    required this.orari,
  });

  final String nome;
  final String indirizzo;
  final LatLng posizione;
  final List<OrarioEcocentro> orari;
}

// TODO: coordinate approssimate, da verificare sul posto/catasto.
const posizioniEcocentri = <LatLng>[
  LatLng(39.4192, 9.5745), // Muravera, via dei Platani
  LatLng(39.2726, 9.5646), // Costa Rei, loc. Piscina Rei
];

List<Ecocentro> ecocentri(AppLocalizations l) => [
  Ecocentro(
    nome: l.ecoMuraveraName,
    indirizzo: l.ecoMuraveraAddress,
    posizione: posizioniEcocentri[0],
    orari: [
      OrarioEcocentro(l.periodOctApr, [l.schedMonSat('07:00 – 13:30')]),
      OrarioEcocentro(l.periodMaySep, [
        l.schedMonSat('07:00 – 13:30'),
        l.schedSunday('08:00 – 12:00'),
      ]),
      OrarioEcocentro(l.periodFerragosto, [
        l.schedMonSat('07:00 – 13:30'),
        l.schedSunday('07:00 – 13:30'),
        l.schedTueThu('16:00 – 18:00'),
      ]),
      OrarioEcocentro(l.periodSantoStefano, [
        l.schedMonSat('07:00 – 13:30'),
        l.schedSunday('07:00 – 13:30'),
      ]),
      OrarioEcocentro(l.periodPasquetta, [
        l.schedMonSat('07:00 – 13:30'),
        l.schedSunday('07:00 – 13:30'),
      ]),
    ],
  ),
  Ecocentro(
    nome: l.ecoCostaReiName,
    indirizzo: l.ecoCostaReiAddress,
    posizione: posizioniEcocentri[1],
    orari: [
      OrarioEcocentro(l.periodOctApr, [l.schedMonSunNoThu('07:30 – 13:30')]),
      OrarioEcocentro(l.periodMaySep, [
        l.schedMonSun('07:00 – 13:00 · 14:00 – 20:00'),
      ]),
      OrarioEcocentro(l.periodFerragosto, [
        l.schedMonSat('07:00 – 13:00 · 14:00 – 20:00'),
        l.schedSunday('07:00 – 13:00 · 14:00 – 20:00'),
      ]),
      OrarioEcocentro(l.periodSantoStefano, [
        l.schedMonSat('07:30 – 13:30'),
        l.schedSunday('07:30 – 13:30'),
      ]),
      OrarioEcocentro(l.periodPasquetta, [
        l.schedMonSat('07:30 – 13:30'),
        l.schedSunday('07:30 – 13:30'),
      ]),
    ],
  ),
];

List<String> rifiutiEcocentro(AppLocalizations l) => [
  l.ecoItem1,
  l.ecoItem2,
  l.ecoItem3,
  l.ecoItem4,
  l.ecoItem5,
  l.ecoItem6,
  l.ecoItem7,
];
