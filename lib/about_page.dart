import 'package:flutter/material.dart';

// ─── SHARED COLORS (same as homepage) ────────────────────────────────────────
const kDeepBlue = Color(0xFF0A2540);
const kSoftRose = Color(0xFFE8AEB7);
const kWhite = Colors.white;
const kHeading = Color(0xFF0A2540);
const kLight = Color(0xFF64748B);

// ─── ENTRY POINT (for standalone testing) ────────────────────────────────────
void main() => runApp(const _TestApp());

class _TestApp extends StatelessWidget {
  const _TestApp();
  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AboutUsPage(),
      );
}

// ═══════════════════════════════════════════════════════════════════════════════
//  ABOUT US PAGE
// ═══════════════════════════════════════════════════════════════════════════════
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: const [
            _AboutHeroSection(),
            _MissionSection(),
            _DoctorProfileSection(),
            _ValuesSection(),
            _TeamSection(),
            _TestimonialsSection(),
            _AboutFooterCTA(),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  1. HERO SECTION — animated headline + diagonal clip
// ═══════════════════════════════════════════════════════════════════════════════
class _AboutHeroSection extends StatefulWidget {
  const _AboutHeroSection();
  @override
  State<_AboutHeroSection> createState() => _AboutHeroSectionState();
}

class _AboutHeroSectionState extends State<_AboutHeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _scale = Tween<double>(begin: 1.08, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 700;

    return SizedBox(
      height: isMobile ? 520 : 600,
      child: Stack(
        children: [
          // ── Animated background image ──
          AnimatedBuilder(
            animation: _scale,
            builder: (_, child) => Transform.scale(
              scale: _scale.value,
              child: child,
            ),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/home_image.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // ── Deep overlay gradient ──
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  kDeepBlue.withOpacity(0.85),
                  kDeepBlue.withOpacity(0.55),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          // ── Diagonal rose accent stripe ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _DiagonalClipper(),
              child: Container(
                height: 100,
                color: kSoftRose.withOpacity(0.25),
              ),
            ),
          ),

          // ── Animated text content ──
          Center(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // pill badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 7),
                        decoration: BoxDecoration(
                          color: kSoftRose.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: kSoftRose.withOpacity(0.6), width: 1.2),
                        ),
                        child: const Text(
                          'ABOUT US',
                          style: TextStyle(
                            color: kSoftRose,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Healing Smiles,\nGlowing Skin.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMobile ? 36 : 52,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Where advanced dentistry meets\npersonalised aesthetic skin care.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: isMobile ? 14 : 17,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
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
    ..moveTo(0, size.height * 0.6)
    ..lineTo(size.width, 0)
    ..lineTo(size.width, size.height)
    ..lineTo(0, size.height)
    ..close();

  @override
  bool shouldReclip(_) => false;
}

// ═══════════════════════════════════════════════════════════════════════════════
//  2. MISSION SECTION — fade-in on scroll simulation with TweenAnimationBuilder
// ═══════════════════════════════════════════════════════════════════════════════
class _MissionSection extends StatelessWidget {
  const _MissionSection();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 700;

    return _FadeSlideIn(
      delay: const Duration(milliseconds: 100),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 70,
          horizontal: isMobile ? 24 : 80,
        ),
        color: Colors.white,
        child: isMobile
            ? _MissionContent(isMobile: isMobile)
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: _MissionContent(isMobile: isMobile)),
                  const SizedBox(width: 60),
                  Expanded(child: _MissionImageCard()),
                ],
              ),
      ),
    );
  }
}

class _MissionContent extends StatelessWidget {
  final bool isMobile;
  const _MissionContent({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionBadge(label: 'OUR MISSION'),
        const SizedBox(height: 20),
        Text(
          'Excellence in\nEvery Treatment',
          style: TextStyle(
            color: kHeading,
            fontSize: isMobile ? 28 : 38,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'At Dr. Ravinder\'s Dental & Skin Aesthetic Clinic, we believe every patient deserves world-class care in a comfortable, welcoming environment. Our mission is to combine cutting-edge technology with a gentle, personalised touch.',
          style: TextStyle(
            color: kLight,
            fontSize: isMobile ? 14 : 16,
            height: 1.75,
          ),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: const [
            _HighlightChip(label: '✦  State-of-the-art Equipment'),
            _HighlightChip(label: '✦  Pain-free Procedures'),
            _HighlightChip(label: '✦  Personalised Care Plans'),
            _HighlightChip(label: '✦  Certified Specialists'),
          ],
        ),
        if (isMobile) ...[
          const SizedBox(height: 32),
          _MissionImageCard(),
        ],
      ],
    );
  }
}

class _MissionImageCard extends StatelessWidget {
  const _MissionImageCard();

  @override
  Widget build(BuildContext context) {
    return Stack(
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
        // ── floating badge ──
        Positioned(
          bottom: -20,
          left: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: kDeepBlue,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: kDeepBlue.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.verified, color: kSoftRose, size: 22),
                SizedBox(width: 10),
                Text(
                  '10+ Years of Trust',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  3. DOCTOR PROFILE SECTION
// ═══════════════════════════════════════════════════════════════════════════════
class _DoctorProfileSection extends StatelessWidget {
  const _DoctorProfileSection();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 700;

    return _FadeSlideIn(
      delay: const Duration(milliseconds: 150),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 70,
          horizontal: isMobile ? 24 : 80,
        ),
        decoration: BoxDecoration(
          color: kDeepBlue,
        ),
        child: isMobile
            ? Column(
                children: [
                  _DoctorAvatar(),
                  const SizedBox(height: 32),
                  _DoctorBio(isMobile: isMobile),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _DoctorAvatar(),
                  const SizedBox(width: 60),
                  Expanded(child: _DoctorBio(isMobile: isMobile)),
                ],
              ),
      ),
    );
  }
}

class _DoctorAvatar extends StatefulWidget {
  const _DoctorAvatar();
  @override
  State<_DoctorAvatar> createState() => _DoctorAvatarState();
}

class _DoctorAvatarState extends State<_DoctorAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 1.0, end: 1.04)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, child) => Transform.scale(scale: _pulse.value, child: child),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // outer glow ring
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kSoftRose.withOpacity(0.4), width: 2),
            ),
          ),
          // inner ring
          Container(
            width: 176,
            height: 176,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kSoftRose, width: 3),
            ),
          ),
          // avatar placeholder
          ClipOval(
            child: Container(
              width: 160,
              height: 160,
              color: kSoftRose.withOpacity(0.15),
              child: const Icon(Icons.person, size: 80, color: kSoftRose),
            ),
          ),
        ],
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
        _SectionBadge(label: 'MEET THE DOCTOR', light: true),
        const SizedBox(height: 16),
        Text(
          'Dr. Ravinder',
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 30 : 40,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'BDS, MDS — Specialist in Aesthetic Dentistry & Dermatology',
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: const TextStyle(color: kSoftRose, fontSize: 14, height: 1.5),
        ),
        const SizedBox(height: 20),
        Text(
          'With over a decade of dedicated practice, Dr. Ravinder brings expertise, compassion, and innovation to every chair. Trained from top institutions and passionate about smile makeovers and skin rejuvenation, she has transformed thousands of lives across Kartarpur and beyond.',
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: const TextStyle(
              color: Colors.white70, fontSize: 15, height: 1.75),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 20,
          runSpacing: 12,
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          children: const [
            _StatBubble(value: '5000+', label: 'Patients'),
            _StatBubble(value: '10+', label: 'Years'),
            _StatBubble(value: '98%', label: 'Satisfaction'),
          ],
        ),
      ],
    );
  }
}

class _StatBubble extends StatelessWidget {
  final String value, label;
  const _StatBubble({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kSoftRose.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: kSoftRose, fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  4. VALUES SECTION — staggered card entrance
// ═══════════════════════════════════════════════════════════════════════════════
class _ValuesSection extends StatelessWidget {
  const _ValuesSection();

  static const _values = [
    _ValueData(Icons.favorite_outline, 'Compassion',
        'Every patient is treated with kindness and empathy, always.'),
    _ValueData(Icons.science_outlined, 'Innovation',
        'We use the latest techniques for pain-free, precise results.'),
    _ValueData(Icons.workspace_premium_outlined, 'Excellence',
        'Uncompromising quality in every procedure, big or small.'),
    _ValueData(Icons.lock_outline, 'Trust',
        'Transparent communication and ethical practice at every step.'),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 700;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 70,
        horizontal: isMobile ? 24 : 80,
      ),
      color: const Color(0xFFF8F9FC),
      child: Column(
        children: [
          _SectionBadge(label: 'OUR VALUES'),
          const SizedBox(height: 16),
          Text(
            'What Drives Us Every Day',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kHeading,
              fontSize: isMobile ? 26 : 36,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 50),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: List.generate(
              _values.length,
              (i) => _StaggeredValueCard(data: _values[i], index: i),
            ),
          ),
        ],
      ),
    );
  }
}

class _ValueData {
  final IconData icon;
  final String title, desc;
  const _ValueData(this.icon, this.title, this.desc);
}

class _StaggeredValueCard extends StatefulWidget {
  final _ValueData data;
  final int index;
  const _StaggeredValueCard({required this.data, required this.index});

  @override
  State<_StaggeredValueCard> createState() => _StaggeredValueCardState();
}

class _StaggeredValueCardState extends State<_StaggeredValueCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: 200 * widget.index), () {
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
    final cardWidth = w < 700 ? w - 48.0 : (w - 200) / 2;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: _HoverCard(
          child: Container(
            width: cardWidth.clamp(200.0, 320.0),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: kDeepBlue.withOpacity(0.07),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: kDeepBlue.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(widget.data.icon, color: kDeepBlue, size: 26),
                ),
                const SizedBox(height: 18),
                Text(widget.data.title,
                    style: const TextStyle(
                        color: kHeading,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Text(widget.data.desc,
                    style: const TextStyle(
                        color: kLight, fontSize: 14, height: 1.65)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  5. TEAM SECTION
// ═══════════════════════════════════════════════════════════════════════════════
class _TeamSection extends StatelessWidget {
  const _TeamSection();

  static const _team = [
    _TeamData('Dr. Ravinder', 'Lead Dentist & Aesthetician'),
    _TeamData('Dr. Priya Sharma', 'Skin Care Specialist'),
    _TeamData('Dr. Amandeep Singh', 'Oral Surgeon'),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 700;

    return _FadeSlideIn(
      delay: const Duration(milliseconds: 100),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 70,
          horizontal: isMobile ? 24 : 80,
        ),
        color: Colors.white,
        child: Column(
          children: [
            _SectionBadge(label: 'OUR TEAM'),
            const SizedBox(height: 16),
            Text(
              'Specialists You Can Trust',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kHeading,
                fontSize: isMobile ? 26 : 36,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 50),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: _team.map((t) => _TeamCard(data: t)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamData {
  final String name, role;
  const _TeamData(this.name, this.role);
}

class _TeamCard extends StatefulWidget {
  final _TeamData data;
  const _TeamCard({required this.data});

  @override
  State<_TeamCard> createState() => _TeamCardState();
}

class _TeamCardState extends State<_TeamCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        width: 220,
        transform: _hovered
            ? (Matrix4.identity()..translate(0.0, -8.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: _hovered ? kDeepBlue : const Color(0xFFF4F6FA),
          borderRadius: BorderRadius.circular(24),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: kDeepBlue.withOpacity(0.25),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  )
                ]
              : [],
        ),
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _hovered
                    ? kSoftRose.withOpacity(0.25)
                    : kDeepBlue.withOpacity(0.08),
              ),
              child: Icon(Icons.person,
                  size: 40, color: _hovered ? kSoftRose : kDeepBlue),
            ),
            const SizedBox(height: 16),
            Text(
              widget.data.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _hovered ? Colors.white : kHeading,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.data.role,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _hovered ? kSoftRose : kLight,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  6. TESTIMONIALS — horizontal scroll with stagger
// ═══════════════════════════════════════════════════════════════════════════════
class _TestimonialsSection extends StatelessWidget {
  const _TestimonialsSection();

  static const _reviews = [
    _ReviewData('Simran K.',
        'Best dental experience ever! Dr. Ravinder made my root canal completely painless. Highly recommend.'),
    _ReviewData('Harpreet M.',
        'The skin treatments here are incredible. My acne scars are almost gone after just 3 sessions!'),
    _ReviewData('Rajesh T.',
        'Professional, warm, and very thorough. The clinic is super clean and modern. 10/10!'),
    _ReviewData('Anita B.',
        'Got my smile makeover done here. Absolutely stunning results. Worth every penny.'),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return _FadeSlideIn(
      delay: const Duration(milliseconds: 100),
      child: Container(
        color: const Color(0xFFF8F9FC),
        padding:
            EdgeInsets.symmetric(vertical: 70, horizontal: isMobile ? 24 : 0),
        child: Column(
          children: [
            _SectionBadge(label: 'TESTIMONIALS'),
            const SizedBox(height: 16),
            Text(
              'What Our Patients Say',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kHeading,
                fontSize: isMobile ? 26 : 36,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              height: 210,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                itemCount: _reviews.length,
                separatorBuilder: (_, __) => const SizedBox(width: 20),
                itemBuilder: (ctx, i) => _ReviewCard(data: _reviews[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewData {
  final String name, text;
  const _ReviewData(this.name, this.text);
}

class _ReviewCard extends StatelessWidget {
  final _ReviewData data;
  const _ReviewCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kDeepBlue.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              5,
              (_) => const Icon(Icons.star, color: Color(0xFFFFB84D), size: 16),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Text(
              '"${data.text}"',
              style: const TextStyle(
                color: kLight,
                fontSize: 13,
                height: 1.6,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: kDeepBlue.withOpacity(0.1),
                child: const Icon(Icons.person, size: 18, color: kDeepBlue),
              ),
              const SizedBox(width: 10),
              Text(data.name,
                  style: const TextStyle(
                      color: kHeading,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  7. FOOTER CTA — same style as homepage footer
// ═══════════════════════════════════════════════════════════════════════════════
class _AboutFooterCTA extends StatelessWidget {
  const _AboutFooterCTA();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return _FadeSlideIn(
      delay: const Duration(milliseconds: 100),
      child: Container(
        color: kDeepBlue,
        padding: EdgeInsets.symmetric(
          vertical: 80,
          horizontal: isMobile ? 24 : 80,
        ),
        child: Column(
          children: [
            const Text(
              "Dr. Ravinder's\nDental & Skin Aesthetic Clinic",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kSoftRose,
                fontSize: 36,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ready to begin your transformation?\nBook a consultation today.',
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white70, fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 40),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: const [
                _FooterCTAButton(label: 'Book Appointment', primary: true),
                _FooterCTAButton(label: 'Call Us Now', primary: false),
              ],
            ),
            const SizedBox(height: 60),
            Wrap(
              spacing: 40,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: const [
                Text('📍 Kartarpur',
                    style: TextStyle(color: Colors.white70, fontSize: 15)),
                Text('📞 +91 98765 43210',
                    style: TextStyle(color: Colors.white70, fontSize: 15)),
                Text('🕒 9AM – 7PM',
                    style: TextStyle(color: Colors.white70, fontSize: 15)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterCTAButton extends StatelessWidget {
  final String label;
  final bool primary;
  const _FooterCTAButton({required this.label, required this.primary});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: primary ? kSoftRose : Colors.transparent,
        foregroundColor: primary ? kDeepBlue : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: primary
              ? BorderSide.none
              : const BorderSide(color: kSoftRose, width: 1.5),
        ),
        elevation: primary ? 4 : 0,
      ),
      child: Text(label,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  REUSABLE HELPERS
// ═══════════════════════════════════════════════════════════════════════════════

/// Generic fade + slide-up entrance animation
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
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

/// Hover lift wrapper (works on web/desktop)
class _HoverCard extends StatefulWidget {
  final Widget child;
  const _HoverCard({required this.child});

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        transform: _hovered
            ? (Matrix4.identity()..translate(0.0, -6.0))
            : Matrix4.identity(),
        child: widget.child,
      ),
    );
  }
}

/// Pill badge label
class _SectionBadge extends StatelessWidget {
  final String label;
  final bool light;
  const _SectionBadge({required this.label, this.light = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: light ? kSoftRose.withOpacity(0.2) : kDeepBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color:
              light ? kSoftRose.withOpacity(0.5) : kDeepBlue.withOpacity(0.2),
          width: 1.2,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: light ? kSoftRose : kDeepBlue,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 2.5,
        ),
      ),
    );
  }
}

/// Small highlight chip
class _HighlightChip extends StatelessWidget {
  final String label;
  const _HighlightChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: kDeepBlue.withOpacity(0.06),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(label,
          style: const TextStyle(
              color: kDeepBlue, fontSize: 13, fontWeight: FontWeight.w500)),
    );
  }
}
