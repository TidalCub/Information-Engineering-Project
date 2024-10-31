import 'package:flutter/material.dart';
import 'package:tfl_app/model/station_response.dart';
import '../services/location.dart';
import 'package:geolocator/geolocator.dart';
import '../services/stations.dart';
import '../views/styling/colours.dart';
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
          return Column(
          children: [
            Text(
              stationResponse.station.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)
              ),
            ...stationResponse.arrivalsByDirection.entries.map((lineEntry) {
              final borderColor = lineColors[lineEntry.key];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: 
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Container(
                  decoration: BoxDecoration(
                    border: Border(
                    left: BorderSide(
                      color: borderColor ?? Color(Colors.black as int),
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
                      lineEntry.key, //Tube Line text
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)
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
                          ...directionEntry.value.map((arrival) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(arrival.destinationName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text("${arrival.timeToStation}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                ),
                                Text("Plat. ${arrival.platform}")
                              ],
                              )
                            ])
                          ))
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
        );
        } else {
          return Text("No stations found");
        }
      },
    );
  }
}