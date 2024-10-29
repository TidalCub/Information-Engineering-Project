import 'package:http/http.dart' as http;
import 'dart:convert';

class StationFinder {
  final double lat;
  final double lon;
  final String stopTypes;
  final int radius;

  StationFinder({required this.lat, required this.lon, this.stopTypes = 'NaptanMetroStation', this.radius = 400});

  Future<http.Response> fetchStation() {
    final String _uri = "https://api.tfl.gov.uk/StopPoint/?lat=$lat&lon=$lon&stopTypes=$stopTypes&radius=$radius";
    print("\n\n\n URI: $_uri \n\n\n");
    return http.get(Uri.parse(_uri));
  }

  List<Map<String, dynamic>> parseStation(String responseBody) {
    final data = jsonDecode(responseBody);
    List<Map<String, dynamic>> stations = [];
    for (var item in data['stopPoints']) {
      if (!item['modes'].contains('tube')) continue;
      stations.add({
        'name': item['commonName'],
        'lat': item['lat'],
        'lon': item['lon'],
        'modes': item['modes'],
      });
    }
    return stations;
  }

  Future<List<Map<String, dynamic>>> station() async {
    try {
      final response = await fetchStation();
      if (response.statusCode == 200) {
        return parseStation(response.body);
      } else {
        throw Exception('Failed to load station data');
      }
    } catch (e) {
      throw Exception('Failed to load station data');
    }
  }

  @override
  String toString() {
    return 'StationFinder(lat: $lat, lon: $lon, stopTypes: $stopTypes)';
  }
}