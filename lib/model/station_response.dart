import 'arrival.dart';
import 'station.dart';

class StationResponse {
  final StationInfo station;
  final Map<String, Map<String, List<Arrival>>> arrivalsByDirection;

  StationResponse({required this.station, required this.arrivalsByDirection});

  factory StationResponse.fromJson(Map<String, dynamic> json) {
    var stationInfo = StationInfo.fromJson(json['station']);

    Map<String, Map<String, List<Arrival>>> arrivalsByLineAndDirection = {};

    json['arrivals'].forEach((lineId, arrivalsList) {
      Map<String, List<Arrival>> groupedArrivals = {};

      for (var arrivalJson in arrivalsList) {
        Arrival arrival = Arrival.fromJson(arrivalJson);
        groupedArrivals.putIfAbsent(arrival.direction, () => []).add(arrival);
      }

      groupedArrivals.forEach((direction, arrivals) {
        arrivals.sort((a, b) => a.timeToStation.compareTo(b.timeToStation));
        groupedArrivals[direction] = arrivals.take(2).toList(); // Keep only next 2 arrivals
      });

      arrivalsByLineAndDirection[lineId] = groupedArrivals;
    });

    return StationResponse(station: stationInfo, arrivalsByDirection: arrivalsByLineAndDirection);
  }
}

