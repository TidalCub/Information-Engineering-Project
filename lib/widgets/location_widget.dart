import 'package:flutter/material.dart';
import 'package:tfl_app/model/station_response.dart';
import '../services/location.dart';
import 'package:geolocator/geolocator.dart';
import '../services/stations.dart';
import '../views/styling/colours.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

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
                Text(
                  stationResponse.station.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                ...stationResponse.arrivalsByDirection.entries.map((lineEntry) {
                  final borderColor = lineColors[lineEntry.key];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: borderColor ?? Colors.black,
                                width: 4.0,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lineEntry.key,
                                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                                ),
                                ...lineEntry.value.entries.map((directionEntry) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        directionEntry.key,
                                        style: TextStyle(color: Colors.white, fontSize: 12),
                                      ),
                                      ),
                                      Container(
                                      margin: EdgeInsets.symmetric(vertical: 6),
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(

                                        color: Color.fromARGB(255, 35, 35, 35),
                                        boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                        ],
                                        border: Border(
                                          top: BorderSide(color: Color.fromARGB(255, 21, 21, 21)),
                                          left: BorderSide(color: Color.fromARGB(255, 21, 21, 21)),
                                          right: BorderSide(color: Color.fromARGB(255, 21, 21, 21)),
                                          bottom: BorderSide(color: Color.fromARGB(255, 21, 21, 21)),
                                        )
                                      ),
                                      child: Column(
                                        children: directionEntry.value.take(2).map((arrival) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                          Text(arrival.destinationName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber)),
                                          Row(
                                            children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: CountdownTimer(
                                              endTime: DateTime.now().millisecondsSinceEpoch + arrival.timeToStation * 1000,
                                              widgetBuilder: (_, time) {
                                                if (time == null) {
                                                return Text("Arrived", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber));
                                                }
                                                return Text(
                                                "${time.min ?? 0}m ${time.sec ?? 0}s",
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber),
                                                );
                                              },
                                              ),
                                            ),
                                            Text("Plat. ${arrival.platform}", style: TextStyle(color: Colors.amber))
                                            ],
                                          )
                                          ],
                                        ),
                                        )).toList(),
                                      ),
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
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