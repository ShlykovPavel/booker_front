import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CreateBookingScreen extends StatefulWidget {
  final DateTime selectedDay;

  const CreateBookingScreen({super.key, required this.selectedDay});

  @override
  State<CreateBookingScreen> createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen> {
  late DateTime _startTime;
  late DateTime _endTime;
  bool _isAllDay = false;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime(widget.selectedDay.year, widget.selectedDay.month, widget.selectedDay.day, 9); // Утро по умолчанию
    _endTime = DateTime(widget.selectedDay.year, widget.selectedDay.month, widget.selectedDay.day, 17); // Вечер по умолчанию
  }

  void _selectStartTime() async {
    if (!_isAllDay) {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_startTime),
      );
      if (picked != null) {
        setState(() {
          _startTime = DateTime(widget.selectedDay.year, widget.selectedDay.month, widget.selectedDay.day, picked.hour, picked.minute);
          _updateButtonState();
        });
      }
    }
  }

  void _selectEndTime() async {
    if (!_isAllDay) {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_endTime),
      );
      if (picked != null) {
        setState(() {
          _endTime = DateTime(widget.selectedDay.year, widget.selectedDay.month, widget.selectedDay.day, picked.hour, picked.minute);
          _updateButtonState();
        });
      }
    }
  }

  void _toggleAllDay(bool value) {
    setState(() {
      _isAllDay = value;
      if (_isAllDay) {
        _startTime = DateTime(widget.selectedDay.year, widget.selectedDay.month, widget.selectedDay.day, 0, 0);
        _endTime = DateTime(widget.selectedDay.year, widget.selectedDay.month, widget.selectedDay.day, 23, 59);
      }
      _updateButtonState();
    });
  }

  void _updateButtonState() {
    // Кнопка активна, если есть время или включён "Весь день"
  }

  @override
  Widget build(BuildContext context) {
    final isButtonEnabled = _isAllDay || (_startTime != null && _endTime != null && _endTime.isAfter(_startTime));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Создать бронирование',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Дата: ${DateFormat('dd.MM.yyyy').format(widget.selectedDay)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Начало', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: _isAllDay ? null : _selectStartTime,
                        child: Text(
                          DateFormat('HH:mm').format(_startTime),
                          style: TextStyle(color: _isAllDay ? Colors.grey : null),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Конец', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: _isAllDay ? null : _selectEndTime,
                        child: Text(
                          DateFormat('HH:mm').format(_endTime),
                          style: TextStyle(color: _isAllDay ? Colors.grey : null),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Весь день', style: TextStyle(fontSize: 16)),
                Switch(
                  value: _isAllDay,
                  onChanged: _toggleAllDay,
                  activeColor: Colors.blue,
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isButtonEnabled ? () {} : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isButtonEnabled ? Colors.blue : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Подтвердить',
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