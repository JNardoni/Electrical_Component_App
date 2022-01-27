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


int MAX_HOUSES = 50;

//int state = 0;
int currentRoom = 0;
int currentHouse = 0;

//Rooms house = new Rooms();

House houseList = new House();
Rooms house = houseList.houseRooms[currentRoom];


//String addedRoom = "";

void main() {
  runApp(MyApp());
}
/*

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
*/


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var routes= <String, WidgetBuilder>{
      RoomSelectedState.routeName: (BuildContext context) => new RoomSelectedState(title: "Comps"),
      AddElementState.routeName: (BuildContext context) => new AddElementState(title: "Elements"),
      NewCompState.routeName: (BuildContext context) => new NewCompState(title: "NewComp"),
      SelectHouseState.routeName: (BuildContext context) => new SelectHouseState(title: "SelHouse"),
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
      if(currentHouse == 0) { //Current house being -1 means it was never set, and the app never used
        _houseNameDialog(context);
      }
      super.initState();
    }

    void _newroom() async{
      //state = 0;
      final addroom = await Navigator.pushNamed(context, AddElementState.routeName) as String;

      setState(() {
       house.addroom(addroom);
      });
    }

    void _selectRoom(int i) {
      currentRoom = i;
      Navigator.pushNamed(context, RoomSelectedState.routeName);
    }

    //TODO
    void _select(String choice) {
      if (choice == "Help") {
        int i = 1;
      }
      if (choice == "New House") {

      }
    }

  void _newHouse() {
    _houseNameDialog(context);
  }

    //If there is no most recent house, an alert menu will appear, welcoming the user to the app and getting the name for a first household
    //This menu is also called when a user attempts to add a new house to the list of houses
    //Takes nothing, is inescapable
    //When the name of the house is entered, it adds the house to the house list
    //TODO: scrub house name
    Future _houseNameDialog(BuildContext context) async {
        await Future.delayed(Duration(seconds: 1));
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(   //---Alert dialog pops up----
              title: new Text(    //Top of alert: text
                  "Welcome!\n First, enter the name for the household"),
              content: TextField( //Gets the name of the house by setting it to a input controller
                controller: _houseNameController,
                decoration: InputDecoration(hintText: "House name"),
              ),
              actions: <Widget>[
                new FlatButton( //Button to confirm when it is entered
                  child: new Text("OK"),
                  onPressed: () {
                    if (_houseNameController.text.length == 0) {
                    }
                    else {
                      setState(() {
                        currentHouse = houseList.numHouses;
                        houseList.addHouse(_houseNameController.text);
                        house = houseList.houseRooms[currentHouse];
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
        title: Text('${house.houseName}'),
        actions: <Widget> [
          IconButton(
            icon: Icon( Icons.home,
                color: Colors.white
            ),
            onPressed: _newHouse,
          ),
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

      body: ReorderableListView(
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          String strStore = house.roomNames[oldIndex];
          Comps strComp = house.roomComps[oldIndex];

          if (newIndex > oldIndex) {
            newIndex -=1;
          }
          house.roomComps.removeAt(oldIndex);
          house.roomNames.removeAt(oldIndex);
          house.roomComps.insert(newIndex, strComp);
          house.roomNames.insert(newIndex, strStore);


/*          for(int i = oldIndex; i < newIndex; i++) {
            house.roomNames[i] = house.roomNames[i+1];
            house.roomComps[i] = house.roomComps[i+1];
          }

          for(int i = oldIndex; i > newIndex; i--) {
            house.roomNames[i] = house.roomNames[i-1];
            house.roomComps[i] = house.roomComps[i-1];
          }

          house.roomNames[newIndex] = strStore;
          house.roomComps[newIndex] = strComp;*/
        });
      },
        children: <Widget> [
          for (int index = 0; index < house.roomNames.length; index++)
            Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                setState(() {
                  house.roomNames.removeAt(index);
                  house.roomComps.removeAt(index);
                });
              },
              background: Container(color: Colors.red),
              confirmDismiss: (DismissDirection direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Delete Confirmation"),
                      content: const Text("Are you sure you want to delete this room?"),
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
                onTap:  () => _selectRoom(index),
                tileColor: index % 2 == 0 ? evenItemColor : oddItemColor,
                title: Text('${house.roomNames[index]}')
              )
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newroom,
        tooltip: 'Add Room',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

/*
//Calls when adding a room to the house
class AddElementState extends StatefulWidget {
  AddElementState({Key? key, required this.title}) : super(key: key);

  static const String routeName = "/AddElement";

  final String title;

  @override
  _AddElement createState() => _AddElement();
}

//The add room screen. 3 columns, 5 rows with a text box
class _AddElement extends State<AddElementState> {

  TextEditingController addController = TextEditingController(text: '');
  bool isValid = false;

  String txtToAdd = '';

  void _setTextBox(String text ) {
    setState(() {
      isValid = true;
      addController.text = text;
      txtToAdd = text;
    });
  }

  void _setValidator(valid) {
    setState(() {
      isValid = valid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${globals.title[0]}'),
      ),
      body: ListView(
        // direction: Axis.vertical,
          children: <Widget>[
            for (var index = 0; index < 5; index++)
              Container(
                  child: Row(
                      children: [
                        Spacer(flex: 1),
                        Expanded(
                            flex: 6,
                            child: ElevatedButton(
                              onPressed: () {
                                _setTextBox(globals.inputText[index * 3]);
                              },
                              child: Text(globals.inputText[index * 3]),
                            )
                        ),
                        Spacer(flex: 1),
                        Expanded(
                            flex: 6,
                            child: ElevatedButton(
                              onPressed: () {
                                _setTextBox(globals.inputText[1 + index * 3]);
                                //Navigator.pop(context);
                              },
                              child: Text(globals.inputText[1 + index * 3]),
                            )
                        ),
                        Spacer(flex: 1),
                        Expanded(
                            flex: 6,
                            child: ElevatedButton(
                              onPressed: () {
                                _setTextBox(globals.inputText[2 + index * 3]);
                              },
                              child: Text(globals.inputText[2 + index * 3]),
                            )
                        ),
                        Spacer(flex: 1),
                      ]
                  )
              ),
            Container(
              //width: 15000,
                child: Row(
                    children: <Widget>[
                      Spacer(flex: 1),
                      Expanded(
                          flex: 5,
                          child: TextFormField(
                              onChanged: (inputValue){
                                if (inputValue.isEmpty) {
                                  _setValidator(false);
                                }
                                else {
                                  txtToAdd = inputValue;
                                  _setValidator(true);
                                }
                              },
                              controller: addController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: globals.labelName[0],
                                errorText: isValid ? null : globals.errorText[0],
                              )
                          )
                      ),
                      Spacer(flex: 1),
                    ]
                )
            ),
            Container(
                width: 15000,
                child: Row(
                    children: <Widget>[
                      Spacer(flex: 5),
                      Expanded(
                          flex: 2,
                          child: ElevatedButton(
                              onPressed: () {
                                if (isValid) {
                                  Navigator.pop(context, txtToAdd);
                                }
                              },
                              child: Text('Confirm')
                          )
                      ),
                      Spacer(flex: 1),
                    ]
                )
            )
          ]
      ),
    );
  }
}
*/

/*
//::::::::::::::::::::::::::::::::ON ROOM SELECTION::::::::::::::::::::::::::

//Calls when a room is selected
class RoomSelectedState extends StatefulWidget {
  RoomSelectedState({Key? key, required this.title}) : super(key: key);

  static const String routeName = "/RoomSelected";

  final String title;

  @override
  _RoomSelected createState() => _RoomSelected();
}


//Opened when a room is selected. Shows components in the room
//3 Tabs with a list of components: Basic, Advanced, Adv Text
class _RoomSelected extends State<RoomSelectedState> with TickerProviderStateMixin {

  late TabController _tabController;
  TextEditingController advTextController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
   _tabController = TabController(length: 3, vsync:this);
  }

  void _add(int compNum, int tab) {
    setState(() {
      if (tab == 0) {
        if (house.roomComps[currentRoom].basicCompNum[compNum] < 99) {
          house.roomComps[currentRoom].basicCompNum[compNum]++;
        }
      }
      else if (tab == 1) {
        if (house.roomComps[currentRoom].advCompNum[compNum] < 99) {
          house.roomComps[currentRoom].advCompNum[compNum]++;
        }
      }
      else {
      }
    });
  }

  void _subtract(int compNum, int tab) {
    setState(() {
      if (tab == 0) {
        if (house.roomComps[currentRoom].basicCompNum[compNum] > 0) {
          house.roomComps[currentRoom].basicCompNum[compNum]--;
        }
      }
      else if (tab == 1) {
        if (house.roomComps[currentRoom].advCompNum[compNum] > 0) {
          house.roomComps[currentRoom].advCompNum[compNum]--;
        }
      }
      else {
      }
    });
  }

  //TODO - NEEDS TO BE FINISHED
  void _select(String choice) {
    if (choice == "Help") {
      int i = 1;
    }
  }

  void _addComp() {
    Navigator.pushNamed(context, NewCompState.routeName);
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            title: Text('${house.roomNames[currentRoom]}'),
            bottom: TabBar(
                controller: _tabController,
                tabs: <Widget>[
                  Tab(
                    text: 'Basic',
                  ),
                  Tab(
                      text: 'Advanced'
                  ),
                  Tab(
                    text: 'Adv Text'
                  )
                ]
            ),
          actions: <Widget> [
            IconButton(
              icon: Icon( Icons.add,
              color: Colors.white
              ),
              onPressed: _addComp,
            ),
            PopupMenuButton<String>(
              onSelected: _select,
           //     icon: Icon(Icons.settings,
           //     color: Colors.white),
              itemBuilder: (BuildContext context) {
                return {
                  'Help',
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
          ]
        ),
        body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              //Basic components in room tab
              Center(
              child: ListView.separated (
              separatorBuilder: (context, index) => Divider(
              color: Colors.black,
              ),
              itemCount: house.roomComps[currentRoom].basicCompNames.length,
              itemBuilder: (BuildContext context, int index) {
                return Container (
                child: Row (
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Text('${house.roomComps[currentRoom].basicCompNames[index]}',
                      //textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 30,
                      alignment: Alignment.centerRight,
                      child: TextButton (
                        child: Text('+',
                          style: TextStyle(color: Colors.white),),
                          style:TextButton.styleFrom(
                          minimumSize: Size(30, 20),
                          backgroundColor: Colors.blueGrey),
                        onPressed: () => {_add(index, 0)},
                      )
                    ),
                Container(
                  width: 39,
                  margin: const EdgeInsets.fromLTRB(1, 0, 1, 0),
                  child: Text('  ${ house.roomComps[currentRoom].basicCompNum[index]}',
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                    width: 30,
                    margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    alignment: Alignment.centerRight,
                    child: TextButton (
                      child: Text('-',
                        style: TextStyle(color: Colors.white),),
                      style:TextButton.styleFrom(
                          minimumSize: Size(30, 20),
                          backgroundColor: Colors.blueGrey),
                      onPressed: () => {_subtract(index, 0)},
                    )
                  )
                  ],
                )
                );
                },
                ),
                ),
              //Advanced components in room tab
              Center(
                  child: ListView.separated (
                    separatorBuilder: (context, index) => Divider(
                    color: Colors.black,
                    ),
                    itemCount: house.roomComps[currentRoom].advCompNames.length,
                    itemBuilder: (BuildContext context, int index) {
                    return Container (
                      child: Row (
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 25,
                              margin: const EdgeInsets.fromLTRB(2, 1, 0, 1),
                              child: Text('${house.roomComps[currentRoom].advCompNames[index]}',
                                //textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 21),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              width: 150,
                              height: 25,
                              margin: const EdgeInsets.fromLTRB(15, 1, 0, 1),
                              child: TextFormField(

                                //onChanged: ; //house.roomComps[currentRoom].advCompNames[] =
                                //textAlign: TextAlign.center,
                                //style: TextStyle(fontSize: 22),
                                //textAlign: TextAlign.left,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: globals.advCompsTextDefault[0],
                                  )
                              ),
                            ),
                          ]),
                        const Spacer(),
                        Container(
                        width: 30,
                        alignment: Alignment.centerRight,
                        child: TextButton (
                          child: Text('+',
                            style: TextStyle(color: Colors.white),),
                            style:TextButton.styleFrom(
                            minimumSize: Size(30, 20),
                            backgroundColor: Colors.blueGrey),
                            onPressed: () => {_add(index, 1)},
                          )
                        ),
                        Container(
                          width: 39,
                          margin: const EdgeInsets.fromLTRB(1, 0, 1, 0),
                          child: Text('  ${ house.roomComps[currentRoom].advCompNum[index]}',
                            style: TextStyle(fontSize: 22),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          width: 30,
                          margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                          alignment: Alignment.centerRight,
                          child: TextButton (
                            child: Text('-',
                              style: TextStyle(color: Colors.white),),
                              style:TextButton.styleFrom(
                              minimumSize: Size(30, 20),
                              backgroundColor: Colors.blueGrey),
                              onPressed: () => {_subtract(index, 1)},
                            )
                          )
                        ],
                        )
                      );
                    }
                  )
                ),
              //Adv Text components in room tab
                Center(
                  child: ListView.separated (
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.black,
                    ),
                    itemCount: house.roomComps[currentRoom].advText.length,
                    itemBuilder: (BuildContext context, int index) {
                  return Container (
                    child: Row (
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text('${house.roomComps[currentRoom].advText[index]}',
                        //textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22),
                        textAlign: TextAlign.left,
                        ),
                      )
                    ]
                  )
                );
                }
                )
                )
              ]
            ),
        )
    );
  }
}
*/
//:::::::::::::::::::::FOR ADDING NEW COMPONENTS::::::::::::::::::::
/*
class NewCompState extends StatefulWidget {
  NewCompState({Key? key, required this.title}) : super(key: key);

  static const String routeName = "/NewComp";

  final String title;

  @override
  _NewComp createState() => _NewComp();
}


//New component page. Opened when the '+' button is pressed in the component page
//Allows user to select multiple components, and add them to the main page
class _NewComp extends State<NewCompState> {

  List<String> advCompsAdd = [];
  List<String> changes = [];

  TextEditingController _backArrowController = TextEditingController();
  TextEditingController _userAddCompController = TextEditingController();
  bool lock = false; //On setup, ensures that the _adv comps is called once and only once

  String errorText = "";

  void _advComps() {
    for (int i = 0; i < globals.advComps.length; i++) {
      if (!house.roomComps[currentRoom].advCompNames.contains(globals.advComps[i])) {
        advCompsAdd.add(globals.advComps[i]);
      }
    }
  }

  bool _isSelected(String str) {
    return changes.contains(str);
  }

  void _setSelected(String str) {
    setState(() {
      if (changes.contains(str)) {
        changes.remove(str);
      }
      else {
        changes.add(str);
      }
    });
  }

  void _confirmComps() {

    for(int i = 0; i < changes.length; i++) {
      house.roomComps[currentRoom].advCompNames.add(changes[i]);
      house.roomComps[currentRoom].advCompNum.add(0);
    }

    Navigator.of(context).pop();
  }

  void _checkBack() {

  }

  //i - 0 if adding to room only, 1 to all list
  bool _userCompAdd(int i) {

    if (_userAddCompController.text == "") {
      return false;
    }

    advCompsAdd.add(_userAddCompController.text);
    _setSelected(_userAddCompController.text);

    if (i == 1) {
      globals.advComps.add(_userAddCompController.text);
      globals.advCompsText.add("");
    }

    _userAddCompController.text = "";
    return true;
  }

  @override
  Widget build(BuildContext context) {

    if (!lock) {
      _advComps();
      lock = true;
    }

    return Scaffold(
      appBar: AppBar(
          title: Text('${globals.titleNewCom} ${house.roomComps[currentRoom].roomName}'),
          leading:
            IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (changes.length == 0) {
                Navigator.of(context).pop();
              }
              else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(

                        title: new Text(
                            "Are you sure you want to go back to the room page? Additions will not be saved"),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text("Go back"),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          ),
                          new FlatButton(
                            child: new Text("Stay"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    }
                );
              }
            },
          ),
          actions: <Widget> [
            IconButton(
              icon: Icon( Icons.add,
                  color: Colors.white
              ),
              onPressed: () { //Allows the user to add new elements to the list of adv components
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: new Text("Enter the name for a new component"),
                      content: TextField(
                        controller: _userAddCompController,
                        decoration: InputDecoration(
                                    hintText: "House name",
                                    errorText: errorText == "" ? null : errorText,)
                      ),
                      actions: <Widget>[
                        new FlatButton(
                          child: new Text("Cancel"),
                          onPressed: () {
                            setState(() {Navigator.of(context).pop();
                            _userAddCompController.text = "";},
                          );}
                        ),
                        new FlatButton(
                          child: new Text("Add to the component list for future use"),
                            onPressed: () {
                              setState(() {
                                 (_userCompAdd(1)) ? Navigator.of(context).pop() : errorText = "Must insert a comp name";
                              });
                            },
                          ),
                        new FlatButton(
                          child: new Text("Add to this room"),
                            onPressed: () {
                                setState(() {
                                  (_userCompAdd(0)) ? Navigator.of(context).pop() : errorText = "Must insert a comp name";
                                });
                              },
                        ),
                    ],
                    );
                  },
                );
              }
            ),
      /*      PopupMenuButton<String>(
              onSelected: _select,
              //     icon: Icon(Icons.settings,
              //     color: Colors.white),
              itemBuilder: (BuildContext context) {
                return {
                  'Help',
                  'Settings',
                  'About'
                }.map((String choice) {
                  return PopupMenuItem<String> (
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),*/
          ]
      ),
      body: ListView.builder(
        itemCount: advCompsAdd.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              title: Text('${advCompsAdd[index]}'),
              tileColor: _isSelected(advCompsAdd[index]) ? Colors.green : Colors.white,
              onTap: () => _setSelected(advCompsAdd[index]),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _confirmComps,
        tooltip: 'Confirm changes',
        child: Icon(Icons.check),
      ),
    );
  }
}

*/
