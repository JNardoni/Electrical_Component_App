part of 'main.dart';


//HouseStruct
//Stores two lists, and an int
//int: keeps track of how many houses are currently in the struct
//String list: Keeps a name of all houses added to the struct
//Rooms: Keeps a track of all rooms in each house that has been added to the house list

class HouseStruct extends _MyHomePageState {

  int numHouses = 0;
  List<String> houseName = [];
  List<Rooms> houses = [];

  HouseStruct() {
    //this.houseName.add("");
    //Rooms rooms = new Rooms("");
    //this.houses.add(rooms);
    //
  }

  //Houses is built from the top down. Position 0 is always the newest house.
  void addHouse(String name) {

    this.houseName.insert(0, name);

    Rooms rooms = new Rooms(name);
    this.houses.insert(0, rooms);

    currentHouse = 0;
    this.numHouses += 1;

  }
}