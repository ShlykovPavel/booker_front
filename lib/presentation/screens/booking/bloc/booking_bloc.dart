import 'package:flutter_bloc/flutter_bloc.dart';
import '././/./data/repositories/booking_repository.dart';
import '././/./data/models/booking_models.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final BookingTypeList data;

  BookingLoaded(this.data);
}

class BookingError extends BookingState {
  final String message;

  BookingError(this.message);
}

abstract class BookingEvent {}

class FetchBookingTypes extends BookingEvent {}

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository _repository;

  BookingBloc(this._repository) : super(BookingInitial()) {
    on<FetchBookingTypes>((event, emit) async {
      emit(BookingLoading());
      try {
        final data = await _repository.fetchBookingTypes();
        emit(BookingLoaded(data));
      } catch (e) {
        emit(BookingError('Ошибка: $e'));
      }
    });
  }
}