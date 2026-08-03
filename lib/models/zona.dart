import '../l10n/app_localizations.dart';

enum TipoUtenza {
  domestica('ud'),
  nonDomestica('und');

  const TipoUtenza(this.codice);
  final String codice;

  String label(AppLocalizations l) => switch (this) {
    TipoUtenza.domestica => l.userDomestic,
    TipoUtenza.nonDomestica => l.userNonDomestic,
  };
}

enum Zona {
  zonaA('zona_a'),
  zonaB('zona_b'),
  costaRei('costa_rei'),
  rurale('rurale');

  const Zona(this.codice);
  final String codice;

  /// Nelle zone A e B il calendario è lo stesso per utenze domestiche e non.
  bool get distingueTipo => this == Zona.costaRei || this == Zona.rurale;

  String label(AppLocalizations l) => switch (this) {
    Zona.zonaA => l.zoneA,
    Zona.zonaB => l.zoneB,
    Zona.costaRei => l.zoneCostaRei,
    Zona.rurale => l.zoneRurale,
  };

  String descrizione(AppLocalizations l) => switch (this) {
    Zona.zonaA => l.zoneADesc,
    Zona.zonaB => l.zoneBDesc,
    Zona.costaRei => l.zoneCostaReiDesc,
    Zona.rurale => l.zoneRuraleDesc,
  };

  static Zona? daCodice(String? c) {
    for (final z in Zona.values) {
      if (z.codice == c) return z;
    }
    return null;
  }
}

class Selezione {
  const Selezione(this.zona, this.tipo);

  final Zona zona;
  final TipoUtenza tipo;

  String get asset => zona.distingueTipo
      ? 'assets/json/cal_${zona.codice}_${tipo.codice}.json'
      : 'assets/json/cal_${zona.codice}.json';

  String etichetta(AppLocalizations l) =>
      '${zona.label(l)} · ${tipo.label(l)}';
}
