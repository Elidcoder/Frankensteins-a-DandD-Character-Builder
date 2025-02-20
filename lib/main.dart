// External imports
import "dart:io" show File;
import "package:flutter/material.dart";
import "package:file_picker/file_picker.dart" show FilePicker, FileType;
import "package:flutter_colorpicker/flutter_colorpicker.dart" show ColorPicker;

// Project imports
import "colour_scheme.dart";
import "file_manager.dart";
import "top_bar.dart" show RegularTop;



void main() {
  runApp(MaterialApp(
    home: InitialTop(key: InitialTopKey)
  ));
}

/* Notifier for when settings changes colour to rebuild. */
final ValueNotifier<int> themeNotifier = ValueNotifier<int>(0);

/* Create a GlobalKey for the state of InitialTop. */
final GlobalKey<InitialTopState> InitialTopKey = GlobalKey<InitialTopState>();

class InitialTop extends StatefulWidget {
  static ColourScheme colourScheme = THEMELIST.isEmpty 
    ? ColourScheme(textColour: Colors.white, backingColour: Colors.blue, backgroundColour: Colors.white) 
    : THEMELIST.last;

  const InitialTop({super.key});
  @override
  InitialTopState createState() => InitialTopState();
}

class InitialTopState extends State<InitialTop> {
  ColourScheme currentScheme = InitialTop.colourScheme;
  static const String appTitle = "Frankenstein's - a D&D 5e character builder";
  late Future<void> globalsLoaded;

  @override
  void initState() {
    super.initState();
    globalsLoaded = initialiseGlobals();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: themeNotifier,
      builder: (context, value, child) {
        return  FutureBuilder<void>(
      /* Load all required global variables */
      future: globalsLoaded,

      /* keep running until the app is built successfully (globals loaded) */
      builder: (context, snapshot) {

        /* If initialiseGlobals is successfull, return MaterialApp */
        if (snapshot.connectionState == ConnectionState.done) {

          /* Load up the previously used colour scheme. */
          if (THEMELIST.isNotEmpty) {
            InitialTop.colourScheme = THEMELIST.last;
            currentScheme = THEMELIST.last;
          }

          /* Create the bar at the top with app name, settings and logo.*/
          return MaterialApp(
            theme: ThemeData(primaryColor: InitialTop.colourScheme.textColour),
            title: appTitle,
            home: Scaffold(
              appBar: AppBar(
                foregroundColor: InitialTop.colourScheme.textColour,
                backgroundColor: InitialTop.colourScheme.backingColour,
                leading: IconButton(
                    icon: const Icon(Icons.image),
                    tooltip: "Put logo here",
                    onPressed: () {}),
                title: const Center(child: Text(appTitle)),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.settings),
                    tooltip: "Settings",
                    onPressed: () {
                      showColorPicker(context);
                    },
                  ),
                ],
              ),

              /* Create the main menu as the body */
              body: MainMenu(),
            ),
          );

        /* if saveChanges is still running, output some text to let the user know */
        } else {
          return const Center(
            child: Text(
              "Please wait while the application saves or loads data",
              style: TextStyle(color: Colors.blue, fontSize: 30),
            ),
          );
        }
      },
    );});
  }

  /* Returns a popup that allows the user to change the app's colour scheme. */ 
  void showColorPicker(BuildContext context) {
    int? selectedIndex;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
        builder: (context, setState) { 
        return Stack(
          children: [
            const Opacity(opacity: 0.5, child: ModalBarrier(dismissible: false, color: Colors.grey)),
            /* Settings menu (choosing colours). */
            AlertDialog(
              title: const Text("Settings", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    /* Selection of backing colour */
                    ...styledSeperatedText("Select box colours:"),
                    ColorPicker(
                      pickerColor: currentScheme.backingColour,
                      onColorChanged: (color) {
                        currentScheme.backingColour = color;
                      },
                    ),

                    /* Selection of text colour */
                    ...styledSeperatedText("Select text colour:"),
                    ColorPicker(
                      pickerColor: currentScheme.textColour,
                      onColorChanged: (color) {
                        currentScheme.textColour = color;
                      },
                    ),

                    /* Selection of background colour */
                    ...styledSeperatedText("Select background colour:"),
                    ColorPicker(
                      pickerColor: currentScheme.backgroundColour,
                      onColorChanged: (color) {
                        currentScheme.backgroundColour = color;
                      },
                    ),

                    /* User can instead make use of a previous colour combination. */
                    ...styledSeperatedText("Or choose a theme:"),
                    SizedBox(
                      height: 300,
                      width: 307,
                      child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 15);
                        },
                        itemCount: THEMELIST.length,
                        itemBuilder: (BuildContext context, int index) {
                          /* Create a mini version of the home screen matching each 
                          * previous set of colours to give a visualisation to the user */
                          return SizedBox(
                            width: 305,
                            height: 180,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: THEMELIST.reversed.toList()[index].backgroundColour,
                                /* Highlight the selected colour with a thicker boarder */
                                side: (selectedIndex == index) ? BorderSide(width: 7, color: Colors.amber) :BorderSide(width: 0.7, color: Colors.black),
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                              ),
                              child: Column(
                                children: [
                                  /* Mini and simplified version of the app title bar. */
                                  Container(
                                    width: 305,
                                    height: 18,
                                    color: THEMELIST.reversed.toList()[index].backingColour,
                                    child: Text(
                                      "Frankensteins  - a D&D 5e character builder:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 9,
                                        color: THEMELIST.reversed.toList()[index].textColour),
                                      textAlign: TextAlign.center,
                                  )),
                                  
                                  /* Mini version of the page title bar. */
                                  Container(
                                    width: 305,
                                    height: 18,
                                    color: THEMELIST.reversed.toList()[index].backingColour,
                                    child: Text("Main Menu",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        color: THEMELIST.reversed.toList()[index].textColour
                                      ),
                                      textAlign: TextAlign.center
                                  )),
                                  const SizedBox(height: 28),

                                  /* Mini versions of the buttons on the main page. */
                                  Center(
                                    child: Row(
                                      children: [
                                        /* Mini version of the button that takes the user to the create_a_character page */
                                        const SizedBox(width: 21),
                                        buildStyledMockButton("Create a \n character", index),
                                        
                                        /* Mini version of the button that takes the user to the search_for_content page */
                                        const SizedBox(width: 27.5),
                                        buildStyledMockButton("Search for\nContent", index),

                                        /* Mini version of the button that takes the user to the my_characters page */
                                        const SizedBox(width: 27.5),
                                        buildStyledMockButton("My\nCharacters", index)

                                      ],
                                )),
                                const SizedBox(height: 25),
                                Center(
                                  child: Row(
                                    children: [
                                      /* Mini version of the button that makes the download content popup */
                                      const SizedBox(width: 50),
                                      buildStyledMockButton("Download\nContent", index),
                                      
                                      /* Mini version of the button that takes the user to the create_content page */
                                      const SizedBox(width: 27.5),
                                      buildStyledMockButton("Create\nContent", index)
                                  ],
                                ))
                              ]),
                              onPressed: () {
                                setState(() {
                                  selectedIndex = index;
                                  currentScheme = THEMELIST.reversed.toList()[index];
                                });
                              },
                            ));
                        },
                      )),
                  ])),
              actions: [
                TextButton(
                  onPressed: () {Navigator.of(context).pop();},
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                      InitialTop.colourScheme = currentScheme;
                      
                      // Put current colour scheme at the top of the list
                      THEMELIST.removeWhere((theme) => currentScheme.isSameColourScheme(theme));
                      THEMELIST.add(currentScheme);
                      saveChanges();

                      // Increment notifier to trigger rebuilds and remove popup.
                      themeNotifier.value++;
                      Navigator.of(context).pop();
                    
                  },
                  child: const Text("Save settings"),
                ),
              ],
            ),
          ],
        );
        });
      },
    );
  }

  /* Builds a fake version of a button styled to look like a given colour scheme. */
  Widget buildStyledMockButton(String text, int index) {
    return Container(
      width: 61,
      height: 31,
      decoration: BoxDecoration(
        color: THEMELIST.reversed.toList()[index].backingColour,
        borderRadius:const BorderRadius.all(Radius.circular(4))),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 10,
          color: THEMELIST.reversed.toList()[index].textColour),
        textAlign: TextAlign.center
      )
    );
  }

  /* Return a text widget of the given text followed by a small space. */
  List<Widget> styledSeperatedText(String text){
    return [
      Text(
        text,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 9),
  ];}
}

/* Displays the 5 buttons that take you to other pages as well as the floating button
 * Note: This should not be moved into "initialtop" as it is used elsewhere */
class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  MainMenuState createState() => MainMenuState();
}
class MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: InitialTop.colourScheme.textColour,
        backgroundColor: InitialTop.colourScheme.backingColour,
        title: Text(
          textAlign: TextAlign.center,
          "Main Menu",
          style: TextStyle(fontSize: 45, fontWeight: FontWeight.w700, color: InitialTop.colourScheme.textColour),
      )),
      backgroundColor: InitialTop.colourScheme.backgroundColour,
      floatingActionButton: FloatingActionButton(
        tooltip: "Help and guidance",
        foregroundColor: InitialTop.colourScheme.textColour,
        backgroundColor: InitialTop.colourScheme.backingColour,
        onPressed: () {
          _showInfoAndHelp(context);
        },
        child: const Icon(
          Icons.info,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 80),
          /* Row containing the create character, search for content and my characters buttons. */
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /* Create a character button. */
              buildStyledButton("Create a \ncharacter", "Create a Character", context),
              const SizedBox(width: 120),

              /* Search for content button */
              buildStyledButton("Search for\ncontent", "Search for Content", context),
              const SizedBox(width: 120),

              /* My characters button */
              buildStyledButton("My \ncharacters", "My Characters", context)
            ],
          ),
          const SizedBox(height: 120),

          /* Row containing the download content and create content buttons */
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /* Download content button */
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: InitialTop.colourScheme.backingColour,
                  padding: const EdgeInsets.fromLTRB(45, 25, 45, 25),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  side: const BorderSide(width: 3.3, color: Colors.black),
                ),
                /* Get the target file. */
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    dialogTitle: "Navigate to and select a Json file to download the contents from, this content can then be used in your characters",
                    type: FileType.custom,
                    allowedExtensions: ["json"],
                  );

                  /* If a matching file is found read it as a file */
                  if (result != null) {
                    final targetFile = File(result.files.single.path ?? "PATH SHOULD NEVER OCCUR");

                    /* Attempt to add the contents of the file to the LISTS */
                    try {
                      addToGlobalsFromFile(targetFile);
                      await saveChanges();
                    }
                    catch (e) {
                      if (mounted) {
                        // ignore: use_build_context_synchronously (mounted check ensures correctness)
                        showErrorDialog(context);
                      }
                    }
                  }
                },
                child: Text(
                  "Download\n Content",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700, color: InitialTop.colourScheme.textColour),
                ),
              ),
              const SizedBox(width: 100),

              /* Create content button */
              buildStyledButton("Create \ncontent", "Custom Content", context)
            ],
          ),
        ],
      ));
  }

  /* Builds a button that takes the user to another page. */
  OutlinedButton buildStyledButton(String text, String pagechoice, BuildContext context){
    return OutlinedButton(
    style: OutlinedButton.styleFrom(
      backgroundColor: InitialTop.colourScheme.backingColour,
      padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      side: const BorderSide(width: 3.3, color: Colors.black),
    ),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegularTop(pagechoice: pagechoice)),
      );
    },
    child: Text(
      textAlign: TextAlign.center,
      text,
      style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700, color: InitialTop.colourScheme.textColour),
    )
  );
  }

  /* Displays a popup with helpfull information for new users. */
  void _showInfoAndHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            const Opacity(
              opacity: 0.5,
              child: ModalBarrier(dismissible: false, color: Colors.grey),
            ),
            AlertDialog(
              /* Title */
              title: const Text("Help and information", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
              content: SingleChildScrollView(
                  child: Column(children: [

                    /* Display an overview of the app with a subtitle */
                    const Text(
                      "App overview",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 9),
                    buildStyledBulletPoint('''• Main Menu - This is the section you are currently in, \nit allows you to navigate between every section.'''),
                    buildStyledBulletPoint('''• Create a Character - This is the section to build your character,\nit contains tabs which will guide you through the creation process.'''),
                    buildStyledBulletPoint('''• Search for Content - This is the section to look through your content,\nit allows you to search through and delete much of that content.'''),
                    buildStyledBulletPoint('''• My Characters -  This is the section to look through your characters,\nit allows you to search through, delete, edit and get their PDF.'''),
                    buildStyledBulletPoint('''• Download Content -  This is a button to install content,\nit allows you to select content to install from your computer.'''),
                    buildStyledBulletPoint('''• Create Content -  This is the section to create new content,\nit takes you to another page to select the type of content. Once there,\nyou can create that type of content, saving it to your app.'''),
                    const SizedBox(height: 9),

                    /* Display information on how to report a bug or ask for help */
                    const Text(
                      "Report a bug or ask for help:",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 9),
                    const Text(
                      '''This is an open source project, to report bugs, \nask for help or suggest improvements please go to:\nhttps://github.com/Elidcoder/Frankensteins-a-DandD-Character-Builder''',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ])),
              actions: [
                TextButton(
                  onPressed: () {Navigator.of(context).pop();},
                  child: const Text("OK"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /* Generate a bullet point of a string input. */
  Row buildStyledBulletPoint(String text) {
    return Row(children: [
      Expanded(child: Text(text, style: const TextStyle(fontSize: 20)))
    ]);
  }

  /* Display an error dialogue letting the user know that the download was bad. */
  void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("Json format incorrect, reformat and try again!",
          style: TextStyle(color: Colors.red, fontSize: 45, fontWeight: FontWeight.w800)),
        actions: [
          TextButton(
            onPressed: () {Navigator.of(context).pop();},
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }
}
