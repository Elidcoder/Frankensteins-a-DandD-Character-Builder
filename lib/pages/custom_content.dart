// External Import
import 'package:flutter/material.dart';

// Project Imports
import "../main.dart";

/* Serves as a linker page between the main page and the users choice of content to create. */
class CustomContent extends StatelessWidget {
  const CustomContent({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* Page title (Create content) */
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Homepage.colourScheme.textColour,
        backgroundColor: Homepage.colourScheme.backingColour,
        title: Text(
          textAlign: TextAlign.center,
          'Create content',
          style: TextStyle(fontSize: 45, fontWeight: FontWeight.w700, color: Homepage.colourScheme.textColour),
      )),
      backgroundColor: Homepage.colourScheme.backgroundColour,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /* Button taking the user to the create custom spells page */
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Homepage.colourScheme.backingColour,
                  padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  side: const BorderSide(width: 3, color: Colors.black),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ScreenTop(pagechoice: "Create spells")),
                  );
                },
                child: Text(
                  textAlign: TextAlign.center,
                  'Create a\nspell',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700, color: Homepage.colourScheme.textColour),
                ),
              ),
            ],
          ),
        ],
      ));
  }
}
