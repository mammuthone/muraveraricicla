import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/waste_type.dart';
import '../services/calendario_service.dart';
import '../services/selezione_service.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/unofficial_note.dart';
import '../widgets/waste_chip.dart';
import 'impostazioni_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final cal = CalendarioService.instance;
    final now = DateTime.now();
    final oggi = cal.forDay(now);
    final prossimi = cal.next(now, 6);

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.pageGradient),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const _Hero(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _OggiCard(oggi: oggi, giorno: now),
                if (prossimi.isNotEmpty) ...[
                  SectionTitle(l.nextCollections, icon: Icons.event_rounded),
                  ...prossimi.map(
                    (e) => _ProssimaRiga(giorno: e.key, tipi: e.value),
                  ),
                ],
                SectionTitle(
                  l.reminderSection,
                  icon: Icons.info_outline_rounded,
                ),
                GlassCard(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.schedule_rounded,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          l.exposureRule,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Hero fotografica: litorale di Costa Rei, icona dell'app e titolo.
class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return SizedBox(
      height: 260,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/hero_costa_rei.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.centerRight,
          ),
          // Sfuma verso il fondo pagina così il contenuto sottostante si innesta.
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x40000000),
                  Color(0x99071823),
                  AppColors.background,
                ],
                stops: [0.0, 0.55, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 4, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.help_outline_rounded),
                        color: Colors.white,
                        tooltip: l.unofficialApp,
                        onPressed: () => mostraNotaNonUfficiale(context),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings_rounded),
                        color: Colors.white,
                        tooltip: l.settings,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ImpostazioniScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/icon/icon.png',
                          height: 52,
                          width: 52,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'MURAVERA',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                                height: 1.05,
                                shadows: [
                                  Shadow(blurRadius: 12, color: Colors.black54),
                                ],
                              ),
                            ),
                            Text(
                              l.appSubtitle,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                shadows: [
                                  Shadow(blurRadius: 10, color: Colors.black54),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.55),
                      ),
                    ),
                    child: Text(
                      SelezioneService.instance.selezione!.etichetta(l),
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OggiCard extends StatelessWidget {
  const _OggiCard({required this.oggi, required this.giorno});

  final List<WasteType> oggi;
  final DateTime giorno;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).toString();
    final data = DateFormat('EEEE d MMMM', lang).format(giorno);
    final vuoto = oggi.isEmpty;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surfaceHigh, AppColors.surface],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: vuoto
              ? AppColors.hairline
              : AppColors.primary.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${l.todayLabel} · ${data.toUpperCase()}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          if (vuoto)
            Row(
              children: [
                const Icon(
                  Icons.bedtime_rounded,
                  color: AppColors.textMuted,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  l.noCollection,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: oggi.map((t) => WasteChip(t)).toList(),
            ),
        ],
      ),
    );
  }
}

class _ProssimaRiga extends StatelessWidget {
  const _ProssimaRiga({required this.giorno, required this.tipi});

  final DateTime giorno;
  final List<WasteType> tipi;

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).toString();
    final now = DateTime.now();
    final domani = DateTime(now.year, now.month, now.day + 1);
    final isDomani = giorno == domani;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        tint: isDomani ? AppColors.primary : null,
        child: Row(
          children: [
            SizedBox(
              width: 52,
              child: Column(
                children: [
                  Text(
                    DateFormat('E', lang).format(giorno).toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${giorno.day}',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: tipi.map((t) => WasteChip(t, compact: true)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
