import 'package:flight_tracker/services/io_helper.dart';
import 'package:flight_tracker/keys.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import '../model/flight.dart';

const String baseUrl =
    'http://api.aviationstack.com/v1/flights?access_key=$API_KEY';

class NetworkHelper {
  Future<List<Flight>> updateFlights() async {
    IoHelper ioh = IoHelper();
    List<Flight> flights = await ioh.getFlights();
    flights.forEach((f) => print("---> Gettado: "+f.toString()));
    //List<Flight> flightsReturn = await findAll(flights);
    return findAll(flights);
  }

  Future<List<Flight>> searchFlights(String flight_number, DateTime flight_date) async {
    List<Flight> flights = List<Flight>();
    String formattedDate = DateFormat('yyyy-MM-dd').format(flight_date);
    final http.Response response = await http.get(
        'https://aerodatabox.p.rapidapi.com/flights/$flight_number/$formattedDate',
        headers: {
          'x-rapidapi-host': 'aerodatabox.p.rapidapi.com',
          'x-rapidapi-key': '$apiKey'
        });
    if (response.statusCode == 200) {
      List<dynamic> decodedJson = jsonDecode(response.body);
      print(response.body);
      for (int i = 0; i < decodedJson.length; i++) {
        Flight flight = Flight.fromJson(decodedJson[i]);
        flights.add(flight);
      }
    } else {
      print(response.statusCode);
    }
    return flights;
  }

  Future<List<Flight>> findAll(List<Flight> flights) async {
    List<Flight> flightReturn = List<Flight>();
    for (Flight fl in flights) {
      if(fl.status == 'Arrived')
        break;
      final http.Response response = await http.get(fl.getUrl(), headers: {
        'x-rapidapi-host': 'aerodatabox.p.rapidapi.com',
        'x-rapidapi-key': '$apiKey'
      });
      print('URLK AKEW: ' + fl.getUrl());
      if (response.statusCode == 200) {
        List<dynamic> decodedJson = jsonDecode(response.body);
        print(decodedJson);
        Flight flight = Flight.fromJson(decodedJson[fl.index]);
        flightReturn.add(flight);
      } else {
        print(response.statusCode);
      }
    }
    return flightReturn;
  }

}
