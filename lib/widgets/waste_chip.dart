import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/waste_type.dart';
import 'scheda_rifiuto_sheet.dart';

/// Toccando la chip si apre la scheda della frazione.
class WasteChip extends StatelessWidget {
  const WasteChip(this.type, {super.key, this.compact = false});

  final WasteType type;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Material(
      color: type.color.withValues(alpha: 0.22),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => mostraSchedaRifiuto(context, type),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 8 : 12,
            vertical: compact ? 4 : 7,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: type.color.withValues(alpha: 0.55)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(type.icon, size: compact ? 12 : 16, color: type.color),
              SizedBox(width: compact ? 4 : 6),
              Text(
                type.label(l),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 11 : 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: compact ? 3 : 5),
              Icon(
                Icons.chevron_right_rounded,
                size: compact ? 12 : 15,
                color: Colors.white54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pallino colorato usato nella griglia del calendario.
class WasteDot extends StatelessWidget {
  const WasteDot(this.type, {super.key, this.size = 6});

  final WasteType type;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: type.color, shape: BoxShape.circle),
    );
  }
}
