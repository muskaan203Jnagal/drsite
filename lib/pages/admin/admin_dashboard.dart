// ================================================================
//  pages/admin/admin_dashboard.dart
//  Full Admin Dashboard — Bookings + Contacts + Stats
//  Palette: Deep Green #0A2E2A · Teal #5EEAD4
// ================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../models/booking_model.dart';
import '../../models/contact_model.dart';

// ── Palette ───────────────────────────────────────────────────────
const _kDark = Color(0xFF0A2E2A);
const _kCard = Color(0xFF0F3D36);
const _kCardLight = Color(0xFF143D37);
const _kTeal = Color(0xFF5EEAD4);
const _kTealDim = Color(0xFF0D9E8C);
const _kBorder = Color(0xFF1E5248);

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});
  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  final _fs = FirestoreService.instance;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    await AuthService.instance.logout();
    if (mounted) context.go('/admin/login');
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 900;

    return Scaffold(
      backgroundColor: _kDark,
      body: Column(
        children: [
          // ── Top AppBar ───────────────────────────────────────
          _buildAppBar(isWide),

          // ── Stats Row ────────────────────────────────────────
          FutureBuilder<Map<String, int>>(
            future: _fs.getDashboardStats(),
            builder: (ctx, snap) {
              final stats = snap.data ?? {};
              return _StatsRow(stats: stats);
            },
          ),

          // ── Tab Bar ──────────────────────────────────────────
          Container(
            color: _kCard,
            child: TabBar(
              controller: _tab,
              indicatorColor: _kTeal,
              labelColor: _kTeal,
              unselectedLabelColor: Colors.white38,
              labelStyle:
                  GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700),
              tabs: const [
                Tab(icon: Icon(Icons.calendar_month_rounded), text: 'Bookings'),
                Tab(icon: Icon(Icons.message_rounded), text: 'Messages'),
              ],
            ),
          ),

          // ── Tab Content ──────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _BookingsTab(fs: _fs),
                _ContactsTab(fs: _fs),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(bool isWide) {
    return Container(
      height: 68,
      padding: EdgeInsets.symmetric(horizontal: isWide ? 40 : 20),
      decoration: const BoxDecoration(
        color: _kCard,
        border: Border(bottom: BorderSide(color: _kBorder)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _kTeal.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.admin_panel_settings_rounded,
                color: _kTeal, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Glowora Admin",
                  style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700)),
              Text("Dr. Ravinder's Clinic",
                  style:
                      GoogleFonts.nunito(color: Colors.white38, fontSize: 12)),
            ],
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout_rounded,
                size: 16, color: Colors.white38),
            label: Text('Logout',
                style: GoogleFonts.nunito(color: Colors.white38, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  Stats Row
// ════════════════════════════════════════════════════════════════
class _StatsRow extends StatelessWidget {
  final Map<String, int> stats;
  const _StatsRow({required this.stats});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      color: _kDark,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _StatCard(
              label: 'Total Bookings',
              value: '${stats['total_bookings'] ?? 0}',
              icon: Icons.calendar_today_rounded,
              color: _kTeal),
          _StatCard(
              label: 'Pending',
              value: '${stats['pending_bookings'] ?? 0}',
              icon: Icons.pending_actions_rounded,
              color: const Color(0xFFFBBF24)),
          _StatCard(
              label: 'Confirmed',
              value: '${stats['confirmed_bookings'] ?? 0}',
              icon: Icons.check_circle_rounded,
              color: const Color(0xFF34D399)),
          _StatCard(
              label: 'Unread Messages',
              value: '${stats['unread_contacts'] ?? 0}',
              icon: Icons.mark_unread_chat_alt_rounded,
              color: const Color(0xFFF87171)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _StatCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800)),
              Text(label,
                  style:
                      GoogleFonts.nunito(color: Colors.white38, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  Bookings Tab
// ════════════════════════════════════════════════════════════════
class _BookingsTab extends StatelessWidget {
  final FirestoreService fs;
  const _BookingsTab({required this.fs});

  Color _statusColor(BookingStatus s) => switch (s) {
        BookingStatus.pending => const Color(0xFFFBBF24),
        BookingStatus.confirmed => const Color(0xFF34D399),
        BookingStatus.cancelled => const Color(0xFFF87171),
        BookingStatus.completed => _kTeal,
      };

  String _statusLabel(BookingStatus s) => switch (s) {
        BookingStatus.pending => 'Pending',
        BookingStatus.confirmed => 'Confirmed',
        BookingStatus.cancelled => 'Cancelled',
        BookingStatus.completed => 'Completed',
      };

  void _showStatusMenu(BuildContext ctx, BookingModel b) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: _kCard,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Update Status',
                style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text('${b.patientName} — ${b.service}',
                style: GoogleFonts.nunito(color: Colors.white38, fontSize: 13)),
            const SizedBox(height: 20),
            for (final status in BookingStatus.values)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      color: _statusColor(status), shape: BoxShape.circle),
                ),
                title: Text(_statusLabel(status),
                    style: GoogleFonts.nunito(
                        color: b.status == status ? _kTeal : Colors.white70,
                        fontWeight: b.status == status
                            ? FontWeight.w700
                            : FontWeight.w500)),
                trailing: b.status == status
                    ? const Icon(Icons.check, color: _kTeal, size: 18)
                    : null,
                onTap: () {
                  Navigator.pop(ctx);
                  fs.updateBookingStatus(b.id!, status);
                },
              ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  fs.deleteBooking(b.id!);
                },
                icon: const Icon(Icons.delete_outline,
                    size: 16, color: Color(0xFFF87171)),
                label: Text('Delete Record',
                    style: GoogleFonts.nunito(
                        color: const Color(0xFFF87171), fontSize: 13)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFF87171), width: 0.8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BookingModel>>(
      stream: fs.streamBookings(),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: _kTeal, strokeWidth: 2));
        }
        final bookings = snap.data ?? [];
        if (bookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_today_rounded,
                    color: Colors.white12, size: 60),
                const SizedBox(height: 16),
                Text('Koi booking nahi abhi tak',
                    style: GoogleFonts.nunito(
                        color: Colors.white38, fontSize: 16)),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: bookings.length,
          itemBuilder: (ctx, i) {
            final b = bookings[i];
            final color = _statusColor(b.status);
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: _kCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withOpacity(0.25)),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                leading: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.person_rounded, color: color, size: 22),
                ),
                title: Text(b.patientName,
                    style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                        '${b.service}  •  ${b.formattedDate}  •  ${b.timeSlot}',
                        style: GoogleFonts.nunito(
                            color: Colors.white54, fontSize: 12.5)),
                    const SizedBox(height: 2),
                    Text(b.patientPhone,
                        style: GoogleFonts.nunito(
                            color: Colors.white38, fontSize: 12)),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: color.withOpacity(0.4), width: 0.8),
                      ),
                      child: Text(_statusLabel(b.status),
                          style: GoogleFonts.nunito(
                              color: color,
                              fontSize: 11,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 6),
                    Text(DateFormat('dd MMM').format(b.createdAt),
                        style: GoogleFonts.nunito(
                            color: Colors.white24, fontSize: 11)),
                  ],
                ),
                onTap: () => _showStatusMenu(ctx, b),
              ),
            );
          },
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  Contacts Tab
// ════════════════════════════════════════════════════════════════
class _ContactsTab extends StatelessWidget {
  final FirestoreService fs;
  const _ContactsTab({required this.fs});

  Color _statusColor(ContactStatus s) => switch (s) {
        ContactStatus.unread => const Color(0xFFF87171),
        ContactStatus.read => const Color(0xFFFBBF24),
        ContactStatus.replied => const Color(0xFF34D399),
      };

  String _statusLabel(ContactStatus s) => switch (s) {
        ContactStatus.unread => 'Unread',
        ContactStatus.read => 'Read',
        ContactStatus.replied => 'Replied',
      };

  void _showDetail(BuildContext ctx, ContactModel c) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: _kCard,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        builder: (_, scrollCtrl) => SingleChildScrollView(
          controller: scrollCtrl,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(c.patientName,
                        style: GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700)),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor(c.status).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(_statusLabel(c.status),
                        style: GoogleFonts.nunito(
                            color: _statusColor(c.status),
                            fontSize: 11,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _detailRow(Icons.phone_rounded, c.patientPhone),
              const SizedBox(height: 8),
              _detailRow(Icons.email_outlined, c.patientEmail),
              const SizedBox(height: 8),
              _detailRow(Icons.medical_services_rounded, c.service),
              const SizedBox(height: 20),
              Text('Message',
                  style: GoogleFonts.nunito(
                      color: Colors.white38,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8)),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(c.message,
                    style: GoogleFonts.nunito(
                        color: Colors.white70, fontSize: 14, height: 1.6)),
              ),
              const SizedBox(height: 24),
              Text('Update Status',
                  style: GoogleFonts.nunito(
                      color: Colors.white38,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8)),
              const SizedBox(height: 12),
              Row(
                children: [
                  for (final s in ContactStatus.values)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            fs.updateContactStatus(c.id!, s);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _statusColor(s),
                            side: BorderSide(
                                color: _statusColor(s)
                                    .withOpacity(c.status == s ? 1 : 0.4),
                                width: c.status == s ? 1.5 : 0.8),
                            backgroundColor: c.status == s
                                ? _statusColor(s).withOpacity(0.12)
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: Text(_statusLabel(s),
                              style: GoogleFonts.nunito(
                                  fontSize: 12, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    fs.deleteContact(c.id!);
                  },
                  icon: const Icon(Icons.delete_outline,
                      size: 16, color: Color(0xFFF87171)),
                  label: Text('Delete Message',
                      style: GoogleFonts.nunito(
                          color: const Color(0xFFF87171), fontSize: 13)),
                  style: OutlinedButton.styleFrom(
                    side:
                        const BorderSide(color: Color(0xFFF87171), width: 0.8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // Mark as read on open
    if (c.status == ContactStatus.unread) {
      fs.updateContactStatus(c.id!, ContactStatus.read);
    }
  }

  Widget _detailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white38, size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text,
              style: GoogleFonts.nunito(color: Colors.white60, fontSize: 13.5)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ContactModel>>(
      stream: fs.streamContacts(),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: _kTeal, strokeWidth: 2));
        }
        final contacts = snap.data ?? [];
        if (contacts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.message_rounded,
                    color: Colors.white12, size: 60),
                const SizedBox(height: 16),
                Text('Koi message nahi abhi tak',
                    style: GoogleFonts.nunito(
                        color: Colors.white38, fontSize: 16)),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: contacts.length,
          itemBuilder: (ctx, i) {
            final c = contacts[i];
            final color = _statusColor(c.status);
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: _kCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withOpacity(0.25)),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                leading: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.person_rounded, color: color, size: 22),
                ),
                title: Text(c.patientName,
                    style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: c.status == ContactStatus.unread
                            ? FontWeight.w800
                            : FontWeight.w600)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(c.service,
                        style: GoogleFonts.nunito(
                            color: Colors.white54, fontSize: 12.5)),
                    const SizedBox(height: 2),
                    Text(
                        c.message.length > 60
                            ? '${c.message.substring(0, 60)}...'
                            : c.message,
                        style: GoogleFonts.nunito(
                            color: Colors.white38, fontSize: 12)),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: color.withOpacity(0.4), width: 0.8),
                      ),
                      child: Text(_statusLabel(c.status),
                          style: GoogleFonts.nunito(
                              color: color,
                              fontSize: 11,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 6),
                    Text(DateFormat('dd MMM').format(c.createdAt),
                        style: GoogleFonts.nunito(
                            color: Colors.white24, fontSize: 11)),
                  ],
                ),
                onTap: () => _showDetail(ctx, c),
              ),
            );
          },
        );
      },
    );
  }
}
