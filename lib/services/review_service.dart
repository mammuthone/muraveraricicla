import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Richiesta di recensione in-app.
///
/// Entrambi gli store limitano quante volte il popup può comparire davvero, ma
/// il momento in cui viene chiesto lo decide l'app: chiederlo al primo avvio
/// significa raccogliere il giudizio di chi non ha ancora usato niente. Qui si
/// aspetta che l'utente sia tornato qualche volta.
class ReviewService {
  ReviewService._();
  static final ReviewService instance = ReviewService._();

  static const _kAvvii = 'avvii';
  static const _kChiesta = 'recensione_chiesta';
  static const _avviiMinimi = 8;

  final _review = InAppReview.instance;

  /// Da chiamare a ogni avvio: conta e, al momento giusto, chiede.
  Future<void> forseChiedi() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_kChiesta) ?? false) return;

    final avvii = (prefs.getInt(_kAvvii) ?? 0) + 1;
    await prefs.setInt(_kAvvii, avvii);
    if (avvii < _avviiMinimi) return;

    if (await _review.isAvailable()) {
      await _review.requestReview();
      await prefs.setBool(_kChiesta, true);
    }
  }

  /// Apre la scheda sullo store: usato dalla voce esplicita in impostazioni,
  /// dove l'utente ha scelto lui di lasciare un giudizio.
  Future<void> apriStore() => _review.openStoreListing(
    appStoreId: appStoreId,
  );

  /// Apple ID numerico assegnato da App Store Connect.
  static const appStoreId = '6799002753';
}
