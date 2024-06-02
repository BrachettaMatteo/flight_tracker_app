import 'repository/database_repository.dart';
import 'repository/flight_tracker_api_repository.dart';

/// Utility to get-set current implementation storage data app
/// Version:2.0.0
class UtilityAccessStorage {
  ///Local db to storage data
  static DatabaseRepository? db;

  ///API to access data flight
  static FightTrackerApiRepository? apiFlightTracker;
}
