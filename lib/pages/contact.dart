// ================================================================
//  pages/contact.dart  —  Contact Us Page (matching Replit design)
// ================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/header.dart'; // kNavBarHeight, kTeal

const List<String> _kServices = [
  "Select a service...",
  "Dental Consultation",
  "Teeth Cleaning",
  "Teeth Whitening",
  "Braces / Aligners",
  "Skin Consultation",
  "Acne Treatment",
  "Hair Treatment",
  "Laser Therapy",
];

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  String _selectedService = _kServices[0];
  int _msgLength = 0;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _msgCtrl.addListener(() {
      setState(() => _msgLength = _msgCtrl.text.length);
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedService == _kServices[0]) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please select a service",
                style: GoogleFonts.nunito()),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }
      setState(() => _submitted = true);
    }
  }

  void _launch(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 900;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: kNavBarHeight),
        child: Column(
          children: [
            // ── HERO HEADING ─────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 80 : 24,
                vertical: isWide ? 64 : 48,
              ),
              child: Column(
                children: [
                  // "Get in Touch" — two-tone heading
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Get in ",
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: isWide ? 64 : 42,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: "Touch",
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: isWide ? 64 : 42,
                            color: kTeal,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Have a question or ready to book your appointment? Fill out the form below or\nreach us directly.",
                    style: GoogleFonts.nunito(
                        color: Colors.white60, fontSize: 16, height: 1.6),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // ── MAIN CONTENT ─────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 80 : 24,
              ),
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: _buildForm()),
                        const SizedBox(width: 32),
                        Expanded(flex: 4, child: _buildInfoPanel()),
                      ],
                    )
                  : Column(
                      children: [
                        _buildForm(),
                        const SizedBox(height: 32),
                        _buildInfoPanel(),
                      ],
                    ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // ── FORM ──────────────────────────────────────────────────────
  Widget _buildForm() {
    if (_submitted) return _buildSuccessCard();

    return Container(
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Book a Consultation",
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 28),

            // Name + Phone row
            Row(
              children: [
                Expanded(
                  child: _field(
                    label: "FULL NAME",
                    hint: "John Doe",
                    controller: _nameCtrl,
                    validator: (v) => v!.isEmpty ? "Name required" : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _field(
                    label: "PHONE NUMBER",
                    hint: "+91 94636 29128",
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    validator: (v) => v!.isEmpty ? "Phone required" : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Email + Service row
            Row(
              children: [
                Expanded(
                  child: _field(
                    label: "EMAIL ADDRESS",
                    hint: "john@example.com",
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v!.isEmpty) return "Email required";
                      if (!v.contains('@')) return "Enter valid email";
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(child: _buildServiceDropdown()),
              ],
            ),
            const SizedBox(height: 20),

            // Message with char counter
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "YOUR MESSAGE",
                      style: GoogleFonts.nunito(
                        color: Colors.white54,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Text(
                      "$_msgLength/500",
                      style: GoogleFonts.nunito(
                          color: Colors.white38, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _msgCtrl,
                  maxLines: 6,
                  maxLength: 500,
                  buildCounter: (_, {required currentLength, required isFocused, maxLength}) =>
                      const SizedBox.shrink(),
                  validator: (v) =>
                      v!.isEmpty ? "Please write a message" : null,
                  style: GoogleFonts.nunito(color: Colors.white),
                  decoration: InputDecoration(
                    hintText:
                        "Tell us about your concern or what you'd like to book...",
                    hintStyle:
                        GoogleFonts.nunito(color: Colors.white24, fontSize: 14),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.06),
                    contentPadding: const EdgeInsets.all(16),
                    border: _inputBorder(),
                    enabledBorder: _inputBorder(),
                    focusedBorder: _inputBorder(focused: true),
                    errorBorder: _inputBorder(error: true),
                    errorStyle: GoogleFonts.nunito(color: Colors.redAccent),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Submit
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kTeal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(
                  "Send Request",
                  style: GoogleFonts.nunito(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "SERVICE OF INTEREST",
          style: GoogleFonts.nunito(
            color: Colors.white54,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedService,
          dropdownColor: const Color(0xFF1A2D3F),
          style: GoogleFonts.nunito(color: Colors.white, fontSize: 14),
          icon:
              const Icon(Icons.keyboard_arrow_down, color: Colors.white38),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.06),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: _inputBorder(),
            enabledBorder: _inputBorder(),
            focusedBorder: _inputBorder(focused: true),
          ),
          items: _kServices
              .map((s) => DropdownMenuItem(
                    value: s,
                    child: Text(s,
                        style: GoogleFonts.nunito(
                          color: s == _kServices[0]
                              ? Colors.white38
                              : Colors.white,
                          fontSize: 14,
                        )),
                  ))
              .toList(),
          onChanged: (v) => setState(() => _selectedService = v!),
        ),
      ],
    );
  }

  Widget _field({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            color: Colors.white54,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: GoogleFonts.nunito(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.nunito(color: Colors.white24, fontSize: 14),
            filled: true,
            fillColor: Colors.white.withOpacity(0.06),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: _inputBorder(),
            enabledBorder: _inputBorder(),
            focusedBorder: _inputBorder(focused: true),
            errorBorder: _inputBorder(error: true),
            errorStyle: GoogleFonts.nunito(color: Colors.redAccent),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _inputBorder({bool focused = false, bool error = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: error
            ? Colors.redAccent
            : focused
                ? kTeal
                : Colors.white.withOpacity(0.12),
        width: focused || error ? 1.5 : 1,
      ),
    );
  }

  Widget _buildSuccessCard() {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: kTeal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kTeal.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle_outline_rounded,
              color: kTeal, size: 60),
          const SizedBox(height: 20),
          Text(
            "Request Sent!",
            style: GoogleFonts.dmSerifDisplay(
                color: Colors.white,
                fontSize: 32,
                fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 10),
          Text(
            "Thank you! We'll get back to you shortly.",
            style: GoogleFonts.nunito(color: Colors.white60, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          TextButton(
            onPressed: () => setState(() {
              _submitted = false;
              _selectedService = _kServices[0];
            }),
            child: Text("Send Another Request",
                style: GoogleFonts.nunito(color: kTeal, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  // ── INFO PANEL ────────────────────────────────────────────────
  Widget _buildInfoPanel() {
    return Column(
      children: [
        _InfoCard(
          icon: Icons.location_on_rounded,
          title: "Clinic Location",
          lines: const [
            "Main Bazaar Road",
            "Kartarpur, Jalandhar",
            "Punjab, India 144801",
          ],
        ),
        const SizedBox(height: 16),
        _InfoCard(
          icon: Icons.phone_rounded,
          title: "Phone",
          lines: const ["+91 94636 29128"],
          badge: "AVAILABLE 24/7 FOR EMERGENCIES",
          onTap: () => _launch("tel:+919463629128"),
        ),
        const SizedBox(height: 16),
        _InfoCard(
          icon: Icons.access_time_rounded,
          title: "Operating Hours",
          lines: const [
            "Mon - Sat:   9:00 AM - 7:00",
            "Sunday:        Closed",
          ],
        ),
        const SizedBox(height: 16),

        // ── GOOGLE MAP EMBED ────────────────────────────────────
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 220,
            child: Stack(
              children: [
                // iframe embed via HtmlElementView on web, fallback for other
                Container(
                  color: Colors.white.withOpacity(0.04),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.map_rounded,
                            color: kTeal.withOpacity(0.5), size: 40),
                        const SizedBox(height: 8),
                        Text(
                          "Kartarpur, Jalandhar",
                          style: GoogleFonts.nunito(
                              color: Colors.white38, fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => _launch(
                              "https://www.google.com/maps/search/Kartarpur+Jalandhar+Punjab"),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: kTeal.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: kTeal.withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.open_in_new,
                                    color: kTeal, size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  "Open in Maps",
                                  style: GoogleFonts.nunito(
                                    color: kTeal,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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

// ── INFO CARD WIDGET ──────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> lines;
  final String? badge;
  final VoidCallback? onTap;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.lines,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon circle
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: kTeal.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: kTeal, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  for (final line in lines)
                    Text(
                      line,
                      style: GoogleFonts.nunito(
                          color: Colors.white60, fontSize: 14, height: 1.5),
                    ),
                  if (badge != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      badge!,
                      style: GoogleFonts.nunito(
                        color: kTeal,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}