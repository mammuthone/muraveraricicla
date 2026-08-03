import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'l10n/app_localizations.dart';
import 'screens/calendario_screen.dart';
import 'screens/ecocentri_screen.dart';
import 'screens/home_screen.dart';
import 'screens/info_screen.dart';
import 'screens/selezione_screen.dart';
import 'services/locale_service.dart';
import 'services/notification_service.dart';
import 'services/review_service.dart';
import 'services/update_service.dart';
import 'services/selezione_service.dart';
import 'theme/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  await LocaleService.instance.load();
  await SelezioneService.instance.load();
  try {
    await NotificationService.instance.init();
  } catch (e) {
    // I promemoria sono un extra: un errore qui non deve impedire l'avvio.
    debugPrint('promemoria non inizializzati: $e');
  }
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(const MuraveraRiciclaApp());
}

class MuraveraRiciclaApp extends StatelessWidget {
  const MuraveraRiciclaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        LocaleService.instance,
        SelezioneService.instance,
      ]),
      builder: (context, _) => MaterialApp(
        onGenerateTitle: (context) =>
            'Muravera · ${AppLocalizations.of(context)!.appSubtitle}',
        debugShowCheckedModeBanner: false,
        locale: LocaleService.instance.locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.dark,
            surface: AppColors.surface,
          ),
        ),
        home: SelezioneService.instance.scelta
            ? const Shell()
            : const SelezioneScreen(primaVolta: true),
      ),
    );
  }
}

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    // Dopo il primo frame: né l'una né l'altra devono ritardare l'avvio.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ReviewService.instance.forseChiedi();
      _controllaAggiornamenti();
    });
  }

  Future<void> _controllaAggiornamenti() async {
    if (!await UpdateService.instance.controlla()) return;
    if (!mounted) return;

    final l = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l.updateReady),
        duration: const Duration(days: 1),
        action: SnackBarAction(
          label: l.updateInstall,
          onPressed: UpdateService.instance.installa,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      // Le schermate leggono il calendario caricato: vanno ricostruite quando
      // cambia la zona. Con figli const Flutter salterebbe il rebuild.
      body: ListenableBuilder(
        listenable: SelezioneService.instance,
        builder: (context, _) {
          final asset = SelezioneService.instance.selezione!.asset;
          return IndexedStack(
            index: _index,
            children: [
              HomeScreen(key: ValueKey('home:$asset')),
              CalendarioScreen(key: ValueKey('cal:$asset')),
              const EcocentriScreen(),
              const InfoScreen(),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.hairline)),
        ),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          height: 68,
          indicatorColor: AppColors.primary.withValues(alpha: 0.22),
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.today_rounded),
              label: l.navToday,
            ),
            NavigationDestination(
              icon: const Icon(Icons.calendar_month_rounded),
              label: l.navCalendar,
            ),
            NavigationDestination(
              icon: const Icon(Icons.place_rounded),
              label: l.navEcocentri,
            ),
            NavigationDestination(
              icon: const Icon(Icons.menu_book_rounded),
              label: l.navGuide,
            ),
          ],
        ),
      ),
    );
  }
}
