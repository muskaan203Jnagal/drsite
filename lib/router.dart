// ================================================================
//  router.dart — GoRouter config
//  FIX: added '/' redirect + all routes
// ================================================================

import 'package:go_router/go_router.dart';

import 'layout/app_layout.dart';
import 'pages/home.dart';
import 'pages/about.dart';
import 'sections/services.dart';
import 'pages/contact.dart';
import 'sections/booking.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Root redirects to /home
    GoRoute(
      path: '/',
      redirect: (_, __) => '/home',
    ),

    GoRoute(
      path: '/home',
      builder: (context, state) => AppLayout(
        currentRoute: '/home',
        child: const HomePage(),
      ),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => AppLayout(
        currentRoute: '/about',
        child: const AboutUsPage(),
      ),
    ),
    GoRoute(
      path: '/services',
      builder: (context, state) => AppLayout(
        currentRoute: '/services',
        child: const ServicesPage(),
      ),
    ),
    GoRoute(
      path: '/contact',
      builder: (context, state) => AppLayout(
        currentRoute: '/contact',
        child: const ContactPage(),
      ),
    ),
    GoRoute(
      path: '/booking',
      builder: (context, state) => AppLayout(
        currentRoute: '/booking',
        child: const BookingPage(),
      ),
    ),
  ],
);
