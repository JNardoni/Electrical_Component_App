part of 'main.dart';


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

  //TextEditingController _compDescriptController = TextEditingController();

  Rooms house = houseList.houses[currentHouse];

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

/*
  void _descriptionChanged(String descript, int index) {
    house.roomComps[currentRoom].advCompDescript.remove(index);
    house.roomComps[currentRoom].advCompDescript.insert(index, descript);

  }*/

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
                                          margin: const EdgeInsets.fromLTRB(4, 1, 0, 1),
                                          child: Text('${house.roomComps[currentRoom].advCompNames[index]}',
                                            //textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 21),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Container(
                                          width: 150,
                                          height: 25,
                                          margin: const EdgeInsets.fromLTRB(15, 29, 0, 1),
                                          child: TextFormField(
                                            initialValue: house.roomComps[currentRoom].advCompDescript[index],
                                            onChanged: (text) {
                                              //house.roomComps[currentRoom].advCompDescript.remove(index);
                                              house.roomComps[currentRoom].advCompDescript[index] = '$text';
                                            },
                                            //textAlign: TextAlign.center,
                                            //style: TextStyle(fontSize: 22),
                                            //textAlign: TextAlign.left,
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                hintText: "Description",
                                                //labelText: "Description", //house.roomComps[currentRoom].advCompDescript[index],
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