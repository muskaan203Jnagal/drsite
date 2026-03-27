// ================================================================
//  pages/home.dart  —  Placeholder (team member builds this)
// ================================================================
//
//  NOTE: Add SizedBox(height: 72) at top of your hero section so
//  content doesn't hide behind the transparent NavBar!
// ================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/header.dart'; // for kNavBarHeight constant

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Add top padding = navbar height so content isn't hidden
      padding: EdgeInsets.only(top: kNavBarHeight),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            Text(
              "Home Page",
              style: GoogleFonts.dmSerifDisplay(
                color: Colors.white,
                fontSize: 48,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "[ Team member builds this section ]",
              style: GoogleFonts.nunito(color: Colors.white38),
            ),
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }
}
