import 'package:dio/dio.dart';
import '../models/booking_models.dart';
import '../network/dio_client.dart';

class BookingRepository {
  final DioClient _dioClient = DioClient();

  Future<BookingTypeList> fetchBookingTypes() async {
    final response = await _dioClient.get('/bookingsType');
    if (response.statusCode == 200) {
      return BookingTypeList.fromJson(response.data);
    } else {
      throw Exception('Ошибка сервера: ${response.statusCode}');
    }
  }
}