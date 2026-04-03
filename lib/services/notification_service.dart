// ================================================================
//  services/notification_service.dart
//
//  Jab koi booking / contact submit kare:
//    ✅ Doctor ko Email aata hai  (EmailJS)
//    ✅ Doctor ko WhatsApp aata hai  (CallMeBot — free)
//
//  SETUP STEPS (ek baar):
//  ─────────────────────────────────────────────────────────────
//  EMAIL (EmailJS):
//    1. emailjs.com pe free account banao
//    2. "Email Services" → Gmail connect karo
//    3. "Email Templates" → do templates banao:
//         • booking_notification
//         • contact_notification
//       (Template variables neeche likhe hain)
//    4. Account → API Keys → Public Key copy karo
//    5. Neeche _serviceId, _publicKey, _adminEmail fill karo
//
//  WHATSAPP (CallMeBot — free):
//    1. Apne phone se WhatsApp open karo
//    2. Is number ko save karo: +34 644 59 74 90
//    3. Unhe message karo: "I allow callmebot to send me messages"
//    4. Woh tumhe ek API key bhejenge (e.g. 1234567)
//    5. Neeche _waPhone aur _waApiKey fill karo
//
//  EmailJS Template Variables:
//    Booking: {{patient_name}}, {{patient_phone}}, {{category}},
//             {{service}}, {{date}}, {{time}}, {{notes}}
//    Contact: {{patient_name}}, {{patient_phone}}, {{patient_email}},
//             {{service}}, {{message}}
// ================================================================

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/booking_model.dart';
import '../models/contact_model.dart';

// ── ⚙️ CONFIG — Yahan apni details bharo ─────────────────────────
class _Config {
  // EmailJS
  static const serviceId = 'service_f4yvwwb'; // e.g. service_abc123
  static const publicKey = 'wdOoR4hD1NatRrfMw'; // EmailJS Public Key
  static const adminEmail =
      'muskaanjnagal@gmail.com'; // e.g. ravinder@gmail.com
  static const bookingTpl = 'template_cuobk2p'; // Template ID
  static const contactTpl = 'template_jbh76ol'; // Template ID

  // CallMeBot WhatsApp
  static const waPhone = '916239338774'; // (unused — WhatsApp disabled)
  static const waApiKey = 'YOUR_CALLMEBOT_APIKEY'; // (unused)
}
// ─────────────────────────────────────────────────────────────────

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  static const _emailUrl = 'https://api.emailjs.com/api/v1.0/email/send';

  // ════════════════════════════════════════════════════════════
  //  BOOKING NOTIFICATION
  // ════════════════════════════════════════════════════════════
  Future<void> notifyBooking(BookingModel b) async {
    await _sendEmail(
      templateId: _Config.bookingTpl,
      params: {
        'to_email': _Config.adminEmail,
        'patient_name': b.patientName,
        'patient_phone': b.patientPhone,
        'category': b.category,
        'service': b.service,
        'date': b.formattedDate,
        'time': b.timeSlot,
        'notes': b.notes.isEmpty ? 'None' : b.notes,
      },
    );
  }

  // ════════════════════════════════════════════════════════════
  //  CONTACT NOTIFICATION
  // ════════════════════════════════════════════════════════════
  Future<void> notifyContact(ContactModel c) async {
    await _sendEmail(
      templateId: _Config.contactTpl,
      params: {
        'to_email': _Config.adminEmail,
        'patient_name': c.patientName,
        'patient_phone': c.patientPhone,
        'patient_email': c.patientEmail,
        'service': c.service,
        'message': c.message,
      },
    );
  }

  // ════════════════════════════════════════════════════════════
  //  PRIVATE: Send Email via EmailJS
  // ════════════════════════════════════════════════════════════
  Future<void> _sendEmail({
    required String templateId,
    required Map<String, String> params,
  }) async {
    try {
      final res = await http.post(
        Uri.parse(_emailUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service_id': _Config.serviceId,
          'template_id': templateId,
          'user_id': _Config.publicKey,
          'template_params': params,
        }),
      );
      if (res.statusCode == 200) {
        debugPrint('✅ Email sent');
      } else {
        debugPrint('❌ Email failed: ${res.statusCode} ${res.body}');
      }
    } catch (e) {
      debugPrint('❌ Email error: $e');
    }
  }
}
