// ================================================================
//  models/booking_model.dart
// ================================================================

import 'package:cloud_firestore/cloud_firestore.dart';

enum BookingStatus { pending, confirmed, cancelled, completed }

class BookingModel {
  final String? id;
  final String patientName;
  final String patientPhone;
  final String category;
  final String service;
  final DateTime date;
  final String timeSlot;
  final String notes;
  final BookingStatus status;
  final DateTime createdAt;

  BookingModel({
    this.id,
    required this.patientName,
    required this.patientPhone,
    required this.category,
    required this.service,
    required this.date,
    required this.timeSlot,
    this.notes = '',
    this.status = BookingStatus.pending,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // ── Firestore → Model ─────────────────────────────────────────
  factory BookingModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return BookingModel(
      id: doc.id,
      patientName: d['patientName'] ?? '',
      patientPhone: d['patientPhone'] ?? '',
      category: d['category'] ?? '',
      service: d['service'] ?? '',
      date: (d['date'] as Timestamp).toDate(),
      timeSlot: d['timeSlot'] ?? '',
      notes: d['notes'] ?? '',
      status: BookingStatus.values.firstWhere(
        (e) => e.name == (d['status'] ?? 'pending'),
        orElse: () => BookingStatus.pending,
      ),
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // ── Model → Firestore ─────────────────────────────────────────
  Map<String, dynamic> toMap() => {
        'patientName': patientName,
        'patientPhone': patientPhone,
        'category': category,
        'service': service,
        'date': Timestamp.fromDate(date),
        'timeSlot': timeSlot,
        'notes': notes,
        'status': status.name,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  // ── Formatted date for display ────────────────────────────────
  String get formattedDate => '${date.day}/${date.month}/${date.year}';

  BookingModel copyWith({BookingStatus? status}) => BookingModel(
        id: id,
        patientName: patientName,
        patientPhone: patientPhone,
        category: category,
        service: service,
        date: date,
        timeSlot: timeSlot,
        notes: notes,
        status: status ?? this.status,
        createdAt: createdAt,
      );
}
