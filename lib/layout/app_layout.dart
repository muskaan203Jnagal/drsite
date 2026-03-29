// ================================================================
//  layout/app_layout.dart  —  Shell with floating NavBar + Footer
// ================================================================

import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  final String currentRoute;

  const AppLayout({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A2E2A),
      body: Stack(
        children: [
          // ── [0] Scrollable content + footer ──────────────────
          SingleChildScrollView(
            child: Column(
              children: [
                // Page content (each page handles its own top-padding)
                child,

                // Footer always at the bottom
                const AppFooter(),
              ],
            ),
          ),

          // ── [1] Floating transparent NavBar ──────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavBar(currentRoute: currentRoute),
          ),
        ],
      ),
    );
  }
}
