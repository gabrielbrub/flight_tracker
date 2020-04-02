import 'package:flight_tracker/services/io_helper.dart';
import 'package:flight_tracker/services/network_helper.dart';
import 'package:flight_tracker/screen/results_list.dart';
import 'package:flutter/material.dart';


import '../model/flight.dart';

class FlightForm extends StatefulWidget {
  @override
  _FlightFormState createState() => _FlightFormState();
}

class _FlightFormState extends State<FlightForm> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _airlineController = TextEditingController();
  NetworkHelper _netHelper = NetworkHelper();
  DateTime _selectedDate;
  IoHelper _io;
  bool _isLoading;



  @override
  void initState() {
    super.initState();
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Flight'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              child: _isLoading ? LinearProgressIndicator() : SizedBox(),
            ),
            TextField(
              controller: _numberController,
              decoration: InputDecoration(
                labelText: 'Flight Number (iata)',
              ),
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 6,
                    child: TextField(
                      controller: _airlineController,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Flight date',
                      ),
                      style: TextStyle(
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.date_range, color: Colors.blueAccent,),
                      onPressed: () async {
                        _selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2018),
                          lastDate: DateTime(2030),
                          builder: (BuildContext context, Widget child) {
                            return Theme(
                              data: ThemeData.fallback(),
                              child: child,
                            );
                          },
                        );
                        _airlineController.text = ('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}');
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: double.maxFinite,
                child: RaisedButton(
                  child: Text('Add'),
                  onPressed: () async {
                   setState(() {
                     _isLoading = true;
                   });
                    _io = IoHelper();
                    List<Flight> flights = await _netHelper.searchFlights(
                        _numberController.text, _selectedDate).catchError((_){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return errorDialog(title: 'Request timeout', content: 'Please try again later.');
                        },
                      );
                      setState(() {
                        _isLoading = false;
                      });
                    });
                    if (flights.length > 1) {
                      _isLoading = true;
                      final Flight resultFlight = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ResultsList(flights),
                        ),
                      );
                      _saveFlight(resultFlight);
                    } else if (flights.isEmpty) {
                      setState(() {
                        _isLoading = false;
                      });
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return errorDialog(title: 'No results found', content: 'Please check your input');
                        },
                      );
                    } else {
                      flights[0].index=0;
                      _saveFlight(flights[0]);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _saveFlight(Flight flight) async{
    await _io.save(flight);
    Navigator.pop(context);
  }

  Widget errorDialog({String title, String content}){
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        FlatButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}



