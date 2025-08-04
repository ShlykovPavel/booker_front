import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorScreen({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 50, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Что-то пошло не так: $message',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: onRetry,
            child: const Text('Попробовать снова', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}