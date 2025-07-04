// External Import
import "package:flutter/material.dart";

// Project Imports
import "../../main.dart" show InitialTop;
import "../../top_bar.dart";

/* Serves as a linker page between the main page and the users choice of content to create. */
class CustomContent extends StatelessWidget {
  const CustomContent({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* Page title (Create content) */
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: InitialTop.colourScheme.textColour,
        backgroundColor: InitialTop.colourScheme.backingColour,
        title: Text(
          textAlign: TextAlign.center,
          "Create content",
          style: TextStyle(fontSize: 45, fontWeight: FontWeight.w700, color: InitialTop.colourScheme.textColour),
      )),
      backgroundColor: InitialTop.colourScheme.backgroundColour,
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
                  backgroundColor: InitialTop.colourScheme.backingColour,
                  padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  side: const BorderSide(width: 3, color: Colors.black),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegularTop(pagechoice: "Create spells")),
                  );
                },
                child: Text(
                  textAlign: TextAlign.center,
                  "Create a\nspell",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700, color: InitialTop.colourScheme.textColour),
                ),
              ),
            ],
          ),
        ],
      ));
  }
}
