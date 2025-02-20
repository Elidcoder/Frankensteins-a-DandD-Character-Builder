// External imports
import "package:flutter/material.dart";

// Project imports
import "pages/all_home_subpages.dart";
import "pages/custom_content_pages/all_custom_content_pages.dart" show MakeASpell;
import "main.dart";

/* A map of all the pages that can be navigated to. */
final Map<String, Widget Function()> PAGELINKER = {
  "Main Menu": () => MainMenu(),
  "Create a Character":() => CreateACharacter(),
  "Search for Content":() => SearchForContent(),
  "My Characters":() => MyCharacters(),
  "Custom Content": () => CustomContent(),
  "Create spells": () => MakeASpell(),
};

/* Takes a parameter - the page you want to go too
 * Creates a bar and the top and then displays the requested page. */
class RegularTop extends StatelessWidget {
  final String? pagechoice;
  const RegularTop({super.key, this.pagechoice});
  static const String appTitle = "Frankenstein's - a D&D 5e character builder";

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: themeNotifier,
      builder: (context, value, child) {
        return Scaffold(
        appBar: AppBar(
          foregroundColor: InitialTop.colourScheme.textColour,
          backgroundColor: InitialTop.colourScheme.backingColour,
          /* Button taking the user back to the InitialTop */
          leading: IconButton(
            icon: (pagechoice == "Main Menu") ? const Icon(Icons.image) : const Icon(Icons.home),
            tooltip: (pagechoice == "Main Menu") ? "Put logo here" : "Return to the main menu",
            onPressed: () {
              if (pagechoice != "Main Menu") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegularTop(pagechoice: "Main Menu"))
                );
              }
            }),
          title: const Center(child: Text(appTitle)),
          actions: <Widget>[
            /* Presents a back button only if one isn't generated. */
            if (pagechoice == "Main Menu") 
              IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: "Return to the previous page",
                onPressed: () {Navigator.pop(context);}
            ),

            /* Allow users to select a colour scheme */
            IconButton(
                icon: const Icon(Icons.settings),
                tooltip: "Settings",
                onPressed: () {
                  InitialTopKey.currentState?.showColorPicker(context);
                }),
          ],
        ),
        
        /* Take the user to the page they chose. */
        body: PAGELINKER[pagechoice]?.call(),
      );});
  }
}