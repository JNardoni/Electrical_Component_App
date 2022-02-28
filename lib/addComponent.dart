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
/* Allows the user to do a few actions
    1. Select items from a list of components, which adds them to the advanced components in the room
    2. Add items to this and EVERY future list of components. When used
    3. Add items to ONLY this rooms list of components

 */
//Allows user to select multiple components, and add them to the main page
class _AddComp extends State<AddCompState> {

  List<String> advCompsAdd = []; //List of global adv comps which arent in the room
  List<String> changes = [];  //list of changes which have been selected to be added to the room

  //TextEditingController _backArrowController = TextEditingController();
  TextEditingController _userAddCompController = TextEditingController();
  bool lock = false; //On setup, ensures that the _advcomps is called once and only once

  String errorText = "";
  String roomName = "";

  //State initialization
  //Calls the initialize, and sets up the list of unused components, which are added to the main selection screen
  @override
  void initState() {
    super.initState();
    setState(() {});

    fetchUnusedComps();
  }

  //Returns a boolean of whether an item in the list is selected or not
  //  PARAMS - String - name of the object being questioned
  bool _isSelected(String str) {
    return changes.contains(str);
  }

  //Toggles the objeects selection status. If selected, deselects it. Otherwise selects it
  // PARAMS - String - name of object to select/deselect
  void _setSelected(String str) {
    setState(() {
      if (changes.contains(str)) { //If selected, removes it from the selection list
        changes.remove(str);
      }
      else {  //otherwise, adds it to the selection list
        changes.add(str);
      }
    });
  }

  //Confirms that the components should be added to the list
  //Returns to the previous activity with the list of components to add
  void _confirmComps() {
    Navigator.pop(context, changes);
  }

  //Fetches the list of unused adv comps from the global table in order to populate this list
  //First gets a list of all globals that have been added to the permamnt list
  //Next, gets the list of comps added to this room, and removes them from the globals list
  Future<void> fetchUnusedComps() async {

    if (lock) return; //Ensures it only runs once
    lock = true;

    //Gets a list of all global adv comps
    var list = await dbWorld.retrieveGlobals(); //list of all global adv comps
    if (list.isNotEmpty) {
      for (int i = 0; i < list.length; i++) {
        advCompsAdd.add(list[i].name);
      }
    }

    //Removes comps which have already been added to the room from the list
    var clist = await dbWorld.retrieveAdvComps(roomName); //list of all adv comps in the room
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

    //Adds the name of the new component to the list of advanced components the room uses, and then sets it to selected
    advCompsAdd.add(_userAddCompController.text);
    _setSelected(_userAddCompController.text);

    if (i == 1) { //If added to global list, adds it into the table
      addToGlobal(_userAddCompController.text);
    }

    _userAddCompController.text = "";
    return true;
  }

  //Adds a new user component to the global component table
  //  PARAMS - String - name of component to add
  Future<void> addToGlobal(String name) async {
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
      //-----------Title and icons------
      appBar: AppBar(
          title: Text("Adding to " + roomName), //Title
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
      //------Main body, a list of components to be added------
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
                        content: const Text("Are you sure you want to delete this component?"), //does nothing yet...
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
                child: ListTile(  //Each tile has its respective index
                    key: Key('$index'),
                    onTap: () => _setSelected(advCompsAdd[index]),  //Sets selected, sends name of the comp
                    title: Text('${advCompsAdd[index]}'), //Only displays component name
                    tileColor: _isSelected(advCompsAdd[index]) ? Colors.green : Colors.white, //Green if selected, white if not
                )
            )
        ],
      ),//;//);
      //Confirm changes button. No pop up, just adds
      floatingActionButton: FloatingActionButton(
        onPressed: _confirmComps,
        tooltip: 'Confirm changes',
        child: Icon(Icons.check),
      ),
    );
  }
}
