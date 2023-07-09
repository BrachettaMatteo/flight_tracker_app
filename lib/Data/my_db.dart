import 'dart:developer';
import 'package:sqflite/sqflite.dart';

import '../Domain/Repository/database_repository.dart';
import 'model/flight.dart';

/// Perisnal db for save data in local device
class MyDB implements DatabaseRepository {
  late final Database db;
  @override
  String get fieldGateAirport => "gate";

  @override
  String get fieldId => "iata";

  @override
  String get fieldMapAirportDetailArrival => "arrival";

  @override
  String get fieldMapAirportDetailDeparture => "departure";

  @override
  String get fieldNameAirport => "airport";

  @override
  String get fieldTerminalAirport => "terminal";

  @override
  String get fieldTimeEstimatedAirport => "estimated";

  @override
  String get fieldidAirport => "iata";
  @override
  String get nameDb => "FlightTracker.db";

  @override
  String get nameTable => "FlightTracker";
  @override
  String get fieldNote => "note";
  TypeAirpot get destinationType => TypeAirpot.arrival;
  TypeAirpot get startType => TypeAirpot.departure;
  @override
  String get fieldDelay => "delay";

  @override
  Future<void> initDB() async {
    final String path = "${await getDatabasesPath()} flighttracker.db ";
    db = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute("""
        CREATE TABLE $nameTable(
          $fieldId TEXT PRIMARY KEY,
          ${fieldNameAirport + destinationType.name} TEXT NOT NULL,
          ${fieldidAirport + destinationType.name} TEXT NOT NULL,
          ${fieldGateAirport + destinationType.name} TEXT NOT NULL,
          ${fieldTerminalAirport + destinationType.name} TEXT NOT NULL,
          ${fieldTimeEstimatedAirport + destinationType.name} INTEGER NOT NULL,
           ${fieldDelay + destinationType.name} INTEGER NOT NULL,
          ${fieldNameAirport + startType.name} TEXT NOT NULL,
          ${fieldidAirport + startType.name} TEXT NOT NULL,
          ${fieldGateAirport + startType.name} TEXT NOT NULL,
          ${fieldTerminalAirport + startType.name} TEXT NOT NULL,
          ${fieldTimeEstimatedAirport + startType.name} INTEGER NOT NULL,
          ${fieldDelay + startType.name} INTEGER NOT NULL,
          $fieldNote TEXT
        )
        """);
      log("create db");
    });
  }

  @override
  Future<List<Flight>> getAllFlight() async {
    final List<Map<String, dynamic>> allElements =
        await db.rawQuery('SELECT * FROM $nameTable');
    return allElements.map((e) => Flight.fromJson(e)).toList();
  }

  @override
  Future<void> addFlight(Flight flight) async {
    await db.insert(nameTable, flight.toJson());
  }

  @override
  Future<void> removeFlight(Flight flight) async {
    await db.delete(nameTable, where: "$fieldId = ?", whereArgs: [flight.id]);
  }

  @override
  Future<void> updateFlight(Flight flight) async {
    await db.update(nameTable, flight.toJson(),
        where: "$fieldId =?", whereArgs: [flight.id]);
  }

  @override
  Future<void> updateNoteFligth(Flight flight, String note) async {
    await db.rawUpdate('''
    UPDATE $nameTable 
    SET $fieldNote = ?
    WHERE $fieldId = ?
    ''', [flight.note, flight.id]);
  }
}

enum TypeAirpot { departure, arrival }
