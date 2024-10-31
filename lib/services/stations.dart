import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/station_response.dart';
class StationFinder {
  final double lat;
  final double lon;

  StationFinder({required this.lat, required this.lon});

  Future<StationResponse> fetchStation() async {
  final String _uri = "https://tfl.leon-skinner.dev/api/v1/stations/live_departures_predictions?lat=${lat}&lon=${lon}";
  print("\n\n\n URI: $_uri \n\n\n");
  final response = await http.get(Uri.parse(_uri));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    return StationResponse.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to load station data');
  }
}

}
