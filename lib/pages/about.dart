// ================================================================
//  pages/about.dart  —  Dr. Ravinder's Clinic • About Page
//  PREMIUM: Video Hero · Parallax Scroll · 3D Tilt Cards
//           Scroll Progress Bar · Cinematic Entrances
// ================================================================

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Palette ───────────────────────────────────────────────────────
const _kDark = Color(0xFF0A2E2A);
const _kDeep = Color(0xFF071E1B);
const _kTealLight = Color(0xFF5EEAD4);
const _kTeal = Color(0xFF0D9E8C);
const _kHeading = Color(0xFF0A2E2A);
const _kLight = Color(0xFF64748B);
const _kBody = Color(0xFF334155);
const _kSlate = Color(0xFFE6FAF7);
const _kIvory = Color(0xFFF0FDFA);

// ═══════════════════════════════════════════════════════════════════
//  PAGE ROOT
// ═══════════════════════════════════════════════════════════════════
class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});
  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final ScrollController _scrollCtrl = ScrollController();
  double _scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollCtrl.hasClients) return;
    final max = _scrollCtrl.position.maxScrollExtent;
    if (max == 0) return;
    setState(() => _scrollProgress = _scrollCtrl.offset / max);
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SingleChildScrollView(
        controller: _scrollCtrl,
        child: Column(children: [
          _VideoHeroSection(scrollCtrl: _scrollCtrl),
          _MissionSection(),
          _DoctorProfileSection(),
          _StatsSection(),
          _BeforeAfterSection(),
          _TestimonialsSection(),
        ]),
      ),
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: _ScrollProgressBar(progress: _scrollProgress),
      ),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════
//  SCROLL PROGRESS BAR
// ═══════════════════════════════════════════════════════════════════
class _ScrollProgressBar extends StatelessWidget {
  final double progress;
  const _ScrollProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final filled = constraints.maxWidth * progress.clamp(0.0, 1.0);
      return Stack(children: [
        Container(height: 3, color: _kTeal.withOpacity(0.15)),
        AnimatedContainer(
          duration: const Duration(milliseconds: 60),
          height: 3,
          width: filled,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [_kTeal, _kTealLight]),
          ),
        ),
        if (progress > 0.01)
          Positioned(
            left: filled - 6,
            top: -3,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: _kTealLight,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _kTealLight.withOpacity(0.8),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ],
              ),
            ),
          ),
      ]);
    });
  }
}

// ═══════════════════════════════════════════════════════════════════
//  1 · VIDEO HERO with Parallax
// ═══════════════════════════════════════════════════════════════════
class _VideoHeroSection extends StatefulWidget {
  final ScrollController scrollCtrl;
  const _VideoHeroSection({required this.scrollCtrl});
  @override
  State<_VideoHeroSection> createState() => _VideoHeroSectionState();
}

class _VideoHeroSectionState extends State<_VideoHeroSection>
    with TickerProviderStateMixin {
  late final AnimationController _textCtrl;
  late final AnimationController _bgCtrl;
  late final Animation<double> _badgeFade, _titleFade, _subFade;
  late final Animation<Offset> _titleSlide, _badgeSlide;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    widget.scrollCtrl.addListener(_onScroll);

    _bgCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 12))
          ..repeat();

    _textCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400))
      ..forward();
    _badgeFade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _textCtrl, curve: const Interval(0.0, 0.35)));
    _badgeSlide = Tween<Offset>(begin: const Offset(0, 0.6), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _textCtrl,
            curve: const Interval(0.0, 0.35, curve: Curves.easeOut)));
    _titleFade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _textCtrl, curve: const Interval(0.2, 0.6)));
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _textCtrl,
            curve: const Interval(0.2, 0.6, curve: Curves.easeOutCubic)));
    _subFade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _textCtrl, curve: const Interval(0.5, 0.9)));
  }

  void _onScroll() {
    if (mounted) setState(() => _scrollOffset = widget.scrollCtrl.offset);
  }

  @override
  void dispose() {
    widget.scrollCtrl.removeListener(_onScroll);
    _bgCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    final heroH = isMobile ? 600.0 : 700.0;

    return SizedBox(
      height: heroH,
      child: Stack(fit: StackFit.expand, children: [
        // ── 3D Animated Background with parallax ────────────────
        Positioned(
          top: -_scrollOffset * 0.4,
          left: 0,
          right: 0,
          height: heroH + 200,
          child: AnimatedBuilder(
            animation: _bgCtrl,
            builder: (_, __) => CustomPaint(
              painter: _HeroBgPainter(_bgCtrl.value),
            ),
          ),
        ),

        // Dark gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _kDeep.withOpacity(0.92),
                _kDark.withOpacity(0.70),
                _kDark.withOpacity(0.25),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),

        // Teal left vignette
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_kTeal.withOpacity(0.18), Colors.transparent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),

        // Grid texture
        CustomPaint(painter: _GridPainter()),

        // Diagonal accent
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipPath(
            clipper: _DiagClipper(),
            child: Container(height: 120, color: _kTealLight.withOpacity(0.08)),
          ),
        ),

        // Decorative circles
        Positioned(
            top: -80,
            right: -80,
            child: Container(
                width: 340,
                height: 340,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: _kTeal.withOpacity(0.12), width: 1.5),
                ))),
        Positioned(
            top: 40,
            right: 40,
            child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: _kTealLight.withOpacity(0.07), width: 1),
                ))),

        // Text
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 80),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              FadeTransition(
                opacity: _badgeFade,
                child: SlideTransition(
                  position: _badgeSlide,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
                    decoration: BoxDecoration(
                      color: _kTealLight.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: _kTealLight.withOpacity(0.45), width: 1.2),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                              color: _kTealLight, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Text('ABOUT US',
                          style: GoogleFonts.nunito(
                              color: _kTealLight,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 3.5)),
                    ]),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              FadeTransition(
                opacity: _titleFade,
                child: SlideTransition(
                  position: _titleSlide,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'Expert Care,\n',
                          style: GoogleFonts.playfairDisplay(
                              color: Colors.white,
                              fontSize: isMobile ? 40 : 62,
                              fontWeight: FontWeight.w700,
                              height: 1.12)),
                      TextSpan(
                          text: 'Personalised for You.',
                          style: GoogleFonts.playfairDisplay(
                              color: _kTealLight,
                              fontSize: isMobile ? 40 : 62,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                              height: 1.12)),
                    ]),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              FadeTransition(
                opacity: _subFade,
                child: Column(children: [
                  Text("Dr. Ravinder's Dental & Skin Aesthetic Clinic",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                          color: Colors.white70,
                          fontSize: isMobile ? 14 : 17,
                          height: 1.6,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('Kartarpur, Punjab',
                      style: GoogleFonts.nunito(
                          color: _kTealLight.withOpacity(0.7),
                          fontSize: isMobile ? 12 : 14,
                          letterSpacing: 1.2)),
                ]),
              ),
              const SizedBox(height: 40),
              FadeTransition(
                opacity: _subFade,
                child: Column(children: [
                  Text('scroll',
                      style: GoogleFonts.nunito(
                          color: Colors.white30,
                          fontSize: 10,
                          letterSpacing: 2)),
                  const SizedBox(height: 6),
                  _ScrollCue(),
                ]),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _ScrollCue extends StatefulWidget {
  @override
  State<_ScrollCue> createState() => _ScrollCueState();
}

class _ScrollCueState extends State<_ScrollCue>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _bounce;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _bounce = Tween<double>(begin: 0, end: 8)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _bounce,
        builder: (_, __) => Transform.translate(
            offset: Offset(0, _bounce.value),
            child: Icon(Icons.keyboard_arrow_down_rounded,
                color: Colors.white30, size: 22)),
      );
}

// ═══════════════════════════════════════════════════════════════════
//  3D ANIMATED HERO BACKGROUND PAINTER
// ═══════════════════════════════════════════════════════════════════
class _HeroBgPainter extends CustomPainter {
  final double t; // 0..1 looping
  _HeroBgPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Base deep gradient ─────────────────────────────────────────
    final bgPaint = Paint()
      ..shader = LinearGradient(
        colors: const [
          Color(0xFF020F1A),
          Color(0xFF041628),
          Color(0xFF061E30),
          Color(0xFF0A2540),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    // ── Animated aurora sweeps ─────────────────────────────────────
    final a1 = math.sin(t * math.pi * 2) * 0.5 + 0.5;
    final a2 = math.cos(t * math.pi * 2 + 1.2) * 0.5 + 0.5;

    _drawAurora(canvas, size,
        center: Offset(w * (0.15 + a1 * 0.25), h * 0.3),
        radius: w * 0.55,
        color: const Color(0xFF0D9E8C),
        opacity: 0.13 + a1 * 0.07);
    _drawAurora(canvas, size,
        center: Offset(w * (0.75 - a2 * 0.2), h * 0.6),
        radius: w * 0.45,
        color: const Color(0xFF0A5570),
        opacity: 0.10 + a2 * 0.06);
    _drawAurora(canvas, size,
        center: Offset(w * 0.5, h * (0.1 + a1 * 0.15)),
        radius: w * 0.38,
        color: const Color(0xFF5EEAD4),
        opacity: 0.06 + a2 * 0.04);

    // ── Perspective grid ───────────────────────────────────────────
    _drawGrid(canvas, size, t);

    // ── 3D Floating orbs ──────────────────────────────────────────
    _draw3DOrb(canvas,
        center: Offset(w * 0.78 + math.cos(t * math.pi * 2) * 28,
            h * 0.22 + math.sin(t * math.pi * 2) * 18),
        radius: 90,
        baseColor: const Color(0xFF0D9E8C),
        depth: 1.0);
    _draw3DOrb(canvas,
        center: Offset(w * 0.12 + math.sin(t * math.pi * 2 + 0.8) * 22,
            h * 0.72 + math.cos(t * math.pi * 2 + 0.8) * 14),
        radius: 65,
        baseColor: const Color(0xFF0A5570),
        depth: 0.7);
    _draw3DOrb(canvas,
        center: Offset(w * 0.88 + math.sin(t * math.pi * 2 + 2.0) * 16,
            h * 0.65 + math.cos(t * math.pi * 2 + 2.0) * 20),
        radius: 48,
        baseColor: const Color(0xFF5EEAD4),
        depth: 0.5);
    _draw3DOrb(canvas,
        center: Offset(w * 0.05 + math.cos(t * math.pi * 2 + 3.5) * 12,
            h * 0.18 + math.sin(t * math.pi * 2 + 3.5) * 18),
        radius: 36,
        baseColor: const Color(0xFF0D9E8C),
        depth: 0.4);

    // ── Floating particles ─────────────────────────────────────────
    for (int i = 0; i < 28; i++) {
      final seed = i * 137.508;
      final px = w * ((seed * 0.3141) % 1.0);
      final baseY = h * ((seed * 0.7182) % 1.0);
      final floatY = (baseY - (t * h * 0.3 + seed * 0.5) % h);
      final phase = (t + i / 28.0) % 1.0;
      final opacity = (math.sin(phase * math.pi) * 0.6 + 0.1).clamp(0.0, 0.7);
      final radius = 1.2 + (i % 3) * 1.2;
      final pColor = i % 3 == 0
          ? const Color(0xFF5EEAD4)
          : i % 3 == 1
              ? const Color(0xFF0D9E8C)
              : Colors.white;
      canvas.drawCircle(Offset(px, floatY), radius,
          Paint()..color = pColor.withOpacity(opacity));
      if (i % 3 == 0) {
        canvas.drawCircle(
            Offset(px, floatY),
            radius * 2.5,
            Paint()
              ..color = const Color(0xFF5EEAD4).withOpacity(opacity * 0.25)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
      }
    }

    // ── Bottom vignette ────────────────────────────────────────────
    canvas.drawRect(
        Rect.fromLTWH(0, h * 0.35, w, h * 0.65),
        Paint()
          ..shader = LinearGradient(
            colors: [
              Colors.transparent,
              const Color(0xFF020F1A).withOpacity(0.65),
              const Color(0xFF020F1A),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(Rect.fromLTWH(0, h * 0.35, w, h * 0.65)));
  }

  void _drawAurora(Canvas canvas, Size size,
      {required Offset center,
      required double radius,
      required Color color,
      required double opacity}) {
    canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = color.withOpacity(opacity)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.7));
  }

  void _draw3DOrb(Canvas canvas,
      {required Offset center,
      required double radius,
      required Color baseColor,
      required double depth}) {
    // Outer glow
    canvas.drawCircle(
        center,
        radius * 1.6,
        Paint()
          ..color = baseColor.withOpacity(0.06 * depth)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.8));
    // Sphere body
    canvas.drawCircle(
        center,
        radius,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(-0.35, -0.4),
            radius: 0.9,
            colors: [
              Color.lerp(Colors.white, baseColor, 0.3)!
                  .withOpacity(0.35 * depth),
              baseColor.withOpacity(0.20 * depth),
              baseColor.withOpacity(0.04 * depth),
            ],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(Rect.fromCircle(center: center, radius: radius)));
    // Specular highlight
    canvas.drawCircle(
        Offset(center.dx - radius * 0.28, center.dy - radius * 0.32),
        radius * 0.22,
        Paint()
          ..color = Colors.white.withOpacity(0.18 * depth)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.15));
    // Ring
    canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = baseColor.withOpacity(0.22 * depth)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0);
  }

  void _drawGrid(Canvas canvas, Size size, double t) {
    final paint = Paint()
      ..color = const Color(0xFF0D9E8C).withOpacity(0.045)
      ..strokeWidth = 0.8;
    const cols = 12;
    const rows = 8;
    final vanishX = size.width * 0.5;
    final vanishY = size.height * 0.42;
    final shift = (t * size.width / cols) % (size.width / cols);
    for (int i = -1; i <= cols + 1; i++) {
      final x = i * (size.width / cols) + shift;
      canvas.drawLine(Offset(x, 0), Offset(vanishX, vanishY), paint);
    }
    for (int j = 0; j <= rows; j++) {
      final p = j / rows;
      final y = vanishY + (size.height - vanishY) * p;
      final xL = (vanishX - vanishX * p * 1.4).clamp(0.0, size.width);
      final xR =
          (vanishX + (size.width - vanishX) * p * 1.4).clamp(0.0, size.width);
      canvas.drawLine(Offset(xL, y), Offset(xR, y), paint);
    }
  }

  @override
  bool shouldRepaint(_HeroBgPainter old) => old.t != t;
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.025)
      ..strokeWidth = 0.8;
    for (double x = 0; x < size.width; x += 60) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 60) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _DiagClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size s) => Path()
    ..moveTo(0, s.height * 0.55)
    ..lineTo(s.width, 0)
    ..lineTo(s.width, s.height)
    ..lineTo(0, s.height)
    ..close();
  @override
  bool shouldReclip(_) => false;
}

// ═══════════════════════════════════════════════════════════════════
//  2 · MISSION
// ═══════════════════════════════════════════════════════════════════
class _MissionSection extends StatelessWidget {
  const _MissionSection();
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    return _RevealOnScroll(
      child: Container(
        width: double.infinity,
        padding:
            EdgeInsets.symmetric(vertical: 80, horizontal: isMobile ? 24 : 80),
        color: Colors.white,
        child: isMobile
            ? _MissionContent(isMobile: true)
            : Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(child: _MissionContent(isMobile: false)),
                const SizedBox(width: 60),
                Expanded(child: _MissionImageCard()),
              ]),
      ),
    );
  }
}

class _MissionContent extends StatelessWidget {
  final bool isMobile;
  const _MissionContent({required this.isMobile});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _SectionBadge(label: 'OUR MISSION'),
      const SizedBox(height: 22),
      RichText(
          text: TextSpan(children: [
        TextSpan(
            text: 'Excellence in\n',
            style: GoogleFonts.playfairDisplay(
                color: _kHeading,
                fontSize: isMobile ? 32 : 46,
                fontWeight: FontWeight.w700,
                height: 1.15)),
        TextSpan(
            text: 'Every Treatment',
            style: GoogleFonts.playfairDisplay(
                color: _kTeal,
                fontSize: isMobile ? 32 : 46,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                height: 1.15)),
      ])),
      const SizedBox(height: 22),
      Text(
          "At Dr. Ravinder's Clinic, we believe every patient deserves personalised, world-class care in a comfortable and welcoming environment. Dr. Ravinder combines the latest dental and dermatology techniques with a gentle, patient-first approach — because your comfort and confidence matter to us.",
          style: GoogleFonts.nunito(
              color: _kLight, fontSize: isMobile ? 14 : 16, height: 1.8)),
      const SizedBox(height: 32),
      Wrap(spacing: 14, runSpacing: 14, children: const [
        _HighlightChip(label: '✦  Modern Equipment'),
        _HighlightChip(label: '✦  Pain-free Procedures'),
        _HighlightChip(label: '✦  Personalised Care Plans'),
        _HighlightChip(label: '✦  Hygienic & Safe'),
      ]),
      if (isMobile) ...[const SizedBox(height: 40), _MissionImageCard()],
    ]);
  }
}

class _MissionImageCard extends StatelessWidget {
  const _MissionImageCard();
  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(children: [
          Image.asset(
            'assets/images/clinic_team.jpg',
            height: 420,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
                height: 420,
                decoration: BoxDecoration(
                    color: _kTealLight.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24)),
                child: Icon(Icons.local_hospital, size: 80, color: _kTeal)),
          ),
          // Subtle teal gradient overlay at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 160,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    _kDark.withOpacity(0.72),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ]),
      ),
      // Trust badge overlay on image
      Positioned(
        bottom: 22,
        left: 24,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
              color: _kTeal,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                    color: _kTeal.withOpacity(0.45),
                    blurRadius: 22,
                    offset: const Offset(0, 8))
              ]),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.verified_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text('Trusted by Our Patients',
                style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13)),
          ]),
        ),
      ),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════
//  3 · DOCTOR PROFILE
// ═══════════════════════════════════════════════════════════════════
class _DoctorProfileSection extends StatelessWidget {
  const _DoctorProfileSection();
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    return _RevealOnScroll(
      direction: _RevealDirection.right,
      child: Container(
        width: double.infinity,
        padding:
            EdgeInsets.symmetric(vertical: 90, horizontal: isMobile ? 24 : 80),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [_kDark, Color(0xFF0D3B34), Color(0xFF0A4A3A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: isMobile
            ? Column(children: const [
                _FloatingDoctorAvatar(),
                SizedBox(height: 40),
                _DoctorBio(isMobile: true)
              ])
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                    _FloatingDoctorAvatar(),
                    SizedBox(width: 72),
                    Expanded(child: _DoctorBio(isMobile: false))
                  ]),
      ),
    );
  }
}

class _FloatingDoctorAvatar extends StatefulWidget {
  const _FloatingDoctorAvatar();
  @override
  State<_FloatingDoctorAvatar> createState() => _FloatingDoctorAvatarState();
}

class _FloatingDoctorAvatarState extends State<_FloatingDoctorAvatar>
    with TickerProviderStateMixin {
  late final AnimationController _floatCtrl, _glowCtrl, _rotCtrl;
  late final Animation<double> _float, _glow, _rot;

  @override
  void initState() {
    super.initState();
    _floatCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat(reverse: true);
    _float = Tween<double>(begin: -10, end: 10)
        .animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
    _glowCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
    _glow = Tween<double>(begin: 0.3, end: 1.0)
        .animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));
    _rotCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 20))
          ..repeat();
    _rot = Tween<double>(begin: 0, end: math.pi * 2)
        .animate(CurvedAnimation(parent: _rotCtrl, curve: Curves.linear));
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _glowCtrl.dispose();
    _rotCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_float, _glow, _rot]),
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _float.value),
        child: SizedBox(
            width: 260,
            height: 300,
            child: Stack(alignment: Alignment.center, children: [
              Transform.rotate(
                  angle: _rot.value,
                  child: Container(
                      width: 255,
                      height: 290,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(130),
                          border: Border.all(
                              color:
                                  _kTealLight.withOpacity(0.12 * _glow.value),
                              width: 1.5)))),
              Container(
                  width: 242,
                  height: 278,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(122),
                      border: Border.all(
                          color: _kTealLight.withOpacity(0.28 * _glow.value),
                          width: 2),
                      boxShadow: [
                        BoxShadow(
                            color: _kTealLight.withOpacity(0.20 * _glow.value),
                            blurRadius: 48,
                            spreadRadius: 6)
                      ])),
              Container(
                  width: 226,
                  height: 260,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(114),
                      border: Border.all(
                          color: _kTeal.withOpacity(0.45), width: 1.5))),
              ClipRRect(
                  borderRadius: BorderRadius.circular(106),
                  child: Image.asset('assets/images/aboutpic.jpg',
                      width: 208,
                      height: 248,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                          width: 208,
                          height: 248,
                          color: _kTealLight.withOpacity(0.15),
                          child: Icon(Icons.person,
                              size: 100, color: _kTealLight)))),
              Positioned(
                  bottom: 6,
                  right: 0,
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 9),
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [_kTeal, Color(0xFF0A7A6A)]),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: _kTeal.withOpacity(0.5),
                                blurRadius: 18,
                                offset: const Offset(0, 4))
                          ]),
                      child: Text('BDS · MDS',
                          style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8)))),
            ])),
      ),
    );
  }
}

class _DoctorBio extends StatelessWidget {
  final bool isMobile;
  const _DoctorBio({required this.isMobile});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        _SectionBadge(label: 'MEET YOUR DOCTOR', light: true),
        const SizedBox(height: 20),
        Text('Dr. Ravinder',
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.playfairDisplay(
                color: Colors.white,
                fontSize: isMobile ? 34 : 50,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Text('BDS, MDS — Dental Surgeon & Aesthetic Dermatologist',
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.nunito(
                color: _kTealLight,
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 24),
        Container(
            width: 50,
            height: 3,
            decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [_kTeal, _kTealLight]),
                borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 24),
        Text(
            "Dr. Ravinder is a qualified dental surgeon and aesthetic dermatologist who has recently opened Dr. Ravinder's Dental and Skin Aesthetic Clinic right here in Kartarpur. With professional training in both dentistry and skin care, she brings expert, personalised treatment to every patient — combining clinical precision with a warm, caring approach.\n\nAt this clinic, you're not just a patient — you're a priority. Dr. Ravinder personally handles every consultation and treatment, ensuring the highest standard of care every single visit.",
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.nunito(
                color: Colors.white60, fontSize: 15, height: 1.8)),
        const SizedBox(height: 32),
        Wrap(
            spacing: 14,
            runSpacing: 14,
            alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
            children: const [
              _InfoBubble(
                  icon: Icons.school_rounded, label: 'BDS + MDS Qualified'),
              _InfoBubble(
                  icon: Icons.face_retouching_natural,
                  label: 'Dental & Skin Expert'),
              _InfoBubble(
                  icon: Icons.location_on_rounded, label: 'Based in Kartarpur'),
            ]),
      ],
    );
  }
}

class _InfoBubble extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoBubble({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _kTealLight.withOpacity(0.3))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: _kTealLight, size: 16),
        const SizedBox(width: 9),
        Text(label,
            style: GoogleFonts.nunito(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600)),
      ]));
}

// ═══════════════════════════════════════════════════════════════════
//  4 · STATS — 3D Tilt Cards
// ═══════════════════════════════════════════════════════════════════
class _StatsSection extends StatelessWidget {
  const _StatsSection();
  static const _items = [
    _StatItem(Icons.medical_services_rounded, '2', 'Specialities'),
    _StatItem(Icons.star_rounded, '100%', 'Dedication'),
    _StatItem(Icons.cleaning_services_rounded, '12+', 'Dental Services'),
    _StatItem(Icons.face_retouching_natural, '8+', 'Skin Therapies'),
  ];
  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return _RevealOnScroll(
      child: Container(
        width: double.infinity,
        color: _kSlate,
        padding:
            EdgeInsets.symmetric(vertical: 80, horizontal: isWide ? 80 : 24),
        child: Column(children: [
          const _SectionBadge(label: 'GLOWORA AT A GLANCE'),
          const SizedBox(height: 18),
          Text('Everything We Bring\nTo Your Care',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                  color: _kHeading,
                  fontSize: isWide ? 44 : 30,
                  fontWeight: FontWeight.w700,
                  height: 1.2)),
          const SizedBox(height: 10),
          Text('Newly opened. Fully equipped. Deeply committed.',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(color: _kLight, fontSize: 14)),
          const SizedBox(height: 56),
          Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: _items.map((d) => _Tilt3DStatCard(item: d)).toList()),
        ]),
      ),
    );
  }
}

class _StatItem {
  final IconData icon;
  final String value, label;
  const _StatItem(this.icon, this.value, this.label);
}

class _Tilt3DStatCard extends StatefulWidget {
  final _StatItem item;
  const _Tilt3DStatCard({required this.item});
  @override
  State<_Tilt3DStatCard> createState() => _Tilt3DStatCardState();
}

class _Tilt3DStatCardState extends State<_Tilt3DStatCard> {
  Offset _mouse = Offset.zero;
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    const cardW = 190.0;
    const cardH = 220.0;
    final tiltX = _hovered ? _mouse.dy * 0.18 : 0.0;
    final tiltY = _hovered ? -_mouse.dx * 0.18 : 0.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) {
        setState(() {
          _hovered = false;
          _mouse = Offset.zero;
        });
      },
      onHover: (e) {
        final x = (e.localPosition.dx / cardW - 0.5) * 2;
        final y = (e.localPosition.dy / cardH - 0.5) * 2;
        setState(() => _mouse = Offset(x, y));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(tiltX)
          ..rotateY(tiltY)
          ..translate(0.0, _hovered ? -10.0 : 0.0),
        child: Container(
          width: cardW,
          padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 22),
          decoration: BoxDecoration(
              color: _hovered ? _kDark : Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                    color: _kDark.withOpacity(_hovered ? 0.35 : 0.09),
                    blurRadius: _hovered ? 40 : 18,
                    offset: const Offset(0, 10)),
                if (_hovered)
                  BoxShadow(
                      color: _kTeal.withOpacity(0.18),
                      blurRadius: 60,
                      offset: const Offset(0, 20)),
              ],
              border: Border.all(
                  color:
                      _hovered ? _kTeal.withOpacity(0.4) : Colors.transparent)),
          child: Column(children: [
            Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                    color: _hovered
                        ? _kTealLight.withOpacity(0.2)
                        : _kTeal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16)),
                child: Icon(widget.item.icon,
                    color: _hovered ? _kTealLight : _kTeal, size: 26)),
            const SizedBox(height: 18),
            Text(widget.item.value,
                style: GoogleFonts.playfairDisplay(
                    color: _hovered ? _kTealLight : _kDark,
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            Text(widget.item.label,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                    color: _hovered ? Colors.white60 : _kLight,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
          ]),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  6 · BEFORE & AFTER
// ═══════════════════════════════════════════════════════════════════
class _BeforeAfterSection extends StatelessWidget {
  const _BeforeAfterSection();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    return _RevealOnScroll(
      child: Container(
        width: double.infinity,
        padding:
            EdgeInsets.symmetric(vertical: 90, horizontal: isMobile ? 24 : 80),
        color: _kIvory,
        child: Column(children: [
          const _SectionBadge(label: 'REAL RESULTS'),
          const SizedBox(height: 18),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                  text: 'Before & ',
                  style: GoogleFonts.playfairDisplay(
                      color: _kHeading,
                      fontSize: isMobile ? 30 : 44,
                      fontWeight: FontWeight.w700,
                      height: 1.2)),
              TextSpan(
                  text: 'After',
                  style: GoogleFonts.playfairDisplay(
                      color: _kTeal,
                      fontSize: isMobile ? 30 : 44,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      height: 1.2)),
            ]),
          ),
          const SizedBox(height: 10),
          Text('Real patients. Real results. Right here in Kartarpur.',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(color: _kLight, fontSize: 14)),
          const SizedBox(height: 56),

          // ── Cards ──
          isMobile
              ? Column(children: const [
                  _BeforeAfterCard(
                    imagePath: 'assets/images/wrinkle_img.jpeg',
                    label: 'Wrinkle Treatment',
                    description:
                        'Visible reduction in fine lines & wrinkles after treatment.',
                  ),
                  SizedBox(height: 24),
                  _BeforeAfterCard(
                    imagePath: 'assets/images/hair_img.jpeg',
                    label: 'Hair Treatment',
                    description:
                        'Significant hair regrowth and scalp improvement.',
                  ),
                ])
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    _BeforeAfterCard(
                      imagePath: 'assets/images/wrinkle_img.jpeg',
                      label: 'Wrinkle Treatment',
                      description:
                          'Visible reduction in fine lines & wrinkles after treatment.',
                    ),
                    SizedBox(width: 28),
                    _BeforeAfterCard(
                      imagePath: 'assets/images/hair_img.jpeg',
                      label: 'Hair Treatment',
                      description:
                          'Significant hair regrowth and scalp improvement.',
                    ),
                  ],
                ),
        ]),
      ),
    );
  }
}

class _BeforeAfterCard extends StatefulWidget {
  final String imagePath;
  final String label;
  final String description;
  const _BeforeAfterCard({
    required this.imagePath,
    required this.label,
    required this.description,
  });
  @override
  State<_BeforeAfterCard> createState() => _BeforeAfterCardState();
}

class _BeforeAfterCardState extends State<_BeforeAfterCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    final cardW = isMobile ? MediaQuery.of(context).size.width - 48.0 : 420.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..translate(0.0, _hovered ? -8.0 : 0.0),
        width: cardW,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: _kDark.withOpacity(_hovered ? 0.18 : 0.08),
                blurRadius: _hovered ? 40 : 20,
                offset: const Offset(0, 10)),
            if (_hovered)
              BoxShadow(
                  color: _kTeal.withOpacity(0.12),
                  blurRadius: 60,
                  offset: const Offset(0, 20)),
          ],
          border: Border.all(
              color: _hovered ? _kTeal.withOpacity(0.35) : Colors.transparent),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ──
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              child: Stack(children: [
                Image.asset(
                  widget.imagePath,
                  height: 280,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                      height: 280,
                      color: _kTealLight.withOpacity(0.1),
                      child:
                          Icon(Icons.image_rounded, size: 60, color: _kTeal)),
                ),
                // Before / After label badges
                Positioned(
                  top: 16,
                  left: 16,
                  child: _BadgeLabel(text: 'BEFORE', color: Colors.black87),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: _BadgeLabel(text: 'AFTER', color: _kTeal),
                ),
                // Bottom gradient
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 80,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.35)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ]),
            ),

            // ── Text content ──
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.label,
                      style: GoogleFonts.playfairDisplay(
                          color: _kHeading,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(widget.description,
                      style: GoogleFonts.nunito(
                          color: _kLight, fontSize: 13, height: 1.6)),
                  const SizedBox(height: 16),
                  Row(children: [
                    Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                            color: _kTeal, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text('Treated at Dr. Ravinder\'s Clinic',
                        style: GoogleFonts.nunito(
                            color: _kTeal,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgeLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _BadgeLabel({required this.text, required this.color});

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ]),
      child: Text(text,
          style: GoogleFonts.nunito(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5)));
}

// ═══════════════════════════════════════════════════════════════════
//  5 · TESTIMONIALS — dark bg, 3D tilt
// ═══════════════════════════════════════════════════════════════════
class _TestimonialsSection extends StatelessWidget {
  const _TestimonialsSection();
  static const _reviews = [
    _ReviewData(
        'Manpreet Kaur',
        "Bahut hi achha experience tha. Dr. Ravinder ne bahut carefully dental cleaning kiti — bilkul pain nahi si. Highly recommended!",
        '⭐⭐⭐⭐⭐'),
    _ReviewData(
        'Arjun Singh',
        "Acne treatment started recently and already seeing good results. Dr. Ravinder explained everything clearly. Bahut professional clinic hai.",
        '⭐⭐⭐⭐⭐'),
    _ReviewData(
        'Simran Bhatia',
        "Sadi locality vich hi itni premium clinic aa gayi. Kartarpur de liye bahut vadia hai. Doctor da behaviour bahut caring hai.",
        '⭐⭐⭐⭐⭐'),
  ];
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    return _RevealOnScroll(
      child: Container(
        width: double.infinity,
        padding:
            EdgeInsets.symmetric(vertical: 90, horizontal: isMobile ? 24 : 80),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [_kDeep, _kDark],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Column(children: [
          const _SectionBadge(label: 'WHAT PATIENTS SAY', light: true),
          const SizedBox(height: 18),
          Text('Early Smiles,\nReal Feedback',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontSize: isMobile ? 30 : 44,
                  fontWeight: FontWeight.w700,
                  height: 1.2)),
          const SizedBox(height: 10),
          Text("From our first patients — honest feedback we're proud of.",
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(color: Colors.white38, fontSize: 14)),
          const SizedBox(height: 56),
          Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: _reviews.map((r) => _ReviewTiltCard(data: r)).toList()),
        ]),
      ),
    );
  }
}

class _ReviewData {
  final String name, review, stars;
  const _ReviewData(this.name, this.review, this.stars);
}

class _ReviewTiltCard extends StatefulWidget {
  final _ReviewData data;
  const _ReviewTiltCard({required this.data});
  @override
  State<_ReviewTiltCard> createState() => _ReviewTiltCardState();
}

class _ReviewTiltCardState extends State<_ReviewTiltCard> {
  Offset _mouse = Offset.zero;
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cardW = (w < 700 ? w - 48.0 : 340.0).clamp(260.0, 400.0);
    final tiltX = _hovered ? _mouse.dy * 0.14 : 0.0;
    final tiltY = _hovered ? -_mouse.dx * 0.14 : 0.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) {
        setState(() {
          _hovered = false;
          _mouse = Offset.zero;
        });
      },
      onHover: (e) {
        final x = (e.localPosition.dx / cardW - 0.5) * 2;
        final y = (e.localPosition.dy / 200 - 0.5) * 2;
        setState(() => _mouse = Offset(x, y));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(tiltX)
          ..rotateY(tiltY)
          ..translate(0.0, _hovered ? -10.0 : 0.0),
        child: Container(
          width: cardW,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
              color: _hovered
                  ? const Color(0xFF0D3B34)
                  : Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                  color: _hovered
                      ? _kTeal.withOpacity(0.5)
                      : _kTealLight.withOpacity(0.15)),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                          color: _kTeal.withOpacity(0.25),
                          blurRadius: 40,
                          offset: const Offset(0, 14))
                    ]
                  : []),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.data.stars, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text('"${widget.data.review}"',
                style: GoogleFonts.nunito(
                    color: _hovered ? Colors.white : Colors.white60,
                    fontSize: 14,
                    height: 1.75,
                    fontStyle: FontStyle.italic)),
            const SizedBox(height: 20),
            Row(children: [
              CircleAvatar(
                  radius: 18,
                  backgroundColor: _kTeal.withOpacity(0.2),
                  child: Icon(Icons.person, size: 18, color: _kTealLight)),
              const SizedBox(width: 12),
              Text(widget.data.name,
                  style: GoogleFonts.nunito(
                      color: _kTealLight,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
            ]),
          ]),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  HELPERS
// ═══════════════════════════════════════════════════════════════════
enum _RevealDirection { up, left, right }

class _RevealOnScroll extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final _RevealDirection direction;
  const _RevealOnScroll({
    required this.child,
    this.delay = Duration.zero,
    this.direction = _RevealDirection.up,
  });
  @override
  State<_RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<_RevealOnScroll>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    final begin = switch (widget.direction) {
      _RevealDirection.up => const Offset(0, 0.18),
      _RevealDirection.left => const Offset(-0.12, 0),
      _RevealDirection.right => const Offset(0.12, 0),
    };
    _slide = Tween<Offset>(begin: begin, end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child));
}

class _SectionBadge extends StatelessWidget {
  final String label;
  final bool light;
  const _SectionBadge({required this.label, this.light = false});
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
      decoration: BoxDecoration(
          color:
              light ? _kTealLight.withOpacity(0.15) : _kTeal.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: light
                  ? _kTealLight.withOpacity(0.45)
                  : _kTeal.withOpacity(0.35),
              width: 1.2)),
      child: Text(label,
          style: GoogleFonts.nunito(
              color: light ? _kTealLight : _kTeal,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.5)));
}

class _HighlightChip extends StatelessWidget {
  final String label;
  const _HighlightChip({required this.label});
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
          color: _kTeal.withOpacity(0.08),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: _kTeal.withOpacity(0.22))),
      child: Text(label,
          style: GoogleFonts.nunito(
              color: _kDark, fontSize: 13, fontWeight: FontWeight.w600)));
}
