///Imports
//import 'dart:ffi';
import 'package:flutter/material.dart';
//import 'dart:convert';
//add this back if there are errors:
//import 'package:flutter/services.dart';
//import 'dart:io';
import 'pages/customContent.dart';
import 'pages/createACharacter.dart';
import 'pages/myCharacters.dart';
import 'pages/rollDice.dart';
import 'pages/searchForContent.dart';

final Map<int, Widget> PAGELINKER = {
  0: const MainMenu(),
  1: CreateACharacter(),
  2: const SearchForContent(),
  3: const MyCharacters(),
  4: const RollDice(),
  5: const CustomContent()
};

//get rid of this later{

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
              icon: (pagechoice == 0)
                  ? const Icon(Icons.image)
                  : const Icon(Icons.home),
              tooltip: (pagechoice == 0)
                  ? "Put logo here"
                  : "Return to the main menu",
              onPressed: () {
                if (pagechoice != 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ScreenTop(pagechoice: 0)));
                }
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
        body: PAGELINKER[pagechoice],
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
                      builder: (context) => const ScreenTop(pagechoice: 1)),
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
