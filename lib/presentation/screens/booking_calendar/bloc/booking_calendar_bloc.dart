import 'package:flutter_bloc/flutter_bloc.dart';
import '././/./data/repositories/booking_repository.dart';
import '../../../../data/models/booking_models.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:intl/intl.dart';

abstract class BookingCalendarState {}

class BookingCalendarInitial extends BookingCalendarState {}

class BookingCalendarLoading extends BookingCalendarState {}

class BookingCalendarLoaded extends BookingCalendarState {
  final BookingsList bookingsList;
  final DateTime selectedDay;
  final DateTime focusedDay;

  BookingCalendarLoaded(this.bookingsList, this.selectedDay, this.focusedDay);
}

class BookingCalendarError extends BookingCalendarState {
  final String message;

  BookingCalendarError(this.message);
}

abstract class BookingCalendarEvent {}

class LoadBookings extends BookingCalendarEvent {
  final int bookingEntityId;

  LoadBookings(this.bookingEntityId);
}

class SelectDay extends BookingCalendarEvent {
  final DateTime selectedDay;
  final DateTime focusedDay;

  SelectDay(this.selectedDay, this.focusedDay);
}

class BookingCalendarBloc extends Bloc<BookingCalendarEvent, BookingCalendarState> {
  final BookingRepository _repository;
  final DateTime _today = DateTime.now();

  BookingCalendarBloc(this._repository) : super(BookingCalendarInitial()) {
    on<LoadBookings>((event, emit) async {
      emit(BookingCalendarLoading());
      try {
        final bookingsList = await _repository.fetchBookings(event.bookingEntityId);
        emit(BookingCalendarLoaded(bookingsList, _today, _today));
      } catch (e) {
        emit(BookingCalendarError('Ошибка: $e'));
      }
    });

    on<SelectDay>((event, emit) {
      if (state is BookingCalendarLoaded) {
        final currentState = state as BookingCalendarLoaded;
        if (!isSameDay(currentState.selectedDay, event.selectedDay) ||
            !isSameDay(currentState.focusedDay, event.focusedDay)) {
          emit(BookingCalendarLoaded(
            currentState.bookingsList,
            event.selectedDay,
            event.focusedDay,
          ));
        }
      } else if (state is BookingCalendarInitial) {
        emit(BookingCalendarLoaded(
          BookingsList(bookings: [], meta: BookingsListMetaData(page: 0, limit: 0, offset: 0, total: 0)),
          event.selectedDay,
          event.focusedDay,
        ));
      }
    });
  }
}