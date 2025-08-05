import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '././/./data/models/booking_models.dart';

class BookingTile extends StatelessWidget {
  final BookingInfo booking;
  final VoidCallback onTap;

  const BookingTile({super.key, required this.booking, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Конвертация времени из UTC в локальное
    DateTime localStartTime = booking.startTime.toLocal();
    DateTime localEndTime = booking.endTime.toLocal();

    // Форматирование времени в HH:mm
    DateFormat formatter = DateFormat('HH:mm');
    String formattedStartTime = formatter.format(localStartTime);
    String formattedEndTime = formatter.format(localEndTime);
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.access_time, size: 32, color: Colors.orange),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${booking.id}',
                      style: const TextStyle(fontSize: 16)),
                  Text('Начало: $formattedStartTime',
                      style: const TextStyle(fontSize: 14)),
                  Text('Конец: $formattedEndTime',
                      style: const TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
