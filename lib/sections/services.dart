// pages/services.dart — Placeholder
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/header.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kNavBarHeight),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            Text("Our Services",
                style: GoogleFonts.dmSerifDisplay(
                    color: Colors.white,
                    fontSize: 48,
                    fontStyle: FontStyle.italic)),
            const SizedBox(height: 12),
            Text("[ Coming soon ]",
                style: GoogleFonts.nunito(color: Colors.white38)),
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }
}
