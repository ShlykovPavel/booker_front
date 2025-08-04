import 'package:booker_front/data/repositories/booking_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'bloc/edit_booking_bloc.dart';
// import '././/./data/repositories/booking_repository.dart';


class EditBookingScreen extends StatelessWidget {
  final int bookingId;

  const EditBookingScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditBookingBloc(BookingRepository(), bookingId)
        ..add(LoadEditBooking()), // Используем новое событие
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => context.pop(),
          ),
          title: const Text('Изменить бронирование', style: TextStyle(color: Colors.black87)),
          backgroundColor: Colors.white,
        ),
        body: BlocListener<EditBookingBloc, EditBookingState>(
          listener: (context, state) {
            if (state is EditBookingLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Бронирование успешно изменено')),
              );
              context.pop();
            }
          },
          child: BlocBuilder<EditBookingBloc, EditBookingState>(
            builder: (context, state) {
              if (state is EditBookingLoading) {
                return const Center(child: CircularProgressIndicator(color: Colors.blue));
              }
              if (state is EditBookingLoaded) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Выберите новое время:', style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Начало:', style: TextStyle(fontSize: 16)),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CupertinoDatePicker(
                                    mode: CupertinoDatePickerMode.time,
                                    initialDateTime: state.startTime,
                                    onDateTimeChanged: (DateTime newTime) {
                                      context.read<EditBookingBloc>().add(UpdateStartTime(newTime));
                                    },
                                    use24hFormat: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Конец:', style: TextStyle(fontSize: 16)),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CupertinoDatePicker(
                                    mode: CupertinoDatePickerMode.time,
                                    initialDateTime: state.endTime,
                                    onDateTimeChanged: (DateTime newTime) {
                                      context.read<EditBookingBloc>().add(UpdateEndTime(newTime));
                                    },
                                    use24hFormat: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        onPressed: () {
                          context.read<EditBookingBloc>().add(SaveBooking());
                        },
                        child: const Text('Сохранить', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              }
              if (state is EditBookingError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 50, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Ошибка: ${state.message}', style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        onPressed: () => context.pop(),
                        child: const Text('Назад', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}