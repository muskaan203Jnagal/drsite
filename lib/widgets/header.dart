// ================================================================
//  widgets/header.dart  —  Transparent floating NavBar
// ================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Brand colours ───────────────────────────────────────────────
const Color kTeal = Color(0xFF009688);
const Color kDark = Color(0xFF1A2332);
const Color kGray = Color(0xFF6B7280);
const Color kGold = Color(0xFFC9A84C);

// ── Nav route map ───────────────────────────────────────────────
const _kNavItems = <(String, String)>[
  ('Home', '/'),
  ('About Us', '/about'),
  ('Services', '/services'),
  ('Contact Us', '/contact'),
];

// ── Navbar height (used for page top-padding reference) ─────────
const double kNavBarHeight = 72;

// ════════════════════════════════════════════════════════════════
//  NavBar
// ════════════════════════════════════════════════════════════════
class NavBar extends StatefulWidget {
  final String currentRoute;
  const NavBar({super.key, this.currentRoute = '/'});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  String? _hoveredLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kNavBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 80),

      // ── Transparent with a very subtle gradient so text stays
      //    readable even over light hero sections ───────────────
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.30),
            Colors.transparent,
          ],
        ),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── LOGO ──────────────────────────────────────────────
          const _Logo(),

          const Spacer(),

          // ── NAV LINKS ─────────────────────────────────────────
          for (final item in _kNavItems)
            _NavLink(
              label: item.$1,
              route: item.$2,
              isActive: widget.currentRoute == item.$2,
              isHover: _hoveredLabel == item.$1,
              onHover: (h) =>
                  setState(() => _hoveredLabel = h ? item.$1 : null),
              onTap: () => context.go(item.$2),
            ),

          const SizedBox(width: 12),

          // ── BOOK APPOINTMENT ──────────────────────────────────
          _BookButton(onTap: () => context.go('/contact')),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  Logo
// ════════════════════════════════════════════════════════════════
class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: kTeal,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.medical_services_rounded,
              color: Colors.white, size: 20),
        ),
        const SizedBox(width: 10),
        Text(
          'Dr.',
          style: GoogleFonts.dmSerifDisplay(
            fontSize: 24,
            color: Colors.white,
            fontStyle: FontStyle.italic,
          ),
        ),
        Text(
          "Ravinder's Clinic",
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: kTeal,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  Single Nav Link
// ════════════════════════════════════════════════════════════════
class _NavLink extends StatelessWidget {
  final String label;
  final String route;
  final bool isActive;
  final bool isHover;
  final void Function(bool) onHover;
  final VoidCallback onTap;

  const _NavLink({
    required this.label,
    required this.route,
    required this.isActive,
    required this.isHover,
    required this.onHover,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final highlighted = isActive || isHover;

    return Padding(
      padding: const EdgeInsets.only(right: 36),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => onHover(true),
        onExit: (_) => onHover(false),
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: GoogleFonts.nunito(
                  fontSize: 14.5,
                  // White text since navbar is over dark/image bg
                  color: highlighted ? kTeal : Colors.white,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                height: 2.5,
                width: highlighted ? 22 : 0,
                decoration: BoxDecoration(
                  color: isActive ? kTeal : kGold,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  Book Appointment Button
// ════════════════════════════════════════════════════════════════
class _BookButton extends StatefulWidget {
  final VoidCallback onTap;
  const _BookButton({required this.onTap});

  @override
  State<_BookButton> createState() => _BookButtonState();
}

class _BookButtonState extends State<_BookButton> {
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
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          decoration: BoxDecoration(
            color: _hovered ? kTeal : Colors.transparent,
            border: Border.all(color: kTeal, width: 1.8),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            'Book Appointment',
            style: GoogleFonts.nunito(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: _hovered ? Colors.white : kTeal,
            ),
          ),
        ),
      ),
    );
  }
}
