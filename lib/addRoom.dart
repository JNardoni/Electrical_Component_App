part of 'main.dart';


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