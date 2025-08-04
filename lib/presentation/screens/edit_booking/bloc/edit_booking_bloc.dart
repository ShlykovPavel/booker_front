import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/booking_models.dart';
import '././/./data/repositories/booking_repository.dart';


abstract class EditBookingState {}

class EditBookingInitial extends EditBookingState {}

class EditBookingLoading extends EditBookingState {}

class EditBookingLoaded extends EditBookingState {
  final DateTime startTime;
  final DateTime endTime;

  EditBookingLoaded(this.startTime, this.endTime);
}

class EditBookingError extends EditBookingState {
  final String message;

  EditBookingError(this.message);
}

abstract class EditBookingEvent {}

class LoadEditBooking extends EditBookingEvent {} // Переименовали событие

class UpdateStartTime extends EditBookingEvent {
  final DateTime startTime;

  UpdateStartTime(this.startTime);
}

class UpdateEndTime extends EditBookingEvent {
  final DateTime endTime;

  UpdateEndTime(this.endTime);
}

class SaveBooking extends EditBookingEvent {}

class EditBookingBloc extends Bloc<EditBookingEvent, EditBookingState> {
  final BookingRepository _repository;
  final int _bookingId;
  late DateTime _startTime;
  late DateTime _endTime;

  EditBookingBloc(this._repository, this._bookingId) : super(EditBookingInitial()) {
    on<LoadEditBooking>((event, emit) async {
      emit(EditBookingLoading());
      try {
        final response = await _repository.getBooking(_bookingId);
        if (response.statusCode == 200) {
          final booking = BookingInfo.fromJson(response.data);
          _startTime = booking.startTime;
          _endTime = booking.endTime;
          emit(EditBookingLoaded(_startTime, _endTime));
        } else {
          emit(EditBookingError('Ошибка сервера: ${response.statusCode}'));
        }
      } catch (e) {
        emit(EditBookingError('Ошибка: $e'));
      }
    });

    on<UpdateStartTime>((event, emit) {
      if (state is EditBookingLoaded) {
        _startTime = DateTime(
          (state as EditBookingLoaded).startTime.year,
          (state as EditBookingLoaded).startTime.month,
          (state as EditBookingLoaded).startTime.day,
          event.startTime.hour,
          event.startTime.minute,
        );
        emit(EditBookingLoaded(_startTime, _endTime));
      }
    });

    on<UpdateEndTime>((event, emit) {
      if (state is EditBookingLoaded) {
        _endTime = DateTime(
          (state as EditBookingLoaded).endTime.year,
          (state as EditBookingLoaded).endTime.month,
          (state as EditBookingLoaded).endTime.day,
          event.endTime.hour,
          event.endTime.minute,
        );
        emit(EditBookingLoaded(_startTime, _endTime));
      }
    });

    on<SaveBooking>((event, emit) async {
      if (state is EditBookingLoaded) {
        emit(EditBookingLoading());
        try {
          final request = {
            'user_id': 0, // Placeholder
            'booking_entity_id': (await _repository.getBooking(_bookingId)).data['booking_entity'],
            'start_time': _startTime.toIso8601String(),
            'end_time': _endTime.toIso8601String(),
            'status': (await _repository.getBooking(_bookingId)).data['status'],
            'company_id': 0, // Placeholder
          };
          final response = await _repository.updateBooking(_bookingId, request);
          if (response.statusCode == 200) {
            emit(EditBookingLoaded(_startTime, _endTime)); // Успешное состояние
          } else {
            emit(EditBookingError('Ошибка сервера: ${response.statusCode}'));
          }
        } catch (e) {
          emit(EditBookingError('Ошибка: $e'));
        }
      }
    });
  }
}