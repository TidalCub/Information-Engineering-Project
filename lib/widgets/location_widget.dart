import 'package:flutter/material.dart';
import '../services/location.dart';
import 'package:geolocator/geolocator.dart';
import '../services/stations.dart';

class LiveLocationWidget extends StatefulWidget {
  @override
  _LiveLocationWidgetState createState() => _LiveLocationWidgetState();
}

class _LiveLocationWidgetState extends State<LiveLocationWidget> {
  final GeolocationService _geoService = GeolocationService();
  late Stream<Position> _positionStream;

  @override
  void initState() {
    super.initState();
    _positionStream = _geoService.getPositionStream();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<Position>(
        stream: _positionStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Waiting for location updates...");
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData) {
            final position = snapshot.data!;
            StationFinder stationFinder = StationFinder(lat: position.latitude, lon: position.longitude);
            return FutureBuilder<String>(
              future: stationFinder.station().then((stations) => stations.toString()),
              builder: (context, stationSnapshot) {
                if (stationSnapshot.connectionState == ConnectionState.waiting) {
                  return Text("Fetching station data...");
                } else if (stationSnapshot.hasError) {
                  return Text("Error: ${stationSnapshot.error}");
                } else if (stationSnapshot.hasData) {
                  return Text(
                    "Latitude: ${position.latitude}, Longitude: ${position.longitude}\nStation Data: ${stationSnapshot.data}",
                    style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                  );
                } else {
                  return Text("No station data available");
                }
              },
            );
          } else {
            return Text("No location data available");
          }
        },
      ),
    );
  }
}

