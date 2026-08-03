import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/zona.dart';
import '../services/notification_service.dart';
import '../services/selezione_service.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';

/// Scelta di zona e tipo di utenza: decide quale dei sei calendari mostrare.
/// Appare al primo avvio e come schermata a sé dalle impostazioni.
class SelezioneScreen extends StatefulWidget {
  const SelezioneScreen({super.key, this.primaVolta = false});

  final bool primaVolta;

  @override
  State<SelezioneScreen> createState() => _SelezioneScreenState();
}

class _SelezioneScreenState extends State<SelezioneScreen> {
  late Zona _zona;
  late TipoUtenza _tipo;

  @override
  void initState() {
    super.initState();
    final corrente = SelezioneService.instance.selezione;
    _zona = corrente?.zona ?? Zona.zonaA;
    _tipo = corrente?.tipo ?? TipoUtenza.domestica;
  }

  Future<void> _conferma() async {
    await SelezioneService.instance.set(Selezione(_zona, _tipo));
    // Le notifiche pendenti riguardano il calendario precedente.
    await NotificationService.instance.riprogramma();
    if (mounted && !widget.primaVolta) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: widget.primaVolta
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              title: Text(l.changeZone),
            ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.pageGradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  children: [
                    if (widget.primaVolta) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/icon/icon.png',
                          height: 72,
                          width: 72,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    Text(
                      l.chooseZoneTitle,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l.chooseZoneSubtitle,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...Zona.values.map(
                      (z) => _CardZona(
                        zona: z,
                        scelta: z == _zona,
                        onTap: () => setState(() => _zona = z),
                      ),
                    ),
                    SectionTitle(l.chooseUserType, icon: Icons.badge_outlined),
                    if (_zona.distingueTipo)
                      Row(
                        children: TipoUtenza.values
                            .map(
                              (t) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: _BottoneTipo(
                                    tipo: t,
                                    scelto: t == _tipo,
                                    onTap: () => setState(() => _tipo = t),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      )
                    else
                      GlassCard(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l.sameCalendarBothTypes,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
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
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _conferma,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      l.confirm,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardZona extends StatelessWidget {
  const _CardZona({
    required this.zona,
    required this.scelta,
    required this.onTap,
  });

  final Zona zona;
  final bool scelta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: scelta ? AppColors.primary.withValues(alpha: 0.18) : AppColors.glass,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: scelta ? AppColors.primary : AppColors.hairline,
                width: scelta ? 1.6 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  scelta
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: scelta ? AppColors.primary : AppColors.textMuted,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        zona.label(l),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        zona.descrizione(l),
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottoneTipo extends StatelessWidget {
  const _BottoneTipo({
    required this.tipo,
    required this.scelto,
    required this.onTap,
  });

  final TipoUtenza tipo;
  final bool scelto;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Material(
      color: scelto ? AppColors.accent.withValues(alpha: 0.2) : AppColors.glass,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: scelto ? AppColors.accent : AppColors.hairline,
            ),
          ),
          child: Column(
            children: [
              Icon(
                tipo == TipoUtenza.domestica
                    ? Icons.home_rounded
                    : Icons.storefront_rounded,
                color: scelto ? AppColors.accent : AppColors.textMuted,
              ),
              const SizedBox(height: 6),
              Text(
                tipo.label(l),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: scelto ? AppColors.textPrimary : AppColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
