import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/waste_type.dart';
import '../services/calendario_service.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/waste_chip.dart';

class CalendarioScreen extends StatefulWidget {
  const CalendarioScreen({super.key});

  @override
  State<CalendarioScreen> createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  late DateTime _mese;
  DateTime? _selezionato;

  final _cal = CalendarioService.instance;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final primo = _cal.primoGiorno!;
    final ultimo = _cal.ultimoGiorno!;
    final corrente = DateTime(now.year, now.month);
    _mese = corrente.isBefore(DateTime(primo.year, primo.month))
        ? DateTime(primo.year, primo.month)
        : corrente.isAfter(DateTime(ultimo.year, ultimo.month))
        ? DateTime(ultimo.year, ultimo.month)
        : corrente;
  }

  bool get _puoIndietro =>
      _mese.isAfter(DateTime(_cal.primoGiorno!.year, _cal.primoGiorno!.month));
  bool get _puoAvanti => _mese.isBefore(
    DateTime(_cal.ultimoGiorno!.year, _cal.ultimoGiorno!.month),
  );

  void _sposta(int delta) {
    setState(() {
      _mese = DateTime(_mese.year, _mese.month + delta);
      _selezionato = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.pageGradient),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            _BarraMese(
              mese: _mese,
              onPrev: _puoIndietro ? () => _sposta(-1) : null,
              onNext: _puoAvanti ? () => _sposta(1) : null,
            ),
            const SizedBox(height: 16),
            _Griglia(
              mese: _mese,
              selezionato: _selezionato,
              onTap: (g) =>
                  setState(() => _selezionato = _selezionato == g ? null : g),
            ),
            if (_selezionato != null) ...[
              const SizedBox(height: 20),
              _DettaglioGiorno(giorno: _selezionato!),
            ],
            SectionTitle(l.legend, icon: Icons.palette_outlined),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: WasteType.values.map((t) => WasteChip(t)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarraMese extends StatelessWidget {
  const _BarraMese({required this.mese, this.onPrev, this.onNext});

  final DateTime mese;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).toString();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPrev,
          icon: const Icon(Icons.chevron_left_rounded),
          color: AppColors.textPrimary,
          disabledColor: AppColors.textMuted.withValues(alpha: 0.3),
        ),
        Text(
          DateFormat('MMMM yyyy', lang).format(mese).toUpperCase(),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right_rounded),
          color: AppColors.textPrimary,
          disabledColor: AppColors.textMuted.withValues(alpha: 0.3),
        ),
      ],
    );
  }
}

class _Griglia extends StatelessWidget {
  const _Griglia({
    required this.mese,
    required this.selezionato,
    required this.onTap,
  });

  final DateTime mese;
  final DateTime? selezionato;
  final ValueChanged<DateTime> onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final cal = CalendarioService.instance;
    final primo = DateTime(mese.year, mese.month, 1);
    final giorniNelMese = DateTime(mese.year, mese.month + 1, 0).day;
    final offset = primo.weekday - 1; // lunedì = 0
    final oggi = DateTime.now();
    final oggiKey = DateTime(oggi.year, oggi.month, oggi.day);

    return Column(
      children: [
        Row(
          children: l.weekdayInitials
              .split(',')
              .map(
                (g) => Expanded(
                  child: Center(
                    child: Text(
                      g,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: offset + giorniNelMese,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            childAspectRatio: 0.82,
          ),
          itemBuilder: (context, i) {
            if (i < offset) return const SizedBox.shrink();
            final giorno = DateTime(mese.year, mese.month, i - offset + 1);
            final tipi = cal.forDay(giorno);
            final isOggi = giorno == oggiKey;
            final isSel = giorno == selezionato;
            final isDomenica = giorno.weekday == DateTime.sunday;

            return GestureDetector(
              onTap: () => onTap(giorno),
              child: Container(
                decoration: BoxDecoration(
                  color: isSel
                      ? AppColors.primary.withValues(alpha: 0.25)
                      : AppColors.glass,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isOggi
                        ? AppColors.primary
                        : isSel
                        ? AppColors.primary.withValues(alpha: 0.6)
                        : Colors.transparent,
                    width: isOggi ? 1.6 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${giorno.day}',
                      style: TextStyle(
                        color: isDomenica
                            ? AppColors.error
                            : AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: isOggi ? FontWeight.w800 : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: tipi
                            .map(
                              (t) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 1,
                                ),
                                child: WasteDot(t),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _DettaglioGiorno extends StatelessWidget {
  const _DettaglioGiorno({required this.giorno});

  final DateTime giorno;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).toString();
    final tipi = CalendarioService.instance.forDay(giorno);

    return GlassCard(
      tint: tipi.isEmpty ? null : tipi.first.color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('EEEE d MMMM yyyy', lang).format(giorno),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          if (tipi.isEmpty)
            Text(
              l.noCollectionPlanned,
              style: const TextStyle(color: AppColors.textSecondary),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tipi.map((t) => WasteChip(t)).toList(),
            ),
        ],
      ),
    );
  }
}
