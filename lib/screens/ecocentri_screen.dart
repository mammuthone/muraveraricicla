import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/ecocentri.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';

class EcocentriScreen extends StatefulWidget {
  const EcocentriScreen({super.key});

  @override
  State<EcocentriScreen> createState() => _EcocentriScreenState();
}

class _EcocentriScreenState extends State<EcocentriScreen> {
  final _mapController = MapController();

  /// null = vista d'insieme con entrambi gli ecocentri.
  int? _attivo;

  static final _vistaInsieme = CameraFit.coordinates(
    coordinates: posizioniEcocentri,
    padding: const EdgeInsets.all(56),
  );

  void _focus(int i) {
    // Toccare di nuovo la scheda già attiva riporta alla vista d'insieme.
    if (_attivo == i) return _mostraTutti();
    setState(() => _attivo = i);
    _mapController.move(posizioniEcocentri[i], 14);
  }

  void _mostraTutti() {
    setState(() => _attivo = null);
    _mapController.fitCamera(_vistaInsieme);
  }

  Future<void> _indicazioni(Ecocentro e) async {
    final p = e.posizione;
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${p.latitude},${p.longitude}',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final centri = ecocentri(l);

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.pageGradient),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 260,
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(initialCameraFit: _vistaInsieme),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.sardinialabs.muraveraricicla',
                      ),
                      MarkerLayer(
                        markers: [
                          for (var i = 0; i < centri.length; i++)
                            Marker(
                              point: centri[i].posizione,
                              width: 44,
                              height: 44,
                              child: GestureDetector(
                                onTap: () => _focus(i),
                                child: _Pin(attivo: i == _attivo),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  if (_attivo != null)
                    Positioned(
                      left: 12,
                      top: 12,
                      child: Material(
                        color: AppColors.surface.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(999),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: _mostraTutti,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 9,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.zoom_out_map_rounded,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l.showBoth,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      color: Colors.black54,
                      child: const Text(
                        '© OpenStreetMap',
                        style: TextStyle(color: Colors.white70, fontSize: 9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                children: [
                  for (var i = 0; i < centri.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _SchedaEcocentro(
                        ecocentro: centri[i],
                        attivo: i == _attivo,
                        onTap: () => _focus(i),
                        onIndicazioni: () => _indicazioni(centri[i]),
                      ),
                    ),
                  SectionTitle(
                    l.whatYouCanBring,
                    icon: Icons.recycling_rounded,
                  ),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final r in rifiutiEcocentro(l))
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
                                    r,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const Divider(color: AppColors.hairline),
                        const SizedBox(height: 8),
                        Text(
                          l.tariNote,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                            height: 1.4,
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
  }
}

class _Pin extends StatelessWidget {
  const _Pin({required this.attivo});

  final bool attivo;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: attivo ? AppColors.primary : AppColors.surfaceHigh,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: const Icon(Icons.recycling_rounded, color: Colors.white, size: 22),
    );
  }
}

class _SchedaEcocentro extends StatelessWidget {
  const _SchedaEcocentro({
    required this.ecocentro,
    required this.attivo,
    required this.onTap,
    required this.onIndicazioni,
  });

  final Ecocentro ecocentro;
  final bool attivo;
  final VoidCallback onTap;
  final VoidCallback onIndicazioni;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        tint: attivo ? AppColors.primary : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ecocentro.nome,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        ecocentro.indirizzo,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onIndicazioni,
                  icon: const Icon(Icons.directions_rounded),
                  color: AppColors.primary,
                  tooltip: l.directions,
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (final o in ecocentro.orari)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      o.periodo,
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    for (final riga in o.orari)
                      Text(
                        riga,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
