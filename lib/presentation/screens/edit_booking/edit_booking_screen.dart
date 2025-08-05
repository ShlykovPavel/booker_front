import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EditBookingScreen extends StatefulWidget {
  final DateTime selectedDay;
  final DateTime? startDate;
  final DateTime? endDate;
  final int bookingEntityId;

  const EditBookingScreen(
      {super.key,
      required this.selectedDay,
      required this.bookingEntityId,
      this.startDate,
      this.endDate});

  @override
  State<EditBookingScreen> createState() => _EditBookingScreenState();
}

class _EditBookingScreenState extends State<EditBookingScreen> {
  late DateTime _startTime;
  late DateTime _endTime;
  bool _isAllDay = false;
  late DateTime _selectedPickerTime;

  @override
  void initState() {
    super.initState();
    _startTime = widget.startDate ??
        DateTime(widget.selectedDay.year, widget.selectedDay.month,
            widget.selectedDay.day, 9);
    _endTime = widget.endDate ??
        DateTime(widget.selectedDay.year, widget.selectedDay.month,
            widget.selectedDay.day, 17);
    _selectedPickerTime = _startTime;
  }

  Future<void> _selectStartTime() async {
    if (!_isAllDay) {
      final TimeOfDay initialTime = TimeOfDay.fromDateTime(_startTime);
      final picked = await showCupertinoDialog<TimeOfDay>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return _buildTimePickerDialog(initialTime, 'Выберите время начала');
        },
      );
      if (picked != null) {
        setState(() {
          _startTime = DateTime(
              widget.selectedDay.year,
              widget.selectedDay.month,
              widget.selectedDay.day,
              picked.hour,
              picked.minute);
        });
        _updateButtonState();
      }
    }
  }

  Future<void> _selectEndTime() async {
    if (!_isAllDay) {
      final TimeOfDay initialTime = TimeOfDay.fromDateTime(_endTime);
      final picked = await showCupertinoDialog<TimeOfDay>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return _buildTimePickerDialog(
              initialTime, 'Выберите время окончания');
        },
      );
      if (picked != null) {
        setState(() {
          _endTime = DateTime(widget.selectedDay.year, widget.selectedDay.month,
              widget.selectedDay.day, picked.hour, picked.minute);
        });
        _updateButtonState();
      }
    }
  }

  Widget _buildTimePickerDialog(TimeOfDay initialTime, String title) {
    DateTime selectedDateTime = DateTime(
        widget.selectedDay.year,
        widget.selectedDay.month,
        widget.selectedDay.day,
        initialTime.hour,
        initialTime.minute);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: selectedDateTime,
                onDateTimeChanged: (DateTime newDateTime) {
                  selectedDateTime = newDateTime;
                },
                use24hFormat: true,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Отмена',
                      style: TextStyle(color: Colors.blue)),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    final selectedTime =
                        TimeOfDay.fromDateTime(selectedDateTime);
                    Navigator.pop(context, selectedTime);
                  },
                  child: const Text('Готово',
                      style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _toggleAllDay(bool value) {
    setState(() {
      _isAllDay = value;
      if (_isAllDay) {
        _startTime = DateTime(widget.selectedDay.year, widget.selectedDay.month,
            widget.selectedDay.day, 0, 0);
        _endTime = DateTime(widget.selectedDay.year, widget.selectedDay.month,
            widget.selectedDay.day, 23, 59);
      }
      _updateButtonState();
    });
  }

  void _updateButtonState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final startDate = _startTime.toLocal();
    final endDate = _endTime.toLocal();
    var checkisAfter = endDate.isAfter(startDate);

    final isButtonEnabled = _isAllDay || checkisAfter;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Редактировать бронирование',
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
                          DateFormat('HH:mm').format(startDate),
                          style:
                              TextStyle(color: _isAllDay ? Colors.grey : null),
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
                          DateFormat('HH:mm').format(endDate),
                          style:
                              TextStyle(color: _isAllDay ? Colors.grey : null),
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
                onPressed: isButtonEnabled
                    ? () {
                        context.push(
                          '/booking-confirmation',
                          extra: {
                            'selectedDay': widget.selectedDay,
                            'startTime': _startTime,
                            'endTime': _endTime,
                            'isAllDay': _isAllDay,
                            'bookingEntityId': widget.bookingEntityId,
                            'isEditMode': true,
                          },
                        );
                      }
                    : null,
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



// class EditBookingScreen extends StatelessWidget {
//   final int bookingId;

//   const EditBookingScreen({super.key, required this.bookingId});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => EditBookingBloc(BookingRepository(), bookingId)
//         ..add(LoadEditBooking()), // Используем новое событие
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.black87),
//             onPressed: () => context.pop(),
//           ),
//           title: const Text('Изменить бронирование', style: TextStyle(color: Colors.black87)),
//           backgroundColor: Colors.white,
//         ),
//         body: BlocListener<EditBookingBloc, EditBookingState>(
//           listener: (context, state) {
//             if (state is EditBookingLoaded) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Бронирование успешно изменено')),
//               );
//               context.pop();
//             }
//           },
//           child: BlocBuilder<EditBookingBloc, EditBookingState>(
//             builder: (context, state) {
//               if (state is EditBookingLoading) {
//                 return const Center(child: CircularProgressIndicator(color: Colors.blue));
//               }
//               if (state is EditBookingLoaded) {
//                 return Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('Выберите новое время:', style: TextStyle(fontSize: 18)),
//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text('Начало:', style: TextStyle(fontSize: 16)),
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     border: Border.all(color: Colors.blue),
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: CupertinoDatePicker(
//                                     mode: CupertinoDatePickerMode.time,
//                                     initialDateTime: state.startTime,
//                                     onDateTimeChanged: (DateTime newTime) {
//                                       context.read<EditBookingBloc>().add(UpdateStartTime(newTime));
//                                     },
//                                     use24hFormat: true,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text('Конец:', style: TextStyle(fontSize: 16)),
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     border: Border.all(color: Colors.blue),
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: CupertinoDatePicker(
//                                     mode: CupertinoDatePickerMode.time,
//                                     initialDateTime: state.endTime,
//                                     onDateTimeChanged: (DateTime newTime) {
//                                       context.read<EditBookingBloc>().add(UpdateEndTime(newTime));
//                                     },
//                                     use24hFormat: true,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const Spacer(),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                         onPressed: () {
//                           context.read<EditBookingBloc>().add(SaveBooking());
//                         },
//                         child: const Text('Сохранить', style: TextStyle(color: Colors.white)),
//                       ),
//                     ],
//                   ),
//                 );
//               }
//               if (state is EditBookingError) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(Icons.error, size: 50, color: Colors.red),
//                       const SizedBox(height: 16),
//                       Text('Ошибка: ${state.message}', style: const TextStyle(fontSize: 18)),
//                       const SizedBox(height: 16),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                         onPressed: () => context.pop(),
//                         child: const Text('Назад', style: TextStyle(color: Colors.white)),
//                       ),
//                     ],
//                   ),
//                 );
//               }
//               return const SizedBox.shrink();
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }