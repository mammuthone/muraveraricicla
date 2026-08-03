import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/waste_type.dart';
import '../theme/app_colors.dart';

/// Apre la scheda della frazione — stesso contenuto della sezione Guida.
Future<void> mostraSchedaRifiuto(BuildContext context, WasteType tipo) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      final l = AppLocalizations.of(context)!;

      return DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.92,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.alphaBlend(
                  tipo.color.withValues(alpha: 0.35),
                  AppColors.surfaceHigh,
                ),
                AppColors.background,
              ],
              stops: const [0.0, 0.45],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: tipo.color.withValues(alpha: 0.4)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: tipo.color.withValues(alpha: 0.3),
                          child: Icon(tipo.icon, color: tipo.color, size: 28),
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
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                tipo.subtitle(l),
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _Blocco(
                      titolo: l.sheetWhere,
                      colore: tipo.color,
                      testo: tipo.where(l),
                    ),
                    const SizedBox(height: 16),
                    _Blocco(
                      titolo: l.sheetWhat,
                      colore: tipo.color,
                      testo: tipo.what(l),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.glass,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.hairline),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l.exposureRuleShort,
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
            ],
          ),
        ),
      );
    },
  );
}

class _Blocco extends StatelessWidget {
  const _Blocco({
    required this.titolo,
    required this.colore,
    required this.testo,
  });

  final String titolo;
  final Color colore;
  final String testo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titolo.toUpperCase(),
          style: TextStyle(
            color: colore,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          testo,
          style: const TextStyle(
            color: AppColors.textSecondary,
            height: 1.55,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
