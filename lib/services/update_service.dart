import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_update/in_app_update.dart';

/// Aggiornamento in-app, solo Android: su iOS l'App Store non espone nulla di
/// equivalente e il plugin lancia un'eccezione.
///
/// Si usa l'aggiornamento *flessibile*: scarica in background e lascia l'utente
/// continuare. Quello immediato blocca l'app a schermo intero e per un
/// calendario dei rifiuti sarebbe sproporzionato.
class UpdateService {
  UpdateService._();
  static final UpdateService instance = UpdateService._();

  bool _prontoAlRiavvio = false;
  bool get prontoAlRiavvio => _prontoAlRiavvio;

  /// Ritorna true quando il download è finito e serve solo riavviare.
  Future<bool> controlla() async {
    if (!Platform.isAndroid) return false;

    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability != UpdateAvailability.updateAvailable) {
        return false;
      }
      if (!info.flexibleUpdateAllowed) return false;

      await InAppUpdate.startFlexibleUpdate();
      _prontoAlRiavvio = true;
      return true;
    } catch (e) {
      // Nessun aggiornamento, build non installata dal Play Store, utente che
      // annulla: niente di cui avvisare.
      debugPrint('controllo aggiornamenti non riuscito: $e');
      return false;
    }
  }

  Future<void> installa() async {
    if (!Platform.isAndroid) return;
    await InAppUpdate.completeFlexibleUpdate();
  }
}
