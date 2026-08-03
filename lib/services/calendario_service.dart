import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/waste_type.dart';

/// Il calendario COSIR è per data esplicita (giugno 2026 – maggio 2027), non
/// per giorno della settimana: nessuna regola ricorrente lo riproduce fedelmente.
class CalendarioService {
  CalendarioService._();
  static final CalendarioService instance = CalendarioService._();

  Map<DateTime, List<WasteType>> _byDay = {};
  bool get isLoaded => _byDay.isNotEmpty;

  DateTime? _first;
  DateTime? _last;
  DateTime? get primoGiorno => _first;
  DateTime? get ultimoGiorno => _last;

  /// Carica uno dei sei calendari COSIR; sostituisce quello già in memoria.
  Future<void> load(String asset) async {
    final raw = await rootBundle.loadString(asset);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;

    final parsed = <DateTime, List<WasteType>>{};
    for (final entry in decoded.entries) {
      final day = DateTime.parse(entry.key);
      final types = (entry.value as List)
          .map((c) => WasteType.fromCode(c as String))
          .whereType<WasteType>()
          .toList();
      if (types.isNotEmpty) parsed[day] = types;
    }
    _byDay = parsed;

    final keys = parsed.keys.toList()..sort();
    _first = keys.first;
    _last = keys.last;
  }

  List<WasteType> forDay(DateTime day) =>
      _byDay[DateTime(day.year, day.month, day.day)] ?? const [];

  /// I prossimi [count] giorni con almeno un conferimento, da [from] escluso.
  List<MapEntry<DateTime, List<WasteType>>> next(DateTime from, int count) {
    final start = DateTime(from.year, from.month, from.day);
    final keys = _byDay.keys.where((d) => d.isAfter(start)).toList()..sort();
    return keys.take(count).map((d) => MapEntry(d, _byDay[d]!)).toList();
  }
}
