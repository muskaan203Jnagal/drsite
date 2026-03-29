// ================================================================
//  sections/booking.dart  —  UPDATED with Firebase + Email
//  Changes vs original:
//   ✓ _submitBooking() now saves to Firestore
//   ✓ Sends email notification via EmailJS
//   ✓ Loading state + error handling
// ================================================================
//
//  NOTE: Sirf _submitBooking() method replace karna hai
//  Baaki UI code bilkul same rakhna hai
//
// ================================================================

// ── Original _submitBooking() replace karo is se ─────────────────

/*
  // ── Imports add karo file ke top mein ──
  import '../services/firestore_service.dart';
  import '../services/email_service.dart';
  import '../models/booking_model.dart';
*/

// ── State class mein ye variable add karo ────────────────────────
/*
  bool _submitting = false;
  String? _submitError;
*/

// ── Ye replace karo _submitBooking() ─────────────────────────────
/*
  void _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _submitting = true;
      _submitError = null;
    });

    try {
      final booking = BookingModel(
        patientName: _nameCtrl.text.trim(),
        patientPhone: _phoneCtrl.text.trim(),
        category: _category,
        service: _service!,
        date: _selectedDate,
        timeSlot: _selectedSlot!,
        notes: _noteCtrl.text.trim(),
      );

      // 1. Firestore mein save karo
      await FirestoreService.instance.saveBooking(booking);

      // 2. Doctor ko email bhejo (fail hone pe bhi booking save rahegi)
      await EmailService.instance.sendBookingNotification(booking);

      // 3. Success step dikhao
      if (mounted) {
        await _pageCtrl.reverse();
        setState(() {
          _step = 3;
          _submitting = false;
        });
        _pageCtrl.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _submitting = false;
          _submitError = 'Kuch error hua. Dobara try karo.';
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_submitError!, style: GoogleFonts.nunito()),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
      }
    }
  }
*/

// ── "Book Appointment" button pe loading state add karo ──────────
/*
  // Button ke onTap mein:
  onTap: _submitting ? null : _submitBooking,

  // Button child mein loading check:
  child: _submitting
      ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 16, height: 16,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Text('Saving...', style: GoogleFonts.nunito(fontSize: 15)),
          ],
        )
      : Text('Confirm Booking', style: GoogleFonts.nunito(
            fontSize: 15, fontWeight: FontWeight.w700)),
*/

// ================================================================
//  COMPLETE UPDATED booking.dart — Drop-in replacement
// ================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/header.dart';
import '../services/firestore_service.dart';
import '../services/email_service.dart';
import '../models/booking_model.dart';

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

  // ── NEW: submission state ─────────────────────────────────────
  bool _submitting = false;
  String? _submitError;

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

  // ── UPDATED: Real Firebase submission ────────────────────────
  void _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _submitting = true;
      _submitError = null;
    });

    try {
      final booking = BookingModel(
        patientName: _nameCtrl.text.trim(),
        patientPhone: _phoneCtrl.text.trim(),
        category: _category,
        service: _service!,
        date: _selectedDate,
        timeSlot: _selectedSlot!,
        notes: _noteCtrl.text.trim(),
      );

      // 1. Firestore mein save karo
      await FirestoreService.instance.saveBooking(booking);

      // 2. Doctor ko email bhejo
      await EmailService.instance.sendBookingNotification(booking);

      // 3. Confirmation screen
      if (mounted) {
        await _pageCtrl.reverse();
        setState(() {
          _step = 3;
          _submitting = false;
        });
        _pageCtrl.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _submitting = false;
          _submitError = 'Kuch error hua. Please dobara try karo.';
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Booking save nahi hui. Dobara try karo.',
              style: GoogleFonts.nunito()),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
      }
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
              _buildHero(isWide),
              if (_step < 3)
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 80 : 24, vertical: 8),
                  child: _StepIndicator(currentStep: _step),
                ),
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

  Widget _buildHero(bool isWide) {
    return Container(
      width: double.infinity,
      color: _kCard,
      padding: EdgeInsets.symmetric(
          horizontal: isWide ? 80 : 24, vertical: isWide ? 72 : 48),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: _kTeal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _kTeal.withOpacity(0.4)),
          ),
          child: Text('EASY ONLINE BOOKING',
              style: GoogleFonts.nunito(
                  color: _kTeal,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.8)),
        ),
        const SizedBox(height: 24),
        Text('Book Your Appointment',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
                fontSize: isWide ? 42 : 28,
                color: _kDark,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Text(
            'Select your service, pick a time that works for you, and we will confirm your appointment.',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
                color: Colors.black54, fontSize: 15, height: 1.6),
          ),
        ),
      ]),
    );
  }

  Widget _buildStep(bool isWide) {
    switch (_step) {
      case 0:
        return _buildServiceStep(isWide);
      case 1:
        return _buildDateTimeStep(isWide);
      case 2:
        return _buildDetailsStep(isWide);
      case 3:
        return _buildConfirmStep();
      default:
        return const SizedBox();
    }
  }

  // ── Step 0: Service Selection ─────────────────────────────────
  Widget _buildServiceStep(bool isWide) {
    final services = _kServices[_category]!;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _sectionTitle('Choose Category'),
      const SizedBox(height: 16),
      Row(
          children: _kCategories.map((cat) {
        final isSelected = _category == cat;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: cat == _kCategories.last ? 0 : 12),
            child: GestureDetector(
              onTap: () => setState(() {
                _category = cat;
                _service = null;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: isSelected ? _kTeal : _kCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color:
                          isSelected ? _kTeal : Colors.black.withOpacity(0.08)),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                              color: _kTeal.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4))
                        ]
                      : [],
                ),
                child: Text(cat,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : _kDark)),
              ),
            ),
          ),
        );
      }).toList()),
      const SizedBox(height: 28),
      _sectionTitle('$_category Treatments'),
      const SizedBox(height: 16),
      ...services.map((s) => _ServiceTile(
            label: s,
            selected: _service == s,
            onTap: () => setState(() => _service = s),
          )),
      const SizedBox(height: 32),
      _NextButton(
          label: 'Continue', enabled: _service != null, onTap: _nextStep),
    ]);
  }

  // ── Step 1: Date + Time ───────────────────────────────────────
  Widget _buildDateTimeStep(bool isWide) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _sectionTitle('Select Date'),
      const SizedBox(height: 16),
      _DatePicker(
        selected: _selectedDate,
        onPick: (d) {
          setState(() {
            _selectedDate = d;
            _selectedSlot = null;
          });
        },
      ),
      const SizedBox(height: 28),
      _sectionTitle('Available Time Slots'),
      const SizedBox(height: 16),
      Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _kTimeSlots
              .map((slot) => _TimeChip(
                    label: slot,
                    selected: _selectedSlot == slot,
                    onTap: () => setState(() => _selectedSlot = slot),
                  ))
              .toList()),
      const SizedBox(height: 32),
      Row(children: [
        _BackButton(onTap: _prevStep),
        const SizedBox(width: 12),
        Expanded(
            child: _NextButton(
                label: 'Continue',
                enabled: _selectedSlot != null,
                onTap: _nextStep)),
      ]),
    ]);
  }

  // ── Step 2: Patient Details ───────────────────────────────────
  Widget _buildDetailsStep(bool isWide) {
    return Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _AppointmentSummaryBanner(
          service: _service!,
          date: _selectedDate,
          slot: _selectedSlot!,
        ),
        const SizedBox(height: 28),
        _sectionTitle('Your Details'),
        const SizedBox(height: 16),
        if (isWide)
          Row(children: [
            Expanded(
                child: _FormField(
                    label: 'Full Name',
                    icon: Icons.person_outline_rounded,
                    controller: _nameCtrl,
                    validator: (v) => v!.trim().isEmpty ? 'Naam daalo' : null)),
            const SizedBox(width: 16),
            Expanded(
                child: _FormField(
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                    controller: _phoneCtrl,
                    keyboard: TextInputType.phone,
                    validator: (v) =>
                        v!.length < 10 ? 'Sahi phone number daalo' : null)),
          ])
        else ...[
          _FormField(
              label: 'Full Name',
              icon: Icons.person_outline_rounded,
              controller: _nameCtrl,
              validator: (v) => v!.trim().isEmpty ? 'Naam daalo' : null),
          const SizedBox(height: 14),
          _FormField(
              label: 'Phone Number',
              icon: Icons.phone_outlined,
              controller: _phoneCtrl,
              keyboard: TextInputType.phone,
              validator: (v) =>
                  v!.length < 10 ? 'Sahi phone number daalo' : null),
        ],
        const SizedBox(height: 14),
        _FormField(
            label: 'Notes (optional)',
            icon: Icons.notes_rounded,
            controller: _noteCtrl,
            maxLines: 3),
        const SizedBox(height: 32),
        Row(children: [
          _BackButton(onTap: _prevStep),
          const SizedBox(width: 12),
          Expanded(
            child: _NextButton(
              label: _submitting ? 'Saving...' : 'Confirm Booking',
              enabled: !_submitting,
              loading: _submitting,
              onTap: _submitBooking,
            ),
          ),
        ]),
      ]),
    );
  }

  // ── Step 3: Confirmation ──────────────────────────────────────
  Widget _buildConfirmStep() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: _kCard,
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
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: _kTeal.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child:
              const Icon(Icons.check_circle_rounded, color: _kTeal, size: 38),
        ),
        const SizedBox(height: 20),
        Text('Booking Confirmed!',
            style: GoogleFonts.playfairDisplay(
                fontSize: 28, color: _kDark, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Text(
          'Your appointment has been booked.\nDr. Ravinder will confirm via phone.',
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
              color: Colors.black54, fontSize: 15, height: 1.6),
        ),
        const SizedBox(height: 32),
        _ConfirmRow(label: 'Service', value: _service ?? '-'),
        _ConfirmRow(
            label: 'Date',
            value:
                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
        _ConfirmRow(label: 'Time', value: _selectedSlot ?? '-'),
        _ConfirmRow(
            label: 'Patient',
            value: _nameCtrl.text.isNotEmpty ? _nameCtrl.text : '-'),
        _ConfirmRow(
            label: 'Phone',
            value: _phoneCtrl.text.isNotEmpty ? _phoneCtrl.text : '-'),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _step = 0;
                _service = null;
                _selectedSlot = null;
                _nameCtrl.clear();
                _phoneCtrl.clear();
                _noteCtrl.clear();
              });
              _pageCtrl.forward(from: 0);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _kTeal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Text('Book Another Appointment',
                style: GoogleFonts.nunito(
                    fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ),
      ]),
    );
  }

  Widget _sectionTitle(String t) => Text(t,
      style: GoogleFonts.playfairDisplay(
          fontSize: 20, color: _kDark, fontWeight: FontWeight.w700));
}

// ════════════════════════════════════════════════════════════════
//  Supporting Widgets (unchanged from original)
// ════════════════════════════════════════════════════════════════

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  const _StepIndicator({required this.currentStep});
  static const _labels = ['Service', 'Date & Time', 'Details'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: List.generate(_labels.length * 2 - 1, (i) {
          if (i.isOdd) {
            final stepIdx = i ~/ 2;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 2,
                color: stepIdx < currentStep
                    ? _kTeal
                    : Colors.black.withOpacity(0.1),
              ),
            );
          }
          final idx = i ~/ 2;
          final done = idx < currentStep;
          final active = idx == currentStep;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: done
                  ? _kTeal
                  : active
                      ? _kDark
                      : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                  color: done || active
                      ? Colors.transparent
                      : Colors.black.withOpacity(0.15),
                  width: 1.5),
            ),
            child: Center(
              child: done
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : Text('${idx + 1}',
                      style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: active ? Colors.white : Colors.black38)),
            ),
          );
        }),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ServiceTile(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? _kTeal.withOpacity(0.08) : _kCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected ? _kTeal : Colors.black.withOpacity(0.08),
              width: selected ? 1.5 : 1),
        ),
        child: Row(children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? _kTeal : Colors.transparent,
              border: Border.all(
                  color: selected ? _kTeal : Colors.black.withOpacity(0.2),
                  width: 1.5),
            ),
            child: selected
                ? const Icon(Icons.check, color: Colors.white, size: 12)
                : null,
          ),
          const SizedBox(width: 14),
          Text(label,
              style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? _kTeal : _kDark)),
        ]),
      ),
    );
  }
}

class _DatePicker extends StatelessWidget {
  final DateTime selected;
  final void Function(DateTime) onPick;
  const _DatePicker({required this.selected, required this.onPick});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 14,
        itemBuilder: (_, i) {
          final d = now.add(Duration(days: i + 1));
          final isSelected = selected.day == d.day &&
              selected.month == d.month &&
              selected.year == d.year;
          final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
          return GestureDetector(
            onTap: () => onPick(d),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: isSelected ? _kTeal : _kCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color:
                        isSelected ? _kTeal : Colors.black.withOpacity(0.08)),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(dayNames[d.weekday - 1],
                        style: GoogleFonts.nunito(
                            fontSize: 10,
                            color: isSelected ? Colors.white70 : Colors.black38,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text('${d.day}',
                        style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: isSelected ? Colors.white : _kDark)),
                  ]),
            ),
          );
        },
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TimeChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? _kTeal : _kCard,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: selected ? _kTeal : Colors.black.withOpacity(0.1)),
        ),
        child: Text(label,
            style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : _kDark)),
      ),
    );
  }
}

class _AppointmentSummaryBanner extends StatelessWidget {
  final String service;
  final DateTime date;
  final String slot;
  const _AppointmentSummaryBanner(
      {required this.service, required this.date, required this.slot});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _kTeal.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kTeal.withOpacity(0.3)),
      ),
      child: Wrap(spacing: 24, runSpacing: 8, children: [
        _bannerItem(Icons.medical_services_outlined, service),
        _bannerItem(Icons.calendar_today_outlined,
            '${date.day}/${date.month}/${date.year}'),
        _bannerItem(Icons.access_time_rounded, slot),
      ]),
    );
  }

  Widget _bannerItem(IconData icon, String text) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: _kTeal, size: 16),
      const SizedBox(width: 6),
      Text(text,
          style: GoogleFonts.nunito(
              fontSize: 13, color: _kDark, fontWeight: FontWeight.w600)),
    ]);
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType? keyboard;
  final int? maxLines;
  final String? Function(String?)? validator;

  const _FormField({
    required this.label,
    required this.icon,
    required this.controller,
    this.keyboard,
    this.maxLines,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: maxLines ?? 1,
      validator: validator,
      style: GoogleFonts.nunito(color: _kDark, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.nunito(fontSize: 13, color: Colors.black38),
        prefixIcon: Icon(icon, size: 18, color: Colors.black38),
        filled: true,
        fillColor: _kCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _kTeal, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final bool loading;
  final VoidCallback onTap;

  const _NextButton({
    required this.label,
    required this.enabled,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: enabled ? _kTeal : Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : Text(label,
                  style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: enabled ? Colors.white : Colors.black26)),
        ),
      ),
    );
  }
}

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
          border: Border.all(color: Colors.black.withOpacity(0.1)),
        ),
        child:
            const Icon(Icons.arrow_back_ios_rounded, size: 16, color: _kDark),
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  final String label, value;
  const _ConfirmRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.nunito(
                  color: Colors.black38,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          Text(value,
              style: GoogleFonts.nunito(
                  color: _kDark, fontSize: 14, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
