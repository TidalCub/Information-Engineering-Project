class Line {
  final String id;
  final String lineName;
  final String uri;

  Line({required this.id, required this.lineName, required this.uri});

  factory Line.fromJson(Map<String, dynamic> json) {
    return Line(
      id: json['id'],
      lineName: json['line_name'],
      uri: json['uri'],
    );
  }
}
