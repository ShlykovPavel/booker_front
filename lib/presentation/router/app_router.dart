import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/booking/booking_screen.dart';
import '../screens/booking_entity/booking_entity_screen.dart';
import '../screens/booking_calendar/booking_calendar_screen.dart';
import '../screens/booking_detail/booking_detail_screen.dart';
import '../screens/edit_booking/edit_booking_screen.dart';
import '../screens/create_booking/create_booking_screen.dart';

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
    GoRoute(
      path: '/booking/calendar/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return BookingCalendarScreen(bookingEntityId: id);
      },
    ),
    GoRoute(
      path: '/booking-detail/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return BookingDetailScreen(bookingId: id);
      },
    ),
    GoRoute(
      path: '/edit-booking/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return EditBookingScreen(bookingId: id);
      },
    ),
    GoRoute(
      path: '/create-booking',
      builder: (context, state) {
        final selectedDay = state.extra as DateTime?;
        return CreateBookingScreen(selectedDay: selectedDay ?? DateTime.now());
      },
    ),
  ],
);