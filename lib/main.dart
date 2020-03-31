import 'package:flutter/material.dart';
import 'screen/home_screen.dart';
import 'services/io_helper.dart';

void main() => runApp(FlightTracker());

class FlightTracker extends StatelessWidget {
@override
  Widget build(BuildContext context) {
//  IoHelper ioh = IoHelper();
//  ioh.write('', true);
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue[600],
        accentColor: Colors.blueAccent[700],
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueAccent[700],
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: DefaultTabController(length: 3, child: HomeScreen(),),
    );
  }
}