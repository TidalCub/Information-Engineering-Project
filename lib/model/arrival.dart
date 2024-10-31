class Arrival {
  final String destinationName;
  final String destinationNaptanId;
  final String direction;
  final String platform;
  final int timeToStation;
  final DateTime expectedArrival;

  Arrival({
    required this.destinationName,
    required this.destinationNaptanId,
    required this.direction,
    required this.platform,
    required this.timeToStation,
    required this.expectedArrival,
  });

  factory Arrival.fromJson(Map<String, dynamic> json) {
    return Arrival(
      destinationName: json['destination_name'] ?? 'Not Given',
      destinationNaptanId: json['destination_naptan_id'] ?? 'Not Given',
      direction: json['direction'] ?? 'Not Given',
      platform: json['platform'] ?? 'Not Given',
      timeToStation: json['time_to_station'] ?? 'Not Given',
      expectedArrival: DateTime.parse(json['expected_arrival']),
    );
  }
}
