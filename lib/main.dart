import 'package:flutter/material.dart';
import 'screen/home_screen.dart';


void main() => runApp(FlightTracker());

class FlightTracker extends StatelessWidget {
@override
  Widget build(BuildContext context) {
//  wipe file
//  IoHelper ioh = IoHelper();
//  ioh.write('', true);
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue[600],
        accentColor: Colors.blueAccent[300],
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueAccent[300],
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: HomeScreen(),
    );
  }
}