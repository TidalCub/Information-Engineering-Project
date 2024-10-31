import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import '../model/arrival.dart';

Widget train(List<Arrival> arrivals) {
  return Column(
    children: arrivals.take(2).map((arrival) => Padding(
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
  );
}

Widget arrivalsPerDirection(directionEntry){
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
      child: train(directionEntry.value)
      ),
    ],
  );
}