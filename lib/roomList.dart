part of 'main.dart';

class RoomsListState extends StatefulWidget {
  RoomsListState({Key? key, required this.title}) : super(key: key);

  static const String routeName = "/RoomsList";

  final String title;

  @override
  _RoomsList createState() => _RoomsList();
}


//Home page - shows the list of rooms
class _RoomsList extends State<RoomsListState> {
//  late DatabaseComps dbComps; //Will contain a database for every component active in the HOUSE
//  late DatabaseRooms dbRooms; //will contain a database for every room active in the house
//  late Comps _comps;
//  late Rooms _rooms;


  //Every house has two tables associated with it. When the house is selected, it comes here.
  //This activity shows a list of all rooms added into the house.
  //The two tables: 1. _rooms. This is a list of every room which is active in the house
  //                2. _comps. This is a list of every comp which is active in the house
  //When this is first called, the _rooms and _comps tables are created. They will both be empty
  //The databases are loaded here. When a new room is added, the standard comps will always be added to that
  //_comp database.
  @override
  void initState() {
    super.initState();

    setState(() {});

  }

  //Calls the addRoom activity. This will return a string of the new room to be added. From here, goes
  //to addoreditrooms, where the room and its components can be added to the tables
  void _newroom() async {
    //state = 0;
    final addroom = await Navigator.pushNamed(context, AddElementState.routeName) as String;
    if (addroom.isNotEmpty) { //TODO untested, not sure if it was an issue?
      addOrEditRooms(addroom);
    }
  }

  //When a room is added, must add it to two tables
  //1. The Houseroom Table, which stores the room list for a single house
  //2. The HoueComp table, which stores the comp list for a single house
  Future<void> addOrEditRooms(String name) async {
    //String roomname = nameController.text;

   // Rooms room = new Rooms(room: name);
   // await addRoom(room);
   // await dbWorld.insertRoom(room); //Todo untested, same as comps

    for (int i = 0; i < globals.basicComps.length; i++) {
      Comps comps = new Comps(house: houseName, room: name, comp: globals.basicComps[i], isBasic: 1);
      await dbWorld.insertComp(comps); //TODO Untested, as opposed to calling another function for some reason
      //await addComps(comp);
    }
    setState(() {});
  }

/*  Future<int> addComps(Comps comps) async {
    return await this.dbComps.insertComp(comps);
  }*/

/*  Future<int> addRoom(Rooms room) async {
    return await this.dbRooms.insertRoom(room);
  }*/
/*
  Future<void> deleteRoom(Comps comps) async {
    return await dbWorld.deleteComps_Room(room.room);
  }*/
 //TODO go by string roomname vs comps
  void _selectRoom(String room) {
    //_rooms = rooms;
    //roomName = _rooms.room;

    Navigator.pushNamed(context, CompsListState.routeName, arguments: {'roomName': room});
  }

 // Future<int> updateRooms(Comps comps) async {
 //   return await this.dbHelper.updateHouse(house);
 // }


  Widget roomWidget() {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    return FutureBuilder(
      future: dbWorld.retrieveRooms(),
      builder: (BuildContext context, AsyncSnapshot<List<Comps>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, position) {
                return Dismissible(
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Icon(Icons.delete_forever),
                    ),
                    key: UniqueKey(),
                    onDismissed: (DismissDirection direction) async {
                     // await dbWorld.deleteRoom(snapshot.data![position].room);
                      await dbWorld.deleteComps_Room(snapshot.data![position].room);
                    },
                    confirmDismiss: (DismissDirection direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Delete Confirmation"),
                            content: Text('Are you sure you want to delete the ${snapshot.data![position]} ?'),
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
                        onTap:  () => _selectRoom(snapshot.data![position].room),
                        tileColor: position % 2 == 0 ? evenItemColor : oddItemColor,
                        title: Text('${snapshot.data![position].room}')

                  )

                /*    child: new GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _selectRoom(snapshot.data![position].room),
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
                                          snapshot.data![position].room,
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
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('${houseName}'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
                child: SafeArea(child: roomWidget()),
                ),
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