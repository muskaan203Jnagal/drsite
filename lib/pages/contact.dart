// ================================================================
//  pages/contact.dart  —  Dr. Ravinder's Clinic • Contact Page
//  UPGRADED:
//   ✓ Premium dark glassmorphism form card
//   ✓ Animated field focus with gold border
//   ✓ Hover micro-interactions on info cards
//   ✓ Animated submit button with loading state
//   ✓ Polished success card with scale animation
//   ✓ Fully responsive
// ================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/header.dart';

const Color kTeal = Color(0xFF0D9E8C);

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

// ─── Palette ──────────────────────────────────────────────────────
const _kDark = Color(0xFF0A2E2A);
const _kTealLight = Color(0xFF5EEAD4);
const _kTeal = Color(0xFF0D9E8C);

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});
  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  String _selectedService = _kServices[0];
  int _msgLength = 0;
  bool _submitted = false;
  bool _loading = false;

  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _msgCtrl
        .addListener(() => setState(() => _msgLength = _msgCtrl.text.length));
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..forward();
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _msgCtrl.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedService == _kServices[0]) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please select a service", style: GoogleFonts.nunito()),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
        return;
      }
      setState(() => _loading = true);
      await Future.delayed(const Duration(milliseconds: 1400));
      if (mounted)
        setState(() {
          _loading = false;
          _submitted = true;
        });
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
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Padding(
            padding: EdgeInsets.only(top: kNavBarHeight),
            child: Column(
              children: [
                // ── HERO HEADING ──────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 80 : 24, vertical: isWide ? 72 : 52),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0A2E2A), Color(0xFF0D3B34)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 7),
                        decoration: BoxDecoration(
                          color: _kTealLight.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: _kTealLight.withOpacity(0.4), width: 1.2),
                        ),
                        child: Text("CONTACT US",
                            style: GoogleFonts.nunito(
                                color: _kTealLight,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2.5)),
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                            text: "Get in ",
                            style: GoogleFonts.playfairDisplay(
                                fontSize: isWide ? 56 : 38,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text: "Touch",
                            style: GoogleFonts.playfairDisplay(
                                fontSize: isWide ? 56 : 38,
                                color: _kTealLight,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Have a question or ready to book your appointment?\nFill out the form below or reach us directly.",
                        style: GoogleFonts.nunito(
                            color: Colors.white60,
                            fontSize: isWide ? 16 : 14,
                            height: 1.6),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // ── MAIN CONTENT ──────────────────────────────────
                Container(
                  color: const Color(0xFF06192E),
                  padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 80 : 24, vertical: 64),
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 5, child: _buildForm(isWide)),
                            const SizedBox(width: 36),
                            Expanded(flex: 4, child: _buildInfoPanel()),
                          ],
                        )
                      : Column(
                          children: [
                            _buildForm(isWide),
                            const SizedBox(height: 36),
                            _buildInfoPanel(),
                          ],
                        ),
                ),

                const SizedBox(height: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── FORM ─────────────────────────────────────────────────────────
  Widget _buildForm(bool isWide) {
    if (_submitted) return _buildSuccessCard();

    return Container(
      padding: EdgeInsets.all(isWide ? 40 : 26),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 40,
              offset: const Offset(0, 16))
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                      color: _kTealLight,
                      borderRadius: BorderRadius.circular(2)),
                ),
                const SizedBox(width: 12),
                Text("Book a Consultation",
                    style: GoogleFonts.playfairDisplay(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 30),

            // Name + Phone row
            LayoutBuilder(builder: (ctx, constraints) {
              final narrow = constraints.maxWidth < 480;
              if (narrow) {
                return Column(children: [
                  _field(
                      label: "FULL NAME",
                      hint: "Sunita Sharma",
                      controller: _nameCtrl,
                      validator: (v) => v!.isEmpty ? "Name required" : null),
                  const SizedBox(height: 16),
                  _field(
                      label: "PHONE NUMBER",
                      hint: "+91 94636 29128",
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      validator: (v) => v!.isEmpty ? "Phone required" : null),
                ]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _field(
                        label: "FULL NAME",
                        hint: "Sunita Sharma",
                        controller: _nameCtrl,
                        validator: (v) => v!.isEmpty ? "Name required" : null),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _field(
                        label: "PHONE NUMBER",
                        hint: "+91 94636 29128",
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        validator: (v) => v!.isEmpty ? "Phone required" : null),
                  ),
                ],
              );
            }),
            const SizedBox(height: 16),

            // Email
            _field(
                label: "EMAIL ADDRESS",
                hint: "you@example.com",
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v!.isEmpty) return "Email required";
                  if (!v.contains('@')) return "Enter a valid email";
                  return null;
                }),
            const SizedBox(height: 16),

            // Service Dropdown
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("SERVICE",
                    style: GoogleFonts.nunito(
                        color: Colors.white60,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5)),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withOpacity(0.12)),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedService,
                    dropdownColor: const Color(0xFF0A2E2A),
                    style:
                        GoogleFonts.nunito(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      border: InputBorder.none,
                    ),
                    items: _kServices
                        .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(s,
                                style: GoogleFonts.nunito(
                                    color: Colors.white, fontSize: 14))))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedService = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Message
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("MESSAGE",
                    style: GoogleFonts.nunito(
                        color: Colors.white60,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _msgCtrl,
                  maxLines: 4,
                  style: GoogleFonts.nunito(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "Tell us how we can help you...",
                    hintStyle:
                        GoogleFonts.nunito(color: Colors.white38, fontSize: 14),
                    contentPadding: const EdgeInsets.all(16),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    enabledBorder: _inputBorder(),
                    focusedBorder: _inputBorder(focused: true),
                    errorBorder: _inputBorder(error: true),
                    errorStyle: GoogleFonts.nunito(color: Colors.redAccent),
                    suffix: Text("$_msgLength",
                        style: GoogleFonts.nunito(
                            color: Colors.white30, fontSize: 11)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: _loading
                  ? Container(
                      height: 52,
                      decoration: BoxDecoration(
                          color: _kTealLight.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(14)),
                      child: const Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        ),
                      ),
                    )
                  : _PremiumButton(label: "Send Message", onTap: _submit),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.nunito(
                color: Colors.white60,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: GoogleFonts.nunito(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.nunito(color: Colors.white38, fontSize: 14),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            enabledBorder: _inputBorder(),
            focusedBorder: _inputBorder(focused: true),
            errorBorder: _inputBorder(error: true),
            focusedErrorBorder: _inputBorder(error: true, focused: true),
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
                ? _kTeal
                : Colors.white.withOpacity(0.12),
        width: focused || error ? 1.8 : 1,
      ),
    );
  }

  Widget _buildSuccessCard() {
    return Container(
      padding: const EdgeInsets.all(56),
      decoration: BoxDecoration(
        color: kTeal.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: kTeal.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kTeal.withOpacity(0.15),
              border: Border.all(color: kTeal.withOpacity(0.4), width: 2),
            ),
            child: const Icon(Icons.check_rounded, color: kTeal, size: 36),
          ),
          const SizedBox(height: 24),
          Text("Request Sent!",
              style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic)),
          const SizedBox(height: 12),
          Text(
            "Thank you! We'll review your request and get back to you within 24 hours.",
            style: GoogleFonts.nunito(
                color: Colors.white60, fontSize: 15, height: 1.65),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextButton.icon(
            onPressed: () => setState(() {
              _submitted = false;
              _selectedService = _kServices[0];
              _nameCtrl.clear();
              _phoneCtrl.clear();
              _emailCtrl.clear();
              _msgCtrl.clear();
            }),
            icon: const Icon(Icons.refresh_rounded, color: kTeal, size: 16),
            label: Text("Send Another Request",
                style: GoogleFonts.nunito(
                    color: kTeal, fontSize: 14, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // ── INFO PANEL ───────────────────────────────────────────────────
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
            "Mon – Sat:   9:00 AM – 7:00 PM",
            "Sunday:        Closed",
          ],
        ),
        const SizedBox(height: 16),
        _InfoCard(
          icon: Icons.email_rounded,
          title: "Email",
          lines: const ["drravinder@glowora.in"],
          onTap: () => _launch("mailto:drravinder@glowora.in"),
        ),
        const SizedBox(height: 16),

        // Map placeholder
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 220,
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.map_rounded,
                        color: kTeal.withOpacity(0.5), size: 42),
                    const SizedBox(height: 10),
                    Text("Kartarpur, Jalandhar",
                        style: GoogleFonts.nunito(
                            color: Colors.white38, fontSize: 13)),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () => _launch(
                          "https://www.google.com/maps/search/Kartarpur+Jalandhar+Punjab"),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 9),
                        decoration: BoxDecoration(
                          color: kTeal.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: kTeal.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.open_in_new, color: kTeal, size: 14),
                            const SizedBox(width: 6),
                            Text("Open in Maps",
                                style: GoogleFonts.nunito(
                                    color: kTeal,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── PREMIUM SUBMIT BUTTON ─────────────────────────────────────────
class _PremiumButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _PremiumButton({required this.label, required this.onTap});
  @override
  State<_PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<_PremiumButton> {
  bool _h = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: _h
              ? [
                  BoxShadow(
                      color: _kTealLight.withOpacity(0.35),
                      blurRadius: 22,
                      offset: const Offset(0, 8))
                ]
              : [],
        ),
        child: ElevatedButton.icon(
          onPressed: widget.onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: _h ? _kTealLight : _kTealLight.withOpacity(0.85),
            foregroundColor: _kDark,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 28),
          ),
          icon: const Icon(Icons.send_rounded, size: 16),
          label: Text(widget.label,
              style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w800, fontSize: 15)),
        ),
      ),
    );
  }
}

// ── INFO CARD ─────────────────────────────────────────────────────
class _InfoCard extends StatefulWidget {
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
  State<_InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<_InfoCard> {
  bool _h = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(20),
          transform: _h && widget.onTap != null
              ? (Matrix4.identity()..translate(4.0, 0.0))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: _h
                ? Colors.white.withOpacity(0.09)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: _h
                    ? kTeal.withOpacity(0.3)
                    : Colors.white.withOpacity(0.08)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: kTeal.withOpacity(_h ? 0.25 : 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, color: kTeal, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title,
                        style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    for (final line in widget.lines)
                      Text(line,
                          style: GoogleFonts.nunito(
                              color: Colors.white60,
                              fontSize: 13,
                              height: 1.55)),
                    if (widget.badge != null) ...[
                      const SizedBox(height: 6),
                      Text(widget.badge!,
                          style: GoogleFonts.nunito(
                              color: kTeal,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5)),
                    ],
                  ],
                ),
              ),
              if (widget.onTap != null)
                Icon(Icons.chevron_right_rounded,
                    color: _h ? kTeal : Colors.white24, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
