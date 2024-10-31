import 'package:flutter/material.dart';
import '../views/styling/colours.dart';
import 'arrival_widget.dart';

Widget line(lineEntry){
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
                Text( lineEntry.key, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),),
                ...lineEntry.value.entries.map((directionEntry) {
                  return arrivalsPerDirection(directionEntry);
                }),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}