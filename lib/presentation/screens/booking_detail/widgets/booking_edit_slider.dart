import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '././../../edit_booking/edit_booking_screen.dart';


class BookingEditSlider extends StatelessWidget {
  final int bookingId;

  const BookingEditSlider({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Действия',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              Navigator.pop(context); // Закрываем слайдер
              context.push('/edit-booking/$bookingId');
            },
            child: const Text('Изменить', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context); // Закрываем слайдер
              // Событие будет отправлено из BookingDetailScreen
              Navigator.pop(context); // Возвращаемся на экран детализации
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}