import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/booking_models.dart';
import '././/./data/repositories/booking_repository.dart';


abstract class BookingDetailState {}

class BookingDetailInitial extends BookingDetailState {}

class BookingDetailLoading extends BookingDetailState {}

class BookingDetailSuccess extends BookingDetailState {
  final BookingInfo bookingInfo;

  BookingDetailSuccess(this.bookingInfo);
}

class BookingDetailError extends BookingDetailState {
  final String message;

  BookingDetailError(this.message);
}

abstract class BookingDetailEvent {}

class BookingDetailLoaded extends BookingDetailEvent {}

class DeleteBooking extends BookingDetailEvent {
  final int bookingId;

  DeleteBooking(this.bookingId);
}

class BookingDetailBloc extends Bloc<BookingDetailEvent, BookingDetailState> {
  final BookingRepository _repository;
  final int _bookingId;

  BookingDetailBloc(this._repository, this._bookingId) : super(BookingDetailInitial()) {
    on<BookingDetailLoaded>((event, emit) async {
      emit(BookingDetailLoading());
      try {
        final response = await _repository.getBooking(_bookingId);
        if (response.statusCode == 200) {
          emit(BookingDetailSuccess(BookingInfo.fromJson(response.data)));
        } else {
          emit(BookingDetailError('Ошибка сервера: ${response.statusCode}'));
        }
      } catch (e) {
        emit(BookingDetailError('Ошибка: $e'));
      }
    });

    on<DeleteBooking>((event, emit) async {
      emit(BookingDetailLoading());
      try {
        final response = await _repository.deleteBooking(event.bookingId);
        if (response.statusCode == 200) {
          emit(BookingDetailSuccess(BookingInfo(id: 0, userId: 0, bookingEntity: 0, startTime: DateTime.now(), endTime: DateTime.now(), status: ''))); // Пустое состояние после удаления
        } else {
          emit(BookingDetailError('Ошибка сервера: ${response.statusCode}'));
        }
      } catch (e) {
        emit(BookingDetailError('Ошибка: $e'));
      }
    });
  }
}