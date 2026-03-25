import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const ClinicApp());

// ═══════════════════════════════════════════════
//  THEME CONSTANTS
// ═══════════════════════════════════════════════
const Color kTeal       = Color(0xFF009688);
const Color kDarkTeal   = Color(0xFF00695C);
const Color kGold       = Color(0xFFC9A84C);
const Color kLightGold  = Color(0xFFEDD995);
const Color kWarmWhite  = Color(0xFFFCFBF8);
const Color kBeige      = Color(0xFFF0EBE1);
const Color kDark       = Color(0xFF1A2332);
const Color kGray       = Color(0xFF6B7280);

// ═══════════════════════════════════════════════
//  APP ROOT
// ═══════════════════════════════════════════════
class ClinicApp extends StatelessWidget {
  const ClinicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClearSmile Clinic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kTeal),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// ═══════════════════════════════════════════════
//  HOME PAGE — SCROLLABLE LANDING PAGE
// ═══════════════════════════════════════════════
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWarmWhite,
      body: SingleChildScrollView(
        child: Column(
          children: const [
            NavBar(),
            HeroSection(),
            BookingStrip(),
            ServicesSection(),
            StatsSection(),
            AboutSection(),
            TestimonialsSection(),
            ContactSection(),
            FooterSection(),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
//  1. NAVBAR
// ═══════════════════════════════════════════════
class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 18),
      child: Row(
        children: [
          // ── Logo ──
          Row(children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: kTeal,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.medical_services, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Text('ClearSmile',
                style: GoogleFonts.dmSerifDisplay(fontSize: 22, color: kDark)),
            Text(' Clinic',
                style: GoogleFonts.nunito(
                    fontSize: 16, color: kTeal, fontWeight: FontWeight.w700)),
          ]),
          const Spacer(),

          // ── Nav Links ──
          for (final item in ['Home', 'About', 'Services', 'Testimonials', 'Contact'])
            Padding(
              padding: const EdgeInsets.only(right: 32),
              child: InkWell(
                onTap: () {},
                child: Text(item,
                    style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: kDark,
                        fontWeight: FontWeight.w600)),
              ),
            ),

          // ── CTA Button ──
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: kTeal,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: Text('Book Appointment',
                style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════
//  2. HERO SECTION
// ═══════════════════════════════════════════════
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF004D40), Color(0xFF00796B), Color(0xFF26A69A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // ── Decorative Circles ──
          Positioned(
            right: -60,
            top: -60,
            child: Container(
              width: 420,
              height: 420,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            left: 250,
            bottom: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kGold.withOpacity(0.12),
              ),
            ),
          ),

          // ── Content ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: kGold.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kGold.withOpacity(0.4)),
                  ),
                  child: Text('✨ Dental & Dermatology Under One Roof',
                      style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: kLightGold,
                          fontWeight: FontWeight.w600)),
                ),

                const SizedBox(height: 28),

                // Headline
                Text('Your Smile &\nSkin, Both\nDeserve',
                    style: GoogleFonts.dmSerifDisplay(
                        fontSize: 62, color: Colors.white, height: 1.1)),
                Text('the Best Care.',
                    style: GoogleFonts.dmSerifDisplay(
                        fontSize: 62,
                        color: kLightGold,
                        height: 1.1,
                        fontStyle: FontStyle.italic)),

                const SizedBox(height: 20),

                Text(
                    'Expert dental treatments & advanced skin therapies\nunder one roof — because you deserve complete care.',
                    style: GoogleFonts.nunito(
                        fontSize: 16, color: Colors.white70, height: 1.6)),

                const SizedBox(height: 36),

                // CTA Buttons
                Row(children: [
                  _HeroButton(label: '🦷  Book Dental', isPrimary: true),
                  const SizedBox(width: 16),
                  _HeroButton(
                      label: '🧴  Book Skin Consult', isPrimary: false),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  const _HeroButton({required this.label, required this.isPrimary});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? kGold : Colors.transparent,
        foregroundColor: isPrimary ? kDark : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
              color: isPrimary ? kGold : Colors.white38, width: 1.5),
        ),
        elevation: isPrimary ? 4 : 0,
        shadowColor: kGold.withOpacity(0.3),
      ),
      child: Text(label,
          style: GoogleFonts.nunito(
              fontSize: 15, fontWeight: FontWeight.w700)),
    );
  }
}

// ═══════════════════════════════════════════════
//  3. QUICK BOOKING STRIP
// ═══════════════════════════════════════════════
class BookingStrip extends StatelessWidget {
  const BookingStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBeige,
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 28),
      child: Row(
        children: [
          _BookingField(
              label: 'Choose Service',
              hint: 'Dental / Skin',
              icon: Icons.medical_services_outlined),
          _FieldDivider(),
          _BookingField(
              label: 'Choose Date',
              hint: 'DD / MM / YYYY',
              icon: Icons.calendar_today_outlined),
          _FieldDivider(),
          _BookingField(
              label: 'Contact Number',
              hint: '+91 XXXXX XXXXX',
              icon: Icons.phone_outlined),
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: kTeal,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: Text('Book Appointment',
                style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _BookingField extends StatelessWidget {
  final String label, hint;
  final IconData icon;
  const _BookingField(
      {required this.label, required this.hint, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.nunito(
                  fontSize: 11,
                  color: kGray,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5)),
          const SizedBox(height: 6),
          Row(children: [
            Icon(icon, size: 16, color: kTeal),
            const SizedBox(width: 8),
            Text(hint,
                style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: kDark,
                    fontWeight: FontWeight.w600)),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, color: kGray, size: 16),
          ]),
        ],
      ),
    );
  }
}

class _FieldDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: 1,
      color: Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(horizontal: 24),
    );
  }
}

// ═══════════════════════════════════════════════
//  4. SERVICES SECTION
// ═══════════════════════════════════════════════
class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  static const _dental = [
    ('Teeth Whitening', Icons.wb_sunny_outlined),
    ('Dental Implants', Icons.add_circle_outline),
    ('Root Canal Treatment', Icons.healing_outlined),
    ('Braces / Aligners', Icons.straighten_outlined),
    ('Tooth Extraction', Icons.content_cut),
    ('Smile Makeover', Icons.sentiment_very_satisfied_outlined),
  ];

  static const _skin = [
    ('Acne Treatment', Icons.water_drop_outlined),
    ('Anti-Aging Therapy', Icons.face_retouching_natural_outlined),
    ('Laser Treatment', Icons.flash_on_outlined),
    ('Chemical Peel', Icons.science_outlined),
    ('Pigmentation', Icons.brightness_6_outlined),
    ('Hydration Boost', Icons.opacity_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 80),
      child: Column(
        children: [
          Text('OUR EXPERTISE',
              style: GoogleFonts.nunito(
                  fontSize: 12,
                  color: kTeal,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.5)),
          const SizedBox(height: 12),
          Text('Complete Care, One Clinic',
              style: GoogleFonts.dmSerifDisplay(fontSize: 40, color: kDark)),
          const SizedBox(height: 8),
          Text(
              'Two specialties, one dedicated doctor — for your smile and your skin.',
              style: GoogleFonts.nunito(fontSize: 15, color: kGray)),
          const SizedBox(height: 52),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: _ServiceColumn(
                      title: 'Dental Services',
                      emoji: '🦷',
                      accentColor: kTeal,
                      services: _dental)),
              const SizedBox(width: 28),
              Expanded(
                  child: _ServiceColumn(
                      title: 'Dermatology Services',
                      emoji: '🧴',
                      accentColor: kGold,
                      services: _skin)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ServiceColumn extends StatelessWidget {
  final String title, emoji;
  final Color accentColor;
  final List<(String, IconData)> services;

  const _ServiceColumn({
    required this.title,
    required this.emoji,
    required this.accentColor,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: accentColor.withOpacity(0.1),
              blurRadius: 30,
              offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Text(title,
                style: GoogleFonts.dmSerifDisplay(fontSize: 24, color: kDark)),
          ]),
          const SizedBox(height: 8),
          Divider(color: accentColor.withOpacity(0.3), thickness: 1.5),
          const SizedBox(height: 16),
          for (final s in services)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(s.$2, size: 17, color: accentColor),
                ),
                const SizedBox(width: 14),
                Text(s.$1,
                    style: GoogleFonts.nunito(
                        fontSize: 15,
                        color: kDark,
                        fontWeight: FontWeight.w600)),
                const Spacer(),
                Icon(Icons.arrow_forward_ios, size: 12, color: accentColor),
              ]),
            ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: Text('Book ${title.split(' ')[0]} Appointment',
                style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════
//  5. STATS SECTION
// ═══════════════════════════════════════════════
class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF004D40), Color(0xFF00695C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _StatItem(number: '5000+', label: 'Happy Patients'),
          _StatDivider(),
          _StatItem(number: '12+', label: 'Years Experience'),
          _StatDivider(),
          _StatItem(number: '98%', label: 'Satisfaction Rate'),
          _StatDivider(),
          _StatItem(number: '50+', label: 'Treatments Available'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String number, label;
  const _StatItem({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(number,
          style: GoogleFonts.dmSerifDisplay(
              fontSize: 50, color: kLightGold, fontStyle: FontStyle.italic)),
      const SizedBox(height: 8),
      Text(label,
          style: GoogleFonts.nunito(
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.w600)),
    ]);
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 60, width: 1, color: Colors.white24);
  }
}

// ═══════════════════════════════════════════════
//  6. ABOUT DOCTOR SECTION
// ═══════════════════════════════════════════════
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBeige,
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 80),
      child: Row(
        children: [
          // ── Doctor Photo Placeholder ──
          Container(
            width: 380,
            height: 480,
            decoration: BoxDecoration(
              color: kTeal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kTeal.withOpacity(0.2), width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, size: 80, color: kTeal.withOpacity(0.35)),
                const SizedBox(height: 12),
                Text('Add Doctor Photo Here',
                    style: GoogleFonts.nunito(color: kGray, fontSize: 13)),
                Text('(assets/doctor.jpg)',
                    style:
                        GoogleFonts.nunito(color: kGray.withOpacity(0.6), fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(width: 64),

          // ── About Content ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MEET THE EXPERT',
                    style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: kGold,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2)),
                const SizedBox(height: 12),
                Text('Dr. [Your Name]',
                    style: GoogleFonts.dmSerifDisplay(
                        fontSize: 44, color: kDark)),
                const SizedBox(height: 8),
                Text('BDS  •  MD Dermatology',
                    style: GoogleFonts.nunito(
                        fontSize: 16,
                        color: kTeal,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 20),
                Text(
                    'With over 12 years of clinical experience, Dr. [Name] combines expertise in cosmetic dentistry and advanced dermatology to deliver truly comprehensive aesthetic care.\n\nTrained from premier institutions and committed to using the latest technologies, they believe every patient deserves to feel confident — in their smile and in their skin.',
                    style: GoogleFonts.nunito(
                        fontSize: 15, color: kGray, height: 1.75)),
                const SizedBox(height: 32),
                Row(children: [
                  _CredBadge(
                      label: 'BDS Certified',
                      icon: Icons.verified_outlined,
                      color: kTeal),
                  const SizedBox(width: 14),
                  _CredBadge(
                      label: 'MD Dermatology',
                      icon: Icons.verified_outlined,
                      color: kGold),
                ]),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kDark,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: Text('Read Full Bio  →',
                      style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CredBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _CredBadge(
      {required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(label,
            style: GoogleFonts.nunito(
                fontSize: 13, color: color, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════
//  7. TESTIMONIALS SECTION
// ═══════════════════════════════════════════════
class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  static const _testimonials = [
    (
      'Priya Sharma',
      'Dental Patient',
      'Got my smile makeover done here — Dr. [Name] is absolutely brilliant! The clinic feels premium and the staff is so warm. My confidence has gone up so much after the treatment.'
    ),
    (
      'Rahul Verma',
      'Skin Patient',
      'Visited for acne treatment and the results were phenomenal. Within 3 sessions my skin cleared up significantly. Very professional, uses the latest techniques. Highly recommend!'
    ),
    (
      'Ananya Singh',
      'Both Services',
      'Best decision ever — got dental cleaning and skin consultation in one visit! Saves time and the doctor gives personal attention to every patient. Will keep coming back.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 80),
      child: Column(
        children: [
          Text('PATIENT STORIES',
              style: GoogleFonts.nunito(
                  fontSize: 12,
                  color: kTeal,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.5)),
          const SizedBox(height: 12),
          Text('Real Stories, Real Smiles',
              style: GoogleFonts.dmSerifDisplay(fontSize: 40, color: kDark)),
          const SizedBox(height: 52),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _testimonials
                .map((t) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: _TestimonialCard(
                            name: t.$1, tag: t.$2, review: t.$3),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final String name, tag, review;
  const _TestimonialCard(
      {required this.name, required this.tag, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 24,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('★★★★★',
            style: TextStyle(
                color: kGold, fontSize: 18, letterSpacing: 3)),
        const SizedBox(height: 16),
        Text(review,
            style: GoogleFonts.nunito(
                fontSize: 14, color: kGray, height: 1.65)),
        const SizedBox(height: 24),
        Row(children: [
          CircleAvatar(
            backgroundColor: kTeal.withOpacity(0.15),
            radius: 22,
            child: Text(name[0],
                style: GoogleFonts.dmSerifDisplay(
                    fontSize: 18, color: kTeal)),
          ),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name,
                style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: kDark)),
            Text(tag,
                style: GoogleFonts.nunito(fontSize: 12, color: kTeal)),
          ]),
        ]),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════
//  8. CONTACT SECTION
// ═══════════════════════════════════════════════
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBeige,
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 80),
      child: Row(
        children: [
          // ── Contact Info ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('VISIT US',
                    style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: kGold,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2)),
                const SizedBox(height: 12),
                Text('Find Our Clinic',
                    style: GoogleFonts.dmSerifDisplay(
                        fontSize: 40, color: kDark)),
                const SizedBox(height: 32),
                _ContactItem(
                    icon: Icons.location_on_outlined,
                    label: 'Address',
                    value: 'Shop No. X, [Area], [City], Punjab'),
                _ContactItem(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: '+91 XXXXX XXXXX'),
                _ContactItem(
                    icon: Icons.access_time_outlined,
                    label: 'Clinic Hours',
                    value: 'Mon – Sat: 9 AM – 7 PM'),
                _ContactItem(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: 'clinic@clearsmile.in'),
              ],
            ),
          ),
          const SizedBox(width: 64),

          // ── Map Placeholder ──
          Expanded(
            child: Container(
              height: 380,
              decoration: BoxDecoration(
                color: kTeal.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kTeal.withOpacity(0.2), width: 1.5),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map_outlined,
                        size: 60, color: kTeal.withOpacity(0.35)),
                    const SizedBox(height: 12),
                    Text('Google Maps Here',
                        style: GoogleFonts.nunito(
                            color: kGray, fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('(Integrate google_maps_flutter package)',
                        style: GoogleFonts.nunito(
                            color: kGray.withOpacity(0.6), fontSize: 12)),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _ContactItem(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kTeal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: kTeal, size: 20),
        ),
        const SizedBox(width: 16),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: GoogleFonts.nunito(
                  fontSize: 11, color: kGray, fontWeight: FontWeight.w600)),
          Text(value,
              style: GoogleFonts.nunito(
                  fontSize: 15, color: kDark, fontWeight: FontWeight.w600)),
        ]),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════
//  9. FOOTER
// ═══════════════════════════════════════════════
class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kDark,
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 28),
      child: Row(
        children: [
          Row(children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: kTeal, borderRadius: BorderRadius.circular(6)),
              child: const Icon(Icons.medical_services,
                  color: Colors.white, size: 15),
            ),
            const SizedBox(width: 8),
            Text('ClearSmile Clinic',
                style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.white60,
                    fontWeight: FontWeight.w600)),
          ]),
          const Spacer(),
          Text('© 2025 ClearSmile Clinic. All rights reserved.',
              style: GoogleFonts.nunito(fontSize: 12, color: Colors.white38)),
          const Spacer(),
          Text('Made with ❤️ for better health',
              style:
                  GoogleFonts.nunito(fontSize: 12, color: Colors.white38)),
        ],
      ),
    );
  }
}
