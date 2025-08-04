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
      final List<dynamic> data = response.data;
      return data.map((json) => BookingTypeEntitiesResponse.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка сервера: ${response.statusCode}');
    }
  }

  Future<BookingsList> fetchBookings(int bookingEntityId) async {
    try {
      final response = await _dioClient.get('/bookingsEntity/$bookingEntityId/bookings');
      if (response.statusCode == 200) {
        return BookingsList.fromJson(response.data);
      } else {
        throw Exception('Ошибка сервера: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('Ошибка сети: ${e.message}, Response: ${e.response?.data}');
      }
      throw Exception('Неизвестная ошибка: $e');
    }
  }

  Future<Response> getBooking(int bookingId) async {
    return await _dioClient.get('/bookings/$bookingId');
  }

  Future<Response> updateBooking(int bookingId, Map<String, dynamic> data) async {
    return await _dioClient.put('/bookings/$bookingId', data: data);
  }

  Future<Response> deleteBooking(int bookingId) async {
    return await _dioClient.delete('/bookings/$bookingId');
  }

  Future<Response> createBooking(Map<String, dynamic> bookingRequest) async {
    return await _dioClient.post('/bookings', data: bookingRequest);
  }
}