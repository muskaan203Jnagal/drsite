// ================================================================
//  services/firestore_service.dart
//  All Firestore read / write / update operations
// ================================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking_model.dart';
import '../models/contact_model.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  final _db = FirebaseFirestore.instance;

  // ── Collection refs ──────────────────────────────────────────
  CollectionReference get _bookings => _db.collection('bookings');
  CollectionReference get _contacts => _db.collection('contacts');

  // ════════════════════════════════════════════════════════════
  //  BOOKINGS
  // ════════════════════════════════════════════════════════════

  /// Save a new booking and return its Firestore document ID
  Future<String> saveBooking(BookingModel booking) async {
    final ref = await _bookings.add(booking.toMap());
    return ref.id;
  }

  /// Stream of all bookings (latest first) — for admin dashboard
  Stream<List<BookingModel>> streamBookings() {
    return _bookings
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => BookingModel.fromDoc(d)).toList());
  }

  /// Update booking status (confirm / cancel / complete)
  Future<void> updateBookingStatus(String id, BookingStatus status) async {
    await _bookings.doc(id).update({'status': status.name});
  }

  /// Delete a booking record
  Future<void> deleteBooking(String id) async {
    await _bookings.doc(id).delete();
  }

  // ════════════════════════════════════════════════════════════
  //  CONTACTS
  // ════════════════════════════════════════════════════════════

  /// Save a new contact message and return its Firestore document ID
  Future<String> saveContact(ContactModel contact) async {
    final ref = await _contacts.add(contact.toMap());
    return ref.id;
  }

  /// Stream of all contact messages (latest first) — for admin dashboard
  Stream<List<ContactModel>> streamContacts() {
    return _contacts
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => ContactModel.fromDoc(d)).toList());
  }

  /// Mark contact message as read / replied
  Future<void> updateContactStatus(String id, ContactStatus status) async {
    await _contacts.doc(id).update({'status': status.name});
  }

  /// Delete a contact message
  Future<void> deleteContact(String id) async {
    await _contacts.doc(id).delete();
  }

  // ════════════════════════════════════════════════════════════
  //  DASHBOARD STATS
  // ════════════════════════════════════════════════════════════

  /// Returns counts for all statuses — used on admin overview cards
  Future<Map<String, int>> getDashboardStats() async {
    final bookingSnap = await _bookings.get();
    final contactSnap = await _contacts.get();

    final bookings =
        bookingSnap.docs.map((d) => BookingModel.fromDoc(d)).toList();
    final contacts =
        contactSnap.docs.map((d) => ContactModel.fromDoc(d)).toList();

    return {
      'total_bookings': bookings.length,
      'pending_bookings':
          bookings.where((b) => b.status == BookingStatus.pending).length,
      'confirmed_bookings':
          bookings.where((b) => b.status == BookingStatus.confirmed).length,
      'total_contacts': contacts.length,
      'unread_contacts':
          contacts.where((c) => c.status == ContactStatus.unread).length,
    };
  }
}
