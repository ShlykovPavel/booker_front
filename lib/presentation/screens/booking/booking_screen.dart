import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './bloc/booking_bloc.dart';
import 'widgets/booking_tile.dart';
import 'widgets/error_screen.dart';
import '/data/repositories/booking_repository.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingBloc(BookingRepository())..add(FetchBookingTypes()),
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.arrow_back),
          title: const Text('Бронирования'),
        ),
        body: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            if (state is BookingLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BookingLoaded) {
              final bookingTypes = state.data.bookingTypes;
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bookingTypes.length,
                itemBuilder: (context, index) {
                  return BookingTile(booking: bookingTypes[index]);
                },
              );
            } else if (state is BookingError) {
              return ErrorScreen(
                message: state.message,
                onRetry: () {
                  context.read<BookingBloc>().add(FetchBookingTypes());
                },
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