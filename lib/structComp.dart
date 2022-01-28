part of 'main.dart';

//Holds the components in each room
//List of components in the room
//List of numbers of components
class Comps extends _MyHomePageState {
  String roomName = "";

  int numBasicComps = 1;
  int numAdvComps = 1;
  int numAdvText = 1;

  var basicCompNames = [];
  var basicCompNum = [];

  var advCompNames = [];
  var advCompDescript = [];
  var advCompNum = [];

  var advTextNames = [];
  var advText = [];

  Comps(String room) {
    this.roomName = room;

    for (int i = 0; i < globals.basicComps.length; i++) {
      this.basicCompNames.add(globals.basicComps[i]);
      this.basicCompNum.add(0);
    }/*
    for (int i = 0; i < globals.advComps.length; i++) {
      this.advCompNames.add(globals.advComps[i]);
      this.advCompNum.add(0);
    }*/
    for (int i = 0; i < globals.advText.length; i++) {
      this.advTextNames.add(globals.advText[i]);
      //advText[i].add('0');
    }
  }
}
