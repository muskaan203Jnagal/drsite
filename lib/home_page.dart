import 'package:flutter/material.dart';

// COLORS
const kDeepBlue = Color(0xFF0A2540);
const kSoftRose = Color(0xFFE8AEB7);
const kWhite = Colors.white;
const kHeading = Color(0xFF0A2540); // dark text
const kLight = Color(0xFF64748B); // light text

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

// HOME PAGE
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeroSection(),

            SizedBox(height: 20),

            // IMAGE AFTER HERO

            Container(
              margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/doc_image.jpeg',
                  height: 320,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            TweenAnimationBuilder(
              duration: const Duration(milliseconds: 800),
              tween: Tween<double>(begin: 50, end: 0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, value),
                  child: child,
                );
              },
              child: const AppointmentBar(),
            ),
            SizedBox(height: 40),

            AnimatedOpacity(
              opacity: 1,
              duration: Duration(seconds: 1),
              child: ServicesSection(),
            ),
            SizedBox(height: 40),

            TweenAnimationBuilder(
              duration: const Duration(milliseconds: 800),
              tween: Tween<double>(begin: 50, end: 0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, value),
                  child: child,
                );
              },
              child: const StatsSection(),
            ),
            SizedBox(height: 40),
            FooterSection(),
          ],
        ),
      ),
    );
  }
}

// 🔥 HERO SECTION WITH ANIMATION
class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    _scale = Tween<double>(begin: 1.0, end: 1.1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose(); // 🔥 IMPORTANT
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 650,
      child: Stack(
        children: [
          // 🔥 IMAGE ANIMATION
          AnimatedBuilder(
            animation: _scale,
            child: Image.asset(
              'assets/images/home_image.jpeg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            builder: (context, child) {
              return Transform.scale(
                scale: _scale.value,
                child: child,
              );
            },
          ),

          // 🔥 DARK OVERLAY
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.2),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // 🔥 CENTER TEXT
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Dr. Ravinder's Dental & Skin Aesthetic Clinic",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 10),
                const Text(
                  "A Great Place\nCare for Yourself",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Kartarpur • +91 98765 43210",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kDeepBlue,
                      ),
                      child: const Text("Book Appointment"),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Learn More"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppointmentBar extends StatelessWidget {
  const AppointmentBar({super.key});

  Widget field(String title, String value, IconData icon) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: kLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(icon, size: 18, color: kDeepBlue),
              const SizedBox(width: 8),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: kHeading,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 25,
            color: kDeepBlue.withOpacity(0.15),
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        children: [
          field("Service", "Dental Care", Icons.medical_services_outlined),
          field("Date", "DD/MM/YYYY", Icons.calendar_today_outlined),
          field("Contact", "+91 98765 43210", Icons.phone_outlined),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: kDeepBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Book Appointment"),
          )
        ],
      ),
    );
  }
}

// 🔥 SERVICES
class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      "Cardiology",
      "Skin Care",
      "Dental",
      "Surgery",
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      color: kDeepBlue,
      child: Column(
        children: [
          const Text(
            "Our Services",
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          const SizedBox(height: 50),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: services.map((s) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(20),
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.medical_services, color: Colors.white),
                    const SizedBox(height: 10),
                    Text(s, style: const TextStyle(color: Colors.white))
                  ],
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  const ServiceCard(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.medical_services, color: kSoftRose),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: kSoftRose.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: kSoftRose,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Professional healthcare service",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// 🔥 STATS
class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _CircleStat(value: "67%", label: "Patients"),
          _CircleStat(value: "99%", label: "Success"),
          _CircleStat(value: "120+", label: "Doctors"),
        ],
      ),
    );
  }
}

class _CircleStat extends StatelessWidget {
  final String value;
  final String label;

  const _CircleStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: kDeepBlue, width: 3),
          ),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                color: kDeepBlue,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(label),
      ],
    );
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kDeepBlue,
      padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 20),
      child: Column(
        children: [
          const Text(
            "Dr. Ravinder's Dental & Skin Aesthetic Clinic",
            style: TextStyle(
              color: kSoftRose,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Text("📍 Kartarpur",
                  style: TextStyle(color: Colors.white70, fontSize: 20)),
              Text("📞 +91 98765 43210",
                  style: TextStyle(color: Colors.white70, fontSize: 20)),
              Text("🕒 9AM - 7PM",
                  style: TextStyle(color: Colors.white70, fontSize: 20)),
            ],
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FooterButton(label: "Book Appointment"),
              const SizedBox(width: 16),
              _FooterButton(label: "Leave Review"),
            ],
          ),
        ],
      ),
    );
  }
}

class _FooterButton extends StatelessWidget {
  final String label;

  const _FooterButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: kSoftRose,
        foregroundColor: kDeepBlue,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(label),
    );
  }
}
