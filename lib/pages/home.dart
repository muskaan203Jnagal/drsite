// ================================================================
//  pages/home.dart  —  Dr. Ravinder's Clinic • Home Page
//  UPGRADED: Premium ServicesSection, glassmorphism BookBar,
//            staggered animations, parallax hero, luxury design
// ================================================================

import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/header.dart';

// ── Palette ────────────────────────────────────────────────────────
const _kDark = Color(0xFF0A2E2A);
const _kTealLight = Color(0xFF5EEAD4);
const _kTeal = Color(0xFF0D9E8C);
const _kWhite = Colors.white;
const _kIvory = Color(0xFFF0FDFA);
const _kSlate = Color(0xFFE6FAF7);
const _kBody = Color(0xFF334155);
const _kLight = Color(0xFF64748B);

// ═══════════════════════════════════════════════════════════════════
//  HOME PAGE
// ═══════════════════════════════════════════════════════════════════
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _HeroSection(),
        _QuickBookBar(),
        _AboutSection(),
        _PremiumServicesSection(), // ← New reference-image style
        _StatsSection(),
        _CTASection(),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  1 · HERO — Ken Burns + staggered entrance
// ═══════════════════════════════════════════════════════════════════
class _HeroSection extends StatefulWidget {
  const _HeroSection();
  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection>
    with TickerProviderStateMixin {
  late final AnimationController _bgCtrl;
  late final Animation<double> _imgScale;
  late final AnimationController _entrance;
  late final Animation<double> _badgeFade;
  late final Animation<Offset> _badgeSlide;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _subFade;
  late final Animation<double> _btnFade;
  late final Animation<Offset> _btnSlide;

  @override
  void initState() {
    super.initState();
    _bgCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 14))
          ..repeat(reverse: true);
    _imgScale = Tween<double>(begin: 1.0, end: 1.12)
        .animate(CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut));

    _entrance = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600))
      ..forward();

    _badgeFade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _entrance, curve: const Interval(0.0, 0.3)));
    _badgeSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _entrance,
            curve: const Interval(0.0, 0.3, curve: Curves.easeOut)));

    _titleFade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _entrance, curve: const Interval(0.18, 0.52)));
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _entrance,
            curve: const Interval(0.18, 0.52, curve: Curves.easeOut)));

    _subFade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _entrance, curve: const Interval(0.42, 0.68)));

    _btnFade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _entrance, curve: const Interval(0.62, 1.0)));
    _btnSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _entrance,
            curve: const Interval(0.62, 1.0, curve: Curves.easeOut)));
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 700;

    return SizedBox(
      height: isMobile ? 620 : 720,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Ken Burns background
          AnimatedBuilder(
            animation: _imgScale,
            builder: (_, child) =>
                Transform.scale(scale: _imgScale.value, child: child),
            child:
                Image.asset('assets/images/home_image.jpeg', fit: BoxFit.cover),
          ),

          // Multi-stop dark overlay gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.80),
                  Colors.black.withOpacity(0.50),
                  Colors.black.withOpacity(0.15),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          // Blue tint overlay for brand feel
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _kDark.withOpacity(0.55),
                  Colors.transparent,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),

          // Diagonal rose accent
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _DiagonalClipper(),
              child:
                  Container(height: 100, color: _kTealLight.withOpacity(0.12)),
            ),
          ),

          // Floating decorative circle (top-right)
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _kTeal.withOpacity(0.15), width: 1.5),
              ),
            ),
          ),

          // Staggered text content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Badge
                  FadeTransition(
                    opacity: _badgeFade,
                    child: SlideTransition(
                      position: _badgeSlide,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: _kTealLight.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: _kTealLight.withOpacity(0.55), width: 1.2),
                        ),
                        child: Text(
                          "Dr. Ravinder's Dental & Skin Aesthetic Clinic",
                          style: GoogleFonts.nunito(
                              color: _kTealLight,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Headline
                  FadeTransition(
                    opacity: _titleFade,
                    child: SlideTransition(
                      position: _titleSlide,
                      child: Text(
                        "A Great Place\nto Care for Yourself",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: isMobile ? 40 : 66,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Sub
                  FadeTransition(
                    opacity: _subFade,
                    child: Text(
                      "Kartarpur, Punjab  ·  +91 94636 29128",
                      style: GoogleFonts.nunito(
                          color: Colors.white70, fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Buttons
                  FadeTransition(
                    opacity: _btnFade,
                    child: SlideTransition(
                      position: _btnSlide,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 14,
                        runSpacing: 14,
                        children: [
                          _HeroPrimaryBtn(
                              label: "Book Appointment",
                              onTap: (ctx) => ctx.go('/booking')),
                          _HeroOutlineBtn(
                              label: "Our Services",
                              onTap: (ctx) => ctx.go('/services')),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Scroll hint
          Positioned(
            bottom: 28,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _btnFade,
              child: Column(
                children: [
                  Text("scroll down",
                      style: GoogleFonts.nunito(
                          color: Colors.white38,
                          fontSize: 11,
                          letterSpacing: 1.5)),
                  const SizedBox(height: 6),
                  const Icon(Icons.keyboard_arrow_down,
                      color: Colors.white38, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiagonalClipper extends CustomClipper<Path> {
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

// ── Hero buttons ──────────────────────────────────────────────────
class _HeroPrimaryBtn extends StatefulWidget {
  final String label;
  final void Function(BuildContext) onTap;
  const _HeroPrimaryBtn({required this.label, required this.onTap});
  @override
  State<_HeroPrimaryBtn> createState() => _HeroPrimaryBtnState();
}

class _HeroPrimaryBtnState extends State<_HeroPrimaryBtn> {
  bool _h = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _h
            ? (Matrix4.identity()..translate(0.0, -4.0))
            : Matrix4.identity(),
        child: ElevatedButton(
          onPressed: () => widget.onTap(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: _kTealLight,
            foregroundColor: _kDark,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: _h ? 12 : 3,
            shadowColor: _kTealLight.withOpacity(0.5),
          ),
          child: Text(widget.label,
              style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w800, fontSize: 14)),
        ),
      ),
    );
  }
}

class _HeroOutlineBtn extends StatefulWidget {
  final String label;
  final void Function(BuildContext) onTap;
  const _HeroOutlineBtn({required this.label, required this.onTap});
  @override
  State<_HeroOutlineBtn> createState() => _HeroOutlineBtnState();
}

class _HeroOutlineBtnState extends State<_HeroOutlineBtn> {
  bool _h = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _h
            ? (Matrix4.identity()..translate(0.0, -4.0))
            : Matrix4.identity(),
        child: OutlinedButton(
          onPressed: () => widget.onTap(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: _h ? _kTeal : Colors.white,
            side: BorderSide(color: _h ? _kTeal : Colors.white70, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Text(widget.label,
              style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w700, fontSize: 14)),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  2 · QUICK BOOK BAR — glassmorphism floating card
// ═══════════════════════════════════════════════════════════════════
class _QuickBookBar extends StatefulWidget {
  const _QuickBookBar();
  @override
  State<_QuickBookBar> createState() => _QuickBookBarState();
}

class _QuickBookBarState extends State<_QuickBookBar> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      color: _kIvory,
      child: Align(
        alignment: Alignment.topCenter,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            margin: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 80, vertical: 0),
            transform:
                Matrix4.translationValues(0, _hovered ? -38.0 : -36.0, 0),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
            decoration: BoxDecoration(
              // Glassmorphism effect
              color: Colors.white.withOpacity(0.92),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _hovered
                    ? _kTealLight.withOpacity(0.5)
                    : Colors.white.withOpacity(0.6),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: _kDark.withOpacity(_hovered ? 0.20 : 0.13),
                  blurRadius: _hovered ? 48 : 32,
                  spreadRadius: _hovered ? 2 : 0,
                  offset: const Offset(0, 14),
                ),
                BoxShadow(
                  color: _kTealLight.withOpacity(_hovered ? 0.12 : 0.0),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _bookField("Choose Services", "Dental Care",
                          Icons.medical_services_outlined),
                      const _BookDivider(horizontal: true),
                      _bookField("Choose Date", "DD / MM / YYYY",
                          Icons.calendar_today_outlined),
                      const _BookDivider(horizontal: true),
                      _bookField("Contact Number", "+91 94636 29128",
                          Icons.phone_outlined),
                      const SizedBox(height: 18),
                      _BookBarButton(),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _bookField("Choose Services", "Dental Care",
                            Icons.medical_services_outlined),
                      ),
                      const _BookDivider(horizontal: false),
                      Expanded(
                        child: _bookField("Choose Date", "DD / MM / YYYY",
                            Icons.calendar_today_outlined),
                      ),
                      const _BookDivider(horizontal: false),
                      Expanded(
                        child: _bookField("Contact Number", "+91 94636 29128",
                            Icons.phone_outlined),
                      ),
                      const SizedBox(width: 24),
                      _BookBarButton(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _bookField(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.nunito(
                  fontSize: 10,
                  color: _kLight,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2)),
          const SizedBox(height: 7),
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: _kTealLight.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 15, color: _kDark),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(value,
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w700,
                        color: _kDark,
                        fontSize: 13)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BookDivider extends StatelessWidget {
  final bool horizontal;
  const _BookDivider({required this.horizontal});
  @override
  Widget build(BuildContext context) {
    return horizontal
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: _kDark.withOpacity(0.1)),
          )
        : Container(
            width: 1,
            height: 44,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: _kDark.withOpacity(0.1),
          );
  }
}

class _BookBarButton extends StatefulWidget {
  @override
  State<_BookBarButton> createState() => _BookBarButtonState();
}

class _BookBarButtonState extends State<_BookBarButton> {
  bool _h = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        transform: _h
            ? (Matrix4.identity()..translate(0.0, -3.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: _h
              ? [
                  BoxShadow(
                      color: _kDark.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8))
                ]
              : [],
        ),
        child: ElevatedButton(
          onPressed: () => context.go('/booking'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _kDark,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Book Now",
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w800, fontSize: 14)),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  3 · ABOUT / INTRO SECTION
// ═══════════════════════════════════════════════════════════════════
class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 860;

    return _FadeSlideIn(
      child: Container(
        width: double.infinity,
        color: _kIvory,
        padding: EdgeInsets.only(
          top: 28,
          bottom: 72,
          left: isWide ? 80 : 24,
          right: isWide ? 80 : 24,
        ),
        child: isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 5, child: _aboutText(context, isWide)),
                  const SizedBox(width: 56),
                  Expanded(flex: 4, child: _aboutStats()),
                ],
              )
            : Column(
                children: [
                  _aboutText(context, isWide),
                  const SizedBox(height: 40),
                  _aboutStats(),
                ],
              ),
      ),
    );
  }

  Widget _aboutText(BuildContext context, bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: _kTeal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: _kTeal.withOpacity(0.4)),
          ),
          child: Text("ABOUT US",
              style: GoogleFonts.nunito(
                  color: _kTeal,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.8)),
        ),
        const SizedBox(height: 20),
        RichText(
          text: TextSpan(children: [
            TextSpan(
              text: "Where Smiles\n",
              style: GoogleFonts.playfairDisplay(
                  fontSize: isWide ? 46 : 34,
                  color: _kDark,
                  fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text: "& Skin Meet Care",
              style: GoogleFonts.playfairDisplay(
                  fontSize: isWide ? 46 : 34,
                  color: _kTealLight,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700),
            ),
          ]),
        ),
        const SizedBox(height: 18),
        Text(
          "Dr. Ravinder's Clinic is Kartarpur's trusted destination for comprehensive dental and dermatology care. "
          "We combine world-class medical expertise with genuine compassion — "
          "because every patient deserves to look and feel their absolute best.",
          style: GoogleFonts.nunito(color: _kBody, fontSize: 15, height: 1.75),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _featureChip(Icons.verified_rounded, "BDS + MDS Qualified"),
            _featureChip(Icons.people_rounded, "Patients Come First"),
            _featureChip(Icons.local_hospital_rounded, "Dual Speciality"),
          ],
        ),
        const SizedBox(height: 28),
        GestureDetector(
          onTap: () => context.go('/about'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Learn Our Story",
                  style: GoogleFonts.nunito(
                      color: _kDark,
                      fontWeight: FontWeight.w800,
                      fontSize: 14)),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: _kTealLight.withOpacity(0.2),
                    shape: BoxShape.circle),
                child: const Icon(Icons.arrow_forward, size: 14, color: _kDark),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _featureChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _kDark.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
              color: _kDark.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: _kTealLight),
          const SizedBox(width: 8),
          Text(label,
              style: GoogleFonts.nunito(
                  color: _kDark, fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _aboutStats() {
    return Container(
      padding: const EdgeInsets.all(34),
      decoration: BoxDecoration(
        color: _kDark,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: _kDark.withOpacity(0.3),
              blurRadius: 40,
              offset: const Offset(0, 16))
        ],
      ),
      child: Column(
        children: [
          _statRow("BDS · MDS", "Dual Qualified\nDental & Skin Expert"),
          Divider(color: Colors.white.withOpacity(0.08), height: 32),
          _statRow("100%", "Personal Doctor\nEvery Visit"),
          Divider(color: Colors.white.withOpacity(0.08), height: 32),
          _statRow("Kartarpur", "Serving Our\nLocal Community"),
        ],
      ),
    );
  }

  Widget _statRow(String value, String label) {
    return Row(
      children: [
        Container(
          width: 66,
          height: 66,
          decoration: BoxDecoration(
            color: _kTealLight.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: _kTealLight.withOpacity(0.35)),
          ),
          child: Center(
            child: Text(value,
                style: GoogleFonts.playfairDisplay(
                    color: _kTealLight,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic)),
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Text(label,
              style: GoogleFonts.nunito(
                  color: Colors.white70, fontSize: 14, height: 1.55)),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  4 · PREMIUM SERVICES SECTION — Reference image style
//      Left: text + headline  |  Right: vertical scrolling list
//      Background: teal gradient with subtle glass effect
// ═══════════════════════════════════════════════════════════════════
class _PremiumServicesSection extends StatelessWidget {
  const _PremiumServicesSection();

  // ── DENTAL services (left column) ──────────────────────────────
  static const _dentalServices = [
    _SvcData(Icons.cleaning_services_rounded, 'Teeth Cleaning',
        'Deep scaling & polishing to remove plaque and prevent gum disease'),
    _SvcData(Icons.wb_incandescent_outlined, 'Teeth Whitening',
        'Professional whitening for a brighter, radiant smile'),
    _SvcData(Icons.straighten_rounded, 'Braces & Aligners',
        'Metal braces or clear aligners for perfect alignment'),
    _SvcData(Icons.local_hospital_rounded, 'Root Canal Treatment',
        'Pain-free root canal to save your natural tooth'),
    _SvcData(Icons.layers_rounded, 'Dental Implants',
        'Permanent, natural-looking tooth replacement'),
    _SvcData(Icons.blur_circular_rounded, 'Digital X-Ray',
        'High-res digital X-rays with minimal radiation exposure'),
  ];

  // ── DERMATOLOGY services (right column) ────────────────────────
  static const _dermServices = [
    _SvcData(Icons.face_retouching_natural_rounded, 'Acne Treatment',
        'Advanced therapies to clear active acne & prevent breakouts'),
    _SvcData(Icons.flash_on_rounded, 'Laser Therapy',
        'Targeted laser for pigmentation, hair removal & rejuvenation'),
    _SvcData(Icons.water_drop_rounded, 'HydraFacial',
        'Deep cleansing, exfoliation & intense hydration'),
    _SvcData(Icons.auto_awesome_rounded, 'Anti-Aging Treatments',
        'Botox, fillers & peels to restore a youthful appearance'),
    _SvcData(Icons.spa_rounded, 'Hair Restoration',
        'PRP therapy & mesotherapy for proven hair regrowth'),
    _SvcData(Icons.psychology_rounded, 'Skin Consultation',
        'Personalised skin analysis & tailored treatment planning'),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 900;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0A4A4A), // deep teal
            Color(0xFF0D3B34),
            Color(0xFF0A2E2A), // brand blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Decorative background circles
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.03),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _kTealLight.withOpacity(0.06),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 80, horizontal: isWide ? 80 : 24),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ServicesSectionLeft(),
                            const SizedBox(height: 36),
                            _SectionLabel(label: '🦷  DENTAL SERVICES'),
                            const SizedBox(height: 12),
                            _ServicesListPanel(services: _dentalServices),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48),
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            _SectionLabel(label: '✨  DERMATOLOGY SERVICES'),
                            const SizedBox(height: 12),
                            _ServicesListPanel(services: _dermServices),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ServicesSectionLeft(),
                      const SizedBox(height: 36),
                      _SectionLabel(label: '🦷  DENTAL SERVICES'),
                      const SizedBox(height: 12),
                      _ServicesListPanel(services: _dentalServices),
                      const SizedBox(height: 32),
                      _SectionLabel(label: '✨  DERMATOLOGY SERVICES'),
                      const SizedBox(height: 12),
                      _ServicesListPanel(services: _dermServices),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _ServicesSectionLeft extends StatefulWidget {
  const _ServicesSectionLeft();
  @override
  State<_ServicesSectionLeft> createState() => _ServicesSectionLeftState();
}

class _ServicesSectionLeftState extends State<_ServicesSectionLeft>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..forward();
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(-0.2, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: _kTealLight.withOpacity(0.15),
                borderRadius: BorderRadius.circular(30),
                border:
                    Border.all(color: _kTealLight.withOpacity(0.4), width: 1.2),
              ),
              child: Text("OUR SERVICES",
                  style: GoogleFonts.nunito(
                      color: _kTealLight,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2)),
            ),
            const SizedBox(height: 24),

            // Headline
            Text(
              "See what we\nprovide to keep\nyou healthy",
              style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontSize: isMobile ? 34 : 42,
                  fontWeight: FontWeight.w700,
                  height: 1.18),
            ),
            const SizedBox(height: 22),

            // Divider line with gold
            Container(
              width: 48,
              height: 3,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [_kTeal, _kTealLight]),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 22),

            // Description
            Text(
              "With World-class Preventive, Prescriptive & Curative "
              "Medical Practices, Dr. Ravinder's has been at the helm of "
              "nurturing healthy living since the turn of the New Century.",
              style: GoogleFonts.nunito(
                  color: Colors.white60, fontSize: 15, height: 1.75),
            ),
            const SizedBox(height: 36),

            // CTA
            Builder(builder: (ctx) {
              return _HeroPrimaryBtn(
                  label: "View All Services", onTap: (c) => c.go('/services'));
            }),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: _kTealLight.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: _kTealLight, width: 3)),
      ),
      child: Text(label,
          style: GoogleFonts.nunito(
              color: _kTealLight,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2)),
    );
  }
}

class _SvcData {
  final IconData icon;
  final String title, desc;
  const _SvcData(this.icon, this.title, this.desc);
}

class _ServicesListPanel extends StatelessWidget {
  final List<_SvcData> services;
  const _ServicesListPanel({required this.services});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(services.length, (i) {
        return _ServiceListItem(data: services[i], index: i);
      }),
    );
  }
}

class _ServiceListItem extends StatefulWidget {
  final _SvcData data;
  final int index;
  const _ServiceListItem({required this.data, required this.index});
  @override
  State<_ServiceListItem> createState() => _ServiceListItemState();
}

class _ServiceListItemState extends State<_ServiceListItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0.15, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    // Stagger: each item appears one by one
    Future.delayed(Duration(milliseconds: 100 * widget.index), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isActive = _hovered;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.only(bottom: 2),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            transform: isActive
                ? (Matrix4.identity()..translate(6.0, 0.0))
                : Matrix4.identity(),
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.white.withOpacity(0.12)
                  : Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(14),
              border: Border(
                left: BorderSide(
                  color:
                      isActive ? _kTealLight : Colors.white.withOpacity(0.15),
                  width: isActive ? 3 : 1,
                ),
              ),
            ),
            child: Row(
              children: [
                // Icon container
                AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isActive
                        ? _kTealLight.withOpacity(0.25)
                        : Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(widget.data.icon,
                      color: isActive ? _kTealLight : Colors.white60, size: 20),
                ),
                const SizedBox(width: 18),

                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.data.title,
                          style: GoogleFonts.nunito(
                              color: isActive ? Colors.white : Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                      if (isActive) ...[
                        const SizedBox(height: 4),
                        Text(widget.data.desc,
                            style: GoogleFonts.nunito(
                                color: Colors.white54,
                                fontSize: 13,
                                height: 1.4)),
                      ],
                    ],
                  ),
                ),

                // Arrow indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isActive
                        ? _kTealLight.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isActive ? Icons.arrow_forward_rounded : Icons.add_rounded,
                    color: isActive ? _kTealLight : Colors.white30,
                    size: 18,
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

// ═══════════════════════════════════════════════════════════════════
//  5 · STATS SECTION — animated counters
// ═══════════════════════════════════════════════════════════════════
class _StatsSection extends StatelessWidget {
  const _StatsSection();

  static const _stats = [
    _StatData('5000+', 'Patients Treated'),
    _StatData('10+', 'Years Experience'),
    _StatData('98%', 'Satisfaction Rate'),
    _StatData('2', 'Specialities'),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;

    return _FadeSlideIn(
      child: Container(
        width: double.infinity,
        color: _kSlate,
        padding:
            EdgeInsets.symmetric(vertical: 72, horizontal: isWide ? 80 : 24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: _kTeal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: _kTeal.withOpacity(0.4), width: 1.2),
              ),
              child: Text("OUR IMPACT",
                  style: GoogleFonts.nunito(
                      color: _kTeal,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2)),
            ),
            const SizedBox(height: 16),
            Text(
              "Numbers That Speak\nFor Themselves",
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                  color: _kDark,
                  fontSize: isWide ? 40 : 28,
                  fontWeight: FontWeight.w700,
                  height: 1.2),
            ),
            const SizedBox(height: 52),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: _stats.map((s) => _StatCard(data: s)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatData {
  final String value, label;
  const _StatData(this.value, this.label);
}

class _StatCard extends StatefulWidget {
  final _StatData data;
  const _StatCard({required this.data});
  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        width: 180,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
        transform: _hovered
            ? (Matrix4.identity()..translate(0.0, -6.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: _hovered ? _kDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: _hovered ? _kDark : _kDark.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(
                color: _kDark.withOpacity(_hovered ? 0.28 : 0.08),
                blurRadius: _hovered ? 32 : 16,
                offset: const Offset(0, 8))
          ],
        ),
        child: Column(
          children: [
            Text(widget.data.value,
                style: GoogleFonts.playfairDisplay(
                    color: _hovered ? _kTealLight : _kDark,
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic)),
            const SizedBox(height: 10),
            Text(widget.data.label,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                    color: _hovered ? Colors.white70 : _kLight,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  6 · CTA BANNER
// ═══════════════════════════════════════════════════════════════════
class _CTASection extends StatelessWidget {
  const _CTASection();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    return _FadeSlideIn(
      child: Container(
        width: double.infinity,
        color: _kIvory,
        padding:
            EdgeInsets.symmetric(vertical: 80, horizontal: isWide ? 80 : 24),
        child: Container(
          padding: EdgeInsets.all(isWide ? 60 : 36),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0A2E2A), Color(0xFF0D3B34)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFF0A2E2A).withOpacity(0.4),
                  blurRadius: 50,
                  offset: const Offset(0, 20))
            ],
          ),
          child: isWide
              ? Row(
                  children: [
                    Expanded(child: _ctaText(isWide)),
                    const SizedBox(width: 48),
                    Column(
                      children: [
                        _ctaBtn(context, "Book Appointment", true),
                        const SizedBox(height: 12),
                        _ctaBtn(context, "Our Services", false),
                      ],
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ctaText(isWide),
                    const SizedBox(height: 32),
                    _ctaBtn(context, "Book Appointment", true),
                    const SizedBox(height: 12),
                    _ctaBtn(context, "Our Services", false),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _ctaText(bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 3,
          decoration: BoxDecoration(
              color: _kTeal, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(height: 18),
        Text(
          "Ready for Your\nTransformation?",
          style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: isWide ? 44 : 30,
              fontWeight: FontWeight.w700,
              height: 1.18),
        ),
        const SizedBox(height: 14),
        Text(
          "Book a consultation today.\nExpert dental & skin care — just one click away.",
          style: GoogleFonts.nunito(
              color: Colors.white60, fontSize: 15, height: 1.65),
        ),
      ],
    );
  }

  Widget _ctaBtn(BuildContext context, String label, bool filled) {
    return SizedBox(
      width: 210,
      child: filled
          ? ElevatedButton(
              onPressed: () => context.go('/booking'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _kTealLight,
                foregroundColor: _kDark,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 0,
              ),
              child: Text(label,
                  style: GoogleFonts.nunito(
                      fontSize: 14, fontWeight: FontWeight.w800)),
            )
          : OutlinedButton(
              onPressed: () => context.go('/services'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withOpacity(0.35)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: Text(label,
                  style: GoogleFonts.nunito(
                      fontSize: 14, fontWeight: FontWeight.w700)),
            ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  UTIL — Fade + Slide In wrapper
// ═══════════════════════════════════════════════════════════════════
class _FadeSlideIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  const _FadeSlideIn(
      {required this.child, this.delay = const Duration(milliseconds: 100)});
  @override
  State<_FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<_FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 850));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
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
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: _fade,
        child: SlideTransition(position: _slide, child: widget.child));
  }
}
