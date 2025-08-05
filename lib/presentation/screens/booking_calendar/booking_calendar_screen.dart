import 'package:booker_front/data/repositories/booking_repository.dart';
import 'package:booker_front/presentation/screens/booking_calendar/bloc/booking_calendar_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import 'widgets/booking_tile.dart';

class BookingCalendarScreen extends StatelessWidget {
  final int bookingEntityId;

  const BookingCalendarScreen({super.key, required this.bookingEntityId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingCalendarBloc(BookingRepository())
        ..add(LoadBookings(bookingEntityId)),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Календарь бронирований',
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            BlocBuilder<BookingCalendarBloc, BookingCalendarState>(
              builder: (context, state) {
                if (state is BookingCalendarLoading) {
                  return const Center(
                      child: CircularProgressIndicator(color: Colors.blue));
                }
                if (state is BookingCalendarLoaded) {
                  return TableCalendar(
                    firstDay: DateTime.utc(2023, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: state.focusedDay,
                    calendarFormat: CalendarFormat.month,
                    selectedDayPredicate: (day) {
                      return isSameDay(state.selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      context
                          .read<BookingCalendarBloc>()
                          .add(SelectDay(selectedDay, focusedDay));
                    },
                    onPageChanged: (focusedDay) {
                      context
                          .read<BookingCalendarBloc>()
                          .add(SelectDay(state.selectedDay, focusedDay));
                    },
                    calendarStyle: CalendarStyle(
                      todayTextStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.blue, width: 1.0),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      markerSize: 6.0,
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    eventLoader: (day) {
                      if (state.bookingsList.bookings.isNotEmpty) {
                        final events = state.bookingsList.bookings
                            .where((booking) =>
                                booking.bookingEntity == bookingEntityId &&
                                (isSameDay(day, booking.startTime) ||
                                    isSameDay(day, booking.endTime)))
                            .toList();
                        print('Day: $day, Events: $events');
                        return events;
                      }
                      return [];
                    },
                  );
                }
                if (state is BookingCalendarError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 50, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Ошибка: ${state.message}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          onPressed: () {
                            context
                                .read<BookingCalendarBloc>()
                                .add(LoadBookings(bookingEntityId));
                          },
                          child: const Text(
                            'Попробовать снова',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            Expanded(
              child: BlocBuilder<BookingCalendarBloc, BookingCalendarState>(
                builder: (context, state) {
                  if (state is BookingCalendarLoaded) {
                    final bookingsForDay = state.bookingsList.bookings
                        .where((booking) =>
                            booking.bookingEntity == bookingEntityId &&
                            isSameDay(state.selectedDay, booking.startTime))
                        .toList();
                    if (bookingsForDay.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.info, size: 50, color: Colors.blue),
                            SizedBox(height: 16),
                            Text(
                              'Нет бронирований на этот день',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: bookingsForDay.length,
                      itemBuilder: (context, index) {
                        final booking = bookingsForDay[index];
                        return BookingTile(
                          booking: booking,
                          onTap: () {
                            print(
                                'Tapped booking ID: ${booking.id}'); // Отладка
                            _showBookingDetail(context, booking.id);
                          },
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return BlocBuilder<BookingCalendarBloc, BookingCalendarState>(
              builder: (context, state) {
                DateTime selectedDay = DateTime.now();
                if (state is BookingCalendarLoaded) {
                  selectedDay = state.selectedDay;
                }
                final bloc = context.read<BookingCalendarBloc>();
                return FloatingActionButton(
                  onPressed: () {
                    context.push('/create-booking', extra: {
                      'selectedDay': selectedDay,
                      'bookingEntityId': bookingEntityId,
                      'bloc': bloc, // Передаём Bloc
                    });
                  },
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.add, color: Colors.white),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showBookingDetail(BuildContext context, int bookingId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          const Center(child: CircularProgressIndicator(color: Colors.blue)),
    );
    try {
      final repository = BookingRepository();
      final response = await repository.getBooking(bookingId);
      print(
          'Response status: ${response.statusCode}, Data: ${response.data}'); // Отладка
      if (response.statusCode == 200) {
        Navigator.pop(context);
        context.push('/booking-detail/$bookingId');
      } else {
        Navigator.pop(context);
        _showError(context, 'Ошибка сервера: ${response.statusCode}');
      }
    } catch (e) {
      Navigator.pop(context);
      _showError(context, 'Ошибка: $e');
    }
  }

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ошибка'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
