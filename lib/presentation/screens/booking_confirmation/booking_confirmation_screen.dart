import 'package:booker_front/data/models/booking_models.dart';
import 'package:booker_front/data/repositories/booking_repository.dart';
import 'package:booker_front/presentation/screens/booking_calendar/bloc/booking_calendar_bloc.dart';
import 'package:booker_front/presentation/screens/booking_entity/bloc/booking_entity_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final DateTime selectedDay;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAllDay;
  final int bookingEntityId;
  final bool isEditMode;
  final int bookingId;

  const BookingConfirmationScreen({
    super.key,
    required this.selectedDay,
    required this.startTime,
    required this.endTime,
    required this.isAllDay,
    required this.bookingEntityId,
    required this.bookingId,
    this.isEditMode = false,
  });

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  BookingInfo? _bookingInfo;

  Future<void> _confirmBooking() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final bookingRequest = {
        'booking_entity_id': widget.bookingEntityId,
        'start_time': widget.startTime
            .toUtc()
            .toIso8601String()
            .replaceAll('+00:00', 'Z'),
        'end_time':
            widget.endTime.toUtc().toIso8601String().replaceAll('+00:00', 'Z'),
        'status': 'pending',
      };

      final response = await BookingRepository().createBooking(bookingRequest);
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final bookingId = responseData['id'] as int;

        final bookingDetails = await BookingRepository().getBooking(bookingId);
        if (bookingDetails.statusCode == 200) {
          setState(() {
            _bookingInfo = BookingInfo.fromJson(
                bookingDetails.data as Map<String, dynamic>);
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage =
                'Ошибка при получении деталей бронирования: ${bookingDetails.statusCode}';
            _isLoading = false;
          });
        }
      } else if (response.statusCode == 400) {
        final errorData = response.data as Map<String, dynamic>;
        setState(() {
          _errorMessage = errorData['error'] ?? 'Неизвестная ошибка';
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Ошибка сервера: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _editBooking() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final bookingRequest = {
        'booking_entity_id': widget.bookingEntityId,
        'start_time': widget.startTime
            .toUtc()
            .toIso8601String()
            .replaceAll('+00:00', 'Z'),
        'end_time':
            widget.endTime.toUtc().toIso8601String().replaceAll('+00:00', 'Z'),
        'status': 'pending',
      };

      final response = await BookingRepository()
          .updateBooking(widget.bookingId, bookingRequest);
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final bookingId = responseData['id'] as int;

        final bookingDetails = await BookingRepository().getBooking(bookingId);
        if (bookingDetails.statusCode == 200) {
          setState(() {
            _bookingInfo = BookingInfo.fromJson(
                bookingDetails.data as Map<String, dynamic>);
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage =
                'Ошибка при получении деталей бронирования: ${bookingDetails.statusCode}';
            _isLoading = false;
          });
        }
      } else if (response.statusCode == 400) {
        final errorData = response.data as Map<String, dynamic>;
        setState(() {
          _errorMessage = errorData['error'] ?? 'Неизвестная ошибка';
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Ошибка сервера: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.blue)),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Подтверждение бронирования',
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 50, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (_errorMessage == 'Booking not available')
                ElevatedButton(
                  onPressed: () {
                    context.push('/booking/calendar/${widget.bookingEntityId}');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text(
                    'Вернуться к календарю',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              else
                ElevatedButton(
                  onPressed: widget.isEditMode ? _editBooking : _confirmBooking,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text(
                    'Попробовать снова',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    if (_bookingInfo != null) {
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
      final bloc = extra?['bloc'] as BookingCalendarBloc?;

      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Подтверждение бронирования',
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Детали бронирования',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Дата: ${DateFormat('dd.MM.yyyy').format(widget.selectedDay)}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Время: ${widget.isAllDay ? 'Весь день' : '${DateFormat('HH:mm').format(_bookingInfo!.startTime.toLocal())} - ${DateFormat('HH:mm').format(_bookingInfo!.endTime.toLocal())}'}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Статус: ${_bookingInfo!.status}',
                style: const TextStyle(fontSize: 16),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (bloc != null) {
                      bloc.add(LoadBookings(widget.bookingEntityId));
                    }
                    context.push('/booking/calendar/${widget.bookingEntityId}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Вернуться к календарю',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    final bookingEntityBloc = context.read<BookingEntityBloc>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Подтверждение бронирования',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Детали бронирования',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Дата: ${DateFormat('dd.MM.yyyy').format(widget.selectedDay)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Время: ${widget.isAllDay ? 'Весь день' : '${DateFormat('HH:mm').format(widget.startTime)} - ${DateFormat('HH:mm').format(widget.endTime)}'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Название объекта: ${bookingEntityBloc.state is BookingEntityLoaded ? (bookingEntityBloc.state as BookingEntityLoaded).entities.firstWhere((e) => e.id == widget.bookingEntityId).name ?? 'Неизвестно' : 'Загрузка...'}',
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.isEditMode ? _editBooking : _confirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Подтвердить бронирование',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
