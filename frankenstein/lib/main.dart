///Imports
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:io';

dynamic topleftcornericonforbanner(int? x) {
  if (x == 0) {
    return const Icon(Icons.image);
  }
  return const Icon(Icons.home);
}

String topleftcornertextforbanner(int? x) {
  if (x == 0) {
    return "Put logo here";
  }
  return "Return to the main menu";
}

var pageLinker = {
  0: const MainMenu(),
  1: CreateACharacter(),
  2: const SearchForContent(),
  3: const MyCharacters(),
  4: const RollDice(),
  5: const CustomContent()
};

//CONTENT WILL BE ADDED IN ITS OWN FILE AND LINKED IN A SINGLE FILE WHICH CONTAINS ALL LINKED FILES AS WELL AS THEIR TYPE
//THEY WILL ALL THEN BE IMPORTED AND SORTED INTO JOINED LISTS THROUGH A BETTER REPEATING FUNCTION E.G. FOR EVERY SPELL: READ, ADD TO SPELL LIST THEN FOR EVERY WEAPON....
//Classes to unload JSON into
class Spell {
  //ADD SPELL TYPE THINGY
  final String name;
  final String effect;
  final int level;
  final String? verbal;
  final String? somatic;
  final String? material;
  factory Spell.fromJson(Map<String, dynamic> data) {
    // note the explicit cast to String
    // this is required if robust lint rules are enabled
    //COULD GO THROUGH EVERY DATA[SPELL[X,Y,Z*]] TO ALLOW LESS FILES TO BE ADDED WITH CONTENT
    final name = data['Name'] as String;
    final effect = data['Effect'] as String;
    final level = data['Level'] as int?;
    final verbal = data['Verbal'] as String?;
    final somatic = data['Somatic'] as String?;
    final material = data['Material'] as String?;
    return Spell(
        name: name,
        effect: effect,
        level: level ?? 0,
        verbal: verbal ?? "None",
        somatic: somatic ?? "None",
        material: material ?? "None");
  }
  Spell(
      {required this.name,
      required this.level,
      required this.effect,
      this.material,
      this.somatic,
      this.verbal});
}

class Weapon {
  final String name;
  final String? range;
  final List<String>? tags;
  final String damage;
  final Int weight;

  ///MAY REMOVE AND COMBINE WITH TAGS AND SET TO STRENGTH
  Weapon(
      {required this.name,
      this.range,
      this.tags,
      required this.damage,
      required this.weight});
}

//JSON unloading process
const JsonDecoder decoder = JsonDecoder();
const String filepath =
    "C:\\Users\\arieh\\OneDrive\\Documents\\Dartwork\\frankenstein\\lib\\SRDspells.json";

///file loaded as a string 'jsonString'
String jsonString = File(filepath).readAsStringSync();

///file decoded into 'jsonmap'
final dynamic jsonmap = decoder.convert(jsonString);
/*
final Spell spell = Spell.fromJson(jsonmap);
List<Spell> list = <Spell>[spell];
*/
List<Spell> list = [for (var x in jsonmap["Spells"]) Spell.fromJson(x)];
Spell listgetter(String spellname) {
  //huge issue with adding content WITH DUPLICATE NAME AND (TYPE)
  for (int x = 0; x < list.length; x++) {
    if (list[x].name == spellname) {
      return list[x];
    }
  }
  //ADD SOMETHING FOR FAILED COMPARISONS
  return list[0];
}

///file split into the spells, weapons etc...
/*List<Map<String, String>> Spelllist = jsonmap[0];
List<String> spellnames =
    Spelllist.map((x) => x["name"] ?? "NULLLISISSUESSS").toList();
Map<Weapon, dynamic> Weaponlists = jsonmap[1];*/

void main() => runApp(const Homepage());

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  //String jsonString = File(filepath).readAsStringSync();
  //late final Map<String, dynamic> jsonmap = decoder.convert(jsonString);

  static const String _title = 'Frankenstein\'s - a D&D 5e character builder';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.image),
              tooltip: 'Put logo here',
              onPressed: () {}),
          title: const Center(child: Text(_title)),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.settings),
                tooltip: 'settings??',
                onPressed: () {}),
          ],
        ),
        //appBar: AppBar(title: const Text(_title)),

        //appBar: AppBar(title: new Center(child: const Text(_title))),
        body: const MainMenu(),
      ),
    );
  }
}

class ScreenTop extends StatelessWidget {
  final int? pagechoice;
  const ScreenTop({Key? key, this.pagechoice}) : super(key: key);
  static const String _title = 'Frankenstein\'s - a D&D 5e character builder';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: topleftcornericonforbanner(pagechoice),
              tooltip: topleftcornertextforbanner(pagechoice),
              onPressed: () {
                if (pagechoice != 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ScreenTop(pagechoice: 0)));
                } /*else {
                  ////SHOW ISSUE LATER IF TIME
                }*/
              }),
          title: const Center(child: Text(_title)),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Return to the previous page',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            IconButton(
                icon: const Icon(Icons.settings),
                tooltip: 'Settings??',
                onPressed: () {}),
          ],
        ),
        //pick relevent call
        body: pageLinker[pagechoice],
      ),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.blue,
                child: const Text(
                  textAlign: TextAlign.center,
                  'Main Menu',
                  style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 100),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                side: const BorderSide(
                    width: 5, color: Color.fromARGB(255, 7, 26, 239)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScreenTop(pagechoice: 1)),
                );
              },
              child: const Text(
                textAlign: TextAlign.center,
                'Create a \ncharacter',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            const SizedBox(width: 100),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                side: const BorderSide(
                    width: 5, color: Color.fromARGB(255, 7, 26, 239)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ScreenTop(pagechoice: 2)),
                );
              },
              child: const Text(
                textAlign: TextAlign.center,
                'Search for\ncontent',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            const SizedBox(width: 100),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                side: const BorderSide(
                    width: 5, color: Color.fromARGB(255, 7, 26, 239)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ScreenTop(pagechoice: 3)),
                );
              },
              child: const Text(
                textAlign: TextAlign.center,
                'My \ncharacters',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 100),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.fromLTRB(30, 42, 30, 42),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                side: const BorderSide(
                    width: 5, color: Color.fromARGB(255, 7, 26, 239)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ScreenTop(pagechoice: 4)),
                );
              },
              child: const Text(
                'Roll dice',
                style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            const SizedBox(width: 100),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                side: const BorderSide(
                    width: 5, color: Color.fromARGB(255, 7, 26, 239)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ScreenTop(pagechoice: 5)),
                );
              },
              child: const Text(
                textAlign: TextAlign.center,
                'Custom \ncontent',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CreateACharacter extends StatefulWidget {
  @override
  MainCreateCharacter createState() => MainCreateCharacter();
}

class MainCreateCharacter extends State<CreateACharacter> {
  //const MainCreateCharacter({Key? key}) //: super(key: key);
  Spell spellExample = list.first;
  String? levellingMethod;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: DefaultTabController(
      length: 10,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              textAlign: TextAlign.center,
              'Create a character',
              style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(child: Text("Basics")),
              Tab(child: Text("Race")),
              Tab(child: Text("Class")),
              Tab(child: Text("Backround")),
              Tab(child: Text("Ability scores")),
              Tab(child: Text("Spells")),
              Tab(child: Text("Equipment")),
              Tab(child: Text("Boons and magic items")),
              Tab(child: Text("Backstory")),
              Tab(child: Text("Finishing up")),
            ],
          ),
        ),
        body: TabBarView(children: [
          Column(children: [
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    side: const BorderSide(
                        width: 2, color: Color.fromARGB(255, 7, 26, 239)),
                  ),
                  onPressed: () {},
                  child: const Text(
                    textAlign: TextAlign.center,
                    'Character info',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(width: 80),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    side: const BorderSide(
                        width: 2, color: Color.fromARGB(255, 7, 26, 239)),
                  ),
                  onPressed: () {},
                  child: const Text(
                    textAlign: TextAlign.center,
                    'Build Parameters',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(width: 80),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    side: const BorderSide(
                        width: 2, color: Color.fromARGB(255, 7, 26, 239)),
                  ),
                  onPressed: () {},
                  child: const Text(
                    textAlign: TextAlign.center,
                    'Other build parameters',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 150,
                    height: 50,
                    child: TextField(
                        cursorColor: Colors.blue,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "Enter data",
                            hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 212, 208, 224)),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 124, 112, 112),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(12))))),
              ],
            )
          ]),
          Column(children: [
            DropdownButton<String>(
              onChanged: (String? value) {
                // This is scalled when the user selects an item.
                setState(() {
                  spellExample = listgetter(value!);
                });
              },
              value: spellExample.name,
              icon: const Icon(Icons.arrow_downward),
              items: list.map<DropdownMenuItem<String>>((Spell value) {
                return DropdownMenuItem<String>(
                  value: value.name,
                  child: Text(value.name),
                );
              }).toList(),
              elevation: 2,
              style: const TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.w700),
              underline: Container(
                height: 1,
                color: Colors.deepPurpleAccent,
              ),
            ),
          ]),
          Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Row(
                children: [
                  Expanded(
                      child: Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          //mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            side: const BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 7, 26, 239)),
                          ),
                          onPressed: () {},
                          child: const Text(
                            textAlign: TextAlign.center,
                            'Character info',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                            width: 250,
                            height: 50,
                            child: TextField(
                                cursorColor: Colors.blue,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    hintText: "Enter character's name",
                                    hintStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 212, 208, 224)),
                                    filled: true,
                                    fillColor: const Color.fromARGB(
                                        255, 124, 112, 112),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(12))))),
                        //ask level or exp
                        //add switch + list tittle stuff for lvl/exp
                        const SizedBox(height: 15),
                        SizedBox(
                            width: 250,
                            height: 50,
                            child: TextField(
                                cursorColor: Colors.blue,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    hintText: "Enter the player's name",
                                    hintStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 212, 208, 224)),
                                    filled: true,
                                    fillColor: const Color.fromARGB(
                                        255, 124, 112, 112),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(12))))),
                        const SizedBox(height: 15),
                        SizedBox(
                            width: 250,
                            height: 50,
                            child: TextField(
                                cursorColor: Colors.blue,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    hintText: "Enter the character's gender",
                                    hintStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 212, 208, 224)),
                                    filled: true,
                                    fillColor: const Color.fromARGB(
                                        255, 124, 112, 112),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(12))))),
                        SizedBox(
                            width: 300,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  RadioListTile(
                                    title: const Text("Use experience"),
                                    value: "Experience",
                                    groupValue: levellingMethod,
                                    onChanged: (value) {
                                      setState(() {
                                        levellingMethod = value.toString();
                                      });
                                    },
                                  ),
                                  Container(
                                      child: levellingMethod == "Experience"
                                          ? SizedBox(
                                              width: 250,
                                              height: 50,
                                              child: TextField(
                                                  cursorColor: Colors.blue,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          "Enter the character's exp",
                                                      hintStyle: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              212,
                                                              208,
                                                              224)),
                                                      filled: true,
                                                      fillColor:
                                                          const Color.fromARGB(
                                                              255, 124, 112, 112),
                                                      border: OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide.none,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12)))))
                                          : RadioListTile(
                                              title: const Text("Use levels"),
                                              value: "Levels",
                                              groupValue: levellingMethod,
                                              onChanged: (value) {
                                                setState(() {
                                                  levellingMethod =
                                                      value.toString();
                                                });
                                              },
                                            )),
                                  Container(
                                    child: levellingMethod == "Experience"
                                        ? RadioListTile(
                                            title: const Text("Use levels"),
                                            value: "Levels",
                                            groupValue: levellingMethod,
                                            onChanged: (value) {
                                              setState(() {
                                                levellingMethod =
                                                    value.toString();
                                              });
                                            },
                                          )
                                        : SizedBox(
                                            width: 250,
                                            height: 50,
                                            child: TextField(
                                                cursorColor: Colors.blue,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                decoration: InputDecoration(
                                                    hintText:
                                                        "Enter the character's level",
                                                    hintStyle: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255,
                                                            212,
                                                            208,
                                                            224)),
                                                    filled: true,
                                                    fillColor:
                                                        const Color.fromARGB(
                                                            255, 124, 112, 112),
                                                    border: OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                12))))),
                                  ),
                                ]))
                      ])),
                  Expanded(
                      child: Column(
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          side: const BorderSide(
                              width: 2, color: Color.fromARGB(255, 7, 26, 239)),
                        ),
                        onPressed: () {},
                        child: const Text(
                          textAlign: TextAlign.center,
                          'Build Parameters',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          side: const BorderSide(
                              width: 2, color: Color.fromARGB(255, 7, 26, 239)),
                        ),
                        onPressed: () {},
                        child: const Text(
                          textAlign: TextAlign.center,
                          'Other build parameters',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ))
                ],
              )
            ],
          ),
          //const Icon(Icons.directions_bike),
          const Icon(Icons.directions_car),
          const Icon(Icons.directions_transit),
          const Icon(Icons.directions_bike),
          const Icon(Icons.directions_car),
          const Icon(Icons.directions_transit),
          const Icon(Icons.directions_bike),
          const Icon(Icons.directions_car),
        ]),
      ),
    ));
  }
}

class SearchForContent extends StatelessWidget {
  const SearchForContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.blue,
                child: const Text(
                  textAlign: TextAlign.center,
                  'Search for content',
                  style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MyCharacters extends StatelessWidget {
  const MyCharacters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.blue,
                child: const Text(
                  textAlign: TextAlign.center,
                  'My Characters',
                  style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class RollDice extends StatelessWidget {
  const RollDice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.blue,
                child: Text(
                  textAlign: TextAlign.center,
                  'Roll dice',
                  style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomContent extends StatelessWidget {
  const CustomContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.blue,
                child: Text(
                  textAlign: TextAlign.center,
                  'Custom content',
                  style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
