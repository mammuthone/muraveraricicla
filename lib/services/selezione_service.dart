import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/zona.dart';
import 'calendario_service.dart';

/// Zona e tipo di utenza scelti: determinano quale dei sei calendari COSIR
/// viene caricato. `null` finché l'utente non sceglie al primo avvio.
class SelezioneService extends ChangeNotifier {
  SelezioneService._();
  static final SelezioneService instance = SelezioneService._();

  static const _kZona = 'zona';
  static const _kTipo = 'tipo_utenza';

  Selezione? _selezione;
  Selezione? get selezione => _selezione;
  bool get scelta => _selezione != null;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final zona = Zona.daCodice(prefs.getString(_kZona));
    if (zona == null) return;

    final tipo = prefs.getString(_kTipo) == TipoUtenza.nonDomestica.codice
        ? TipoUtenza.nonDomestica
        : TipoUtenza.domestica;
    _selezione = Selezione(zona, tipo);
    await CalendarioService.instance.load(_selezione!.asset);
  }

  Future<void> set(Selezione s) async {
    _selezione = s;
    await CalendarioService.instance.load(s.asset);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kZona, s.zona.codice);
    await prefs.setString(_kTipo, s.tipo.codice);
  }
}
