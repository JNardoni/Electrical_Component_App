part of 'main.dart';


//::::::::::::::::::::::::::::::::ON ROOM SELECTION::::::::::::::::::::::::::

//Calls when a room is selected
class CompsListState extends StatefulWidget {
  CompsListState({Key? key, required this.title}) : super(key: key);

  static const String routeName = "/RoomSelected";

  final String title;

  @override
  _CompsList createState() => _CompsList();
}

//Opened when a room is selected. Shows components in the room
//3 Tabs with a list of components: Basic, Advanced, Adv Text
class _CompsList extends State<CompsListState> with TickerProviderStateMixin {

  final nameController = TextEditingController();
  late TabController _tabController;
  late Comps _comps;

  String roomName = "";
  bool isEditing = false;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    //  this.dbComps = DatabaseComps();
    //  this.dbComps.initCompsDB().whenComplete(() async {
    setState(() {});

  }

  //TODO
  void _select(String choice) {

  }

  Future<void> _addAdvComp() async {

    List<String> advCompsAdd = await Navigator.pushNamed(context, AddCompState.routeName, arguments: {'roomName' : roomName}) as List<String>;

    for (int i = 0; i < advCompsAdd.length; i++) {
      Comps comp = new Comps(house: houseName, room: roomName, comp: advCompsAdd[i], isBasic: 0);
      await dbWorld.insertComp(comp);
    }
    setState(() {});
  }


  Future<void> _add(Comps comp) async {
    if (comp.count < 100) {
      comp.count = comp.count + 1;
      await dbWorld.updateComps(comp);
      setState(() {});
    }
  }

  Future<void> _subtract(Comps comp) async {
    if (comp.count > 0) {
      comp.count = comp.count - 1;
      await dbWorld.updateComps(comp);
      setState(() {});
    }
  }

  Future<void> _updateText(Comps comp, String desc) async {
    comp.desc = desc;
    await dbWorld.updateComps(comp);
    setState(() {});
  }

  //Basic component build, located in tab 1
  Widget basicCompWidget() {
    return FutureBuilder(
      future: dbWorld.retrieveBasicComps(roomName),
      builder: (BuildContext context, AsyncSnapshot<List<Comps>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, position) {
                return Container(
                    child: Row(
                      children: <Widget>[
                        Stack(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                height: 25,
                                margin: const EdgeInsets.fromLTRB(4, 1, 0, 1),
                                child: Text(snapshot.data![position].comp,
                                  //textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 21),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ]),
                        const Spacer(),
                        Container(
                            width: 30,
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              child: Text('+',
                                style: TextStyle(color: Colors.white),),
                              style: TextButton.styleFrom(
                                  minimumSize: Size(30, 20),
                                  backgroundColor: Colors.blueGrey),
                              onPressed: () => {_add(snapshot.data![position])},
                            )
                        ),
                        Container(
                          width: 39,
                          margin: const EdgeInsets.fromLTRB(1, 0, 1, 0),
                          child: Text(snapshot.data![position].count.toString(),
                            style: TextStyle(fontSize: 22),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                            width: 30,
                            margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              child: Text('-',
                                style: TextStyle(color: Colors.white),),
                              style: TextButton.styleFrom(
                                  minimumSize: Size(30, 20),
                                  backgroundColor: Colors.blueGrey),
                              onPressed: () => {_subtract(snapshot.data![position])},
                            )
                        )
                      ],
                    )
                );
              }
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }
      );
    }//
  //Advanced component build, located in tab 2
  Widget advCompWidget() {
    return FutureBuilder(
        future: dbWorld.retrieveAdvComps(roomName),
        builder: (BuildContext context, AsyncSnapshot<List<Comps>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, position) {
                  return Container(
                      child: Row(
                        children: <Widget>[
                          Stack(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  height: 25,
                                  margin: const EdgeInsets.fromLTRB(4, 1, 0, 1),
                                  child: Text(snapshot.data![position].comp,
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
                                    initialValue: snapshot.data![position].desc,
                                    onChanged: (text) {
                                      _updateText(snapshot.data![position], '$text');
                                    },
                                    onFieldSubmitted: (text) {

                                    },
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: "Description",
                                    )
                                ),
                              ),
                              ]),
                          const Spacer(),
                          Container(
                              width: 30,
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                child: Text('+',
                                  style: TextStyle(color: Colors.white),),
                                style: TextButton.styleFrom(
                                    minimumSize: Size(30, 20),
                                    backgroundColor: Colors.blueGrey),
                                onPressed: () => {_add(snapshot.data![position])},
                              )
                          ),
                          Container(
                            width: 39,
                            margin: const EdgeInsets.fromLTRB(1, 0, 1, 0),
                            child: Text(snapshot.data![position].count.toString(),
                              style: TextStyle(fontSize: 22),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                              width: 30,
                              margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                child: Text('-',
                                  style: TextStyle(color: Colors.white),),
                                style: TextButton.styleFrom(
                                    minimumSize: Size(30, 20),
                                    backgroundColor: Colors.blueGrey),
                                onPressed: () => {_subtract(snapshot.data![position])},
                              )
                          )
                        ],
                      )
                  );
                }
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute
        .of(context)!
        .settings
        .arguments as Map;
    roomName = arguments['roomName'];

    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              title: Text(roomName),
              bottom: TabBar(
                  controller: _tabController,
                  tabs: <Widget>[
                    Tab(
                      text: 'Basic',
                    ),
                    Tab(
                        text: 'Advanced'
                    ),
                  ]
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.add,
                      color: Colors.white
                  ),
                  onPressed: _addAdvComp,
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
                      return PopupMenuItem<String>(
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
                Expanded(
                  flex: 1,
                  child: SafeArea(child: basicCompWidget()),
                ),
                Expanded(
                  flex: 1,
                  child: SafeArea(child: advCompWidget()),
                ),
              ]
          ),
        )
    );
  }
}