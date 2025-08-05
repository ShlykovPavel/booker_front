import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookingEditSlider extends StatelessWidget {
  final int bookingId;
  final DateTime? startDate;
  final DateTime? endDate;
  const BookingEditSlider(
      {super.key, required this.bookingId, this.startDate, this.endDate});

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
              context.push(
                '/edit-booking/$bookingId',
                extra: {
                  'startDate': startDate, // передайте ваши значения
                  'endDate': endDate,
                },
              );
            },
            child:
                const Text('Изменить', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context, true); // Закрываем слайдер
              // Событие будет отправлено из BookingDetailScreen
              Navigator.pop<bool>(
                  context, true); // Возвращаемся на экран детализации
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
