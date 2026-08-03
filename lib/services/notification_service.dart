import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../l10n/app_localizations.dart';
import 'calendario_service.dart';
import 'locale_service.dart';

/// Promemoria locali: una notifica la sera prima di ogni giornata di raccolta.
///
/// iOS consente al massimo 64 notifiche pendenti, quindi ne pianifichiamo un
/// numero limitato e le riprogrammiamo a ogni avvio.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  static const _kAbilitate = 'promemoria_abilitati';
  static const _kOra = 'promemoria_ora';
  static const _kMinuto = 'promemoria_minuto';
  static const _maxPendenti = 60;

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _init = false;

  bool abilitate = false;
  int ora = 20;
  int minuto = 0;

  Future<void> init() async {
    if (_init) return;
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Rome'));

    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );

    final prefs = await SharedPreferences.getInstance();
    abilitate = prefs.getBool(_kAbilitate) ?? false;
    ora = prefs.getInt(_kOra) ?? 20;
    minuto = prefs.getInt(_kMinuto) ?? 0;
    _init = true;

    if (abilitate) await riprogramma();
  }

  Future<bool> _chiediPermesso() async {
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      return await ios.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      final ok = await android.requestNotificationsPermission() ?? false;
      await android.requestExactAlarmsPermission();
      return ok;
    }
    return false;
  }

  /// Ritorna lo stato effettivo dopo il tentativo (false se il permesso è negato).
  Future<bool> setAbilitate(bool valore) async {
    if (valore && !await _chiediPermesso()) return false;

    abilitate = valore;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kAbilitate, valore);
    await riprogramma();
    return valore;
  }

  Future<void> setOrario(int nuovaOra, int nuovoMinuto) async {
    ora = nuovaOra;
    minuto = nuovoMinuto;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kOra, ora);
    await prefs.setInt(_kMinuto, minuto);
    await riprogramma();
  }

  /// Il testo delle notifiche è già scritto al momento della pianificazione,
  /// quindi va rifatto anche quando cambia la lingua.
  Future<void> riprogramma() async {
    await _plugin.cancelAll();
    if (!abilitate) return;

    final l = await _localizations();

    final dettagli = NotificationDetails(
      android: AndroidNotificationDetails(
        'raccolta',
        l.notifChannelName,
        channelDescription: l.notifChannelDesc,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
    );

    final adesso = tz.TZDateTime.now(tz.local);
    var id = 0;

    for (final giorno in CalendarioService.instance.next(
      DateTime.now(),
      _maxPendenti * 2,
    )) {
      // La notifica parte la sera prima, all'orario scelto.
      final vigilia = giorno.key.subtract(const Duration(days: 1));
      final quando = tz.TZDateTime(
        tz.local,
        vigilia.year,
        vigilia.month,
        vigilia.day,
        ora,
        minuto,
      );
      if (!quando.isAfter(adesso)) continue;

      final frazioni = giorno.value.map((t) => t.label(l)).join(', ');
      await _plugin.zonedSchedule(
        id++,
        l.notifTitle,
        frazioni,
        quando,
        dettagli,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: giorno.key.toIso8601String(),
      );

      if (id >= _maxPendenti) break;
    }
  }

  /// Le notifiche vengono pianificate fuori dall'albero dei widget, quindi le
  /// stringhe si caricano direttamente dal delegate.
  Future<AppLocalizations> _localizations() {
    final scelta = LocaleService.instance.locale;
    final sistema = PlatformDispatcher.instance.locale;
    final locale =
        scelta ??
        (LocaleService.supportate.contains(sistema.languageCode)
            ? Locale(sistema.languageCode)
            : const Locale('it'));
    return AppLocalizations.delegate.load(locale);
  }
}
