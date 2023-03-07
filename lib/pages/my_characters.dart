import "package:flutter/material.dart";

//import "package:frankenstein/character_creation_globals.dart";
import 'package:frankenstein/SRD_globals.dart';
import "dart:collection";
import "package:flutter_multi_select_items/flutter_multi_select_items.dart";
import 'package:frankenstein/character_globals.dart';
import "package:frankenstein/PDFdocs/pdf_final_display.dart";
import "my_character_options/edit_character.dart";
import "dart:math";
import "dart:convert";
import "dart:io";

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
              ? const Text("You have no created characters to view")
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
                              Text(
                                  CHARACTERLIST
                                      .where((element) =>
                                          element.name.contains(searchTerm))
                                      .toList()[index]
                                      .name,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                              Text(
                                  "Level: ${CHARACTERLIST.where((element) => element.name.contains(searchTerm)).toList()[index].classList.length}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                              SizedBox(
                                  width: 175.0,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: (CHARACTERLIST
                                            .where((element) => element.name
                                                .contains(searchTerm))
                                            .toList()[index]
                                            .classLevels
                                            .any((x) => x != 0))
                                        ? Text(
                                            CHARACTERLIST
                                                .where((element) => element.name
                                                    .contains(searchTerm))
                                                .toList()
                                                .asMap()
                                                .entries
                                                .where((entry) =>
                                                    CHARACTERLIST
                                                            .where((element) =>
                                                                element.name
                                                                    .contains(
                                                                        searchTerm))
                                                            .toList()[index]
                                                            .classLevels[
                                                        entry.key] !=
                                                    0)
                                                .map((entry) =>
                                                    "${entry.value.name}: ${CHARACTERLIST.where((element) => element.name.contains(searchTerm)).toList()[index].classLevels[entry.key]}")
                                                .join(", "),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white),
                                          )
                                        : const Text("No Classes to display",
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
                                      final String jsonContent =
                                          File("assets/Characters.json")
                                              .readAsStringSync();
                                      final Map<String, dynamic> json =
                                          jsonDecode(jsonContent);
                                      final List<dynamic> characters =
                                          json["Characters"];
                                      String curCharacterName = CHARACTERLIST
                                          .where((element) =>
                                              element.name.contains(searchTerm))
                                          .toList()[index]
                                          .name;
                                      final int Index = characters.indexWhere(
                                          (character) =>
                                              character["Name"] ==
                                              curCharacterName);
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
                                      if (Index != -1) {
                                        characters.removeAt(Index);
                                      }
                                      File("assets/Characters.json")
                                          .writeAsStringSync(jsonEncode(json));
                                      updateGlobals();
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
}
