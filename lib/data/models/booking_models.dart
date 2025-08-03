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