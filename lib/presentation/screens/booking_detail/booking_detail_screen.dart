import 'package:booker_front/presentation/screens/booking_entity/bloc/booking_entity_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '././/./data/repositories/booking_repository.dart';
import 'bloc/booking_detail_bloc.dart';
import 'widgets/booking_edit_slider.dart';

class BookingDetailScreen extends StatelessWidget {
  final int bookingId;

  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingDetailBloc(BookingRepository(), bookingId)
        ..add(BookingDetailLoaded()),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => context.pop(),
          ),
          title: const Text('Детали бронирования',
              style: TextStyle(color: Colors.black87)),
          backgroundColor: Colors.white,
        ),
        body: BlocListener<BookingDetailBloc, BookingDetailState>(
          listener: (context, state) {
            if (state is BookingDetailSuccess) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(content: Text('Бронирование удалено')),
              // );
              // // context.pop();
            }
          },
          child: BlocBuilder<BookingDetailBloc, BookingDetailState>(
            builder: (context, state) {
              if (state is BookingDetailLoading) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.blue));
              }
              if (state is BookingDetailSuccess) {
                DateTime localStartTime = state.bookingInfo.startTime.toLocal();
                DateTime localEndTime = state.bookingInfo.endTime.toLocal();

                // Форматирование времени в HH:mm
                DateFormat formatter = DateFormat('HH:mm');
                String formattedStartTime = formatter.format(localStartTime);
                String formattedEndTime = formatter.format(localEndTime);
                final bookingEntityBloc = context.read<BookingEntityBloc>();
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${state.bookingInfo.id}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text('User ID: ${state.bookingInfo.userId}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text(
                          'Название объекта: ${bookingEntityBloc.state is BookingEntityLoaded ? (bookingEntityBloc.state as BookingEntityLoaded).entities.firstWhere((e) => e.id == state.bookingInfo.bookingEntity).name ?? 'Неизвестно' : 'Загрузка...'}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text('Время начала: $formattedStartTime',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text('Время окончания: $formattedEndTime',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text('Статус: ${state.bookingInfo.status}',
                          style: const TextStyle(fontSize: 18)),
                      const Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.edit,
                              color: Colors.blue, size: 30),
                          onPressed: () {
                            showModalBottomSheet<bool>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              builder: (context) {
                                final bookingEntityId =
                                    state.bookingInfo.bookingEntity;
                                return BookingEditSlider(
                                  bookingId: bookingId,
                                  startDate: state.bookingInfo.startTime,
                                  endDate: state.bookingInfo.endTime,
                                  bookingEntityId: bookingEntityId,
                                );
                              },
                            ).then((value) {
                              // После закрытия слайдера проверяем, было ли выбрано удаление
                              if (value == true) {
                                context
                                    .read<BookingDetailBloc>()
                                    .add(DeleteBooking(bookingId));
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (state is BookingDetailError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 50, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Ошибка: ${state.message}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        onPressed: () => context.pop(),
                        child: const Text('Назад',
                            style: TextStyle(color: Colors.white)),
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
