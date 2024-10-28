import 'package:flutter/material.dart';
import '../services/location.dart';
import 'package:geolocator/geolocator.dart';

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
    _positionStream = _geoService.getPositionStream();  // Initialize the location stream
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
            return Text(
              "Latitude: ${position.latitude}, Longitude: ${position.longitude}",
              style: TextStyle(fontSize: 18, color: Colors.blueAccent),
            );
          } else {
            return Text("No location data available");
          }
        },
      ),
    );
  }
}
