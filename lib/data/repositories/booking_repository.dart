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

  Future<List<BookingTypeEntitiesResponse>> fetchBookingEntities(int bookingTypeId) async {
    final response = await _dioClient.get('/bookingsEntity/$bookingTypeId');
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data; // Предполагаем, что возвращается массив
      return data.map((json) => BookingTypeEntitiesResponse.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка сервера: ${response.statusCode}');
    }
  }
}