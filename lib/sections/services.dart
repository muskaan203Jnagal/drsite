// ================================================================
//  sections/services.dart  —  Premium Light Theme
//  DNA-style: Full bg image behind grid, hover → solid teal overlay
// ================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/header.dart';

// ── Palette ───────────────────────────────────────────────────────
const Color _kDark = Color(0xFF0A2E2A);
const Color _kTealLight = Color(0xFF5EEAD4);
const Color _kTeal = Color(0xFF0D9E8C);
const Color _kIvory = Color(0xFFF0FDFA);
const Color _kCard = Color(0xFFFFFFFF);
const Color _kOverlay = Color(0xFF0D9E8C); // solid teal fill on hover

// ── Service data ──────────────────────────────────────────────────
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

// ════════════════════════════════════════════════════════════════
//  Page
// ════════════════════════════════════════════════════════════════
class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});
  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1100))
      ..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Animation<double> _fade(double from, double to) =>
      Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: _ctrl, curve: Interval(from, to, curve: Curves.easeOut)));

  Animation<Offset> _slideUp(double from, double to) =>
      Tween<Offset>(begin: const Offset(0, 0.14), end: Offset.zero).animate(
          CurvedAnimation(
              parent: _ctrl, curve: Interval(from, to, curve: Curves.easeOut)));

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 900;

    return Container(
      color: _kIvory,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: kNavBarHeight),
          child: Column(
            children: [
              FadeTransition(
                opacity: _fade(0.0, 0.40),
                child: SlideTransition(
                  position: _slideUp(0.0, 0.40),
                  child: _buildHero(isWide),
                ),
              ),
              FadeTransition(
                opacity: _fade(0.2, 0.60),
                child: SlideTransition(
                  position: _slideUp(0.2, 0.60),
                  child: _buildSection(
                    context: context,
                    tag: 'DENTAL CARE',
                    title: 'Dental',
                    accent: 'Services',
                    subtitle:
                        'Complete dental care from routine check-ups to advanced cosmetic treatments — all under one roof.',
                    items: _kDental,
                    bgImage: 'assets/images/dentist_service.jpg',
                    isWide: isWide,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24),
                child:
                    Divider(color: _kTealLight.withOpacity(0.45), thickness: 1),
              ),
              const SizedBox(height: 8),
              FadeTransition(
                opacity: _fade(0.4, 0.80),
                child: SlideTransition(
                  position: _slideUp(0.4, 0.80),
                  child: _buildSection(
                    context: context,
                    tag: 'SKIN & HAIR',
                    title: 'Dermatology',
                    accent: 'Services',
                    subtitle:
                        'Expert skin, hair and laser treatments tailored to your unique skin type and beauty goals.',
                    items: _kDerm,
                    bgImage: 'assets/images/derma_service.jpg',
                    isWide: isWide,
                  ),
                ),
              ),
              FadeTransition(
                opacity: _fade(0.6, 1.0),
                child: SlideTransition(
                  position: _slideUp(0.6, 1.0),
                  child: _buildCTA(context, isWide),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  // ── HERO ──────────────────────────────────────────────────────
  Widget _buildHero(bool isWide) {
    return Container(
      width: double.infinity,
      color: _kCard,
      padding: EdgeInsets.symmetric(
          horizontal: isWide ? 80 : 24, vertical: isWide ? 80 : 56),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: _kTeal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _kTeal.withOpacity(0.4)),
            ),
            child: Text('WHAT WE OFFER',
                style: GoogleFonts.nunito(
                    color: _kTeal,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.8)),
          ),
          const SizedBox(height: 28),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                text: 'Our ',
                style: GoogleFonts.dmSerifDisplay(
                    fontSize: isWide ? 64 : 42, color: _kDark),
              ),
              TextSpan(
                text: 'Services',
                style: GoogleFonts.dmSerifDisplay(
                    fontSize: isWide ? 64 : 42,
                    color: _kTealLight,
                    fontStyle: FontStyle.italic),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              "From a sparkling smile to radiant skin — Dr. Ravinder's Glowora Clinic offers premium dental and dermatology care at every step of your journey.",
              style: GoogleFonts.nunito(
                  color: _kDark.withOpacity(0.55),
                  fontSize: isWide ? 16 : 14,
                  height: 1.75),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 52),
          Wrap(
            spacing: isWide ? 64 : 32,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: const [
              _StatChip(value: '12+', label: 'Dental Treatments'),
              _StatChip(value: '8+', label: 'Skin Therapies'),
              _StatChip(value: '5000+', label: 'Happy Patients'),
            ],
          ),
        ],
      ),
    );
  }

  // ── SERVICE SECTION ──────────────────────────────────────────
  Widget _buildSection({
    required BuildContext context,
    required String tag,
    required String title,
    required String accent,
    required String subtitle,
    required List<_ServiceItem> items,
    required String bgImage,
    required bool isWide,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: isWide ? 80 : 24, vertical: isWide ? 64 : 44),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: _kTealLight.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(tag,
                style: GoogleFonts.nunito(
                    color: _kDark,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.6)),
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: '$title ',
                style: GoogleFonts.dmSerifDisplay(
                    fontSize: isWide ? 42 : 30, color: _kDark),
              ),
              TextSpan(
                text: accent,
                style: GoogleFonts.dmSerifDisplay(
                    fontSize: isWide ? 42 : 30,
                    color: _kTealLight,
                    fontStyle: FontStyle.italic),
              ),
            ]),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Text(subtitle,
                style: GoogleFonts.nunito(
                    color: _kDark.withOpacity(0.55),
                    fontSize: 14,
                    height: 1.7)),
          ),
          const SizedBox(height: 40),
          _BgImageGrid(items: items, bgImage: bgImage, isWide: isWide),
        ],
      ),
    );
  }

  // ── CTA ───────────────────────────────────────────────────────
  Widget _buildCTA(BuildContext context, bool isWide) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: isWide ? 80 : 24, vertical: isWide ? 16 : 12),
      padding: EdgeInsets.all(isWide ? 60 : 36),
      decoration: BoxDecoration(
        color: _kDark,
        borderRadius: BorderRadius.circular(24),
      ),
      child: isWide
          ? Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Ready to get started?",
                          style: GoogleFonts.dmSerifDisplay(
                              color: Colors.white,
                              fontSize: 38,
                              fontStyle: FontStyle.italic)),
                      const SizedBox(height: 12),
                      Text(
                          "Book your consultation today. Expert care is just one click away.",
                          style: GoogleFonts.nunito(
                              color: Colors.white60,
                              fontSize: 15,
                              height: 1.6)),
                    ],
                  ),
                ),
                const SizedBox(width: 48),
                Column(
                  children: [
                    _CTAButton(
                        label: "Book Appointment",
                        filled: true,
                        onTap: () => context.go('/booking')),
                    const SizedBox(height: 12),
                    _CTAButton(
                        label: "Call Clinic", filled: false, onTap: () {}),
                  ],
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ready to get started?",
                    style: GoogleFonts.dmSerifDisplay(
                        color: Colors.white,
                        fontSize: 28,
                        fontStyle: FontStyle.italic)),
                const SizedBox(height: 12),
                Text(
                    "Book your consultation today. Expert care is just one click away.",
                    style: GoogleFonts.nunito(
                        color: Colors.white60, fontSize: 14, height: 1.6)),
                const SizedBox(height: 28),
                _CTAButton(
                    label: "Book Appointment",
                    filled: true,
                    onTap: () => context.go('/booking')),
                const SizedBox(height: 12),
                _CTAButton(label: "Call Clinic", filled: false, onTap: () {}),
              ],
            ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  _BgImageGrid
//  Single background image behind a 3-col grid.
//  Cells are transparent — bg shows through.
//  On hover → individual cell fills solid.
// ════════════════════════════════════════════════════════════════
class _BgImageGrid extends StatelessWidget {
  final List<_ServiceItem> items;
  final String bgImage;
  final bool isWide;

  const _BgImageGrid({
    required this.items,
    required this.bgImage,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    final cols = isWide ? 3 : 2;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: LayoutBuilder(builder: (_, constraints) {
        final cellW = constraints.maxWidth / cols;
        const cellH = 220.0;
        final rows = (items.length / cols).ceil();

        return Stack(
          children: [
            // ── Background image fills entire grid ───────────
            SizedBox(
              height: cellH * rows,
              width: constraints.maxWidth,
              child: Image.asset(bgImage, fit: BoxFit.cover),
            ),
            // ── Dark scrim ────────────────────────────────────
            SizedBox(
              height: cellH * rows,
              width: constraints.maxWidth,
              child: ColoredBox(color: _kDark.withOpacity(0.48)),
            ),
            // ── Grid lines ────────────────────────────────────
            SizedBox(
              height: cellH * rows,
              width: constraints.maxWidth,
              child: CustomPaint(
                painter: _GridLinePainter(cols: cols, rows: rows, cellH: cellH),
              ),
            ),
            // ── Cells ─────────────────────────────────────────
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
      ..color = Colors.white.withOpacity(0.20)
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
//  _GridCell — transparent default, solid teal on hover
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

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _ctrl.forward(),
      onExit: (_) => _ctrl.reverse(),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          children: [
            // Solid teal fill fades in on hover
            FadeTransition(
              opacity: _anim,
              child: ClipPath(
                clipper: DiagonalClipper(),
                child: Container(
                  color: _kOverlay.withOpacity(0.95),
                ),
              ),
            ),

            // Default: icon + title (fades OUT on hover)
            FadeTransition(
              opacity: ReverseAnimation(_anim),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white.withOpacity(0.35), width: 1.5),
                      ),
                      child:
                          Icon(widget.item.icon, color: Colors.white, size: 26),
                    ),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        widget.item.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Hover: title + desc + Book Now (fades IN on hover)
            // Hover: title + desc + Book Now (Fade + Slide IN on hover)
            FadeTransition(
              opacity: _anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.2), // thoda niche se aayega
                  end: Offset.zero,
                ).animate(_anim),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.item.title,
                        style: GoogleFonts.dmSerifDisplay(
                          color: Colors.white,
                          fontSize: 17,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.item.desc,
                        style: GoogleFonts.nunito(
                          color: Colors.white.withOpacity(0.88),
                          fontSize: 12.5,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Book Now →',
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.7);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// ── Stat Chip ─────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final String value, label;
  const _StatChip({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.dmSerifDisplay(
                color: _kDark, fontSize: 34, fontStyle: FontStyle.italic)),
        const SizedBox(height: 4),
        Text(label,
            style: GoogleFonts.nunito(
                color: _kDark.withOpacity(0.45),
                fontSize: 13,
                fontWeight: FontWeight.w600)),
      ],
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
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
}
