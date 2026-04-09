// ================================================================
//  sections/services.dart
//  Hero: herosection.jpg + kDeepBlue transparent overlay
//  Grid: full-bg image, hover → teal overlay + desc
//  Responsive: 1col(mobile) / 2col(tablet) / 3col(desktop)
//  Scroll: BouncingScrollPhysics — smooth on mouse + touch
// ================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/header.dart';

const Color _kDark = Color(0xFF092723);
const Color _kTealLight = Color(0xFF5EEAD4);
const Color _kTeal = Color(0xFF0D9E8C);
const Color _kIvory = Color(0xFFF0FDFA);
const Color _kOverlay = Color(0xFF0D9E8C);

class _ServiceItem {
  final IconData icon;
  final String title;
  final String desc;
  const _ServiceItem(this.icon, this.title, this.desc);
}

const _kDental = [
  _ServiceItem(Icons.cleaning_services_rounded, 'Teeth Cleaning',
      'Deep scaling & polishing to remove plaque, tartar and prevent gum disease.'),
  _ServiceItem(Icons.wb_incandescent_outlined, 'Teeth Whitening',
      'Professional whitening treatment for a brighter, radiant smile in one session.'),
  _ServiceItem(Icons.straighten_rounded, 'Braces & Aligners',
      'Metal braces or clear aligners for a perfectly aligned, confident smile.'),
  _ServiceItem(Icons.local_hospital_rounded, 'Root Canal',
      'Pain-free root canal treatment using modern techniques to save your natural tooth.'),
  _ServiceItem(Icons.layers_rounded, 'Dental Implants',
      'Permanent, natural-looking tooth replacement that restores full function and beauty.'),
  _ServiceItem(Icons.blur_circular_rounded, 'Digital X-Ray',
      'High-resolution digital X-rays for accurate diagnosis with minimal radiation exposure.'),
];

const _kDerm = [
  _ServiceItem(Icons.face_retouching_natural_rounded, 'Acne Treatment',
      'Advanced therapies to clear active acne and prevent future breakouts permanently.'),
  _ServiceItem(Icons.flash_on_rounded, 'Laser Therapy',
      'Targeted laser for pigmentation, hair removal, skin resurfacing and rejuvenation.'),
  _ServiceItem(Icons.water_drop_rounded, 'HydraFacial',
      'Deep cleansing, exfoliation and intense hydration for instantly glowing skin.'),
  _ServiceItem(Icons.auto_awesome_rounded, 'Anti-Aging',
      'Botox, fillers and chemical peels to restore a youthful, radiant appearance.'),
  _ServiceItem(Icons.spa_rounded, 'Hair Restoration',
      'PRP therapy and mesotherapy for proven hair loss prevention and regrowth.'),
  _ServiceItem(Icons.psychology_rounded, 'Skin Consultation',
      'Personalised skin analysis and tailored treatment planning with Dr. Ravinder.'),
];

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});
  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Animation<double> _fade(double from, double to) =>
      Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: _ctrl, curve: Interval(from, to, curve: Curves.easeOut)));

  Animation<Offset> _slideUp(double from, double to) =>
      Tween<Offset>(begin: const Offset(0, 0.10), end: Offset.zero).animate(
          CurvedAnimation(
              parent: _ctrl, curve: Interval(from, to, curve: Curves.easeOut)));

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 900;
    final hPad = isWide ? 80.0 : (w > 600 ? 40.0 : 20.0);

    return Container(
      color: _kIvory,
      child: SingleChildScrollView(
        controller: _scrollCtrl,
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            FadeTransition(
              opacity: _fade(0.0, 0.35),
              child: SlideTransition(
                position: _slideUp(0.0, 0.35),
                child: _buildHero(w, isWide, hPad),
              ),
            ),
            FadeTransition(
              opacity: _fade(0.2, 0.55),
              child: SlideTransition(
                position: _slideUp(0.2, 0.55),
                child: _buildSection(
                  context: context,
                  tag: 'DENTAL CARE',
                  title: 'Dental',
                  accent: 'Services',
                  subtitle:
                      'Complete dental care from routine check-ups to advanced cosmetic treatments — all under one roof.',
                  items: _kDental,
                  bgImage: 'assets/images/dentist_service.jpg',
                  w: w,
                  isWide: isWide,
                  hPad: hPad,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: Divider(color: _kTealLight.withOpacity(0.4), thickness: 1),
            ),
            FadeTransition(
              opacity: _fade(0.4, 0.75),
              child: SlideTransition(
                position: _slideUp(0.4, 0.75),
                child: _buildSection(
                  context: context,
                  tag: 'SKIN & HAIR',
                  title: 'Dermatology',
                  accent: 'Services',
                  subtitle:
                      'Expert skin, hair and laser treatments tailored to your unique skin type and beauty goals.',
                  items: _kDerm,
                  bgImage: 'assets/images/derma_service.jpg',
                  w: w,
                  isWide: isWide,
                  hPad: hPad,
                ),
              ),
            ),
            FadeTransition(
              opacity: _fade(0.6, 1.0),
              child: SlideTransition(
                position: _slideUp(0.6, 1.0),
                child: _buildCTA(context, isWide, hPad),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // ── HERO ─────────────────────────────────────────────────────
  Widget _buildHero(double w, bool isWide, double hPad) {
    final heroH = isWide ? 480.0 : (w > 600 ? 400.0 : 320.0);

    return SizedBox(
      width: double.infinity,
      height: heroH + kNavBarHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/herosection.jpg', fit: BoxFit.cover),
          // kDeepBlue gradient overlay — left darker, right lighter
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  _kDark.withOpacity(0.85),
                  _kDark.withOpacity(0.50),
                ],
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(hPad, kNavBarHeight + 36, hPad, 36),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tag pill
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: _kTeal.withOpacity(0.22),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _kTealLight.withOpacity(0.5)),
                    ),
                    child: Text('WHAT WE OFFER',
                        style: GoogleFonts.nunito(
                            color: _kTealLight,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.8)),
                  ),
                  SizedBox(height: isWide ? 20 : 14),
                  // Heading
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Our ',
                        style: GoogleFonts.dmSerifDisplay(
                            fontSize: isWide ? 62 : (w > 600 ? 46 : 34),
                            color: Colors.white),
                      ),
                      TextSpan(
                        text: 'Services',
                        style: GoogleFonts.dmSerifDisplay(
                            fontSize: isWide ? 62 : (w > 600 ? 46 : 34),
                            color: _kTealLight,
                            fontStyle: FontStyle.italic),
                      ),
                    ]),
                  ),
                  SizedBox(height: isWide ? 16 : 12),
                  // Subtitle
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Text(
                      "From a sparkling smile to radiant skin — Dr. Ravinder's Dental & Skin Aesthetic Clinic offers premium dental and dermatology care at every step of your journey.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                          color: Colors.white.withOpacity(0.78),
                          fontSize: isWide ? 15 : 12.5,
                          height: 1.75),
                    ),
                  ),
                  SizedBox(height: isWide ? 34 : 22),
                  // Stats
                  Wrap(
                    spacing: isWide ? 48 : 28,
                    runSpacing: 14,
                    alignment: WrapAlignment.center,
                    children: const [
                      _HeroStat(value: '12+', label: 'Dental Treatments'),
                      _HeroStat(value: '8+', label: 'Skin Therapies'),
                      _HeroStat(value: '5000+', label: 'Happy Patients'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── SECTION ──────────────────────────────────────────────────
  Widget _buildSection({
    required BuildContext context,
    required String tag,
    required String title,
    required String accent,
    required String subtitle,
    required List<_ServiceItem> items,
    required String bgImage,
    required double w,
    required bool isWide,
    required double hPad,
  }) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: hPad, vertical: isWide ? 60 : 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: _kTealLight.withOpacity(0.18),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(tag,
                style: GoogleFonts.nunito(
                    color: _kDark,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.6)),
          ),
          const SizedBox(height: 14),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: '$title ',
                style: GoogleFonts.dmSerifDisplay(
                    fontSize: isWide ? 40 : (w > 600 ? 30 : 26), color: _kDark),
              ),
              TextSpan(
                text: accent,
                style: GoogleFonts.dmSerifDisplay(
                    fontSize: isWide ? 40 : (w > 600 ? 30 : 26),
                    color: _kTealLight,
                    fontStyle: FontStyle.italic),
              ),
            ]),
          ),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Text(subtitle,
                style: GoogleFonts.nunito(
                    color: _kDark.withOpacity(0.55),
                    fontSize: w > 600 ? 14 : 12.5,
                    height: 1.7)),
          ),
          const SizedBox(height: 30),
          _BgImageGrid(items: items, bgImage: bgImage, screenW: w),
        ],
      ),
    );
  }

  // ── CTA ───────────────────────────────────────────────────────
  Widget _buildCTA(BuildContext context, bool isWide, double hPad) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: hPad, vertical: 12),
      padding: EdgeInsets.all(isWide ? 56 : 30),
      decoration: BoxDecoration(
        color: _kDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: isWide
          ? Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Ready to get started?",
                        style: GoogleFonts.dmSerifDisplay(
                            color: Colors.white,
                            fontSize: 36,
                            fontStyle: FontStyle.italic)),
                    const SizedBox(height: 10),
                    Text(
                        "Book your consultation today. Expert care is just one click away.",
                        style: GoogleFonts.nunito(
                            color: Colors.white60, fontSize: 15, height: 1.6)),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              Column(children: [
                _CTAButton(
                    label: "Book Appointment",
                    filled: true,
                    onTap: () => context.go('/booking')),
                const SizedBox(height: 12),
                _CTAButton(label: "Call Clinic", filled: false, onTap: () {}),
              ]),
            ])
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ready to get started?",
                    style: GoogleFonts.dmSerifDisplay(
                        color: Colors.white,
                        fontSize: 26,
                        fontStyle: FontStyle.italic)),
                const SizedBox(height: 10),
                Text(
                    "Book your consultation today. Expert care is just one click away.",
                    style: GoogleFonts.nunito(
                        color: Colors.white60, fontSize: 13, height: 1.6)),
                const SizedBox(height: 24),
                _CTAButton(
                    label: "Book Appointment",
                    filled: true,
                    onTap: () => context.go('/booking')),
                const SizedBox(height: 10),
                _CTAButton(label: "Call Clinic", filled: false, onTap: () {}),
              ],
            ),
    );
  }
}

// ── Hero Stat ─────────────────────────────────────────────────────
class _HeroStat extends StatelessWidget {
  final String value, label;
  const _HeroStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: GoogleFonts.dmSerifDisplay(
                color: _kTealLight, fontSize: 28, fontStyle: FontStyle.italic)),
        Text(label,
            style: GoogleFonts.nunito(
                color: Colors.white60,
                fontSize: 11,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  _BgImageGrid  — responsive cols + cell height
// ════════════════════════════════════════════════════════════════
class _BgImageGrid extends StatelessWidget {
  final List<_ServiceItem> items;
  final String bgImage;
  final double screenW;

  const _BgImageGrid({
    required this.items,
    required this.bgImage,
    required this.screenW,
  });

  @override
  Widget build(BuildContext context) {
    final cols = screenW > 900 ? 3 : (screenW > 600 ? 2 : 1);
    final cellH = screenW > 900 ? 220.0 : (screenW > 600 ? 200.0 : 175.0);
    final rows = (items.length / cols).ceil();

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: LayoutBuilder(builder: (_, constraints) {
        final cellW = constraints.maxWidth / cols;
        return Stack(
          children: [
            SizedBox(
              height: cellH * rows,
              width: constraints.maxWidth,
              child: Image.asset(bgImage, fit: BoxFit.cover),
            ),
            SizedBox(
              height: cellH * rows,
              width: constraints.maxWidth,
              child: ColoredBox(color: _kDark.withOpacity(0.50)),
            ),
            SizedBox(
              height: cellH * rows,
              width: constraints.maxWidth,
              child: CustomPaint(
                painter: _GridLinePainter(cols: cols, rows: rows, cellH: cellH),
              ),
            ),
            SizedBox(
              height: cellH * rows,
              width: constraints.maxWidth,
              child: Wrap(
                children: List.generate(
                  items.length,
                  (i) => _GridCell(
                    item: items[i],
                    width: cellW,
                    height: cellH,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// ── Grid line painter ─────────────────────────────────────────────
class _GridLinePainter extends CustomPainter {
  final int cols, rows;
  final double cellH;
  const _GridLinePainter(
      {required this.cols, required this.rows, required this.cellH});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.18)
      ..strokeWidth = 0.8;
    for (int c = 1; c < cols; c++) {
      final x = size.width / cols * c;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (int r = 1; r < rows; r++) {
      final y = cellH * r;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridLinePainter o) => false;
}

// ════════════════════════════════════════════════════════════════
//  _GridCell — mouse hover + touch tap both supported
// ════════════════════════════════════════════════════════════════
class _GridCell extends StatefulWidget {
  final _ServiceItem item;
  final double width, height;
  const _GridCell(
      {required this.item, required this.width, required this.height});

  @override
  State<_GridCell> createState() => _GridCellState();
}

class _GridCellState extends State<_GridCell>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  bool _active = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 240));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _show() {
    if (!_active) {
      _active = true;
      _ctrl.forward();
    }
  }

  void _hide() {
    if (_active) {
      _active = false;
      _ctrl.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _show(),
      onExit: (_) => _hide(),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (_) => _show(),
        onTapUp: (_) =>
            Future.delayed(const Duration(milliseconds: 1200), _hide),
        onTapCancel: _hide,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Stack(
            children: [
              // Teal overlay
              FadeTransition(
                opacity: _anim,
                child: Container(color: _kOverlay.withOpacity(0.93)),
              ),
              // Default state
              FadeTransition(
                opacity: ReverseAnimation(_anim),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.13),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white.withOpacity(0.30),
                              width: 1.4),
                        ),
                        child: Icon(widget.item.icon,
                            color: Colors.white, size: 23),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          widget.item.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Hover / tap state
              FadeTransition(
                opacity: _anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.10),
                    end: Offset.zero,
                  ).animate(_anim),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.item.title,
                            style: GoogleFonts.dmSerifDisplay(
                                color: Colors.white,
                                fontSize: 15,
                                fontStyle: FontStyle.italic)),
                        const SizedBox(height: 8),
                        Text(widget.item.desc,
                            style: GoogleFonts.nunito(
                                color: Colors.white.withOpacity(0.87),
                                fontSize: 11.5,
                                height: 1.55)),
                        const SizedBox(height: 12),
                        Text('Book Now →',
                            style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── CTA Button ────────────────────────────────────────────────────
class _CTAButton extends StatefulWidget {
  final String label;
  final bool filled;
  final VoidCallback onTap;
  const _CTAButton(
      {required this.label, required this.filled, required this.onTap});

  @override
  State<_CTAButton> createState() => _CTAButtonState();
}

class _CTAButtonState extends State<_CTAButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            color: widget.filled
                ? (_hovered ? _kTealLight : Colors.white)
                : (_hovered
                    ? Colors.white.withOpacity(0.1)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(30),
            border: widget.filled
                ? null
                : Border.all(color: Colors.white.withOpacity(0.35)),
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.nunito(
              color: widget.filled
                  ? (_hovered ? Colors.white : _kDark)
                  : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
} //testingg of branch
