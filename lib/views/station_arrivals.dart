import 'package:flutter/material.dart';
import 'package:tfl_app/model/station_response.dart';
import '../services/location.dart';
import 'package:geolocator/geolocator.dart';
import '../services/stations.dart';
import '../widgets/line_widget.dart';
import '../widgets/station_title_widget.dart';

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
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20),
      child: _buildLocationStreamBuilder(),
    );
  }

  Widget _buildLocationStreamBuilder() {
    return StreamBuilder<Position>(
      stream: _positionStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Waiting for location updates...");
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData) {
          final position = snapshot.data!;
          return _stationFuture(position);
        } else {
          return Text("No location data available");
        }
      },
    );
  }

  Widget _stationFuture(Position position) {
  return FutureBuilder<StationResponse>(
    future: StationFinder(lat: position.latitude, lon: position.longitude).fetchStation(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text("Error: ${snapshot.error}");
      } else if (snapshot.hasData) {
        final stationResponse = snapshot.data!;
        return SizedBox(
          height: MediaQuery.of(context).size.height * 1, // Adjust height as needed
          child: SingleChildScrollView(
            child: Column(
              children: [
                stationTitle(stationResponse),
                ...stationResponse.arrivalsByDirection.entries.map((lineEntry) {
                  return line(lineEntry);
                }).toList(),
              ],
            ),
          ),
        );
      } else {
        return Text("No stations found");
      }
    },
  );
}

}