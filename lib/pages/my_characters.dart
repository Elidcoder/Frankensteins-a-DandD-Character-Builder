import "package:flutter/material.dart";

//import "package:frankenstein/character_creation_globals.dart";
import 'package:frankenstein/SRD_globals.dart';
import 'package:frankenstein/character_globals.dart';
import "package:frankenstein/PDFdocs/pdf_final_display.dart";
import "my_character_options/edit_character.dart";
import "dart:convert";
import "package:frankenstein/main.dart";

class MyCharacters extends StatefulWidget {
  @override
  MainMyCharacters createState() => MainMyCharacters();
}

class MainMyCharacters extends State<MyCharacters> {
  //MainMyCharacters({Key? key}) : super(key: key);
  String searchTerm = "";
  @override
  void initState() {
    super.initState();
    updateGlobals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              textAlign: TextAlign.center,
              "My Characters",
              style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
                child: Container(
              height: 50,
              color: Colors.grey,
              child: SizedBox(
                width: 150,
                child: TextField(
                    cursorColor: Colors.blue,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        hintText: "Character name here",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color.fromARGB(255, 212, 208, 224)),
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12)))),
                    onChanged: (searchEnteredValue) {
                      setState(() {
                        searchTerm = searchEnteredValue;
                      });
                    }),
              ),
            )),
          ]),
          const SizedBox(height: 15),
          (CHARACTERLIST.isEmpty)
              ? const Text("You have no created characters to view",
                  style: TextStyle(color: Colors.blue, fontSize: 22))
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    alignment: WrapAlignment.center,
                    children:
                        // This is the list of buttons
                        List.generate(
                            CHARACTERLIST
                                .where((element) =>
                                    element.name.contains(searchTerm))
                                .toList()
                                .length, (index) {
                      return Container(
                          width: 175,
                          height: 227,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(
                              color: const Color.fromARGB(255, 7, 26, 239),
                              width: 2,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                  width: 175.0,
                                  height: 29,
                                  //make the text fit the space
                                  child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                          CHARACTERLIST
                                              .where((element) => element.name
                                                  .contains(searchTerm))
                                              .toList()[index]
                                              .name,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white)))),
                              Text(
                                  "Level: ${CHARACTERLIST.where((element) => element.name.contains(searchTerm)).toList()[index].classList.length}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                              //Classlist output
                              SizedBox(
                                  width: 175.0,
                                  height: 20,
                                  //make the text fit the space
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child:
                                        ( //Only for characters in the searchterm
                                                CHARACTERLIST
                                                    .where((element) => element
                                                        .name
                                                        .contains(searchTerm))
                                                    .toList()[index]
                                                    //check if the character has any levels in any classes
                                                    .classList
                                                    .isNotEmpty)
                                            ? //if so:
                                            Text(
                                                //get every class
                                                CLASSLIST
                                                    .asMap()
                                                    .entries
                                                    .where(
                                                        //where the character selected has a level in it
                                                        (entry) =>
                                                            CHARACTERLIST
                                                                    //get the correct character
                                                                    .where((element) => element
                                                                        .name
                                                                        .contains(
                                                                            searchTerm))
                                                                    .toList()[index]
                                                                    .classLevels[
                                                                entry.key] !=
                                                            0)
                                                    //for each one create a string with the information on how many times that class was taken and the class name
                                                    .map((entry) =>
                                                        "${entry.value.name}: ${CHARACTERLIST.where((element) => element.name.contains(searchTerm)).toList()[index].classLevels[entry.key]}")
                                                    //Join all the strings together as the child of the fitted text widget
                                                    .join(", "),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white),
                                              )
                                            //if no classes have been taken
                                            : const Text(
                                                //display no classes...
                                                "No Classes to display",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white)),
                                  )),
                              Text(
                                  "Health: ${CHARACTERLIST.where((element) => element.name.contains(searchTerm)).toList()[index].maxHealth}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                              SizedBox(
                                  width: 175,
                                  height: 20,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                        "Group: ${CHARACTERLIST.where((element) => element.name.contains(searchTerm)).toList()[index].group ?? "Not a part of a group"}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white)),
                                  )),
                              OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.grey),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => PdfPreviewPage(
                                              invoice: CHARACTERLIST
                                                  .where((element) => element
                                                      .name
                                                      .contains(searchTerm))
                                                  .toList()[index])),
                                    );
                                  },
                                  child: const SizedBox(
                                      width: 175,
                                      child: Text(
                                          textAlign: TextAlign.center,
                                          "Open PDF",
                                          style:
                                              TextStyle(color: Colors.white)))),
                              OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple),
                                  onPressed: () {},
                                  child: const SizedBox(
                                      width: 175,
                                      child: Text(
                                          textAlign: TextAlign.center,
                                          "Generate echo",
                                          style:
                                              TextStyle(color: Colors.white)))),
                              OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.green),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Edittop(
                                              CHARACTERLIST
                                                  .where((element) => element
                                                      .name
                                                      .contains(searchTerm))
                                                  .toList()[index])),
                                    );
                                  },
                                  child: const SizedBox(
                                      width: 175,
                                      child: Text(
                                          textAlign: TextAlign.center,
                                          "Edit Character",
                                          style:
                                              TextStyle(color: Colors.white)))),
                              OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      updateGlobals();
                                      final Map<String, dynamic> json =
                                          jsonDecode(jsonString ?? "");
                                      final List<dynamic> characters =
                                          json["Characters"];

                                      final int Index = characters.indexWhere(
                                          (character) =>
                                              character["UniqueID"] ==
                                              CHARACTERLIST
                                                  .where((element) => element
                                                      .name
                                                      .contains(searchTerm))
                                                  .toList()[index]
                                                  .uniqueID);
                                      characters.firstWhere(
                                          (element) =>
                                              element["Group"] ==
                                                  CHARACTERLIST
                                                      .where((element) =>
                                                          element.name.contains(
                                                              searchTerm))
                                                      .toList()[index]
                                                      .group &&
                                              element["Name"] !=
                                                  CHARACTERLIST
                                                      .where((element) =>
                                                          element.name.contains(
                                                              searchTerm))
                                                      .toList()[index]
                                                      .name, orElse: () {
                                        final List<dynamic> groups =
                                            json["Groups"];
                                        groups.remove(CHARACTERLIST
                                            .where((element) => element.name
                                                .contains(searchTerm))
                                            .toList()[index]
                                            .group);
                                      });
                                      //final check as a safety net incase something went wrong elsewhere
                                      if (Index != -1) {
                                        characters.removeAt(Index);
                                      }
                                      writeJsonToFile(json, "userContent");
                                      updateGlobals();
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Homepage()),
                                      );
                                      showDeletionDialog(context);
                                    });
                                  },
                                  child: const SizedBox(
                                      width: 175,
                                      child: Text(
                                          textAlign: TextAlign.center,
                                          "Delete character",
                                          style:
                                              TextStyle(color: Colors.white)))),
                            ],
                          ));
                    }),
                  ),
                ),
        ]));
  }

  void showDeletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Character deleted!',
            style: TextStyle(
                color: Colors.red, fontSize: 50, fontWeight: FontWeight.w800)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
