import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

enum WasteType {
  umido('UM', Color(0xFF8D6E63), Icons.eco_rounded),
  secco('SE', Color(0xFF78909C), Icons.delete_rounded),
  plastica('PL', Color(0xFFF9A825), Icons.local_drink_rounded),
  carta('CA', Color(0xFF1E88E5), Icons.description_rounded),
  vetro('VL', Color(0xFF43A047), Icons.wine_bar_rounded);

  const WasteType(this.code, this.color, this.icon);

  final String code;
  final Color color;
  final IconData icon;

  static WasteType? fromCode(String code) {
    for (final t in WasteType.values) {
      if (t.code == code) return t;
    }
    return null;
  }

  String label(AppLocalizations l) => switch (this) {
    WasteType.umido => l.wasteUmido,
    WasteType.secco => l.wasteSecco,
    WasteType.plastica => l.wastePlastica,
    WasteType.carta => l.wasteCarta,
    WasteType.vetro => l.wasteVetro,
  };

  String subtitle(AppLocalizations l) => switch (this) {
    WasteType.umido => l.wasteUmidoSub,
    WasteType.secco => l.wasteSeccoSub,
    WasteType.plastica => l.wastePlasticaSub,
    WasteType.carta => l.wasteCartaSub,
    WasteType.vetro => l.wasteVetroSub,
  };

  /// Contenitore in cui va conferita la frazione.
  String where(AppLocalizations l) => switch (this) {
    WasteType.umido => l.wasteUmidoWhere,
    WasteType.secco => l.wasteSeccoWhere,
    WasteType.plastica => l.wastePlasticaWhere,
    WasteType.carta => l.wasteCartaWhere,
    WasteType.vetro => l.wasteVetroWhere,
  };

  String what(AppLocalizations l) => switch (this) {
    WasteType.umido => l.wasteUmidoWhat,
    WasteType.secco => l.wasteSeccoWhat,
    WasteType.plastica => l.wastePlasticaWhat,
    WasteType.carta => l.wasteCartaWhat,
    WasteType.vetro => l.wasteVetroWhat,
  };
}
