// ================================================================
//  widgets/footer.dart  —  4-column footer (Luxury Design)
//  Palette: Deep Blue #0A2540 | Rose #E8AEB7 | Gold #CFA15D
// ================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'header.dart'; // kTeal, kDeepBlue, kSoftRose, kGoldAccent

// Footer uses the deep-blue navy background
const Color _kFooterBg = Color(0xFF071A16);

const _kFooterLinks = <(String, String)>[
  ('Home', '/home'),
  ('About Us', '/about'),
  ('Services', '/services'),
  ('Contact Us', '/contact'),
];

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  void _launch(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 900;

    return Container(
      width: double.infinity,
      color: _kFooterBg,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 80 : 24,
              vertical: 60,
            ),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 260, child: _buildBrand()),
                      const SizedBox(width: 40),
                      Expanded(child: _buildQuickLinks(context)),
                      Expanded(flex: 2, child: _buildGetInTouch()),
                      SizedBox(width: 220, child: _buildCTA(context)),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBrand(),
                      const SizedBox(height: 40),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildQuickLinks(context)),
                          const SizedBox(width: 32),
                          Expanded(flex: 2, child: _buildGetInTouch()),
                        ],
                      ),
                      const SizedBox(height: 40),
                      _buildCTA(context),
                    ],
                  ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 80 : 24,
              vertical: 20,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.07)),
              ),
            ),
            child: isWide
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("© 2026 Dr Ravinder's Clinic. All rights reserved.",
                          style: GoogleFonts.nunito(
                              color: Colors.white38, fontSize: 13)),
                      Row(children: [
                        _bottomLink("Privacy Policy"),
                        const SizedBox(width: 28),
                        _bottomLink("Terms of Service"),
                      ]),
                    ],
                  )
                : Column(children: [
                    Text("© 2026 Dr Ravinder's Clinic. All rights reserved.",
                        style: GoogleFonts.nunito(
                            color: Colors.white38, fontSize: 13),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 6,
                      children: [
                        _bottomLink("Privacy Policy"),
                        _bottomLink("Terms of Service"),
                      ],
                    )
                  ]),
          ),
        ],
      ),
    );
  }

  Widget _buildBrand() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: kSoftRose,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.medical_services_rounded,
                  color: kDeepBlue, size: 22),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Dr. Ravinder's",
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600)),
                Text("GLOWORA CLINIC",
                    style: GoogleFonts.nunito(
                        fontSize: 9,
                        color: kSoftRose,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.8)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          "Premium dental and dermatology care\nserving Kartarpur, Punjab. Where\nmodern medicine meets compassionate\ncare to reveal your best self.",
          style: GoogleFonts.nunito(
              color: Colors.white54, fontSize: 13.5, height: 1.7),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            _socialIcon(Icons.camera_alt_outlined, "https://instagram.com/"),
            const SizedBox(width: 10),
            _socialIcon(Icons.facebook_outlined, "https://facebook.com/"),
            const SizedBox(width: 10),
            _socialIcon(
                Icons.play_circle_outline_rounded, "https://youtube.com/"),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Quick Links",
            style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 20),
        for (final item in _kFooterLinks)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => context.go(item.$2),
                child: Text(item.$1,
                    style: GoogleFonts.nunito(
                        color: Colors.white54, fontSize: 14)),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGetInTouch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Get in Touch",
            style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 20),
        _touchRow(
          icon: Icons.location_on_rounded,
          text: "Kartarpur, Jalandhar,\nPunjab, India 144801",
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => _launch("tel:+919463629128"),
          child: _touchRow(icon: Icons.phone_rounded, text: "+91 94636 29128"),
        ),
        const SizedBox(height: 16),
        _touchRow(
          icon: Icons.access_time_rounded,
          text: "Mon - Sat: 9:00 AM - 7:00 PM",
          subText: "24/7 EMERGENCY FOR PATIENTS",
        ),
      ],
    );
  }

  Widget _buildCTA(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Ready to glow?",
            style: GoogleFonts.playfairDisplay(
                color: Colors.white,
                fontSize: 24,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => context.go('/contact'),
            style: ElevatedButton.styleFrom(
              backgroundColor: kSoftRose,
              foregroundColor: kDeepBlue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: Text("Book Appointment",
                style: GoogleFonts.nunito(
                    fontSize: 14, fontWeight: FontWeight.w700)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _launch("tel:+919463629128"),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withOpacity(0.25)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text("Call Clinic Now",
                style: GoogleFonts.nunito(
                    fontSize: 14, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }

  Widget _touchRow(
      {required IconData icon, required String text, String? subText}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: kSoftRose.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: kSoftRose, size: 17),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text,
                  style: GoogleFonts.nunito(
                      color: Colors.white60, fontSize: 13.5, height: 1.5)),
              if (subText != null) ...[
                const SizedBox(height: 3),
                Text(subText,
                    style: GoogleFonts.nunito(
                        color: kSoftRose,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4)),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _socialIcon(IconData icon, String url) {
    return GestureDetector(
      onTap: () => _launch(url),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: kSoftRose.withOpacity(0.3)),
        ),
        child: Icon(icon, color: Colors.white60, size: 18),
      ),
    );
  }

  Widget _bottomLink(String text) {
    return Text(text,
        style: GoogleFonts.nunito(color: Colors.white38, fontSize: 13));
  }
}
