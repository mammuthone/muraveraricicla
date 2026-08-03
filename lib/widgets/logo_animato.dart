import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Il simbolo del riciclo che si compone: tre frecce entrano da destra in
/// orizzontale, scorrono verso il centro e si incurvano fino a chiudere il
/// cerchio.
///
/// Il morphing è fatto campionando due percorsi — il segmento retto e l'arco
/// finale — con lo stesso numero di punti e interpolandoli uno a uno. È più
/// robusto che animare raggio e angolo separatamente, dove la retta sarebbe
/// un arco di raggio infinito.
class LogoAnimato extends StatefulWidget {
  const LogoAnimato({
    super.key,
    this.dimensione = 160,
    this.onFine,
  });

  final double dimensione;
  final VoidCallback? onFine;

  @override
  State<LogoAnimato> createState() => _LogoAnimatoState();
}

class _LogoAnimatoState extends State<LogoAnimato>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1900),
  );

  @override
  void initState() {
    super.initState();
    _c.forward().whenComplete(() => widget.onFine?.call());
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.dimensione,
      height: widget.dimensione,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) =>
            CustomPaint(painter: _PittoreLogo(_c.value)),
      ),
    );
  }
}

class _PittoreLogo extends CustomPainter {
  _PittoreLogo(this.t);

  final double t;

  static const _campioni = 48;
  static const _angoli = [-90.0, 30.0, 150.0];

  @override
  void paint(Canvas canvas, Size size) {
    final centro = Offset(size.width / 2, size.height / 2);
    final raggio = size.width * 0.30;
    final spessore = size.width * 0.088;

    // La rotazione entra solo alla fine, quando il cerchio è già formato:
    // applicarla da subito farebbe entrare le frecce storte invece che
    // orizzontali.
    final rotazione =
        Curves.easeOutCubic.transform(((t - 0.62) / 0.38).clamp(0.0, 1.0)) *
        0.4;

    canvas.save();
    canvas.translate(centro.dx, centro.dy);
    canvas.rotate(rotazione);
    canvas.translate(-centro.dx, -centro.dy);

    for (var i = 0; i < _angoli.length; i++) {
      // Nessuno sfasamento temporale: il trenino entra tutto insieme, sono le
      // posizioni lungo la linea a metterle una dietro l'altra.
      _disegnaBraccio(
        canvas,
        size,
        indice: i,
        centro: centro,
        raggio: raggio,
        spessore: spessore,
        p: t,
      );
    }
    canvas.restore();
  }

  void _disegnaBraccio(
    Canvas canvas,
    Size size, {
    required int indice,
    required Offset centro,
    required double raggio,
    required double spessore,
    required double p,
  }) {
    final colore = Color.lerp(
      AppColors.primary,
      AppColors.accent,
      indice / 2,
    )!;

    final aIniziale = _angoli[indice] + 12;
    final aFinale = _angoli[indice] + 96;
    final lunghezza = raggio * (aFinale - aIniziale) * math.pi / 180;

    // Le tre frecce viaggiano in fila indiana sulla stessa linea, distanziate
    // di poco: entra prima la testa del trenino.
    final passo = lunghezza + spessore * 2.2;
    final coda = passo * _angoli.length;

    // Entrata: il trenino attraversa da destra fino al centro.
    final entrata = Curves.easeOutCubic.transform(
      (p / 0.55).clamp(0.0, 1.0),
    );
    final dx = (1 - entrata) * (size.width + coda) + indice * passo;

    // Incurvamento: solo dopo che il trenino è arrivato, altrimenti le frecce
    // si accartocciano mentre stanno ancora scorrendo.
    final curva = Curves.easeInOutCubic.transform(
      ((p - 0.45) / 0.55).clamp(0.0, 1.0),
    );

    final yRetta = centro.dy;

    final punti = <Offset>[];
    for (var k = 0; k <= _campioni; k++) {
      final s = k / _campioni;

      final retta = Offset(
        centro.dx - lunghezza / 2 + lunghezza * s + dx,
        yRetta,
      );
      final angolo = _rad(aIniziale + (aFinale - aIniziale) * s);
      final arco = Offset(
        centro.dx + raggio * math.cos(angolo),
        centro.dy + raggio * math.sin(angolo),
      );

      punti.add(Offset.lerp(retta, arco, curva)!);
    }

    final tracciato = Path()..moveTo(punti.first.dx, punti.first.dy);
    for (final punto in punti.skip(1)) {
      tracciato.lineTo(punto.dx, punto.dy);
    }

    canvas.drawPath(
      tracciato,
      Paint()
        ..color = colore
        ..style = PaintingStyle.stroke
        ..strokeWidth = spessore
        ..strokeCap = StrokeCap.butt
        ..strokeJoin = StrokeJoin.round,
    );

    // Punta orientata sulla tangente: vale sia da retta sia da arco.
    final fine = punti.last;
    final precedente = punti[punti.length - 2];
    final tangente = math.atan2(
      fine.dy - precedente.dy,
      fine.dx - precedente.dx,
    );
    final normale = tangente + math.pi / 2;
    final lung = spessore * 1.5;
    final larg = spessore * 1.15;

    canvas.drawPath(
      Path()
        ..moveTo(
          fine.dx + lung * math.cos(tangente),
          fine.dy + lung * math.sin(tangente),
        )
        ..lineTo(
          fine.dx + larg * math.cos(normale),
          fine.dy + larg * math.sin(normale),
        )
        ..lineTo(
          fine.dx - larg * math.cos(normale),
          fine.dy - larg * math.sin(normale),
        )
        ..close(),
      Paint()..color = colore,
    );
  }

  static double _rad(double gradi) => gradi * math.pi / 180;

  @override
  bool shouldRepaint(_PittoreLogo old) => old.t != t;
}

/// Schermata di avvio: il logo si compone, poi lascia il posto all'app.
class AvvioScreen extends StatefulWidget {
  const AvvioScreen({super.key, required this.child});

  final Widget child;

  @override
  State<AvvioScreen> createState() => _AvvioScreenState();
}

class _AvvioScreenState extends State<AvvioScreen> {
  bool _finito = false;

  @override
  Widget build(BuildContext context) {
    if (_finito) return widget.child;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.pageGradient),
        child: Center(
          child: LogoAnimato(
            dimensione: 180,
            onFine: () async {
              await Future<void>.delayed(const Duration(milliseconds: 350));
              if (mounted) setState(() => _finito = true);
            },
          ),
        ),
      ),
    );
  }
}
