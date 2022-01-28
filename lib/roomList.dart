part of 'main.dart';



class SelectRoomState extends StatefulWidget {
  SelectRoomState({Key? key, required this.title}) : super(key: key);

  static const String routeName = "/SelectRoom";

  final String title;

  @override
  _SelectRoom createState() => _SelectRoom();
  }


//Home page - shows the list of rooms
class _SelectRoom extends State<SelectRoomState> {

  Rooms house = houseList.houses[currentHouse];

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
    if (choice == "Settings") {

    }
  }

  void _toHomeList() {
    Navigator.pop(context);
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
            onPressed: _toHomeList,
          ),
          PopupMenuButton<String>(
            onSelected: _select,
            //     icon: Icon(Icons.settings,
            //     color: Colors.white),
            itemBuilder: (BuildContext context) {
              return {
                'Help',
                'Settings',
                'About',
                'E-mail'
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
