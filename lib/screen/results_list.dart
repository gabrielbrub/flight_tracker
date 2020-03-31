import 'package:flight_tracker/icon/custom_icons.dart';
import 'package:flutter/material.dart';

import '../model/flight.dart';


class ResultsList extends StatelessWidget {
  List<Flight> flights;
  ResultsList(this.flights);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Results'),),
      body: ListView.builder(
        itemCount: flights.length,
          itemBuilder: (context, index){
            return Card(
              child: ListTile(
                leading: Icon(Planecons.flight_1),
                title: Text(flights[index].number),
                subtitle: Text(flights[index].scheduledDep),
                onTap: (){
                  flights[index].index = index;
                  Navigator.pop(context, flights[0]);
                },
              ),
            );
          }),
    );
  }
}
