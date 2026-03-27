import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'layout/app_layout.dart';
import 'pages/home.dart';
import 'pages/about.dart';
import 'sections/services.dart';
import 'pages/contact.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => AppLayout(
        currentRoute: '/',
        child: const HomePage(),
      ),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => AppLayout(
        currentRoute: '/about',
        child: const AboutPage(),
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
  ],
);
