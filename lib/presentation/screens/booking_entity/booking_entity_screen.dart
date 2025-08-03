import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../booking/bloc/booking_bloc.dart';
import 'bloc/booking_entity_bloc.dart';
import 'widgets/booking_entity_tile.dart';
import '././/./data/repositories/booking_repository.dart';

class BookingEntityScreen extends StatelessWidget {
  final int bookingTypeId;

  const BookingEntityScreen({super.key, required this.bookingTypeId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingEntityBloc(BookingRepository())..add(FetchBookingEntities(bookingTypeId)),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(), // Возврат на предыдущий экран
          ),
          title: const Text('Выберите объект', style: TextStyle(color: Colors.black87)),
          backgroundColor: Colors.white,
        ),
        body: BlocBuilder<BookingEntityBloc, BookingEntityState>(
          builder: (context, state) {
            if (state is BookingEntityLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.blue));
            } else if (state is BookingEntityLoaded) {
              final entities = state.entities;
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: entities.length,
                itemBuilder: (context, index) {
                  return BookingEntityTile(entity: entities[index]);
                },
              );
            } else if (state is BookingEntityError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 50, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Что-то пошло не так: ${state.message}',
                        textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      onPressed: () {
                        context.read<BookingEntityBloc>().add(FetchBookingEntities(bookingTypeId));
                      },
                      child: const Text('Попробовать снова', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            } else if (state is BookingEntityEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info, size: 50, color: Colors.blue),
                    SizedBox(height: 16),
                    Text('У данного типа бронирования нет объектов',
                        textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Бронирования'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
          ],
          currentIndex: 1,
          onTap: (index) {
            // Логика навигации (добавить позже)
          },
        ),
      ),
    );
  }
}