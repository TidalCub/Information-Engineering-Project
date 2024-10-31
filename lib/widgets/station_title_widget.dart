import 'package:flutter/material.dart';

Widget stationTitle(stationResponse){
  return Text(
    stationResponse.station.name,
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)
  );
}