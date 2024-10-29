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
          return _StationFuture(position);
        } else {
          return Text("No location data available");
        }
      },
    );
  }

  Widget _StationFuture(Position position) {
    StationFinder stationFinder = StationFinder(lat: position.latitude, lon: position.longitude);
    print("${position.latitude}, ${position.longitude}");
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: stationFinder.station(),
      builder: (context, stationSnapshot) {
        if (stationSnapshot.connectionState == ConnectionState.waiting) {
          return Text("Fetching station data...");
        } else if (stationSnapshot.hasError) {
          return Text("Error: ${stationSnapshot.error}");
        } else if (stationSnapshot.hasData) {
          final stations = stationSnapshot.data!;
          return _StationDataWidget(position, stations);
        } else {
          return Text("No station data available");
        }
      },
    );
  }

  Widget _StationDataWidget(Position position, List<Map<String, dynamic>> stations) {
    return Center (
      child: 
        Column(
          children: stations.map((station) {
            return Text(
              "${station['name']}",
              style: TextStyle(fontSize: 25, color: Colors.black,),
              
            );
          }).toList(),
        )
    );
  }
}