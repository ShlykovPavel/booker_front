import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/booking/booking_screen.dart';
import '../screens/booking_entity/booking_entity_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/booking',
  routes: [
    GoRoute(
      path: '/booking',
      builder: (context, state) => const BookingScreen(),
    ),
    GoRoute(
      path: '/booking/entity/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return BookingEntityScreen(bookingTypeId: id);
      },
    ),
  ],
);