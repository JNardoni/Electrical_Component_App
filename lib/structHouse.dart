part of 'main.dart';

class House extends _MyHomePageState {

  int numHouses = 0;
  List<String> houseName = [];
  List<Rooms> houseRooms = [];

  House() {
    this.houseName.add("");
    Rooms rooms = new Rooms("");
    this.houseRooms.add(rooms);
  }

  void addHouse(String name) {
    this.numHouses += 1;
    this.houseName.add(name);
    Rooms rooms = new Rooms(name);
    this.houseRooms.add(rooms);

    currentHouse = this.numHouses;
  }
}