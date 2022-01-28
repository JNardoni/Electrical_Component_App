import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'globals.dart' as globals;

part 'addComponent.dart';
part 'addRoom.dart';
part 'houseList.dart';
part 'componentList.dart';

part 'structComp.dart';
part 'structHouse.dart';
part 'structRoom.dart';
part 'roomList.dart';


const int MAX_HOUSES = 50;

//int state = 0;
int currentRoom = 0;
int currentHouse = -1;

//Rooms house = new Rooms();

HouseStruct houseList = new HouseStruct();
//Rooms house;


//String addedRoom = "";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var routes= <String, WidgetBuilder>{
      RoomSelectedState.routeName: (BuildContext context) => new RoomSelectedState(title: "Comps"),
      AddElementState.routeName: (BuildContext context) => new AddElementState(title: "Elements"),
      NewCompState.routeName: (BuildContext context) => new NewCompState(title: "NewComp"),
  //    SelectHouseState.routeName: (BuildContext context) => new SelectHouseState(title: "SelHouse"),
      SelectRoomState.routeName: (BuildContext context) => new SelectRoomState(title: "SelectRoom"),
    };
    return MaterialApp(
      title: 'Electrical Mapping',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Electrical Mapping Home Page'),
      routes: routes,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//Home page - shows the list of rooms
class _MyHomePageState extends State<MyHomePage> {

  TextEditingController _houseNameController = TextEditingController();

  @override
  void initState() {
    if(currentHouse == -1) { //Current house being -1 means it was never set, and the app never used
      _houseNameDialog(context);
    }
    super.initState();
  }

  void _selectHouse(int index) {
    currentHouse = index;
    Navigator.pushNamed(context, SelectRoomState.routeName);
  }

  void _newHouse() {
    if (houseList.houseName.length >= MAX_HOUSES) {
      //TODO Add toast warning
    }
    _houseNameDialog(context);
  }

  //TODO menu stuff
  void _select(String choice) {
    if (choice == "Help") {
      int i = 1;
    }
    if (choice == "Settings") {

    }
  }

  //If there is no most recent house, an alert menu will appear, welcoming the user to the app and getting the name for a first household
  //This menu is also called when a user attempts to add a new house to the list of houses
  //Takes nothing, is inescapable
  //When the name of the house is entered, it adds the house to the house list
  //TODO: scrub house name
  Future _houseNameDialog(BuildContext context) async {
    await Future.delayed(Duration(seconds: 0));
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(   //---Alert dialog pops up----
          title: new Text(    //Top of alert: text
              "Welcome!\nFirst, enter the name for the household"),
          content: TextField( //Gets the name of the house by setting it to a input controller
            controller: _houseNameController,
            decoration: InputDecoration(hintText: "House name"),
          ),
          actions: <Widget>[
            new FlatButton( //Button to confirm when it is entered
              child: new Text("Cancel"),
              onPressed: () {
                _houseNameController.text = "";
                Navigator.of(context).pop();
              }
            ),
            new FlatButton( //Button to confirm when it is entered
              child: new Text("OK"),
              onPressed: () {
                if (_houseNameController.text.length == 0) {
                }
                else {
                  setState(() {
                    currentHouse = houseList.numHouses;
                    houseList.addHouse(_houseNameController.text);
                    _houseNameController.text = "";
                  //  house = houseList.houses[currentHouse];
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Saved Houses'),
        actions: <Widget> [
    /*      IconButton(
            icon: Icon( Icons.add,
                color: Colors.white
            ),
            onPressed: _newHouse,
          ),*/
          PopupMenuButton<String>(
            onSelected: _select,
            //     icon: Icon(Icons.settings,
            //     color: Colors.white),
            itemBuilder: (BuildContext context) {
              return {
                'Help',
                'New House',
                'Settings',
                'About'
              }.map((String choice) {
                return PopupMenuItem<String> (
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),

        body: ListView (/* ReorderableListView(
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              String strStore = houseList.houseName[oldIndex];
              Comps strComp = house.roomComps[oldIndex];

              if (newIndex > oldIndex) {
                newIndex -=1;
              }
              house.roomComps.removeAt(oldIndex);
              house.roomNames.removeAt(oldIndex);
              house.roomComps.insert(newIndex, strComp);
              house.roomNames.insert(newIndex, strStore);

            });
          },*/
          children: <Widget> [
            for (int index = 0; index < houseList.houseName.length; index++)
              Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    setState(() {
                      //house.roomNames.removeAt(index);
                      houseList.houseName.removeAt(index);
                      houseList.houses.removeAt(index);
                      //house.roomComps.removeAt(index);
                    });
                  },
                  background: Container(color: Colors.red),
                  confirmDismiss: (DismissDirection direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Delete Confirmation"),
                          content: const Text("Are you sure you want to delete this house?"),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text("Delete")
                            ),
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Cancel"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: ListTile(
                      key: Key('$index'),
                      onTap:  () => _selectHouse(index),
                      tileColor: index % 2 == 0 ? evenItemColor : oddItemColor,
                      title: Text('${houseList.houseName[index]}')
                  )
              )
          ],
        ),//;//);

        floatingActionButton: FloatingActionButton(
          onPressed: _newHouse,
          tooltip: 'Add Room',
          child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
