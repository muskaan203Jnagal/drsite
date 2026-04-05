// ================================================================
//  services/email_service.dart
//  EmailJS REST API — sends email notifications to doctor
//  No backend server needed — works directly from Flutter Web
// ================================================================

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/booking_model.dart';
import '../models/contact_model.dart';

// ── EmailJS Config ────────────────────────────────────────────────
// Replace these with your actual EmailJS credentials from emailjs.com
class _EmailConfig {
  static const serviceId = 'YOUR_SERVICE_ID'; // e.g. service_abc123
  static const bookingTemplate = 'booking_notification';
  static const contactTemplate = 'contact_notification';
  static const publicKey = 'YOUR_EMAILJS_PUBLIC_KEY'; // e.g. xxxxxxxxxxx
  static const adminEmail = 'ravinder@glowora.com'; // Doctor ka email
}

class EmailService {
  EmailService._();
  static final instance = EmailService._();

  static const _apiUrl = 'https://api.emailjs.com/api/v1.0/email/send';

  // ── Send booking notification ────────────────────────────────
  Future<bool> sendBookingNotification(BookingModel booking) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service_id': _EmailConfig.serviceId,
          'template_id': _EmailConfig.bookingTemplate,
          'user_id': _EmailConfig.publicKey,
          'template_params': {
            'to_email': _EmailConfig.adminEmail,
            'patient_name': booking.patientName,
            'patient_phone': booking.patientPhone,
            'category': booking.category,
            'service': booking.service,
            'date': booking.formattedDate,
            'time': booking.timeSlot,
            'notes': booking.notes.isEmpty ? 'None' : booking.notes,
          },
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ Booking email sent successfully');
        return true;
      } else {
        debugPrint('❌ Email failed: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Email error: $e');
      return false;
    }
  }

  // ── Send contact notification ────────────────────────────────
  Future<bool> sendContactNotification(ContactModel contact) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service_id': _EmailConfig.serviceId,
          'template_id': _EmailConfig.contactTemplate,
          'user_id': _EmailConfig.publicKey,
          'template_params': {
            'to_email': _EmailConfig.adminEmail,
            'patient_name': contact.patientName,
            'patient_phone': contact.patientPhone,
            'patient_email': contact.patientEmail,
            'service': contact.service,
            'message': contact.message,
          },
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ Contact email sent successfully');
        return true;
      } else {
        debugPrint('❌ Email failed: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Email error: $e');
      return false;
    }
  }
}
