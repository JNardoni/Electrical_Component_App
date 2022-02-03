import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';

import 'globals.dart' as globals;

part 'structHouse.dart';
part 'structComp.dart';
//part 'structRoom.dart';
part 'structGlobals.dart';

part 'databaseHouses.dart';
//part 'databaseComps.dart';
//part 'databaseRooms.dart';
//part 'databaseGlobals.dart';

part 'roomList.dart';
part 'componentList.dart';

part 'addComponent.dart';
part 'addRoom.dart';


String houseName = ""; //TODO pass it along instead of global
//String roomName = "";
late DatabaseHouses dbWorld;


void main() {
  runApp(RoomsHomePage());
}

class RoomsHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var routes = <String, WidgetBuilder>{
      CompsListState.routeName: (BuildContext context) => new CompsListState(title: "CompsList"),
      AddElementState.routeName: (BuildContext context) => new AddElementState(title: "Elements"),
      AddCompState.routeName: (BuildContext context) => new AddCompState(title: "AddComp"),
      //SelectHouseState.routeName: (BuildContext context) => new SelectHouseState(title: "SelHouse"),
      RoomsListState.routeName: (BuildContext context) => new RoomsListState(title: "RoomsList"),
    };

    return MaterialApp(
      title: 'Electrical Component Mapping',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MainApp(title: 'Electrical Mapping'),
      routes: routes,
    );
  }
}

class MainApp extends StatefulWidget {
  MainApp({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final nameController = TextEditingController();
  late Houses _house;
/*  final ColorScheme colorScheme = Theme.of(context).colorScheme;
  final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
  final Color evenItemColor = colorScheme.primary.withOpacity(0.15);*/


  @override
  void initState() {
    super.initState();
    dbWorld = DatabaseHouses();
    dbWorld.initWorldDB().whenComplete(() async {
      setState(() {});

      buildGlobals();      
    });
  }

  //Build globals will only be fully run once, when the user is first opening up the app. It builds a list of global advanced comps,
  //which will be used to populate the later arrays
  //TODO - Store it in an "is opened" key, can technically be called more times if the user deletes all info. Combine key with tutorial
  Future<void> buildGlobals() async {
    var clist = await dbWorld.retrieveGlobals();

    if (clist.isEmpty) {
        for (int i = 0; i < globals.advComps.length; i++) {
          Globals globalsC = new Globals(name: globals.advComps[i]);
          await dbWorld.insertGlobals(globalsC);
        }
        _houseNameDialog(context);
    }
  }

  //Checks to see if a name will be valid to be added to a house
  //This name will be used in the tablenames for both rooms and components, meaning it must be valid for SQL
  //Must start with a letter, allows no special symbols (Spaces are ok, turned into underscores
  bool checkValidNames(String name, BuildContext context) {

    if (name.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('House must have a name')));
      return false;
    }
    else if (name.length > 40) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('House name is too long')));
      return false;
    }

    //name = name.replaceAll(' ', '_');

    if (!RegExp(r"^[a-zA-Z0-9_ ]+$").hasMatch(name)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Houses may only contain letters, numbers, spaces, and underscores')));
      return false;
    }
  /*  else if (!RegExp(r"^[a-zA-Z]+$").hasMatch('${name[0]}')) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Houses must start with a letter')));
      return false;
    }*/
    return true;
  }


  Future<bool> addOrEditHouse(BuildContext context) async {
    String name = nameController.text;

    //name = name.replaceAll(' ', '_');

    //Check to make sure the house name doesnt already exist
    var currentHouses =  await dbWorld.retrieveHouses();

    for (int i = 0; i < currentHouses.length; i++) {
        if (currentHouses[i].house.compareTo(name) ==0) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('A house with this name already exists')));
          return false;
        }
    }
    Navigator.of(context).pop();

    Houses house = new Houses(house: name);
    await addHouse(house);

    nameController.clear();
    setState(() {});

    return true;
  }

  //Calls databaseHelper query to insert the to be added house
  Future<int> addHouse(Houses house) async {
    return await dbWorld.insertHouse(house);
  }

  //UNUSED
  //Calls an update to the house
  Future<int> updateHouse(Houses house) async {
    return await dbWorld.updateHouse(house);
  }

  //When the button to add a house is pushed, it goes here
  //Callse the alert dialog to give the user a chance to enter a new house name
  void _newHouse() {
    _houseNameDialog(context);
  }

  //When A house is selected, it goes here
  //Calls the new activity, which is the list of rooms located inside that house
  void _selectHouse(Houses house) {
    _house = house;
    houseName = _house.house;

    Navigator.pushNamed(context, RoomsListState.routeName);
  }

  //If there is no most recent house, an alert menu will appear, welcoming the user to the app and getting the name for a first household
  //This menu is also called when a user attempts to add a new house to the list of houses
  //Takes nothing, is inescapable
  //When the name of the house is entered, it adds the house to the house list
  Future _houseNameDialog(BuildContext context) async {
    await Future.delayed(Duration(seconds: 0));
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog( //---Alert dialog pops up----
            title: new Text( //Top of alert: text
                "Welcome!\nFirst, enter the name for the household"),
            content: TextField( //Gets the name of the house by setting it to a input controller
              controller: nameController,
              decoration: InputDecoration(hintText: "House name"),
            ),
            actions: <Widget>[
              // ignore: deprecated_member_use
              new FlatButton( //Button to confirm when it is entered
                  child: new Text("Cancel"),
                  onPressed: () {
                    nameController.text = "";
                    Navigator.of(context).pop();
                  }
              ),
              new FlatButton( //Button to confirm when it is entered
                child: new Text("OK"),
                onPressed: () {
                  if (checkValidNames(nameController.text, context)) {
                    addOrEditHouse(context);
                  }
                },
              ),
            ],
          );
        });
  }


  Widget houseWidget() {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    return FutureBuilder(
      future: dbWorld.retrieveHouses(),
      builder: (BuildContext context, AsyncSnapshot<List<Houses>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, position) {
                return Dismissible (
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Icon(Icons.delete_forever),
                    ),
                    key: UniqueKey(),
                      //TODO drop tables does seem to be working
                    onDismissed: (DismissDirection direction) async {
                      houseName = snapshot.data![position].house;

                      await dbWorld.deleteHouse(snapshot.data![position].house);
                      setState(() {});

                      await dbWorld.deleteComps_House(snapshot.data![position].house);

                    },
                    confirmDismiss: (DismissDirection direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                     return AlertDialog(
                            title: const Text("Delete Confirmation"),
                            content: Text('Are you sure you want to delete ${snapshot.data![position].house} ?'),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("Delete")
                              ),
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("Cancel"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: ListTile(
                        key: Key('$position'),
                        onTap:  () => _selectHouse(snapshot.data![position]),
                        tileColor: position % 2 == 0 ? evenItemColor : oddItemColor,
                        title: Text('${snapshot.data![position].house}')
                    )


             /*       child: new GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _selectHouse(snapshot.data![position]),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        12.0, 12.0, 12.0, 6.0),
                                    child: Text(
                                      snapshot.data![position].house,
                                      style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black26,
                                          borderRadius:
                                          BorderRadius.circular(100)),
                                      )
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Divider(
                            height: 2.0,
                            color: Colors.grey,
                          )
                        ],
                      ),]
                    ))*/
                );
              });
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
   // final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Saved Houses'),
        actions: <Widget>[
          /*      IconButton(
            icon: Icon( Icons.add,
                color: Colors.white
            ),
            onPressed: _newHouse,
          ),*/
          PopupMenuButton<String>(
            //   onSelected: _select, TODO add menus
            //     icon: Icon(Icons.settings,
            //     color: Colors.white),
            itemBuilder: (BuildContext context) {
              return {
                'Help',
                'New House',
                'Settings',
                'About'
              }.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: new Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: SafeArea(child: houseWidget()),
                  )
                ],
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newHouse,
        tooltip: 'Add house',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}