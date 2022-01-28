part of 'main.dart';

//:::::::::::::::::::::FOR ADDING NEW COMPONENTS::::::::::::::::::::

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

  Rooms house = houseList.houses[currentHouse];

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
      house.roomComps[currentRoom].advCompDescript.add("");
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
      //globals.advCompsText.add("");
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

