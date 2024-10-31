import 'line.dart';

class StationInfo {
  final String naptanId;
  final String name;
  final double latitude;
  final double longitude;
  final List<Line> lines;

  StationInfo({
    required this.naptanId,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.lines,
  });

  factory StationInfo.fromJson(Map<String, dynamic> json) {
    var linesList = (json['lines'] as List).map((line) => Line.fromJson(line)).toList();
    return StationInfo(
      naptanId: json['naptan_id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      lines: linesList,
    );
  }
}
