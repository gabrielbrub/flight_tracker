import 'dart:io';
import 'package:flight_tracker/model/flight.dart';
import 'package:path_provider/path_provider.dart';

class IoHelper {

  save(Flight flight) async {
    final String str = ('${flight.number},${flight.airline},${flight.date},${flight.destination},'
        '${flight.destIata},${flight.terminal},${flight.gate},${flight.status},${flight.origin},'
        '${flight.originIata},${flight.aircraftModel},${flight.scheduledDep},${flight.estimatedDep},'
        '${flight.scheduledArr},${flight.estimatedArr},${flight.index};');
    await write(str, false); //false
  }

  Future<List<Flight>> getFlights() async{
    String fileText = await read();
    List<String> flightData;
    List<String> flightStr = fileText.split(';');
    List<Flight> flights = List<Flight>();
    for(String str in flightStr){
      print(str);
      if(str.isEmpty)
        return flights;
      flightData = str.split(',');
      //Flight ftr = Flight(flightData[0], flightData[1], flightData[2], flightData[3], flightData[5], int.parse(flightData[4]));
      flights.add(Flight(flightData[0], flightData[1], flightData[2], flightData[3], flightData[4], flightData[5], flightData[6]
          ,flightData[7],flightData[8],flightData[9],flightData[10],flightData[11],flightData[12],flightData[13], flightData[14],
           int.parse(flightData[15])));
    }
    return flights;
  }


  write(String text, bool overwrite) async{
    FileMode fm = overwrite?FileMode.write:FileMode.append;
    final Directory directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/my_file.txt');
    await file.writeAsString(text, mode: fm,); //escrever line, sem apagar conteudo
  }

  Future<String> read() async {
    String text;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/my_file.txt');
      text = await file.readAsString(); //trocar por read line
    } catch (e) {
      print("Couldn't read file");
    }
    print('read: TEXTOOOOOOOOOOO: ' + text);
    return text;
  }

//  static delete() async{
//    final Directory directory = await getApplicationDocumentsDirectory();
//    final File file = File('${directory.path}/my_file.txt');
//    await file.delete(recursive: true);
//  }

  deleteFlightAt(int index) async{ //ALT: RECEBE INDEX E DELETA NAQUELA POS
    String text = await read();
    List<String> flights = text.split(';');
    flights.removeAt(index);
    //FLIGHTS = FLIGHTS.REMOVEAT(INDEX)
////    for(int index = 0; index<flights.length; index++) {
////      if(flights[index].contains(flight.date) && flights[index].contains(flight.number) && flights[index].contains(flight.index.toString()))
////        flights.removeAt(index);
////    }
    text = flights.join(';');
    print('TEXTO APOS DELETE: $text');
    await write(text, true);
  }

}