// ================================================================
//  router.dart  —  GoRouter + Admin route with auth guard
// ================================================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import 'layout/app_layout.dart';
import 'pages/home.dart';
import 'pages/about.dart';
import 'sections/services.dart';
import 'pages/contact.dart';
import 'sections/booking.dart';
import 'pages/admin/admin_login.dart';
import 'pages/admin/admin_dashboard.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  // ── Redirect logic: /admin/* pages require login ─────────────
  redirect: (context, state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final goingToAdmin = state.matchedLocation.startsWith('/admin');
    final goingToLogin = state.matchedLocation == '/admin/login';

    if (goingToAdmin && !goingToLogin && !isLoggedIn) {
      return '/admin/login';
    }
    if (goingToLogin && isLoggedIn) {
      return '/admin/dashboard';
    }
    return null;
  },
  routes: [
    // ── Public routes ─────────────────────────────────────────
    GoRoute(path: '/', redirect: (_, __) => '/home'),

    GoRoute(
      path: '/home',
      builder: (context, state) =>
          AppLayout(currentRoute: '/home', child: const HomePage()),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) =>
          AppLayout(currentRoute: '/about', child: const AboutUsPage()),
    ),
    GoRoute(
      path: '/services',
      builder: (context, state) =>
          AppLayout(currentRoute: '/services', child: const ServicesPage()),
    ),
    GoRoute(
      path: '/contact',
      builder: (context, state) =>
          AppLayout(currentRoute: '/contact', child: const ContactPage()),
    ),
    GoRoute(
      path: '/booking',
      builder: (context, state) =>
          AppLayout(currentRoute: '/booking', child: const BookingPage()),
    ),

    // ── Admin routes (protected) ──────────────────────────────
    GoRoute(
      path: '/admin/login',
      builder: (context, state) => const AdminLoginPage(),
    ),
    GoRoute(
      path: '/admin/dashboard',
      builder: (context, state) => const AdminDashboardPage(),
    ),
  ],
);
