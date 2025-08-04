import 'package:flutter_bloc/flutter_bloc.dart';
import '././/./data/repositories/booking_repository.dart';
import '../../../../data/models/booking_models.dart';

abstract class BookingEntityState {}

class BookingEntityInitial extends BookingEntityState {}

class BookingEntityLoading extends BookingEntityState {}

class BookingEntityLoaded extends BookingEntityState {
  final List<BookingTypeEntitiesResponse> entities;

  BookingEntityLoaded(this.entities);
}

class BookingEntityError extends BookingEntityState {
  final String message;

  BookingEntityError(this.message);
}

class BookingEntityEmpty extends BookingEntityState {}

abstract class BookingEntityEvent {}

class FetchBookingEntities extends BookingEntityEvent {
  final int bookingTypeId;

  FetchBookingEntities(this.bookingTypeId);
}

class BookingEntityBloc extends Bloc<BookingEntityEvent, BookingEntityState> {
  final BookingRepository _repository;

  BookingEntityBloc(this._repository) : super(BookingEntityInitial()) {
    on<FetchBookingEntities>((event, emit) async {
      emit(BookingEntityLoading());
      try {
        final entities = await _repository.fetchBookingEntities(event.bookingTypeId);
        if (entities.isEmpty) {
          emit(BookingEntityEmpty());
        } else {
          emit(BookingEntityLoaded(entities));
        }
      } catch (e) {
        emit(BookingEntityError('Ошибка: $e'));
      }
    });
  }
}