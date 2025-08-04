import 'package:flutter/material.dart';
import '././/./data/models/booking_models.dart';
import 'package:flutter/material.dart';



class BookingTile extends StatelessWidget {
  final BookingInfo booking;
  final VoidCallback onTap;

  const BookingTile({super.key, required this.booking, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: ${booking.id}', style: const TextStyle(fontSize: 16)),
              Text('Start: ${booking.startTime.toIso8601String()}', style: const TextStyle(fontSize: 14)),
              Text('End: ${booking.endTime.toIso8601String()}', style: const TextStyle(fontSize: 14)),
              Text('Status: ${booking.status}', style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}