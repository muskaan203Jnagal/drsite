import 'package:flutter/material.dart';

// ─── COLORS ───────────────────────────────────────────────────────────────────
const kDeepBlue = Color(0xFF0A2540);
const kSoftRose = Color(0xFFE8AEB7);
const kWhite = Colors.white;
const kHeading = Color(0xFF0A2540);
const kLight = Color(0xFF64748B);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  HOME PAGE
// ═══════════════════════════════════════════════════════════════════════════════
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: const [
            HeroSection(),
            _DocImageSection(),
            _AnimatedAppointmentBar(),
            _AnimatedServicesSection(),
            _AnimatedStatsSection(),
            _AnimatedFooter(),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  1. HERO — Ken Burns zoom + staggered text reveal
// ═══════════════════════════════════════════════════════════════════════════════
class HeroSection extends StatefulWidget {
  const HeroSection({super.key});
  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _ctrl;
  late AnimationController _entrance;
  late Animation<double> _imgScale;
  late Animation<double> _badgeFade;
  late Animation<Offset> _badgeSlide;
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _subFade;
  late Animation<double> _btnFade;
  late Animation<Offset> _btnSlide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);

    _imgScale = Tween<double>(begin: 1.0, end: 1.12)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

    // Text entrance — use a separate short controller
    late AnimationController _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();

    _badgeFade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _entrance, curve: const Interval(0.0, 0.4)));
    _badgeSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _entrance,
            curve: const Interval(0.0, 0.4, curve: Curves.easeOut)));

    _titleFade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _entrance, curve: const Interval(0.2, 0.6)));
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _entrance,
            curve: const Interval(0.2, 0.6, curve: Curves.easeOut)));

    _subFade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _entrance, curve: const Interval(0.45, 0.75)));

    _btnFade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _entrance, curve: const Interval(0.65, 1.0)));
    _btnSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _entrance,
            curve: const Interval(0.65, 1.0, curve: Curves.easeOut)));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 700;

    return SizedBox(
      height: isMobile ? 580 : 680,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Ken Burns image ──
          AnimatedBuilder(
            animation: _imgScale,
            builder: (_, child) =>
                Transform.scale(scale: _imgScale.value, child: child),
            child: Image.asset(
              'assets/images/home_image.jpeg',
              fit: BoxFit.cover,
            ),
          ),

          // ── Gradient overlay ──
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.72),
                  Colors.black.withOpacity(0.35),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          // ── Diagonal rose accent ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _DiagonalClipper(),
              child: Container(height: 80, color: kSoftRose.withOpacity(0.18)),
            ),
          ),

          // ── Staggered text ──
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // badge pill
                  FadeTransition(
                    opacity: _badgeFade,
                    child: SlideTransition(
                      position: _badgeSlide,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 7),
                        decoration: BoxDecoration(
                          color: kSoftRose.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: kSoftRose.withOpacity(0.6), width: 1.2),
                        ),
                        child: const Text(
                          "Dr. Ravinder's Dental & Skin Aesthetic Clinic",
                          style: TextStyle(
                              color: kSoftRose,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // headline
                  FadeTransition(
                    opacity: _titleFade,
                    child: SlideTransition(
                      position: _titleSlide,
                      child: Text(
                        "A Great Place\nCare for Yourself",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isMobile ? 38 : 58,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // sub
                  FadeTransition(
                    opacity: _subFade,
                    child: const Text(
                      "Kartarpur  •  +91 98765 43210",
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // buttons
                  FadeTransition(
                    opacity: _btnFade,
                    child: SlideTransition(
                      position: _btnSlide,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _HeroPrimaryBtn(label: "Book Appointment"),
                          const SizedBox(width: 12),
                          _HeroOutlineBtn(label: "Learn More"),
                        ],
                      ),
                    ),
                  ),
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
  Path getClip(Size size) => Path()
    ..moveTo(0, size.height * 0.5)
    ..lineTo(size.width, 0)
    ..lineTo(size.width, size.height)
    ..lineTo(0, size.height)
    ..close();
  @override
  bool shouldReclip(_) => false;
}

class _HeroPrimaryBtn extends StatefulWidget {
  final String label;
  const _HeroPrimaryBtn({required this.label});
  @override
  State<_HeroPrimaryBtn> createState() => _HeroPrimaryBtnState();
}

class _HeroPrimaryBtnState extends State<_HeroPrimaryBtn> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        transform: _hovered
            ? (Matrix4.identity()..translate(0.0, -3.0))
            : Matrix4.identity(),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: kDeepBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: _hovered ? 8 : 2,
            shadowColor: kDeepBlue.withOpacity(0.4),
          ),
          child: Text(widget.label,
              style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}

class _HeroOutlineBtn extends StatefulWidget {
  final String label;
  const _HeroOutlineBtn({required this.label});
  @override
  State<_HeroOutlineBtn> createState() => _HeroOutlineBtnState();
}

class _HeroOutlineBtnState extends State<_HeroOutlineBtn> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        transform: _hovered
            ? (Matrix4.identity()..translate(0.0, -3.0))
            : Matrix4.identity(),
        child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: BorderSide(
                color: _hovered ? kSoftRose : Colors.white70, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(widget.label,
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  2. DOC IMAGE — parallax-style reveal
// ═══════════════════════════════════════════════════════════════════════════════
class _DocImageSection extends StatelessWidget {
  const _DocImageSection();

  @override
  Widget build(BuildContext context) {
    return _FadeSlideIn(
      delay: const Duration(milliseconds: 200),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                'assets/images/doc_image.jpeg',
                height: 340,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // floating badge bottom-left
            Positioned(
              bottom: -18,
              left: 24,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: kDeepBlue,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                        color: kDeepBlue.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8))
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.verified, color: kSoftRose, size: 20),
                    SizedBox(width: 8),
                    Text('Trusted by 5000+ Patients',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13)),
                  ],
                ),
              ),
            ),
            // floating badge top-right
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: kSoftRose,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('10+ Years ✦',
                    style: TextStyle(
                        color: kDeepBlue,
                        fontWeight: FontWeight.w800,
                        fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  3. APPOINTMENT BAR — slide up + hover fields
// ═══════════════════════════════════════════════════════════════════════════════
class _AnimatedAppointmentBar extends StatelessWidget {
  const _AnimatedAppointmentBar();

  @override
  Widget build(BuildContext context) {
    return _FadeSlideIn(
      delay: const Duration(milliseconds: 100),
      child: const AppointmentBar(),
    );
  }
}

class AppointmentBar extends StatelessWidget {
  const AppointmentBar({super.key});

  Widget _field(String title, String value, IconData icon) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 11,
                  color: kLight,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1)),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(icon, size: 17, color: kDeepBlue),
              const SizedBox(width: 7),
              Flexible(
                child: Text(value,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: kHeading,
                        fontSize: 13)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
              blurRadius: 30,
              color: kDeepBlue.withOpacity(0.12),
              offset: const Offset(0, 10))
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _field(
                    "Service", "Dental Care", Icons.medical_services_outlined),
                const Divider(height: 20),
                _field("Date", "DD / MM / YYYY", Icons.calendar_today_outlined),
                const Divider(height: 20),
                _field("Contact", "+91 98765 43210", Icons.phone_outlined),
                const SizedBox(height: 16),
                _BookBtn(),
              ],
            )
          : Row(
              children: [
                _field(
                    "Service", "Dental Care", Icons.medical_services_outlined),
                _Divider(),
                _field("Date", "DD / MM / YYYY", Icons.calendar_today_outlined),
                _Divider(),
                _field("Contact", "+91 98765 43210", Icons.phone_outlined),
                const SizedBox(width: 20),
                _BookBtn(),
              ],
            ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        color: kDeepBlue.withOpacity(0.1),
      );
}

class _BookBtn extends StatefulWidget {
  @override
  State<_BookBtn> createState() => _BookBtnState();
}

class _BookBtnState extends State<_BookBtn> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        transform: _hovered
            ? (Matrix4.identity()..translate(0.0, -3.0))
            : Matrix4.identity(),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: kDeepBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: _hovered ? 10 : 3,
            shadowColor: kDeepBlue.withOpacity(0.35),
          ),
          child: const Text("Book Appointment",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  4. SERVICES — staggered card entrance + hover glow
// ═══════════════════════════════════════════════════════════════════════════════
class _AnimatedServicesSection extends StatelessWidget {
  const _AnimatedServicesSection();

  static const _services = [
    _ServiceData(Icons.favorite_outline, 'Cardiology',
        'Heart health screenings & consultations'),
    _ServiceData(Icons.face_retouching_natural, 'Skin Care',
        'Advanced dermatology & aesthetic treatments'),
    _ServiceData(Icons.medical_services_outlined, 'Dental Care',
        'Complete oral care from scaling to implants'),
    _ServiceData(Icons.local_hospital_outlined, 'Surgery',
        'Minor surgical procedures done with precision'),
  ];

  @override
  Widget build(BuildContext context) {
    return _FadeSlideIn(
      delay: const Duration(milliseconds: 100),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 24),
        color: kDeepBlue,
        child: Column(
          children: [
            // section badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: kSoftRose.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
                border:
                    Border.all(color: kSoftRose.withOpacity(0.5), width: 1.2),
              ),
              child: const Text('OUR SERVICES',
                  style: TextStyle(
                      color: kSoftRose,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.5)),
            ),
            const SizedBox(height: 16),
            const Text(
              'What We Offer',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Comprehensive care under one roof.',
              style: TextStyle(color: Colors.white60, fontSize: 15),
            ),
            const SizedBox(height: 50),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: List.generate(
                _services.length,
                (i) => _ServiceCard(data: _services[i], index: i),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceData {
  final IconData icon;
  final String title, desc;
  const _ServiceData(this.icon, this.title, this.desc);
}

class _ServiceCard extends StatefulWidget {
  final _ServiceData data;
  final int index;
  const _ServiceCard({required this.data, required this.index});
  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(Duration(milliseconds: 150 * widget.index), () {
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
    final cardW = w < 700 ? w - 48.0 : 240.0;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            width: cardW,
            padding: const EdgeInsets.all(26),
            transform: _hovered
                ? (Matrix4.identity()..translate(0.0, -8.0))
                : Matrix4.identity(),
            decoration: BoxDecoration(
              color: _hovered
                  ? Colors.white.withOpacity(0.15)
                  : Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _hovered
                    ? kSoftRose.withOpacity(0.5)
                    : Colors.white.withOpacity(0.1),
                width: 1.2,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                          color: kSoftRose.withOpacity(0.2),
                          blurRadius: 24,
                          offset: const Offset(0, 10))
                    ]
                  : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: kSoftRose.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(widget.data.icon, color: kSoftRose, size: 24),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 280),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _hovered
                            ? kSoftRose.withOpacity(0.3)
                            : kSoftRose.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.arrow_forward,
                          size: 16, color: kSoftRose),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(widget.data.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(widget.data.desc,
                    style: const TextStyle(
                        color: Colors.white60, fontSize: 13, height: 1.55)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  5. STATS — animated counter + circle pulse
// ═══════════════════════════════════════════════════════════════════════════════
class _AnimatedStatsSection extends StatelessWidget {
  const _AnimatedStatsSection();

  @override
  Widget build(BuildContext context) {
    return _FadeSlideIn(
      delay: const Duration(milliseconds: 100),
      child: Container(
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: kDeepBlue.withOpacity(0.07),
                borderRadius: BorderRadius.circular(30),
                border:
                    Border.all(color: kDeepBlue.withOpacity(0.2), width: 1.2),
              ),
              child: const Text('BY THE NUMBERS',
                  style: TextStyle(
                      color: kDeepBlue,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.5)),
            ),
            const SizedBox(height: 16),
            const Text('Our Results Speak',
                style: TextStyle(
                    color: kHeading,
                    fontSize: 34,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 50),
            Wrap(
              spacing: 40,
              runSpacing: 40,
              alignment: WrapAlignment.center,
              children: const [
                _PulseStatCircle(value: '67%', label: 'Happy Patients'),
                _PulseStatCircle(value: '99%', label: 'Success Rate'),
                _PulseStatCircle(value: '120+', label: 'Procedures Done'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PulseStatCircle extends StatefulWidget {
  final String value, label;
  const _PulseStatCircle({required this.value, required this.label});
  @override
  State<_PulseStatCircle> createState() => _PulseStatCircleState();
}

class _PulseStatCircleState extends State<_PulseStatCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
    _pulse = Tween<double>(begin: 1.0, end: 1.08)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _pulse,
          builder: (_, child) =>
              Transform.scale(scale: _pulse.value, child: child),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // outer glow ring
              Container(
                width: 108,
                height: 108,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: kDeepBlue.withOpacity(0.2), width: 1),
                ),
              ),
              // main circle
              Container(
                width: 94,
                height: 94,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kDeepBlue, width: 3),
                  color: kDeepBlue.withOpacity(0.04),
                ),
                child: Center(
                  child: Text(
                    widget.value,
                    style: const TextStyle(
                        color: kDeepBlue,
                        fontSize: 22,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(widget.label,
            style: const TextStyle(
                color: kLight, fontWeight: FontWeight.w600, fontSize: 14)),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  6. FOOTER — full width + animated buttons
// ═══════════════════════════════════════════════════════════════════════════════
class _AnimatedFooter extends StatelessWidget {
  const _AnimatedFooter();

  @override
  Widget build(BuildContext context) {
    return _FadeSlideIn(
      delay: const Duration(milliseconds: 100),
      child: const FooterSection(),
    );
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      width: double.infinity,
      color: kDeepBlue,
      padding: EdgeInsets.symmetric(
        vertical: 100,
        horizontal: isMobile ? 24 : 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // rose line accent
          Container(
            width: 60,
            height: 3,
            decoration: BoxDecoration(
              color: kSoftRose,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            "Dr. Ravinder's\nDental & Skin Aesthetic Clinic",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kSoftRose,
              fontSize: 38,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your trusted clinic in Kartarpur for smiles & glowing skin.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white60, fontSize: 15, height: 1.6),
          ),
          const SizedBox(height: 50),
          Wrap(
            spacing: 32,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: const [
              _FooterInfo(emoji: '📍', text: 'Kartarpur'),
              _FooterInfo(emoji: '📞', text: '+91 98765 43210'),
              _FooterInfo(emoji: '🕒', text: '9AM – 7PM'),
            ],
          ),
          const SizedBox(height: 50),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: const [
              _FooterButton(label: 'Book Appointment', primary: true),
              _FooterButton(label: 'Leave Review', primary: false),
            ],
          ),
          const SizedBox(height: 60),
          Divider(color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 20),
          const Text(
            '© 2025 Dr. Ravinder\'s Clinic. All rights reserved.',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _FooterInfo extends StatelessWidget {
  final String emoji, text;
  const _FooterInfo({required this.emoji, required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 8),
        Text(text,
            style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _FooterButton extends StatefulWidget {
  final String label;
  final bool primary;
  const _FooterButton({required this.label, required this.primary});
  @override
  State<_FooterButton> createState() => _FooterButtonState();
}

class _FooterButtonState extends State<_FooterButton> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        transform: _hovered
            ? (Matrix4.identity()..translate(0.0, -4.0))
            : Matrix4.identity(),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.primary ? kSoftRose : Colors.transparent,
            foregroundColor: widget.primary ? kDeepBlue : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: widget.primary
                  ? BorderSide.none
                  : const BorderSide(color: kSoftRose, width: 1.5),
            ),
            elevation: widget.primary && _hovered ? 8 : 0,
            shadowColor: kSoftRose.withOpacity(0.4),
          ),
          child: Text(widget.label,
              style:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  REUSABLE — Fade + Slide In wrapper
// ═══════════════════════════════════════════════════════════════════════════════
class _FadeSlideIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  const _FadeSlideIn({required this.child, this.delay = Duration.zero});
  @override
  State<_FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<_FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero)
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
