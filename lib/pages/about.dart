import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/header.dart';

// ── Palette ───────────────────────────────────────────────────────
const _kDark = Color(0xFF0A2E2A);
const _kTealLight = Color(0xFF5EEAD4);
const _kTeal = Color(0xFF0D9E8C);
const _kHeading = Color(0xFF0A2E2A);
const _kLight = Color(0xFF64748B);
const _kBody = Color(0xFF334155);
const _kSlate = Color(0xFFE6FAF7);
const _kIvory = Color(0xFFF0FDFA);

// ═══════════════════════════════════════════════════════════════════
//  PAGE ROOT — AppLayout handles Scaffold + scroll
// ═══════════════════════════════════════════════════════════════════
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _AboutHeroSection(),
        _MissionSection(),
        _DoctorProfileSection(),
        _StatsSection(),
        _ValuesSection(),
        _WhyUsSection(),
        _TestimonialsSection(),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  1 · HERO
// ═══════════════════════════════════════════════════════════════════
class _AboutHeroSection extends StatefulWidget {
  const _AboutHeroSection();
  @override
  State<_AboutHeroSection> createState() => _AboutHeroSectionState();
}

class _AboutHeroSectionState extends State<_AboutHeroSection>
    with TickerProviderStateMixin {
  late final AnimationController _bgCtrl, _textCtrl;
  late final Animation<double> _bgScale, _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _bgCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 12))
          ..repeat(reverse: true);
    _bgScale = Tween<double>(begin: 1.0, end: 1.1)
        .animate(CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut));
    _textCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..forward();
    _fade = CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: _textCtrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    return SizedBox(
      height: isMobile ? 540 : 620,
      child: Stack(fit: StackFit.expand, children: [
        AnimatedBuilder(
          animation: _bgScale,
          builder: (_, child) =>
              Transform.scale(scale: _bgScale.value, child: child),
          child: Image.asset('assets/images/home_image.jpeg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: _kDark)),
        ),
        Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
          colors: [
            _kDark.withOpacity(0.88),
            _kDark.withOpacity(0.55),
            Colors.transparent
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ))),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipPath(
            clipper: _DiagClipper(),
            child: Container(height: 100, color: _kTealLight.withOpacity(0.15)),
          ),
        ),
        Center(
            child: FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const SizedBox(height: 36),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: _kTealLight.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: _kTealLight.withOpacity(0.5), width: 1.2),
                        ),
                        child: Text('ABOUT US',
                            style: GoogleFonts.nunito(
                                color: _kTealLight,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 3)),
                      ),
                      const SizedBox(height: 22),
                      Text('Healing Smiles,\nGlowing Skin.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(
                              color: Colors.white,
                              fontSize: isMobile ? 38 : 56,
                              fontWeight: FontWeight.w700,
                              height: 1.15)),
                      const SizedBox(height: 18),
                      Text(
                          'Your trusted destination for dental\n& skin care in Kartarpur, Punjab.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                              color: Colors.white70,
                              fontSize: isMobile ? 14 : 17,
                              height: 1.6)),
                    ]),
                  ),
                ))),
      ]),
    );
  }
}

class _DiagClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size s) => Path()
    ..moveTo(0, s.height * 0.6)
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
    return _FadeSlideIn(
        child: Container(
      width: double.infinity,
      padding:
          EdgeInsets.symmetric(vertical: 72, horizontal: isMobile ? 24 : 80),
      color: Colors.white,
      child: isMobile
          ? _MissionContent(isMobile: true)
          : Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(child: _MissionContent(isMobile: false)),
              const SizedBox(width: 60),
              Expanded(child: _MissionImageCard()),
            ]),
    ));
  }
}

class _MissionContent extends StatelessWidget {
  final bool isMobile;
  const _MissionContent({required this.isMobile});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _SectionBadge(label: 'OUR MISSION'),
      const SizedBox(height: 20),
      RichText(
          text: TextSpan(children: [
        TextSpan(
            text: 'Excellence in\n',
            style: GoogleFonts.playfairDisplay(
                color: _kHeading,
                fontSize: isMobile ? 30 : 42,
                fontWeight: FontWeight.w700,
                height: 1.2)),
        TextSpan(
            text: 'Every Treatment',
            style: GoogleFonts.playfairDisplay(
                color: _kTeal,
                fontSize: isMobile ? 30 : 42,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                height: 1.2)),
      ])),
      const SizedBox(height: 20),
      Text(
        "At Glowora Clinic, we believe every patient deserves personalised, world-class care in a comfortable and welcoming environment. Dr. Ravinder combines the latest dental and dermatology techniques with a gentle, patient-first approach — because your comfort and confidence matter to us.",
        style: GoogleFonts.nunito(
            color: _kLight, fontSize: isMobile ? 14 : 16, height: 1.75),
      ),
      const SizedBox(height: 32),
      Wrap(spacing: 14, runSpacing: 14, children: const [
        _HighlightChip(label: '✦  Modern Equipment'),
        _HighlightChip(label: '✦  Pain-free Procedures'),
        _HighlightChip(label: '✦  Personalised Care Plans'),
        _HighlightChip(label: '✦  Hygienic & Safe'),
      ]),
      if (isMobile) ...[const SizedBox(height: 36), const _MissionImageCard()],
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
        child: Image.asset('assets/images/doc_image.jpeg',
            height: 360,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
                height: 360,
                color: _kTealLight.withOpacity(0.15),
                child: Icon(Icons.local_hospital, size: 80, color: _kTeal))),
      ),
      Positioned(
        bottom: -20,
        left: 20,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: _kDark,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: _kDark.withOpacity(0.35),
                  blurRadius: 22,
                  offset: const Offset(0, 8))
            ],
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.verified, color: _kTealLight, size: 22),
            const SizedBox(width: 10),
            Text('Trusted by Our Patients',
                style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14)),
          ]),
        ),
      ),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════
//  3 · DOCTOR PROFILE — Dr. Ravinder, solo practitioner
// ═══════════════════════════════════════════════════════════════════
class _DoctorProfileSection extends StatelessWidget {
  const _DoctorProfileSection();
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    return _FadeSlideIn(
      delay: const Duration(milliseconds: 150),
      child: Container(
        width: double.infinity,
        padding:
            EdgeInsets.symmetric(vertical: 80, horizontal: isMobile ? 24 : 80),
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [_kDark, const Color(0xFF0D3B34)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        child: isMobile
            ? const Column(children: [
                _FloatingDoctorAvatar(),
                SizedBox(height: 36),
                _DoctorBio(isMobile: true),
              ])
            : const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    _FloatingDoctorAvatar(),
                    SizedBox(width: 64),
                    Expanded(child: _DoctorBio(isMobile: false)),
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
  late final AnimationController _floatCtrl, _glowCtrl;
  late final Animation<double> _float, _glow;
  @override
  void initState() {
    super.initState();
    _floatCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: true);
    _float = Tween<double>(begin: -8, end: 8)
        .animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
    _glowCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
    _glow = Tween<double>(begin: 0.4, end: 1.0)
        .animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_float, _glow]),
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _float.value),
        child: SizedBox(
            width: 240,
            height: 280,
            child: Stack(alignment: Alignment.center, children: [
              Container(
                  width: 235,
                  height: 270,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(120),
                    border: Border.all(
                        color: _kTealLight.withOpacity(0.25 * _glow.value),
                        width: 2),
                    boxShadow: [
                      BoxShadow(
                          color: _kTealLight.withOpacity(0.18 * _glow.value),
                          blurRadius: 40,
                          spreadRadius: 4)
                    ],
                  )),
              Container(
                  width: 218,
                  height: 252,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(110),
                    border:
                        Border.all(color: _kTeal.withOpacity(0.4), width: 1.5),
                  )),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset('assets/images/aboutpic.jpg',
                    width: 200,
                    height: 240,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                        width: 200,
                        height: 240,
                        color: _kTealLight.withOpacity(0.15),
                        child:
                            Icon(Icons.person, size: 90, color: _kTealLight))),
              ),
              Positioned(
                  bottom: 8,
                  right: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: _kTeal,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: _kTeal.withOpacity(0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 4))
                      ],
                    ),
                    child: Text("BDS · MDS",
                        style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5)),
                  )),
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
        const SizedBox(height: 18),
        Text('Dr. Ravinder',
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.playfairDisplay(
                color: Colors.white,
                fontSize: isMobile ? 32 : 46,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text('BDS, MDS — Dental Surgeon & Aesthetic Dermatologist',
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.nunito(
                color: _kTealLight, fontSize: 14, height: 1.5)),
        const SizedBox(height: 22),
        Container(
            width: 44,
            height: 2,
            decoration: BoxDecoration(
                color: _kTeal, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 22),
        Text(
          "Dr. Ravinder is a qualified dental surgeon and aesthetic dermatologist who has recently opened  Dr Ravinder's Dental and Skin Aesthetic Clinic right here in Kartarpur. With professional training in both dentistry and skin care, she brings expert, personalised treatment to every patient — combining clinical precision with a warm, caring approach.\n\nAt Glowora, you're not just a patient — you're a priority. Dr. Ravinder personally handles every consultation and treatment, ensuring the highest standard of care every single visit.",
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.nunito(
              color: Colors.white70, fontSize: 15, height: 1.75),
        ),
        const SizedBox(height: 30),
        Wrap(
            spacing: 16,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _kTealLight.withOpacity(0.3)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: _kTealLight, size: 17),
          const SizedBox(width: 8),
          Text(label,
              style: GoogleFonts.nunito(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ]),
      );
}

// ═══════════════════════════════════════════════════════════════════
//  4 · STATS — honest numbers for a new clinic
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
    return _FadeSlideIn(
        child: Container(
      width: double.infinity,
      color: _kSlate,
      padding: EdgeInsets.symmetric(vertical: 72, horizontal: isWide ? 80 : 24),
      child: Column(children: [
        const _SectionBadge(label: 'GLOWORA AT A GLANCE'),
        const SizedBox(height: 16),
        Text('Everything We Bring\nTo Your Care',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
                color: _kHeading,
                fontSize: isWide ? 40 : 28,
                fontWeight: FontWeight.w700,
                height: 1.2)),
        const SizedBox(height: 8),
        Text('Newly opened. Fully equipped. Deeply committed.',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(color: _kLight, fontSize: 14)),
        const SizedBox(height: 52),
        Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: _items.map((d) => _StatCard(item: d)).toList()),
      ]),
    ));
  }
}

class _StatItem {
  final IconData icon;
  final String value, label;
  const _StatItem(this.icon, this.value, this.label);
}

class _StatCard extends StatefulWidget {
  final _StatItem item;
  const _StatCard({required this.item});
  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 180,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
        transform: _hovered
            ? (Matrix4.identity()..translate(0.0, -8.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: _hovered ? _kDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: _kDark.withOpacity(_hovered ? 0.3 : 0.08),
                blurRadius: _hovered ? 36 : 16,
                offset: const Offset(0, 8))
          ],
        ),
        child: Column(children: [
          Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: _hovered
                    ? _kTealLight.withOpacity(0.2)
                    : _kTeal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(widget.item.icon,
                  color: _hovered ? _kTealLight : _kTeal, size: 24)),
          const SizedBox(height: 16),
          Text(widget.item.value,
              style: GoogleFonts.playfairDisplay(
                  color: _hovered ? _kTealLight : _kDark,
                  fontSize: 34,
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
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  5 · VALUES
// ═══════════════════════════════════════════════════════════════════
class _ValuesSection extends StatelessWidget {
  const _ValuesSection();
  static const _values = [
    _ValueData(Icons.favorite_outline, 'Compassion',
        'Every patient is treated with kindness, respect, and genuine care.'),
    _ValueData(Icons.science_outlined, 'Innovation',
        'Modern, evidence-based techniques for the best possible results.'),
    _ValueData(Icons.workspace_premium_outlined, 'Excellence',
        'Uncompromising quality in every consultation and procedure.'),
    _ValueData(Icons.lock_outline, 'Trust',
        'Transparent advice and ethical practice — always honest with you.'),
  ];
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding:
          EdgeInsets.symmetric(vertical: 72, horizontal: isMobile ? 24 : 80),
      child: Column(children: [
        const _SectionBadge(label: 'OUR VALUES'),
        const SizedBox(height: 16),
        Text('What Drives Us Every Day',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
                color: _kHeading,
                fontSize: isMobile ? 26 : 40,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 52),
        Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: List.generate(_values.length,
                (i) => _HoverValueCard(data: _values[i], index: i))),
      ]),
    );
  }
}

class _ValueData {
  final IconData icon;
  final String title, desc;
  const _ValueData(this.icon, this.title, this.desc);
}

class _HoverValueCard extends StatefulWidget {
  final _ValueData data;
  final int index;
  const _HoverValueCard({required this.data, required this.index});
  @override
  State<_HoverValueCard> createState() => _HoverValueCardState();
}

class _HoverValueCardState extends State<_HoverValueCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  bool _hovered = false;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(Duration(milliseconds: 180 * widget.index), () {
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
    final w = MediaQuery.of(context).size.width;
    final cardW = (w < 700 ? w - 48.0 : (w - 200) / 2).clamp(200.0, 360.0);
    return FadeTransition(
        opacity: _fade,
        child: SlideTransition(
            position: _slide,
            child: MouseRegion(
              onEnter: (_) => setState(() => _hovered = true),
              onExit: (_) => setState(() => _hovered = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                width: cardW,
                padding: const EdgeInsets.all(28),
                transform: _hovered
                    ? (Matrix4.identity()..translate(0.0, -8.0))
                    : Matrix4.identity(),
                decoration: BoxDecoration(
                  color: _hovered ? _kDark : _kIvory,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: _hovered ? _kDark : _kTeal.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                        color: _kDark.withOpacity(_hovered ? 0.28 : 0.06),
                        blurRadius: _hovered ? 36 : 12,
                        offset: const Offset(0, 8))
                  ],
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: _hovered
                                ? _kTealLight.withOpacity(0.2)
                                : _kTeal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(widget.data.icon,
                              color: _hovered ? _kTealLight : _kTeal,
                              size: 26)),
                      const SizedBox(height: 18),
                      Text(widget.data.title,
                          style: GoogleFonts.playfairDisplay(
                              color: _hovered ? Colors.white : _kHeading,
                              fontSize: 22,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),
                      Text(widget.data.desc,
                          style: GoogleFonts.nunito(
                              color: _hovered ? Colors.white60 : _kLight,
                              fontSize: 14,
                              height: 1.65)),
                    ]),
              ),
            )));
  }
}

// ═══════════════════════════════════════════════════════════════════
//  6 · WHY GLOWORA? — replaces team + timeline (new solo clinic)
// ═══════════════════════════════════════════════════════════════════
class _WhyUsSection extends StatelessWidget {
  const _WhyUsSection();
  static const _points = [
    _WhyData(Icons.person_pin_circle_rounded, 'One Expert, Complete Care',
        "Dr. Ravinder personally handles every dental and skin consultation. No handoffs, no strangers — just consistent, expert care every visit."),
    _WhyData(Icons.medical_information_rounded, 'Latest Equipment',
        "Dr Ravinder's Dental and Skin Aesthetic Clinic is equipped with modern dental and dermatology tools, ensuring accurate diagnosis and comfortable procedures from day one."),
    _WhyData(Icons.location_on_rounded, 'Right Here in Kartarpur',
        "No need to travel to city hospitals. Premium dental and skin care right at home — at fair, transparent prices."),
    _WhyData(Icons.schedule_rounded, 'Easy Appointments',
        "Simple online booking, short wait times, and a doctor who actually listens. Your time and comfort are our priority."),
  ];
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    return _FadeSlideIn(
        child: Container(
      width: double.infinity,
      color: _kSlate,
      padding:
          EdgeInsets.symmetric(vertical: 72, horizontal: isMobile ? 24 : 80),
      child: Column(children: [
        const _SectionBadge(
            label: "WHY Dr Ravinder's Dental and Skin Aesthetic Clinic?"),
        const SizedBox(height: 16),
        Text('Why Patients\nChoose Us',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
                color: _kHeading,
                fontSize: isMobile ? 28 : 42,
                fontWeight: FontWeight.w700,
                height: 1.2)),
        const SizedBox(height: 52),
        Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: _points.map((p) => _WhyCard(data: p)).toList()),
      ]),
    ));
  }
}

class _WhyData {
  final IconData icon;
  final String title, desc;
  const _WhyData(this.icon, this.title, this.desc);
}

class _WhyCard extends StatefulWidget {
  final _WhyData data;
  const _WhyCard({required this.data});
  @override
  State<_WhyCard> createState() => _WhyCardState();
}

class _WhyCardState extends State<_WhyCard> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cardW = (w < 700 ? w - 48.0 : (w > 1100 ? (w - 240) / 2 : w - 208.0))
        .clamp(260.0, 480.0);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: cardW,
        padding: const EdgeInsets.all(28),
        transform: _hovered
            ? (Matrix4.identity()..translate(0.0, -6.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: _hovered ? _kDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: _hovered ? _kDark : _kTeal.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
                color: _kDark.withOpacity(_hovered ? 0.25 : 0.06),
                blurRadius: _hovered ? 32 : 12,
                offset: const Offset(0, 6))
          ],
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: _hovered
                    ? _kTealLight.withOpacity(0.2)
                    : _kTeal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(widget.data.icon,
                  color: _hovered ? _kTealLight : _kTeal, size: 24)),
          const SizedBox(width: 18),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(widget.data.title,
                    style: GoogleFonts.nunito(
                        color: _hovered ? Colors.white : _kHeading,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(widget.data.desc,
                    style: GoogleFonts.nunito(
                        color: _hovered ? Colors.white60 : _kLight,
                        fontSize: 13,
                        height: 1.65)),
              ])),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  7 · TESTIMONIALS — realistic early patient reviews
// ═══════════════════════════════════════════════════════════════════
class _TestimonialsSection extends StatelessWidget {
  const _TestimonialsSection();
  static const _reviews = [
    _ReviewData(
      'Manpreet Kaur',
      "Bahut hi achha experience tha. Dr. Ravinder ne bahut carefully dental cleaning kiti — bilkul pain nahi si. Highly recommended!",
      '⭐⭐⭐⭐⭐',
    ),
    _ReviewData(
      'Arjun Singh',
      "Acne treatment started recently and already seeing good results. Dr. Ravinder explained everything clearly. Bahut professional clinic hai.",
      '⭐⭐⭐⭐⭐',
    ),
    _ReviewData(
      'Simran Bhatia',
      "Sadi locality vich hi itni premium clinic aa gayi. Kartarpur de liye bahut vadia hai. Doctor da behaviour bahut caring hai.",
      '⭐⭐⭐⭐⭐',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    return _FadeSlideIn(
        child: Container(
      width: double.infinity,
      padding:
          EdgeInsets.symmetric(vertical: 80, horizontal: isMobile ? 24 : 80),
      color: Colors.white,
      child: Column(children: [
        const _SectionBadge(label: 'WHAT PATIENTS SAY'),
        const SizedBox(height: 16),
        Text('Early Smiles,\nReal Feedback',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
                color: _kHeading,
                fontSize: isMobile ? 28 : 42,
                fontWeight: FontWeight.w700,
                height: 1.2)),
        const SizedBox(height: 8),
        Text("From our first patients — honest feedback we're proud of.",
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(color: _kLight, fontSize: 14)),
        const SizedBox(height: 52),
        Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: _reviews.map((r) => _ReviewCard(data: r)).toList()),
      ]),
    ));
  }
}

class _ReviewData {
  final String name, review, stars;
  const _ReviewData(this.name, this.review, this.stars);
}

class _ReviewCard extends StatelessWidget {
  final _ReviewData data;
  const _ReviewCard({required this.data});
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Container(
      width: (w < 700 ? w - 48.0 : 320.0).clamp(260.0, 380.0),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: _kIvory,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kTeal.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
              color: _kDark.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 6))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(data.stars, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 14),
        Text('"${data.review}"',
            style: GoogleFonts.nunito(
                color: _kBody,
                fontSize: 14,
                height: 1.7,
                fontStyle: FontStyle.italic)),
        const SizedBox(height: 18),
        Row(children: [
          CircleAvatar(
              radius: 16,
              backgroundColor: _kTeal.withOpacity(0.15),
              child: Icon(Icons.person, size: 18, color: _kTeal)),
          const SizedBox(width: 10),
          Text(data.name,
              style: GoogleFonts.nunito(
                  color: _kHeading, fontWeight: FontWeight.w700, fontSize: 13)),
        ]),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  HELPERS
// ═══════════════════════════════════════════════════════════════════
class _FadeSlideIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  const _FadeSlideIn({required this.child, this.delay = Duration.zero});
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
        vsync: this, duration: const Duration(milliseconds: 900));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: light ? _kTealLight.withOpacity(0.2) : _kTeal.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: light
                  ? _kTealLight.withOpacity(0.5)
                  : _kTeal.withOpacity(0.35),
              width: 1.2),
        ),
        child: Text(label,
            style: GoogleFonts.nunito(
                color: light ? _kTealLight : _kTeal,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.5)),
      );
}

class _HighlightChip extends StatelessWidget {
  final String label;
  const _HighlightChip({required this.label});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
            color: _kTeal.withOpacity(0.08),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: _kTeal.withOpacity(0.2))),
        child: Text(label,
            style: GoogleFonts.nunito(
                color: _kDark, fontSize: 13, fontWeight: FontWeight.w500)),
      );
}
