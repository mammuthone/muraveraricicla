import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/info_rifiuti.dart';
import '../l10n/app_localizations.dart';
import '../models/waste_type.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/scheda_rifiuto_sheet.dart';
import '../widgets/unofficial_note.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  Future<void> _apri(Contatto c) async {
    final uri = switch (c.schema) {
      'tel' => Uri.parse('tel:${c.valore.replaceAll(' ', '')}'),
      'mailto' => Uri.parse('mailto:${c.valore}'),
      _ => Uri.parse('https://${c.valore}'),
    };
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.pageGradient),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            Text(
              l.guideTitle,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            ...WasteType.values.map((t) => _FrazioneTile(tipo: t)),

            SectionTitle(l.howToDeliver, icon: Icons.rule_rounded),
            _Elenco(voci: comeConferire(l)),

            SectionTitle(
              l.whyNotCollected,
              icon: Icons.help_outline_rounded,
            ),
            _Elenco(voci: perchePersoRitiro(l), numerato: true),

            SectionTitle(
              l.bookableServices,
              icon: Icons.event_available_rounded,
            ),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.bookableServicesIntro,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final s in serviziSuPrenotazione(l))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Icon(
                              Icons.circle,
                              size: 5,
                              color: AppColors.accent,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              s,
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

            SectionTitle(l.bulky, icon: Icons.chair_rounded),
            GlassCard(
              child: Text(
                l.bulkyText,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),

            SectionTitle(l.contacts, icon: Icons.call_rounded),
            GlassCard(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                children: [
                  for (final c in contatti(l))
                    ListTile(
                      dense: true,
                      leading: Icon(
                        switch (c.schema) {
                          'tel' => Icons.phone_rounded,
                          'mailto' => Icons.mail_outline_rounded,
                          _ => Icons.language_rounded,
                        },
                        color: AppColors.primary,
                        size: 20,
                      ),
                      title: Text(
                        c.etichetta,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                      subtitle: Text(
                        c.valore,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () => _apri(c),
                    ),
                ],
              ),
            ),

            SectionTitle(l.unofficialApp, icon: Icons.gavel_rounded),
            const NotaNonUfficiale(),
          ],
        ),
      ),
    );
  }
}

class _FrazioneTile extends StatelessWidget {
  const _FrazioneTile({required this.tipo});

  final WasteType tipo;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: tipo.color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => mostraSchedaRifiuto(context, tipo),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: tipo.color.withValues(alpha: 0.35)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: tipo.color.withValues(alpha: 0.3),
                  child: Icon(tipo.icon, color: tipo.color, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tipo.label(l),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        tipo.subtitle(l),
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Elenco extends StatelessWidget {
  const _Elenco({required this.voci, this.numerato = false});

  final List<String> voci;
  final bool numerato;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < voci.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == voci.length - 1 ? 0 : 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (numerato)
                    Text(
                      '${i + 1}.',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Icon(
                        Icons.circle,
                        size: 5,
                        color: AppColors.accent,
                      ),
                    ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      voci[i],
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
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
