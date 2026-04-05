// ================================================================
//  pages/contact.dart — UPDATED with Firebase + Email
//  Changes vs original:
//   ✓ _submit() now saves to Firestore
//   ✓ Sends email notification via EmailJS
//   ✓ Loading state + error handling
//  NOTE: UI is 100% same as original
// ================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/header.dart';
import '../services/firestore_service.dart';
import '../services/notification_service.dart';
import '../models/contact_model.dart';

const Color kTeal = Color(0xFF0D9E8C);

const _kDark = Color(0xFF0A2E2A);
const _kTealLight = Color(0xFF5EEAD4);
const _kTeal = Color(0xFF0D9E8C);

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
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
    _msgCtrl
        .addListener(() => setState(() => _msgLength = _msgCtrl.text.length));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  // ── UPDATED: Real Firebase + Email submission ─────────────────
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

      try {
        final contact = ContactModel(
          patientName: _nameCtrl.text.trim(),
          patientPhone: _phoneCtrl.text.trim(),
          patientEmail: _emailCtrl.text.trim(),
          service: _selectedService,
          message: _msgCtrl.text.trim(),
        );

        // 1. Firestore mein save karo
        await FirestoreService.instance.saveContact(contact);

        // 2. Doctor ko email bhejo
        await NotificationService.instance.notifyContact(contact);

        // 3. Success state
        if (mounted) {
          setState(() {
            _loading = false;
            _submitted = true;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() => _loading = false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Message send nahi hua. Dobara try karo.',
                style: GoogleFonts.nunito()),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ));
        }
      }
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
                _buildHero(isWide),
                _buildBody(isWide),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHero(bool isWide) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: isWide ? 80 : 24, vertical: isWide ? 80 : 48),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A2E2A), Color(0xFF0D4D42)],
        ),
      ),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: _kTealLight.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _kTealLight.withOpacity(0.3)),
          ),
          child: Text('GET IN TOUCH',
              style: GoogleFonts.nunito(
                  color: _kTealLight,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.8)),
        ),
        const SizedBox(height: 20),
        Text("Let's Connect",
            style: GoogleFonts.playfairDisplay(
                fontSize: isWide ? 48 : 32,
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Text(
              "Have questions or ready to book? Reach out — we'll get back to you within 24 hours.",
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                  color: Colors.white54, fontSize: 15, height: 1.6)),
        ),
      ]),
    );
  }

  Widget _buildBody(bool isWide) {
    return Container(
      color: const Color(0xFFF0FDFA),
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 60),
      child: isWide
          ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: 2, child: _buildForm(isWide)),
              const SizedBox(width: 60),
              SizedBox(width: 300, child: _buildInfoCards()),
            ])
          : Column(children: [
              _buildForm(isWide),
              const SizedBox(height: 48),
              _buildInfoCards(),
            ]),
    );
  }

  Widget _buildForm(bool isWide) {
    if (_submitted) return _buildSuccessCard();

    return Container(
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 24,
              offset: const Offset(0, 8))
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Send a Message',
              style: GoogleFonts.playfairDisplay(
                  fontSize: 22, color: _kDark, fontWeight: FontWeight.w700)),
          const SizedBox(height: 24),
          if (isWide)
            Row(children: [
              Expanded(
                  child: _field(
                      ctrl: _nameCtrl,
                      label: 'Full Name',
                      icon: Icons.person_outline_rounded,
                      validator: (v) =>
                          v!.trim().isEmpty ? 'Naam daalo' : null)),
              const SizedBox(width: 16),
              Expanded(
                  child: _field(
                      ctrl: _phoneCtrl,
                      label: 'Phone Number',
                      icon: Icons.phone_outlined,
                      keyboard: TextInputType.phone,
                      validator: (v) =>
                          v!.length < 10 ? 'Sahi number daalo' : null)),
            ])
          else ...[
            _field(
                ctrl: _nameCtrl,
                label: 'Full Name',
                icon: Icons.person_outline_rounded,
                validator: (v) => v!.trim().isEmpty ? 'Naam daalo' : null),
            const SizedBox(height: 14),
            _field(
                ctrl: _phoneCtrl,
                label: 'Phone Number',
                icon: Icons.phone_outlined,
                keyboard: TextInputType.phone,
                validator: (v) => v!.length < 10 ? 'Sahi number daalo' : null),
          ],
          const SizedBox(height: 14),
          _field(
              ctrl: _emailCtrl,
              label: 'Email Address',
              icon: Icons.email_outlined,
              keyboard: TextInputType.emailAddress,
              validator: (v) => (!v!.contains('@') || !v.contains('.'))
                  ? 'Valid email daalo'
                  : null),
          const SizedBox(height: 14),
          _buildServiceDropdown(),
          const SizedBox(height: 14),
          _buildMessageField(),
          const SizedBox(height: 24),
          _PremiumButton(
              label: _loading ? "Sending..." : "Send Message",
              loading: _loading,
              onTap: _loading ? null : _submit),
        ]),
      ),
    );
  }

  Widget _buildSuccessCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 24,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              color: _kTeal.withOpacity(0.1), shape: BoxShape.circle),
          child:
              const Icon(Icons.check_circle_rounded, color: _kTeal, size: 40),
        ),
        const SizedBox(height: 24),
        Text('Message Received!',
            style: GoogleFonts.playfairDisplay(
                fontSize: 26, color: _kDark, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Text(
            "Thank you for reaching out.\nWe'll get back to you within 24 hours.",
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
                color: Colors.black54, fontSize: 15, height: 1.6)),
        const SizedBox(height: 32),
        OutlinedButton(
          onPressed: () => setState(() {
            _submitted = false;
            _selectedService = _kServices[0];
            _nameCtrl.clear();
            _phoneCtrl.clear();
            _emailCtrl.clear();
            _msgCtrl.clear();
          }),
          style: OutlinedButton.styleFrom(
              foregroundColor: _kTeal,
              side: BorderSide(color: _kTeal.withOpacity(0.4)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 14)),
          child: Text('Send Another Message',
              style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w700, fontSize: 14)),
        ),
      ]),
    );
  }

  Widget _buildInfoCards() {
    return Column(children: [
      _InfoCard(
        icon: Icons.location_on_rounded,
        title: 'Visit Us',
        lines: ['Kartarpur, Jalandhar,', 'Punjab, India 144801'],
        onTap: () => _launch(
            "https://www.google.com/maps/search/Kartarpur+Jalandhar+Punjab"),
      ),
      const SizedBox(height: 20),
      _InfoCard(
        icon: Icons.phone_rounded,
        title: 'Call Us',
        lines: ['+91 94636 29128'],
        onTap: () => _launch("tel:+919463629128"),
      ),
      const SizedBox(height: 20),
      _InfoCard(
        icon: Icons.access_time_rounded,
        title: 'Working Hours',
        lines: ['Mon - Sat: 9:00 AM - 7:00 PM', '24/7 Emergency'],
      ),
    ]);
  }

  Widget _buildServiceDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedService,
      items: _kServices
          .map((s) => DropdownMenuItem(
              value: s,
              child: Text(s,
                  style: GoogleFonts.nunito(fontSize: 13, color: _kDark))))
          .toList(),
      onChanged: (v) => setState(() => _selectedService = v!),
      style: GoogleFonts.nunito(color: _kDark, fontSize: 14),
      decoration: InputDecoration(
        labelText: 'Service',
        labelStyle: GoogleFonts.nunito(fontSize: 13, color: Colors.black38),
        prefixIcon: const Icon(Icons.medical_services_outlined,
            size: 18, color: Colors.black38),
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black.withOpacity(0.1))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black.withOpacity(0.1))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _kTeal, width: 1.5)),
      ),
    );
  }

  Widget _buildMessageField() {
    return Stack(
      children: [
        TextFormField(
          controller: _msgCtrl,
          maxLines: 4,
          maxLength: 400,
          style: GoogleFonts.nunito(color: _kDark, fontSize: 14),
          validator: (v) =>
              v!.trim().isEmpty ? 'Message likhna zaroori hai' : null,
          decoration: InputDecoration(
            labelText: 'Your Message',
            labelStyle: GoogleFonts.nunito(fontSize: 13, color: Colors.black38),
            alignLabelWithHint: true,
            prefixIcon: const Padding(
              padding: EdgeInsets.only(bottom: 64),
              child:
                  Icon(Icons.message_outlined, size: 18, color: Colors.black38),
            ),
            filled: true,
            fillColor: const Color(0xFFF8F8F8),
            counterText: '',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.black.withOpacity(0.1))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.black.withOpacity(0.1))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: _kTeal, width: 1.5)),
          ),
        ),
        Positioned(
          bottom: 12,
          right: 14,
          child: Text('$_msgLength/400',
              style: GoogleFonts.nunito(color: Colors.black26, fontSize: 11)),
        ),
      ],
    );
  }

  Widget _field({
    required TextEditingController ctrl,
    required String label,
    required IconData icon,
    TextInputType? keyboard,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      validator: validator,
      style: GoogleFonts.nunito(color: _kDark, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.nunito(fontSize: 13, color: Colors.black38),
        prefixIcon: Icon(icon, size: 18, color: Colors.black38),
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black.withOpacity(0.1))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black.withOpacity(0.1))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _kTeal, width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  Info Card
// ════════════════════════════════════════════════════════════════
class _InfoCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final List<String> lines;
  final VoidCallback? onTap;
  const _InfoCard(
      {required this.icon,
      required this.title,
      required this.lines,
      this.onTap});

  @override
  State<_InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<_InfoCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _hovered ? _kTeal.withOpacity(0.04) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: _hovered
                    ? _kTeal.withOpacity(0.3)
                    : Colors.black.withOpacity(0.08)),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                        color: _kTeal.withOpacity(0.1),
                        blurRadius: 16,
                        offset: const Offset(0, 4))
                  ]
                : [],
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                  color: _kTeal.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(widget.icon, color: _kTeal, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title,
                        style: GoogleFonts.nunito(
                            color: _kDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    for (final l in widget.lines)
                      Text(l,
                          style: GoogleFonts.nunito(
                              color: Colors.black54, fontSize: 13)),
                  ]),
            ),
          ]),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  Premium Submit Button
// ════════════════════════════════════════════════════════════════
class _PremiumButton extends StatefulWidget {
  final String label;
  final bool loading;
  final VoidCallback? onTap;
  const _PremiumButton(
      {required this.label, required this.loading, required this.onTap});

  @override
  State<_PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<_PremiumButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _hovered && !widget.loading
                  ? [const Color(0xFF0D9E8C), const Color(0xFF0A7A6E)]
                  : [const Color(0xFF0D9E8C), const Color(0xFF0B8B7E)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _hovered && !widget.loading
                ? [
                    BoxShadow(
                        color: _kTeal.withOpacity(0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 6))
                  ]
                : [],
          ),
          child: Center(
            child: widget.loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : Text(widget.label,
                    style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }
}
