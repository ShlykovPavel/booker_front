import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ConfirmBookingScreen extends StatelessWidget {
  final DateTime selectedDay;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAllDay;
  final int bookingEntityId;

  const ConfirmBookingScreen({
    super.key,
    required this.selectedDay,
    required this.startTime,
    required this.endTime,
    required this.isAllDay,
    required this.bookingEntityId,
  });

  @override
  Widget build(BuildContext context) {
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
              'Дата: ${DateFormat('dd.MM.yyyy').format(selectedDay)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Время: ${isAllDay ? 'Весь день' : '${DateFormat('HH:mm').format(startTime)} - ${DateFormat('HH:mm').format(endTime)}'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            // Название объекта бронирования (предполагаем, что оно связано с bookingEntityId)
            Text(
              'Объект: ${bookingEntityId.toString()}', // Замени на реальный способ получения имени
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
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