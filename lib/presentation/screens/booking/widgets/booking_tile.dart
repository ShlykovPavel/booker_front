import 'package:flutter/material.dart';
import '././/data/models/booking_models.dart';

class BookingTile extends StatelessWidget {
  final BookingTypeInfoList booking;

  const BookingTile({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.bookmark_border),
        title: Text(booking.name),
        subtitle: Text(booking.description),
        onTap: () {
          // Логика при нажатии (добавить позже)
        },
      ),
    );
  }
}