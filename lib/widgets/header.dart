// ================================================================
//  widgets/header.dart  —  Scroll-Aware Navbar (Luxury Design)
//
//  FIX: "kabhi kabhi header work nahi karta"
//  → On hero pages (home/about) navbar starts transparent then goes
//    solid navy on scroll — via _scrolled bool passed from AppLayout
//  → On light-bg pages (services/booking/contact) always solid navy
//  → White text + rose accent always readable on EVERY page
// ================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Shared color constants (used by footer & pages) ───────────────
const Color kTeal = Color(0xFF0D9E8C); // back-compat alias
const Color kDeepBlue = Color.fromARGB(255, 9, 39, 35);
const Color kSoftRose = Color(0xFF5EEAD4);
const Color kGoldAccent = Color(0xFF0D9E8C);
const Color kDark = Color(0xFF0A2E2A);
const Color kGray = Color(0xFF64748B);
const Color kGold = Color(0xFF14B8A6);

const _kNavItems = <(String, String)>[
  ('Home', '/home'),
  ('About Us', '/about'),
  ('Services', '/services'),
  ('Contact Us', '/contact'),
];

const double kNavBarHeight = 72;

// Pages that DON'T have a dark hero image at top
const _kLightBgRoutes = {'/services', '/booking', '/contact'};

// ════════════════════════════════════════════════════════════════
//  NavBar
// ════════════════════════════════════════════════════════════════
class NavBar extends StatefulWidget {
  final String currentRoute;
  const NavBar({super.key, this.currentRoute = '/home'});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  String? _hoveredLabel;
  bool _scrolled = false;

  bool get _solidBg =>
      _scrolled || _kLightBgRoutes.contains(widget.currentRoute);

  void _onScroll(ScrollNotification n) {
    final isScrolled = n.metrics.pixels > 30;
    if (isScrolled != _scrolled) setState(() => _scrolled = isScrolled);
  }

  void _openMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kDeepBlue,
      isScrollControlled: true, // ← lets content define its own height
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _MobileMenu(currentRoute: widget.currentRoute),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        _onScroll(n);
        return false;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        height: kNavBarHeight,
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 80),
        decoration: BoxDecoration(
          color: _solidBg ? kDeepBlue.withOpacity(0.97) : Colors.transparent,
          gradient: _solidBg
              ? null
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.52), Colors.transparent],
                ),
          boxShadow: _solidBg
              ? [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 2))
                ]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const _Logo(),
            const Spacer(),
            if (isMobile)
              GestureDetector(
                onTap: () => _openMenu(context),
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    border: Border.all(color: kSoftRose.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.menu_rounded,
                      color: Colors.white, size: 22),
                ),
              )
            else ...[
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
              const SizedBox(width: 16),
              _BookButton(onTap: () => context.go('/booking')),
            ],
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  Mobile Menu
// ════════════════════════════════════════════════════════════════
class _MobileMenu extends StatelessWidget {
  final String currentRoute;
  const _MobileMenu({required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 44,
              height: 4,
              margin: const EdgeInsets.only(bottom: 28),
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2))),
          const Align(alignment: Alignment.centerLeft, child: _Logo()),
          const SizedBox(height: 28),
          Divider(color: kSoftRose.withOpacity(0.2)),
          const SizedBox(height: 8),
          for (final item in _kNavItems)
            _MobileNavItem(
              label: item.$1,
              route: item.$2,
              isActive: currentRoute == item.$2,
              onTap: () {
                Navigator.pop(context);
                context.go(item.$2);
              },
            ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/booking');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kSoftRose,
                foregroundColor: kDeepBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text('Book Appointment',
                  style: GoogleFonts.nunito(
                      fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }
}

class _MobileNavItem extends StatelessWidget {
  final String label, route;
  final bool isActive;
  final VoidCallback onTap;
  const _MobileNavItem(
      {required this.label,
      required this.route,
      required this.isActive,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: isActive ? kSoftRose.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color:
                  isActive ? kSoftRose.withOpacity(0.4) : Colors.transparent),
        ),
        child: Row(children: [
          Text(label,
              style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: isActive ? kSoftRose : Colors.white70,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500)),
          if (isActive) ...[
            const Spacer(),
            Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                    color: kSoftRose, shape: BoxShape.circle)),
          ],
        ]),
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
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: kSoftRose, borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.medical_services_rounded,
              color: kDeepBlue, size: 20)),
      const SizedBox(width: 10),
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Dr. Ravinder's",
                style: GoogleFonts.playfairDisplay(
                    fontSize: 16,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600)),
            Text('GLOWORA CLINIC',
                style: GoogleFonts.nunito(
                    fontSize: 9,
                    color: kSoftRose,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.8)),
          ]),
    ]);
  }
}

// ════════════════════════════════════════════════════════════════
//  Desktop Nav Link
// ════════════════════════════════════════════════════════════════
class _NavLink extends StatelessWidget {
  final String label, route;
  final bool isActive, isHover;
  final void Function(bool) onHover;
  final VoidCallback onTap;
  const _NavLink(
      {required this.label,
      required this.route,
      required this.isActive,
      required this.isHover,
      required this.onHover,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final highlighted = isActive || isHover;
    return Padding(
      padding: const EdgeInsets.only(right: 32),
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
                Text(label,
                    style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: highlighted ? kSoftRose : Colors.white,
                        fontWeight:
                            isActive ? FontWeight.w700 : FontWeight.w600)),
                const SizedBox(height: 5),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  height: 2.5,
                  width: highlighted ? 22 : 0,
                  decoration: BoxDecoration(
                      color: isActive ? kSoftRose : kGoldAccent,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ]),
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
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
          decoration: BoxDecoration(
            color: _hovered ? kSoftRose : Colors.transparent,
            border: Border.all(color: kSoftRose, width: 1.6),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text('Book Appointment',
              style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _hovered ? kDeepBlue : Colors.white)),
        ),
      ),
    );
  }
}
