import 'package:booker_front/presentation/screens/edit_booking/edit_booking_screen.dart';
import 'package:go_router/go_router.dart';

import '../screens/booking/booking_screen.dart';
import '../screens/booking_calendar/booking_calendar_screen.dart';
import '../screens/booking_confirmation/booking_confirmation_screen.dart';
import '../screens/booking_detail/booking_detail_screen.dart';
import '../screens/booking_entity/booking_entity_screen.dart';
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
        final extra = state.extra as Map<String, dynamic>?;

        return EditBookingScreen(
          bookingID: id,
          bookingEntityId: extra?['bookingEntityId'] as int,
          startDate: extra?['startDate'] as DateTime?,
          endDate: extra?['endDate'] as DateTime?,
          selectedDay:
              extra?['startDate'] as DateTime? ?? DateTime.now(), // если нужно
        );
      },
    ),
    GoRoute(
      path: '/create-booking',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final selectedDay = extra?['selectedDay'] as DateTime?;
        final bookingEntityId = extra?['bookingEntityId'] as int?;
        return CreateBookingScreen(
          selectedDay: selectedDay ?? DateTime.now(),
          bookingEntityId: bookingEntityId ?? 0,
        );
      },
    ),
    GoRoute(
      path: '/booking-confirmation',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return BookingConfirmationScreen(
          selectedDay: extra?['selectedDay'] as DateTime,
          startTime: extra?['startTime'] as DateTime,
          endTime: extra?['endTime'] as DateTime,
          isAllDay: extra?['isAllDay'] as bool,
          bookingEntityId: extra?['bookingEntityId'] as int,
          isEditMode: extra?['isEditMode'] as bool? ?? false,
          bookingId: extra?['bookingId'] as int? ?? 0,
        );
      },
    ),
  ],
);
