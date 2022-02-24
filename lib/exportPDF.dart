part of 'main.dart';


String monthToDate(int month) {
  switch (month) {
    case 1:
      return "January";
    case 2:
      return "Febuary";
    case 3:
      return "March";
    case 4:
      return "April";
    case 5:
      return "May";
    case 6:
      return "June";
    case 7:
      return "July";
    case 8:
      return "August";
    case 9:
      return "September";
    case 10:
      return "October";
    case 11:
      return "November";
    case 12:
      return "December";
    default:
      return "";
  }
}

//Grabs the house data from the sql databaase

//TODO sort data by room/type/something, remove unneccesarry stuff
Future<Uint8List> dataFromSQL() async {
  List<List<String>> houseComps = List<List<String>>.empty(growable: true);

  List<Comps> pdfComps = await dbWorld.retrieveCompsByHouse();

  houseComps.add(["House", "Room", "Comp", "Count", "Is Basic", "Description"]);

  while (pdfComps.isNotEmpty) {
    houseComps.add(pdfComps[0].compToPDFList());
    pdfComps.removeAt(0);
  }

  houseComps = parseBasicData(houseComps);

  return await generateDocument(houseComps);
}

//Parses basic data into a table, with the x axis as the basic components, and the y axis being the room name
// Additional columns are set up for adv components
//Look:    OT | SP | S3 | ... | advanced components <= 3
//Kitchen   0 |  1 | 3  |.... | fan: 2, overhead
//Garage    2 | 1  | 2 |...

//  PARAMS: List<List<String>> houseComps : a list of lists, where the inside lists contain the SQL tabledata for
//                                    each component that was assigned to the house selected to save as a PDF
//  Returns: a list<list<String>> Which amounts to a 2d array of for the basic components, in the style shown above
//                              list list instead of array becasuse its the input format needed in the pdf generator
List<List<String>> parseBasicData(List<List<String>> houseComps) {

  //Each room will have a place in two lists: basicComps and advComps. They will be in the same position in the two lists. The two
  //will be merged later if the room doesnt have enough adv comps to warrent having its own section
  //Basic comps format: List of basic components. [room name, 'OT','SP','S3','S4','LT','6"','4"','Fan','PH','TV','SD','CARB','PF']
  List<List<String>> basicComps = List<List<String>>.empty(growable: true);

  //Advanced comp format: List of adv components [Room name, Comp 1 name, Comp 1 Count, Comp 1 Description, Comp 2 name, Comp 2 count, etc]
  List<List<String>> advComps = List<List<String>>.empty(growable: true);

  //Creates the headers for the two lists
  basicComps.add(["Room Name", 'OT','SP','S3','S4','LT','6"','4"','Fan','PH','TV','SD','CARB','PF','']);
  advComps.add(["Room Name", "Component Name", "#", "Description"]);

  // Goes through the entire list of components, grabbing any basic ones it can find in order to build a table
  for(int i = 1; i < houseComps.length; i++) { //Starts at 1, as 0 is the header columns
    int j = 0;
    int exists = 0;

    //---------------------------------For advanced Components-------------------------------------
    if (houseComps[i][4] == '0') { //Checks if its an advanced component. 1 basic, 0 adv

      if (houseComps[i][3] != '0') { // Makes sure that there is something there. Otherwise, doesnt add
        //Goes through the list of already added rooms, checking to see if the room the component is in exists
        for (j = 1; j < advComps.length; j++) {
          if (houseComps[i][1] == advComps[j][0]) { //If the room already exists, adds the number of that component to its set location

            advComps[j].add(houseComps[i][2]); //Adds the component name
            advComps[j].add(houseComps[i][3]); //Adds the component count
            advComps[j].add(houseComps[i][5]); //Adds the component description
            exists = 1;
            break;
          }
        }

        if (exists == 0) { //If the room doesnt yet exist, creates it in both the basic and advanced lists
          basicComps.add([houseComps[i][1], '', '', '', '', '', '', '', '', '', '', '', '', '', '']); //Creates a row in basic, everything is defaulted to 0

          advComps.add([
            houseComps[i][1], //Adds the room name
            houseComps[i][2], //Adds the component name
            houseComps[i][3], //Adds the component count
            houseComps[i][5] //Adds the component description
          ]); //adds a new row with the advance comp names
        }
      }
    }

    //---------------------------------For Basic Components----------------------------------------
    else {
      //-------Check if room already exists-----------
      //Goes through the list of already added rooms, checking to see if the room the component is in exists
      for (j = 1; j < basicComps.length; j++) {
        if (houseComps[i][1] == basicComps[j][0]) { //If the room already exists, adds the number of that component to its set location

          int location = findBasicCompLocation(houseComps[i][2]); //finds the position in the axis that the component belongs.
          // Basic comps will be position 1-13, advanced will be 0

          if (houseComps[i][3] != '0' && location != 0) { //Checks if the value is 0. If it is, doesnt add it. Better to leave blank in the grid than a 0
            basicComps[j][location] = houseComps[i][3]; //Assigns the position in the basic comp grid to the count of components
          }
          exists = 1;
          break; //breaks out of this loop so it doesnt go to the default "room doesnt exist"
        }
      }

      //---------If room doesnt exist yet----------
      //If the room doesnt exist, adds it to the grid.
      if (exists == 0) {
        // Creates the entire row: First position is the component, then 1 empty spot for each basic component component
        basicComps.add([houseComps[i][1], '', '', '', '', '', '', '', '', '', '', '', '', '', '']); //Creates a row for the sheet. Room name, then the individual comps
        advComps.add([houseComps[i][1]]); //Also adds a position for the room in the advanced comps list. This list will only be used if enough adv comps exist

        int location = findBasicCompLocation(houseComps[i][2]); //finds the position in the axis that the component belongs.

        if (houseComps[i][3] != '0' && location != 0) { //Still checks to make sure that the value isnt 0. Blank > 0
          basicComps[j][location] = houseComps[i][3]; //Assigns the position in the basic comp grid to the count of components
        }
      }
    }
  }

  //------------------Merges ADV comps into basic comps if needed ----------------------------
  //There are now 2 seperate lists, one storing basic components and one storing advanced comps. In order to minimize space, an attempt is made to merge
  //as many of the two lists as possible. Up to 3 advanced components can be placed into the basic list, filling up the empty column at the end of each
  // basic list. Any room with additional adv comps will use
  //its own section on a seperate table

  for (int i = 1; i < advComps.length; i++) {
    int l = advComps[i].length;
    if (l > 0 && l < 11) { //Looks for numbers greater than the current column, but not too high in order for the room to need an extra table

      String addStrng = '';

      //Goes through the adv components of the room, adding the advanced components into the empty column in the basic components secion
      for (int j = 1; j < advComps[i].length; j+=3) {

        if (j != 1) {
          addStrng += ' | ';
        }
        addStrng = addStrng + basicComps[i][14] + advComps[i][j] + ': ' + advComps[i][j+1] + '  ' + advComps[i][j+2];
      }
      basicComps[i][14] = addStrng;
    }
  }

  return basicComps;
}

//Finds the location that the basic component will be located within the grid on the pdf
//Position based off of  OT | SP | S3 | ... |
//EX. Receives 'SP' - location returned will be 1 to parseBasicData
//    PARAMS: StringBasicCompName - a string containing the name which needs to be added to its correct location
//    returns: int - position in the grid it will go (x coordinate)
int findBasicCompLocation(String basicCompName) {
  for (int i = 0; i < globals.basicComps.length; i++) {
    if (basicCompName == globals.basicComps[i]) {
      return i+1; //Offset by 1, as the first column keeps the room name
    }
  }

  //If it gets here, its an advanced component. Returns 0 so the parse knows its advanced
  return 0;

}


List<List<String>> parseAdvData(List<List<String>> houseComps) {

  List<List<String>> advComps = List<List<String>>.empty(growable: true);




  return advComps;
}

//Using the data from the database, generates the PDF document
Future<Uint8List> generateDocument(List<List<String>> tableData) async {
  final doc = pw.Document(pageMode: PdfPageMode.outlines);

 // final font1 = await PdfGoogleFonts.openSansRegular();
 // final font2 = await PdfGoogleFonts.openSansBold();

  //First page - all basic components, and if a room only has up to three advanced components
  doc.addPage(
    pw.Page(
      pageTheme: pw.PageTheme(
        orientation: pw.PageOrientation.landscape,
        theme: pw.ThemeData.withFont(
         // base: font1,
        //  bold: font2,
        ),
      ),
      build: (context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.only(
            left: 10,
            top: 10,
          ),
          child: pw.Column(
            children: [
              pw.Spacer(),
              pw.RichText(
                  text: pw.TextSpan(children: [
                    pw.TextSpan(
                      text: monthToDate(DateTime.now().month) + ' ' +
                            DateTime.now().day.toString() + ', ' +
                            DateTime.now().year.toString() + '\n',
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 14,
                      ),
                    ),
                    pw.TextSpan(

                      text: '      '  + houseName +' household',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black,
                        fontSize: 28,
                      ),
                    ),
              ])),
              pw.Spacer(),
              pw.Table.fromTextArray(context: context, data: tableData
              ),

            ],
          ),
        );
      },
    ),
  );



  return await doc.save();
}















