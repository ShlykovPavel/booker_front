import 'package:flutter/material.dart';
import '././/./data/models/booking_models.dart';

class BookingEntityTile extends StatelessWidget {
  final BookingTypeEntitiesResponse entity;
  final VoidCallback? onTap;

  const BookingEntityTile({super.key, required this.entity, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.home, color: Colors.blue),
        title: Text(entity.name, style: const TextStyle(color: Colors.black87)),
        subtitle: Text(entity.description, style: const TextStyle(color: Colors.black54)),
        onTap: onTap,
      ),
    );
  }
}