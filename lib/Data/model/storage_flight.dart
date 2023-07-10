import '../../core/utility.dart';
import '../../data/model/flight.dart';
import '../../domain/repository/database_repository.dart';
import '../../domain/repository/flight_tracker_api_repository.dart';

/// Represent the repository for Storage flight.
/// It content action for manage list fo blok
class StorageFlight {
  final DatabaseRepository db;
  final FightTrackerApiRepository api;
  List<Flight> _storage = const [];

  StorageFlight({required this.db, required this.api});

  Future<void> init() async {
    await db.initDB();
    Utility.db = db;
    Utility.apiFlightTracker = api;
    updateListFlight(
        newList:
            await api.updateListFlight(listToUpdate: await db.getAllFlight()));
  }

  void add({required Flight flight}) {
    _storage.add(flight);
  }

  Future<bool> remove({required Flight flight}) async {
    if (contains(flight: flight)) {
      _storage.remove(flight);
      await db.removeFlight(flight);
      return true;
    }
    return false;
  }

  bool contains({required Flight flight}) => _storage.contains(flight);

  bool containsByid({required String idFlight}) =>
      _storage.where((element) => element.id == idFlight).isNotEmpty;

  ///The flight is only updated if the flight has not landed
  ///
  ///If the [flight.airportArrival.estimateArrival] is before [Datetime.now] return [null]
  Future<Flight?> updateFlight({required Flight flight}) async {
    if (containsByid(idFlight: flight.id)) {
      if (flight.airportArrival.estimateArrival.isBefore(DateTime.now())) {
        Flight? update = (await api.getFlightById(flight.id));
        if (update != null) {
          _storage.remove(flight);
          update = update.copyWith(note: flight.note);
          db.updateFlight(update);
          add(flight: update);
          return update;
        }
      }
    }
    return null;
  }

  void updateListFlight({required List<Flight> newList}) => _storage = newList;

  void removeByIDFlight({required String idFlight}) =>
      _storage.removeWhere((element) => element.id == idFlight);

  List<Flight> getTodayFlight() {
    DateTime now = DateTime.now();
    return _storage
        .where((element) =>
            element.airportDeparture.estimateArrival.year == now.year &&
            element.airportDeparture.estimateArrival.month == now.month &&
            element.airportDeparture.estimateArrival.day == now.day)
        .toList();
  }

  List<Flight> getFutureFlight() {
    List<Flight> out = _storage
        .where((element) =>
            element.airportDeparture.estimateArrival.isAfter(DateTime.now()))
        .toList();
    return out.toSet().difference(getTodayFlight().toSet()).toList();
  }

  List<Flight> getPastFlight() => _storage
      .toSet()
      .difference(getFutureFlight().toSet())
      .difference(getTodayFlight().toSet())
      .toList();

  List<Flight> get getStorage => _storage;
  @override
  String toString() {
    return _storage.toString();
  }

  Future<bool> addById({required String idFlight}) async {
    if (!containsByid(idFlight: idFlight)) {
      Flight? flight = await api.getFlightById(idFlight);
      if (flight != null) {
        //add flight to db
        await db.addFlight(flight);
        //add flight in current list
        add(flight: flight);
        return true;
      }
    }
    return false;
  }

  refresh() async => updateListFlight(
      newList: await api.updateListFlight(listToUpdate: _storage));
}
