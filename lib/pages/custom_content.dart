// Imports
import 'package:flutter/material.dart';
import "../file_manager.dart";
import "package:frankenstein/main.dart";

void main() {
  //updateSRDGlobals();
  runApp(const CustomContent());
}

class CustomContent extends StatelessWidget {
  const CustomContent({super.key});
  @override
  Widget build(BuildContext context) {
    updateGlobals();
    return Scaffold(
        backgroundColor: Homepage.backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Homepage.backingColor,
                    child: Text(
                      textAlign: TextAlign.center,
                      'Create content',
                      style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.w700,
                          color: Homepage.textColor),
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
                    backgroundColor: Homepage.backingColor,
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
                          builder: (context) =>
                              const ScreenTop(pagechoice: "Create spells")),
                    );
                  },
                  child: Text(
                    textAlign: TextAlign.center,
                    'Create a\nspell',
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w700,
                        color: Homepage.textColor),
                  ),
                ),
                const SizedBox(width: 100),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Homepage.backingColor,
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
                          builder: (context) =>
                              const ScreenTop(pagechoice: "Create items")),
                    );
                  },
                  child: Text(
                    textAlign: TextAlign.center,
                    'Create an\nItem',
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w700,
                        color: Homepage.textColor),
                  ),
                ),
                const SizedBox(width: 100),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Homepage.backingColor,
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
                          builder: (context) =>
                              const ScreenTop(pagechoice: "Create weapons")),
                    );
                  },
                  child: Text(
                    textAlign: TextAlign.center,
                    'Create a\n weapon',
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w700,
                        color: Homepage.textColor),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
