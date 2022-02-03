part of 'main.dart';

//:::::::::::::::::::::FOR ADDING NEW COMPONENTS::::::::::::::::::::

class AddCompState extends StatefulWidget {
  AddCompState({Key? key, required this.title}) : super(key: key);

  static const String routeName = "/AddComp";

  final String title;

  @override
  _AddComp createState() => _AddComp();
}


//New component page. Opened when the '+' button is pressed in the component page
//Allows user to select multiple components, and add them to the main page
class _AddComp extends State<AddCompState> {

  //Rooms house = houseList.houses[currentHouse];

  List<String> advCompsAdd = []; //List of global adv comps which arent in the room
  List<String> changes = [];  //list of changes which have been selected to be added to the room

 // late DatabaseComps dbComps;
 // late DatabaseGlobals dbGlobals;

  TextEditingController _backArrowController = TextEditingController();
  TextEditingController _userAddCompController = TextEditingController();
  bool lock = false; //On setup, ensures that the _adv comps is called once and only once

  String errorText = "";
  String roomName = "";


  @override
  void initState() {
    super.initState();

    setState(() {});

    fetchUnusedComps();
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
    }

    //Navigator.of(context).pop();
    Navigator.pop(context, changes);
  }

  //Fetches the list of unused adv comps from the global table in order to populate this list
  //First gets a list of all globals that have been added to the permamnt list
  //Next, gets the list of comps added to this room, and removes them from the globals list
  Future<void> fetchUnusedComps() async {

    if (lock) return;
    lock = true;

    var list = await dbWorld.retrieveGlobals();
    if (list.isNotEmpty) {
      for (int i = 0; i < list.length; i++) {
        advCompsAdd.add(list[i].name);
      }
    }

    var clist = await dbWorld.retrieveAdvComps(roomName);
    if (clist.isNotEmpty) {
      for (int i = 0; i < clist.length; i++) {
        advCompsAdd.remove(clist[i].comp);
      }
    }
    setState(() {});

  }

  //Adds a new component to this component list
  //If a 0, adds to THIS ROOM ONLY
  //If a 1, adds the THE GLOBAL LIST
  bool _userCompAdd(int i) {

    if (_userAddCompController.text == "") {
      return false;
    }

    advCompsAdd.add(_userAddCompController.text);
    _setSelected(_userAddCompController.text);

    if (i == 1) {
      //globals.advComps.add(_userAddCompController.text);

      addGlobalToTable(_userAddCompController.text);
    }

    _userAddCompController.text = "";
    return true;
  }

  Future<void> addGlobalToTable(String name) async {
    Globals globalsC = new Globals(name: name);
    await dbWorld.insertGlobals(globalsC);
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute
        .of(context)!
        .settings
        .arguments as Map;
    roomName = arguments['roomName'];

    fetchUnusedComps();

    return Scaffold(
      appBar: AppBar(
          title: Text("Adding to " + roomName),
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
                          // ignore: deprecated_member_use
                          new FlatButton(
                            child: new Text("Go back"),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          ),
                          // ignore: deprecated_member_use
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
                              hintText: "Component name",
                              errorText: errorText == "" ? null : errorText,)
                        ),
                        actions: <Widget>[
                          // ignore: deprecated_member_use
                          new FlatButton(
                              child: new Text("Cancel"),
                              onPressed: () {
                                setState(() {Navigator.of(context).pop();
                                _userAddCompController.text = "";},
                                );}
                          ),
                          // ignore: deprecated_member_use
                          new FlatButton(
                            child: new Text("Add to the component list for future use"),
                            onPressed: () {
                              setState(() {
                                (_userCompAdd(1)) ? Navigator.of(context).pop() : errorText = "Must insert a comp name";
                              });
                            },
                          ),
                          // ignore: deprecated_member_use
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
          ]
      ),
      body: ListView (

        children: <Widget> [
          for (int index = 0; index < advCompsAdd.length; index++)
            Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  setState(() {
                  //TODO make comps deleteable
                   // changes.remove(advCompsAdd[index]);
                   // advCompsAdd.remove(advCompsAdd[index]);
                  //  globals.advComps.remove(advCompsAdd[index]);
                  });
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(Icons.delete_forever),
                ),
                confirmDismiss: (DismissDirection direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Delete Confirmation"),
                        content: const Text("Are you sure you want to delete this component?"),
                        actions: <Widget>[
                          // ignore: deprecated_member_use
                          FlatButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("Delete")
                          ),
                          // ignore: deprecated_member_use
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
                    onTap: () => _setSelected(advCompsAdd[index]),
                    title: Text('${advCompsAdd[index]}'),
                    tileColor: _isSelected(advCompsAdd[index]) ? Colors.green : Colors.white,
                )
            )
        ],
      ),//;//);
/*
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
*/
      floatingActionButton: FloatingActionButton(
        onPressed: _confirmComps,
        tooltip: 'Confirm changes',
        child: Icon(Icons.check),
      ),
    );
  }
}
