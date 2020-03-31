import 'package:flight_tracker/services/io_helper.dart';
import 'package:flight_tracker/keys.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import '../model/flight.dart';


class NetworkHelper {
  Future<List<Flight>> updateFlights() async {
    IoHelper ioh = IoHelper();
    List<Flight> flights = await ioh.getFlights();
    if(flights.isNotEmpty)
      return findAll(flights);
    return [];
  }

  Future<List<Flight>> searchFlights(String flightNumber, DateTime flightDate) async {
    List<Flight> flights = List<Flight>();
    String formattedDate = DateFormat('yyyy-MM-dd').format(flightDate);
    final http.Response response = await http.get(
        'https://aerodatabox.p.rapidapi.com/flights/$flightNumber/$formattedDate',
        headers: {
          'x-rapidapi-host': 'aerodatabox.p.rapidapi.com',
          'x-rapidapi-key': '$apiKey'
        }).timeout(Duration(seconds: 15));
    if (response.statusCode == 200) {
      List<dynamic> decodedJson = jsonDecode(response.body);
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
      final http.Response response = await http.get(fl.getUrl(), headers: {
        'x-rapidapi-host': 'aerodatabox.p.rapidapi.com',
        'x-rapidapi-key': '$apiKey'
      });
      if (response.statusCode == 200) {
        List<dynamic> decodedJson = jsonDecode(response.body);
        Flight flight = Flight.fromJson(decodedJson[fl.index]);
        flightReturn.add(flight);
      } else {
        print(response.statusCode);
      }
    }
    return flightReturn;
  }

}
