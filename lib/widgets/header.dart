// ================================================================
//  widgets/header.dart  —  Responsive NavBar (desktop + mobile)
// ================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kTeal = Color(0xFF009688);
const Color kDark = Color(0xFF1A2332);
const Color kGray = Color(0xFF6B7280);
const Color kGold = Color(0xFFC9A84C);

const _kNavItems = <(String, String)>[
  ('Home', '/'),
  ('About Us', '/about'),
  ('Services', '/services'),
  ('Contact Us', '/contact'),
];

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

  void _openMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D1B2A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _MobileMenu(currentRoute: widget.currentRoute),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      height: kNavBarHeight,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.35),
            Colors.transparent,
          ],
        ),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: kTeal.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(8),
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
            const SizedBox(width: 12),
            _BookButton(onTap: () => context.go('/booking')),
          ],
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  Mobile Bottom Sheet Menu
// ════════════════════════════════════════════════════════════════
class _MobileMenu extends StatelessWidget {
  final String currentRoute;
  const _MobileMenu({required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Align(alignment: Alignment.centerLeft, child: _Logo()),
          const SizedBox(height: 24),
          const Divider(color: Colors.white12),
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
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/booking');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kTeal,
                foregroundColor: Colors.white,
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
        ],
      ),
    );
  }
}

class _MobileNavItem extends StatelessWidget {
  final String label;
  final String route;
  final bool isActive;
  final VoidCallback onTap;

  const _MobileNavItem({
    required this.label,
    required this.route,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: isActive ? kTeal.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? kTeal.withOpacity(0.3) : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Text(label,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: isActive ? kTeal : Colors.white70,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                )),
            if (isActive) ...[
              const Spacer(),
              Container(
                width: 6,
                height: 6,
                decoration:
                    const BoxDecoration(color: kTeal, shape: BoxShape.circle),
              ),
            ],
          ],
        ),
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
              color: kTeal, borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.medical_services_rounded,
              color: Colors.white, size: 20),
        ),
        const SizedBox(width: 10),
        Text('Dr.',
            style: GoogleFonts.dmSerifDisplay(
                fontSize: 22,
                color: Colors.white,
                fontStyle: FontStyle.italic)),
        Text("Ravinder's Clinic",
            style: GoogleFonts.nunito(
                fontSize: 14,
                color: kTeal,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5)),
      ],
    );
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
                    color: highlighted ? kTeal : Colors.white,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                  )),
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
          decoration: BoxDecoration(
            color: _hovered ? kTeal : Colors.transparent,
            border: Border.all(color: kTeal, width: 1.8),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text('Book Appointment',
              style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _hovered ? Colors.white : kTeal)),
        ),
      ),
    );
  }
}
