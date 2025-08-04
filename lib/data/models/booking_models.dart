class BookingTypeInfoList {
  final int id;
  final String name;
  final String description;

  BookingTypeInfoList({
    required this.id,
    required this.name,
    required this.description,
  });

  factory BookingTypeInfoList.fromJson(Map<String, dynamic> json) {
    return BookingTypeInfoList(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}

class BookingTypeListMetaData {
  final int page;
  final int limit;
  final int offset;
  final int total;

  BookingTypeListMetaData({
    required this.page,
    required this.limit,
    required this.offset,
    required this.total,
  });

  factory BookingTypeListMetaData.fromJson(Map<String, dynamic> json) {
    return BookingTypeListMetaData(
      page: json['page'],
      limit: json['limit'],
      offset: json['offset'],
      total: json['total'],
    );
  }
}

class BookingTypeList {
  final List<BookingTypeInfoList> bookingTypes;
  final BookingTypeListMetaData meta;

  BookingTypeList({
    required this.bookingTypes,
    required this.meta,
  });

  factory BookingTypeList.fromJson(Map<String, dynamic> json) {
    return BookingTypeList(
      bookingTypes: (json['data'] as List)
          .map((item) => BookingTypeInfoList.fromJson(item))
          .toList(),
      meta: BookingTypeListMetaData.fromJson(json['meta']),
    );
  }
}


class BookingTypeEntitiesResponse {
  final int id;
  final String name;
  final String description;

  BookingTypeEntitiesResponse({
    required this.id,
    required this.name,
    required this.description,
  });

  factory BookingTypeEntitiesResponse.fromJson(Map<String, dynamic> json) {
    return BookingTypeEntitiesResponse(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}


class BookingInfo {
  final int id;
  final int userId;
  final int bookingEntity;
  final DateTime startTime;
  final DateTime endTime;
  final String status;

  BookingInfo({
    required this.id,
    required this.userId,
    required this.bookingEntity,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory BookingInfo.fromJson(Map<String, dynamic> json) {
    return BookingInfo(
      id: json['id'],
      userId: json['user_id'],
      bookingEntity: json['booking_entity'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      status: json['status'],
    );
  }
}

class BookingsListMetaData {
  final int page;
  final int limit;
  final int offset;
  final int total;

  BookingsListMetaData({
    required this.page,
    required this.limit,
    required this.offset,
    required this.total,
  });

  factory BookingsListMetaData.fromJson(Map<String, dynamic> json) {
    return BookingsListMetaData(
      page: json['page'],
      limit: json['limit'],
      offset: json['offset'],
      total: json['total'],
    );
  }
}

class BookingsList {
  final List<BookingInfo> bookings;
  final BookingsListMetaData meta;

  BookingsList({
    required this.bookings,
    required this.meta,
  });

  factory BookingsList.fromJson(Map<String, dynamic> json) {
    return BookingsList(
      bookings: (json['data'] as List)
          .map((item) => BookingInfo.fromJson(item))
          .toList(),
      meta: BookingsListMetaData.fromJson(json['meta']),
    );
  }
}