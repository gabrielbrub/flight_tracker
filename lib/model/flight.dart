import 'package:intl/intl.dart';

class Flight {
  String number;
  final String airline;
  //String date;
  final String status;
  final String destination;
  final String destIata;
  final String terminal;
  final String gate;
  final String origin;
  final String originIata;
  final String aircraftModel;
  final String scheduledDep;
  final String estimatedDep;
  final String scheduledArr;
  final String estimatedArr;
  int index=0;

  String getUrl(){
    String date = scheduledDep.substring(0,10);
    number = number.replaceAll(RegExp(r"\s\b|\b\s"), "");
    return ("https://aerodatabox.p.rapidapi.com/flights/$number/$date");
  }

  Flight(
      this.number,
      this.airline,
      //this.date,
      this.destination,
      this.destIata,
      this.terminal,
      this.gate,
      this.status,
      this.origin,
      this.originIata,
      this.aircraftModel,
      this.scheduledDep,
      this.estimatedDep,
      this.scheduledArr,
      this.estimatedArr,
      this.index,
      );


  @override
  String toString() {
    return 'Flight{number: $number, airline: $airline, date: $scheduledDep}';
  }

  getTime({bool departure, bool scheduled}){
    String dateTime = getDate(departure, scheduled);
    if(dateTime=='N/A')
      return dateTime;
    var newDateTimeObj = new DateFormat("yyyy-mm-dd HH:mm").parse(dateTime);
    return DateFormat('Hm').format(newDateTimeObj);
  }

  String getWeekday({bool departure, bool scheduled}){
    String dateTime = getDate(departure, scheduled);
    if(dateTime=='N/A')
      return dateTime;
    var newDateTimeObj = new DateFormat("yyyy-mm-dd HH:mm").parse(dateTime);
    return (DateFormat('EEE').format(newDateTimeObj).substring(0, 3) + ' ' + newDateTimeObj.day.toString());
  }

  String getFormattedDate({bool departure, bool scheduled}){
    return getWeekday(departure: departure, scheduled: scheduled) + ', ' + getTime(departure: departure, scheduled: scheduled);
  }

  getDate(bool departure, bool scheduled){
    String flightDate;
      if(departure) {
        if (scheduled)
          flightDate = scheduledDep;
        else
          flightDate = estimatedDep;
      }
      else{
        if (scheduled)
          flightDate = scheduledArr;
        else
          flightDate = estimatedArr;
      }
    try {
      return flightDate.substring(0, 16);
    } on RangeError catch (e) {
      print(e.message);
      return 'N/A';
    }
  }


  Flight.fromJson(Map<String, dynamic> json)
      : number = json['number'],
        airline = json['airline']['name'],
        status = json['status'],
        //date = json['departure']['scheduledTimeLocal'],
//        index = 0,
        destination = json['arrival']['airport']['municipalityName'] ?? 'N/A',
        destIata = json['arrival']['airport']['iata'] ?? 'N/A',
        terminal = json['departure']['terminal'] ?? 'N/A',
        gate = json['departure']['gate'] ?? 'N/A',
        origin = json['departure']['airport']['municipalityName'] ?? 'N/A',
        originIata = json['departure']['airport']['iata'] ?? 'N/A',
        aircraftModel = json['aircraft']==null?'N/A':json['aircraft']['model'] ?? 'N/A',
        scheduledDep = json['departure']['scheduledTimeLocal'] ?? 'N/A',
        estimatedDep = json['departure']['actualTimeLocal'] ?? 'N/A',
        scheduledArr = json['arrival']['scheduledTimeLocal'] ?? 'N/A',
        estimatedArr = json['arrival']['actualTimeLocal'] ?? 'N/A';

}

