import "package:flutter/material.dart";

//import "package:frankenstein/character_creation_globals.dart";
import "package:frankenstein/globals.dart";
import "dart:collection";
import "package:flutter_multi_select_items/flutter_multi_select_items.dart";
import "package:frankenstein/PDFdocs/character_class.dart";
import "package:frankenstein/PDFdocs/pdf_final_display.dart";
import "dart:math";
import "dart:convert";
import "dart:io";

final String jsonContent = File("assets/Characters.json").readAsStringSync();
final Map<String, dynamic> json = jsonDecode(jsonContent);
//final List<dynamic> characters = json["Characters"];
final List<Character> CHARACTERLIST = [
  for (var x in json["Characters"]) Character.fromJson(x)
];

class MyCharacters extends StatefulWidget {
  @override
  MainMyCharacters createState() => MainMyCharacters();
}

class MainMyCharacters extends State<MyCharacters> {
  //MainMyCharacters({Key? key}) : super(key: key);

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
                    height: 40,
                    color: Colors.grey,
                    child: const Text(
                      "Search filters here",
                      textAlign: TextAlign.center,
                    ))),
          ]),
          Text("$CHARACTERLIST"),
        ]));

    /*Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      
      children: [
        Container(
          height: 60,
          color: Colors.blue,
          child: const Text(
            textAlign: TextAlign.center,
            "My Characters",
            style: TextStyle(
                fontSize: 45, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
        Container(
          height: 40,
          color: Colors.blue,
          child: const Text(
            textAlign: TextAlign.center,
            "Search parameters here",
            style: TextStyle(
                fontSize: 35, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
        const Text("characters here")
      ],
    );*/
  }
}
