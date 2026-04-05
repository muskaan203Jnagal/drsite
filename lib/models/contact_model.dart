// ================================================================
//  models/contact_model.dart
// ================================================================

import 'package:cloud_firestore/cloud_firestore.dart';

enum ContactStatus { unread, read, replied }

class ContactModel {
  final String? id;
  final String patientName;
  final String patientPhone;
  final String patientEmail;
  final String service;
  final String message;
  final ContactStatus status;
  final DateTime createdAt;

  ContactModel({
    this.id,
    required this.patientName,
    required this.patientPhone,
    required this.patientEmail,
    required this.service,
    required this.message,
    this.status = ContactStatus.unread,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // ── Firestore → Model ─────────────────────────────────────────
  factory ContactModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return ContactModel(
      id: doc.id,
      patientName: d['patientName'] ?? '',
      patientPhone: d['patientPhone'] ?? '',
      patientEmail: d['patientEmail'] ?? '',
      service: d['service'] ?? '',
      message: d['message'] ?? '',
      status: ContactStatus.values.firstWhere(
        (e) => e.name == (d['status'] ?? 'unread'),
        orElse: () => ContactStatus.unread,
      ),
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // ── Model → Firestore ─────────────────────────────────────────
  Map<String, dynamic> toMap() => {
        'patientName': patientName,
        'patientPhone': patientPhone,
        'patientEmail': patientEmail,
        'service': service,
        'message': message,
        'status': status.name,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  ContactModel copyWith({ContactStatus? status}) => ContactModel(
        id: id,
        patientName: patientName,
        patientPhone: patientPhone,
        patientEmail: patientEmail,
        service: service,
        message: message,
        status: status ?? this.status,
        createdAt: createdAt,
      );
}
