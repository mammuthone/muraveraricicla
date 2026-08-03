import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/locale_service.dart';
import '../services/selezione_service.dart';
import '../services/notification_service.dart';
import '../services/review_service.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/unofficial_note.dart';
import 'selezione_screen.dart';

class ImpostazioniScreen extends StatefulWidget {
  const ImpostazioniScreen({super.key});

  @override
  State<ImpostazioniScreen> createState() => _ImpostazioniScreenState();
}

class _ImpostazioniScreenState extends State<ImpostazioniScreen> {
  final _notif = NotificationService.instance;

  Future<void> _toggle(bool valore) async {
    final l = AppLocalizations.of(context)!;
    final esito = await _notif.setAbilitate(valore);
    if (!mounted) return;
    setState(() {});
    if (valore && !esito) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.permissionDenied)));
    }
  }

  Future<void> _scegliOrario() async {
    final l = AppLocalizations.of(context)!;
    final scelto = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _notif.ora, minute: _notif.minuto),
      helpText: l.reminderTimeHelp,
    );
    if (scelto == null) return;
    await _notif.setOrario(scelto.hour, scelto.minute);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final orario =
        '${_notif.ora.toString().padLeft(2, '0')}:${_notif.minuto.toString().padLeft(2, '0')}';
    final scelta = LocaleService.instance.locale?.languageCode;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(l.settings),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.pageGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              SectionTitle(l.zoneSection, icon: Icons.place_outlined),
              GlassCard(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: const Icon(
                    Icons.map_outlined,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    SelezioneService.instance.selezione!.etichetta(l),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    l.changeZone,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textMuted,
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SelezioneScreen(),
                      ),
                    );
                    if (mounted) setState(() {});
                  },
                ),
              ),

              SectionTitle(
                l.reminderSection,
                icon: Icons.notifications_active_outlined,
              ),
              GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: _notif.abilitate,
                      onChanged: _toggle,
                      activeThumbColor: AppColors.primary,
                      title: Text(
                        l.remindEveningBefore,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        l.remindSubtitle,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    ListTile(
                      enabled: _notif.abilitate,
                      leading: const Icon(
                        Icons.schedule_rounded,
                        color: AppColors.primary,
                      ),
                      title: Text(
                        l.reminderTime,
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                      trailing: Text(
                        orario,
                        style: TextStyle(
                          color: _notif.abilitate
                              ? AppColors.textPrimary
                              : AppColors.textMuted,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onTap: _notif.abilitate ? _scegliOrario : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              GlassCard(
                child: Text(
                  l.reminderNote,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),

              SectionTitle(l.languageSection, icon: Icons.translate_rounded),
              GlassCard(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: RadioGroup<String?>(
                  groupValue: scelta,
                  onChanged: _cambiaLingua,
                  child: Column(
                    children: [
                      RadioListTile<String?>(
                        value: null,
                        activeColor: AppColors.primary,
                        title: Text(
                          l.languageSystem,
                          style: const TextStyle(color: AppColors.textPrimary),
                        ),
                      ),
                      for (final code in LocaleService.supportate)
                        RadioListTile<String?>(
                          value: code,
                          activeColor: AppColors.primary,
                          title: Text(
                            LocaleService.nomi[code]!,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              SectionTitle(l.aboutSection, icon: Icons.info_outline_rounded),
              GlassCard(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: const Icon(
                    Icons.star_outline_rounded,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    l.rateApp,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    l.rateAppSub,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.open_in_new_rounded,
                    color: AppColors.textMuted,
                    size: 18,
                  ),
                  onTap: ReviewService.instance.apriStore,
                ),
              ),

              SectionTitle(l.dataSection, icon: Icons.source_outlined),
              GlassCard(
                child: Text(
                  l.dataSource,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const NotaNonUfficiale(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _cambiaLingua(String? code) async {
    await LocaleService.instance.set(code);
    // Le notifiche già programmate contengono testo nella lingua precedente.
    await NotificationService.instance.riprogramma();
    if (mounted) setState(() {});
  }
}
