// ================================================================
//  sections/booking.dart  —  Premium Light Theme
//  Palette: Deep Blue #0A2540 · Rose #E8AEB7 · Gold #CFA15D · Ivory #FAFAF8
// ================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/header.dart'; // kNavBarHeight

// ── Palette ───────────────────────────────────────────────────────
const Color _kDark = Color(0xFF0A2E2A);
const Color _kTealLight = Color(0xFF5EEAD4);
const Color _kTeal = Color(0xFF0D9E8C);
const Color _kIvory = Color(0xFFF0FDFA);
const Color _kCard = Color(0xFFFFFFFF);

// ── Data ──────────────────────────────────────────────────────────
const _kCategories = ['Dental', 'Dermatology'];

const _kServices = {
  'Dental': [
    'Dental Consultation',
    'Teeth Cleaning',
    'Teeth Whitening',
    'Braces / Aligners',
    'Root Canal',
    'Dental Implants',
  ],
  'Dermatology': [
    'Skin Consultation',
    'Acne Treatment',
    'Laser Therapy',
    'HydraFacial',
    'Anti-Aging Treatment',
    'Hair Restoration (PRP)',
  ],
};

const _kTimeSlots = [
  '9:00 AM',
  '9:30 AM',
  '10:00 AM',
  '10:30 AM',
  '11:00 AM',
  '11:30 AM',
  '12:00 PM',
  '2:00 PM',
  '2:30 PM',
  '3:00 PM',
  '3:30 PM',
  '4:00 PM',
  '4:30 PM',
];

// ════════════════════════════════════════════════════════════════
//  Page
// ════════════════════════════════════════════════════════════════
class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage>
    with TickerProviderStateMixin {
  int _step = 0; // 0=Service, 1=Date+Time, 2=Details, 3=Confirm

  String _category = 'Dental';
  String? _service;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String? _selectedSlot;

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late AnimationController _pageCtrl;
  late Animation<double> _pageFade;
  late Animation<Offset> _pageSlide;

  @override
  void initState() {
    super.initState();
    _pageCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 460));
    _pageFade = CurvedAnimation(parent: _pageCtrl, curve: Curves.easeOut);
    _pageSlide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _pageCtrl, curve: Curves.easeOut));
    _pageCtrl.forward();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _nextStep() async {
    await _pageCtrl.reverse();
    setState(() => _step++);
    _pageCtrl.forward();
  }

  void _prevStep() async {
    await _pageCtrl.reverse();
    setState(() => _step--);
    _pageCtrl.forward();
  }

  void _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      await _pageCtrl.reverse();
      setState(() => _step = 3);
      _pageCtrl.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 900;

    return Container(
      color: _kIvory,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: kNavBarHeight),
          child: Column(
            children: [
              // ── HERO ──────────────────────────────────────────
              _buildHero(isWide),

              // ── STEP INDICATOR ────────────────────────────────
              if (_step < 3)
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 80 : 24, vertical: 8),
                  child: _StepIndicator(currentStep: _step),
                ),

              // ── STEP CONTENT ──────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 80 : 24, vertical: 32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: FadeTransition(
                      opacity: _pageFade,
                      child: SlideTransition(
                        position: _pageSlide,
                        child: _buildStep(isWide),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  // ── HERO ────────────────────────────────────────────────────────
  Widget _buildHero(bool isWide) {
    return Container(
      width: double.infinity,
      color: _kCard,
      padding: EdgeInsets.symmetric(
          horizontal: isWide ? 80 : 24, vertical: isWide ? 72 : 48),
      child: Column(
        children: [
          // Gold pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: _kTeal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _kTeal.withOpacity(0.4)),
            ),
            child: Text(
              'EASY ONLINE BOOKING',
              style: GoogleFonts.nunito(
                  color: _kTeal,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.8),
            ),
          ),
          const SizedBox(height: 24),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                text: 'Book an ',
                style: GoogleFonts.dmSerifDisplay(
                    fontSize: isWide ? 56 : 38,
                    color: _kDark,
                    fontWeight: FontWeight.w400),
              ),
              TextSpan(
                text: 'Appointment',
                style: GoogleFonts.dmSerifDisplay(
                    fontSize: isWide ? 56 : 38,
                    color: _kTealLight,
                    fontStyle: FontStyle.italic),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          Text(
            "Complete the steps below to schedule your visit with Dr. Ravinder.",
            style: GoogleFonts.nunito(
                color: _kDark.withOpacity(0.5),
                fontSize: isWide ? 15 : 13,
                height: 1.65),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStep(bool isWide) {
    switch (_step) {
      case 0:
        return _buildStep0();
      case 1:
        return _buildStep1(isWide);
      case 2:
        return _buildStep2();
      case 3:
        return _buildConfirmation();
      default:
        return const SizedBox();
    }
  }

  // ── STEP 0: Choose Service ────────────────────────────────────
  Widget _buildStep0() {
    final services = _kServices[_category]!;
    return _StepCard(
      stepNum: '01',
      title: 'Choose a Service',
      subtitle: 'Select the type of care you need.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category toggle
          Row(
            children: _kCategories.map((cat) {
              final isSelected = _category == cat;
              return Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.only(right: cat == _kCategories.first ? 8 : 0),
                  child: _ToggleChip(
                    label: cat,
                    selected: isSelected,
                    onTap: () => setState(() {
                      _category = cat;
                      _service = null;
                    }),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text(
            '$_category Treatments',
            style: GoogleFonts.nunito(
                color: _kDark.withOpacity(0.4),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          ...services.map((s) => _ServiceSelectTile(
                label: s,
                selected: _service == s,
                onTap: () => setState(() => _service = s),
              )),
          const SizedBox(height: 28),
          _NextButton(
            label: 'Continue to Date & Time',
            enabled: _service != null,
            onTap: _nextStep,
          ),
        ],
      ),
    );
  }

  // ── STEP 1: Date + Time ───────────────────────────────────────
  Widget _buildStep1(bool isWide) {
    return _StepCard(
      stepNum: '02',
      title: 'Pick a Date & Time',
      subtitle: 'Select a convenient slot for your visit.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DatePicker(
            selected: _selectedDate,
            onChanged: (d) => setState(() {
              _selectedDate = d;
              _selectedSlot = null;
            }),
          ),
          const SizedBox(height: 28),
          Text(
            'AVAILABLE SLOTS',
            style: GoogleFonts.nunito(
                color: _kDark.withOpacity(0.4),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _kTimeSlots
                .map((slot) => _TimeSlotChip(
                      label: slot,
                      selected: _selectedSlot == slot,
                      onTap: () => setState(() => _selectedSlot = slot),
                    ))
                .toList(),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              _BackButton(onTap: _prevStep),
              const SizedBox(width: 12),
              Expanded(
                child: _NextButton(
                  label: 'Continue to Details',
                  enabled: _selectedSlot != null,
                  onTap: _nextStep,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── STEP 2: Patient Details ───────────────────────────────────
  Widget _buildStep2() {
    return _StepCard(
      stepNum: '03',
      title: 'Your Details',
      subtitle: 'Almost done — just a few details.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BookingSummary(
              service: _service!,
              date: _selectedDate,
              slot: _selectedSlot!,
            ),
            const SizedBox(height: 24),
            LayoutBuilder(builder: (ctx, constraints) {
              final narrow = constraints.maxWidth < 480;
              if (narrow) {
                return Column(children: [
                  _bookingField(
                      label: 'FULL NAME',
                      hint: 'John Doe',
                      controller: _nameCtrl,
                      validator: (v) => v!.isEmpty ? 'Name required' : null),
                  const SizedBox(height: 16),
                  _bookingField(
                      label: 'PHONE NUMBER',
                      hint: '+91 94636 29128',
                      controller: _phoneCtrl,
                      keyboard: TextInputType.phone,
                      validator: (v) => v!.isEmpty ? 'Phone required' : null),
                ]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _bookingField(
                        label: 'FULL NAME',
                        hint: 'John Doe',
                        controller: _nameCtrl,
                        validator: (v) => v!.isEmpty ? 'Name required' : null),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _bookingField(
                        label: 'PHONE NUMBER',
                        hint: '+91 94636 29128',
                        controller: _phoneCtrl,
                        keyboard: TextInputType.phone,
                        validator: (v) => v!.isEmpty ? 'Phone required' : null),
                  ),
                ],
              );
            }),
            const SizedBox(height: 16),
            _bookingField(
              label: 'ADDITIONAL NOTE (OPTIONAL)',
              hint: 'Any specific concern or question for the doctor...',
              controller: _noteCtrl,
              maxLines: 3,
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                _BackButton(onTap: _prevStep),
                const SizedBox(width: 12),
                Expanded(
                  child: _NextButton(
                    label: 'Confirm Booking',
                    enabled: true,
                    onTap: _submitBooking,
                    icon: Icons.check_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── STEP 3: Confirmation ──────────────────────────────────────
  Widget _buildConfirmation() {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _kTealLight.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: _kDark.withOpacity(0.07),
            blurRadius: 24,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          // Animated check
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 700),
            curve: Curves.elasticOut,
            builder: (_, v, child) => Transform.scale(scale: v, child: child),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _kTealLight.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: _kTealLight, width: 2),
              ),
              child: const Icon(Icons.check_rounded, color: _kDark, size: 38),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            "Booking Confirmed!",
            style: GoogleFonts.dmSerifDisplay(
                color: _kDark, fontSize: 34, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 10),
          Text(
            "We've received your request and will confirm shortly via phone.",
            style: GoogleFonts.nunito(
                color: _kDark.withOpacity(0.5), fontSize: 15, height: 1.6),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Summary
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _kIvory,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _kTealLight.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                _ConfirmRow(label: 'Service', value: _service ?? '-'),
                _ConfirmRow(
                    label: 'Date',
                    value:
                        "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}"),
                _ConfirmRow(label: 'Time', value: _selectedSlot ?? '-'),
                _ConfirmRow(
                    label: 'Patient',
                    value: _nameCtrl.text.isNotEmpty ? _nameCtrl.text : '-'),
                _ConfirmRow(
                    label: 'Phone',
                    value: _phoneCtrl.text.isNotEmpty ? _phoneCtrl.text : '-'),
              ],
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () async {
                await _pageCtrl.reverse();
                setState(() {
                  _step = 0;
                  _service = null;
                  _selectedSlot = null;
                  _nameCtrl.clear();
                  _phoneCtrl.clear();
                  _noteCtrl.clear();
                });
                _pageCtrl.forward();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: _kDark,
                side: BorderSide(color: _kDark.withOpacity(0.25)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text("Book Another Appointment",
                  style: GoogleFonts.nunito(
                      fontSize: 14, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookingField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.nunito(
                color: _kDark.withOpacity(0.45),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboard,
          validator: validator,
          style: GoogleFonts.nunito(color: _kDark, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.nunito(
                color: _kDark.withOpacity(0.3), fontSize: 14),
            filled: true,
            fillColor: _kIvory,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: _border(),
            enabledBorder: _border(),
            focusedBorder: _border(focused: true),
            errorBorder: _border(error: true),
            errorStyle: GoogleFonts.nunito(color: Colors.redAccent),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border({bool focused = false, bool error = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: error
            ? Colors.redAccent
            : focused
                ? _kDark
                : _kTealLight.withOpacity(0.45),
        width: focused || error ? 1.5 : 1,
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  Sub-widgets
// ════════════════════════════════════════════════════════════════

// ── Step Card ─────────────────────────────────────────────────────
class _StepCard extends StatelessWidget {
  final String stepNum;
  final String title;
  final String subtitle;
  final Widget child;

  const _StepCard({
    required this.stepNum,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kTealLight.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: _kDark.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step number badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _kTealLight.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  stepNum,
                  style: GoogleFonts.dmSerifDisplay(
                      color: _kDark, fontSize: 14, fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: GoogleFonts.nunito(
                            color: _kDark,
                            fontSize: 20,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Text(subtitle,
                        style: GoogleFonts.nunito(
                            color: _kDark.withOpacity(0.4), fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          child,
        ],
      ),
    );
  }
}

// ── Step Indicator ────────────────────────────────────────────────
class _StepIndicator extends StatelessWidget {
  final int currentStep;
  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = ['Service', 'Date & Time', 'Details'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final stepIdx = i ~/ 2;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                height: 2,
                color: currentStep > stepIdx
                    ? _kTealLight
                    : _kDark.withOpacity(0.1),
              ),
            );
          }
          final idx = i ~/ 2;
          final done = currentStep > idx;
          final active = currentStep == idx;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: done
                  ? _kDark
                  : active
                      ? _kCard
                      : _kCard,
              shape: BoxShape.circle,
              border: Border.all(
                color: done || active ? _kDark : _kDark.withOpacity(0.18),
                width: active ? 2 : 1.5,
              ),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: _kDark.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : [],
            ),
            child: Center(
              child: done
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 16)
                  : Text(
                      '${idx + 1}',
                      style: GoogleFonts.nunito(
                        color: active ? _kDark : _kDark.withOpacity(0.3),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          );
        }),
      ),
    );
  }
}

// ── Next Button ───────────────────────────────────────────────────
class _NextButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;
  final IconData? icon;

  const _NextButton({
    required this.label,
    required this.enabled,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: enabled ? onTap : null,
        icon: Icon(icon ?? Icons.arrow_forward_rounded, size: 18),
        label: Text(label,
            style:
                GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700)),
        style: ElevatedButton.styleFrom(
          backgroundColor: _kDark,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _kDark.withOpacity(0.08),
          disabledForegroundColor: _kDark.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),
    );
  }
}

// ── Back Button ───────────────────────────────────────────────────
class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: _kCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _kTealLight.withOpacity(0.5)),
        ),
        child: Icon(Icons.arrow_back_rounded, color: _kDark, size: 18),
      ),
    );
  }
}

// ── Service Select Tile ───────────────────────────────────────────
class _ServiceSelectTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ServiceSelectTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? _kDark : _kCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? _kDark : _kTealLight.withOpacity(0.4),
            width: 1.2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: _kDark.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(label,
                  style: GoogleFonts.nunito(
                    color: selected ? Colors.white : _kDark,
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  )),
            ),
            AnimatedOpacity(
              opacity: selected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 180),
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                    color: _kTealLight, shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, color: _kDark, size: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Category Toggle Chip ──────────────────────────────────────────
class _ToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? _kDark : _kCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? _kDark : _kTealLight.withOpacity(0.4),
            width: 1.2,
          ),
        ),
        child: Center(
          child: Text(label,
              style: GoogleFonts.nunito(
                color: selected ? Colors.white : _kDark.withOpacity(0.5),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              )),
        ),
      ),
    );
  }
}

// ── 14-day Date Picker ────────────────────────────────────────────
class _DatePicker extends StatelessWidget {
  final DateTime selected;
  final ValueChanged<DateTime> onChanged;

  const _DatePicker({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SELECT DATE',
          style: GoogleFonts.nunito(
              color: _kDark.withOpacity(0.4),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 14,
            itemBuilder: (_, i) {
              final date = today.add(Duration(days: i + 1));
              final isSun = date.weekday == DateTime.sunday;
              final isSel = selected.day == date.day &&
                  selected.month == date.month &&
                  selected.year == date.year;

              return GestureDetector(
                onTap: isSun ? null : () => onChanged(date),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.only(right: 10),
                  width: 58,
                  decoration: BoxDecoration(
                    color: isSel
                        ? _kDark
                        : isSun
                            ? _kIvory
                            : _kCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSel
                          ? _kDark
                          : isSun
                              ? _kDark.withOpacity(0.06)
                              : _kTealLight.withOpacity(0.4),
                      width: 1.2,
                    ),
                    boxShadow: isSel
                        ? [
                            BoxShadow(
                              color: _kDark.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            )
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _dayName(date.weekday),
                        style: GoogleFonts.nunito(
                          color: isSel
                              ? Colors.white70
                              : isSun
                                  ? _kDark.withOpacity(0.2)
                                  : _kDark.withOpacity(0.4),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${date.day}',
                        style: GoogleFonts.nunito(
                          color: isSel
                              ? Colors.white
                              : isSun
                                  ? _kDark.withOpacity(0.2)
                                  : _kDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _dayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }
}

// ── Time Slot Chip ────────────────────────────────────────────────
class _TimeSlotChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TimeSlotChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? _kDark : _kCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? _kDark : _kTealLight.withOpacity(0.4),
            width: 1.2,
          ),
        ),
        child: Text(label,
            style: GoogleFonts.nunito(
              color: selected ? Colors.white : _kDark,
              fontSize: 13,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            )),
      ),
    );
  }
}

// ── Booking Summary Banner ────────────────────────────────────────
class _BookingSummary extends StatelessWidget {
  final String service;
  final DateTime date;
  final String slot;

  const _BookingSummary({
    required this.service,
    required this.date,
    required this.slot,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kTealLight.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kTealLight.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
                color: _kTealLight.withOpacity(0.25), shape: BoxShape.circle),
            child: const Icon(Icons.event_available_rounded,
                color: _kDark, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service,
                    style: GoogleFonts.nunito(
                        color: _kDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis),
                Text(
                  '${date.day}/${date.month}/${date.year}  ·  $slot',
                  style: GoogleFonts.nunito(
                      color: _kDark.withOpacity(0.5), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Confirmation Row ──────────────────────────────────────────────
class _ConfirmRow extends StatelessWidget {
  final String label;
  final String value;

  const _ConfirmRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(label,
                style: GoogleFonts.nunito(
                    color: _kDark.withOpacity(0.4),
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(value,
                style: GoogleFonts.nunito(
                    color: _kDark, fontSize: 13, fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
