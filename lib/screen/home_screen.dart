import 'package:flight_tracker/services/io_helper.dart';
import 'package:flight_tracker/services/network_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/flight.dart';
import 'flight_form.dart';
import '../icon/custom_icons.dart';

class HomeScreen extends StatelessWidget {
  GlobalKey<_FlightsListState> globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flight Tracker'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.update),
            onPressed: (){
              globalKey.currentState.updateUI();
            },
          ),
        ],
      ),
      body: FlightsList(key: globalKey,),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FlightForm(),
            ),
          ).then((_){globalKey.currentState.updateUI();});
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}

class FlightsList extends StatefulWidget {
  FlightsList({Key key}) : super(key: key);
  @override
  _FlightsListState createState() => _FlightsListState();
}

class _FlightsListState extends State<FlightsList> {

  IoHelper ioHelper = IoHelper();
  NetworkHelper netHelper = NetworkHelper();
  String _lastUpdated;
  Future<List<Flight>> _future;


    updateUI() {
      var formatter = new DateFormat('HH:mm');
      setState(() {
        print('SETUPDATE');
        _lastUpdated = formatter.format(DateTime.now());
        _future = netHelper.updateFlights();
      });
      //return netHelper.updateFlights();
  }

  @override
  void initState() {
      updateUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,//updateUI(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Flight> flights = snapshot.data;
            if (flights.isNotEmpty) {
              return Column(
                children: <Widget>[
                  Container(
                    color: Colors.grey[200],
                    child: Center(child: Text('Last updated: $_lastUpdated')),
                  ),
                  Expanded(
                    child: ListView.builder(itemBuilder: (context, index) {
                      final bool onSchedule = flights[index].status == 'Delayed' ? false : true;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.grey[300],
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                height: 190,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                        height: 50,
                                        width: double.infinity,
                                        color: selectFlightColor(flights[index].status),
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(flex: 1, child: SizedBox(), fit: FlexFit.tight,),
                                            Flexible(
                                              fit: FlexFit.tight,
                                              flex: 1,
                                              child: Center(
                                                  child: Text('${flights[index].number}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                child: Align(child: IconButton(icon: Icon(Icons.delete), onPressed: () async{
                                                  await ioHelper.deleteFlightAt(index);
                                                  setState(() {
                                                    flights.removeAt(index);
                                                  });
                                                  },),
                                                  alignment: Alignment.centerRight,),
                                             ),
                                              fit: FlexFit.tight,
                                             ),
                                            ],
                                        ),
                                    ),
                                    //'Flight: ${flights[index].number}'
                                    Container(
                                        height: 30,
                                        //width: double.infinity,
                                        color: selectStatusColor(flights[index].status),
                                        child: Center(child: Text(flights[index].status, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),))),
                                    //flights[index].status
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceEvenly,
                                        children: <Widget>[
                                          Flexible(
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                                  child: Text(flights[index].origin),
                                                ),
                                                Text(flights[index].getTime(departure: true, scheduled: onSchedule), style: TextStyle(fontSize: 16),),
                                                SizedBox(height: 4,),
                                                Text(flights[index].getWeekday(departure: true, scheduled: onSchedule), style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),), //extrair
                                              ],
                                            ),
                                            flex: 3,
                                            fit: FlexFit.tight,
                                          ),
                                          Flexible(flex: 1, fit: FlexFit.tight,child: Align(alignment: Alignment.center,child: Icon(Planecons.flight))),
                                          Flexible(
                                            flex: 3,
                                            fit: FlexFit.tight,
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                                  child: Text(flights[index].destination),
                                                ),
                                                Text(flights[index].getTime(departure: false, scheduled: true), style: TextStyle(fontSize: 16),),
                                                SizedBox(height: 4,),
                                                Text(flights[index].getWeekday(departure: false, scheduled: true), style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(flights[index].airline),
                                  ],
                                ),
                              ),
                              ExpansionTile(
                                title: Text('More info'),
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('Company: ${flights[index].airline}'),
                                        Text('Aircraft: ${flights[index].aircraftModel}'),
                                        SizedBox(height: 6,),
                                        Row(children: <Widget>[Icon(Planecons.flight_takeoff), Text('Departure', style: TextStyle(fontSize: 18),)]),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                            Text('${flights[index].origin.trim()} (${flights[index].originIata})'),
                                            Text('Scheduled: ${flights[index].getFormattedDate(departure: false, scheduled: true)}'),
                                            Text('Estimated: ${flights[index].getFormattedDate(departure: false, scheduled: false)}'),
                                            Text('Terminal: ${flights[index].terminal}', style: TextStyle(fontWeight: FontWeight.bold),),
                                            Text('Gate: ${flights[index].gate}', style: TextStyle(fontWeight: FontWeight.bold),),
                                          ],),
                                        ),
                                        SizedBox(height: 6,),
                                        Row(children: <Widget>[Icon(Planecons.flight_land), Text('Arrival', style: TextStyle(fontSize: 18),)]),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                            Text('${flights[index].destination.trim()} (${flights[index].destIata})'),
                                            Text('Scheduled: ${flights[index].getFormattedDate(departure: false, scheduled: true)}'),
                                            Text('Estimated: ${flights[index].getFormattedDate(departure: false, scheduled: false)}'),
                                          ],),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                      itemCount: flights.length,
                    ),
                  ),
                ],
              );
            }
            if(snapshot.connectionState == ConnectionState.done){
              return Center(child: Text('Empty'));
            }
          }
          return LinearProgressIndicator();
        });
  }


  Color selectFlightColor(String status){
    if(status == 'Canceled' || status == 'CanceledUncertain')
      return Colors.red[200];
    if(status == 'Delayed')
      return Colors.yellow[200];
    return Colors.lightGreen[100];
  }

  MaterialColor selectStatusColor(String status){
    if(status == 'Canceled' || status == 'CanceledUncertain')
      return Colors.red;
    if(status == 'Delayed')
      return Colors.yellow;
    return Colors.green;

  }

}
