part of 'main.dart';

//The list of rooms which are owned by a house

//Controls the main house
//List of Room Names
//List of Component objects
class Rooms extends _MyHomePageState {
  int numRooms = 0;
  String houseName = "New Household";

  List<String> roomNames = [];
  List<Comps> roomComps = [];

  Rooms(String houseName) {
    this.houseName = houseName;
  }

  void addroom(String name) {
    this.roomNames.add(name);

    Comps comp = new Comps(name);
    this.roomComps.add(comp);

    this.numRooms++;
  }
}