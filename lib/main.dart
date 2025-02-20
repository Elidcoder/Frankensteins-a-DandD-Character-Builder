// External imports
import "package:flutter/material.dart";
import "file_manager.dart";
import "dart:io";
import "package:file_picker/file_picker.dart";
import "package:flutter_colorpicker/flutter_colorpicker.dart";

// Project imports
import "pages/all_home_subpages.dart";
import "content_classes/all_content_classes.dart";
import "pages/custom_content_pages/all_custom_content_pages.dart";

// ignore: non_constant_identifier_names
final Map<String, Widget Function()> PAGELINKER = {
  "Main Menu": () => MainMenu(),
  "Create a Character":() => CreateACharacter(),
  "Search for Content":() => SearchForContent(),
  "My Characters":() => MyCharacters(),
  "Custom Content": () => CustomContent(),
  "Create spells": () => MakeASpell(),
};

void main() {
  runApp(MaterialApp(
    home: Homepage(key: homepageKey)
  ));
}

/* Notifier for when settings changes colour to rebuild. */
final ValueNotifier<int> themeNotifier = ValueNotifier<int>(0);

/* Create a GlobalKey for the state of Homepage. */
final GlobalKey<MainHomepageState> homepageKey = GlobalKey<MainHomepageState>();

class Homepage extends StatefulWidget {
  static Color textColor = COLORLIST.isEmpty ? Colors.white : COLORLIST.last[0];
  static Color backingColor = COLORLIST.isEmpty ? Colors.blue : COLORLIST.last[1];
  static Color backgroundColor = COLORLIST.isEmpty ? Colors.white : COLORLIST.last[2];

  const Homepage({super.key});
  @override
  MainHomepageState createState() => MainHomepageState();
}

class MainHomepageState extends State<Homepage> {
  Color currentTextColor = Homepage.textColor;
  Color currentBackingColor = Homepage.backingColor;
  Color currentBackgroundColor = Homepage.backgroundColor;

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
          if (COLORLIST.isNotEmpty) {
            Homepage.backgroundColor = COLORLIST.last[2];
            Homepage.backingColor = COLORLIST.last[1];
            Homepage.textColor = COLORLIST.last[0];
            currentTextColor = COLORLIST.last[0];
            currentBackingColor = COLORLIST.last[1];
            currentBackgroundColor = COLORLIST.last[2];
          }

          /* Create the bar at the top with app name, settings and logo.*/
          return MaterialApp(
            theme: ThemeData(primaryColor: Homepage.textColor),
            title: appTitle,
            home: Scaffold(
              appBar: AppBar(
                foregroundColor: Homepage.textColor,
                backgroundColor: Homepage.backingColor,
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
                      pickerColor: currentBackingColor,
                      onColorChanged: (color) {
                        currentBackingColor = color;
                      },
                    ),

                    /* Selection of text colour */
                    ...styledSeperatedText("Select text colour:"),
                    ColorPicker(
                      pickerColor: currentTextColor,
                      onColorChanged: (color) {
                        currentTextColor = color;
                      },
                    ),

                    /* Selection of background colour */
                    ...styledSeperatedText("Select background colour:"),
                    ColorPicker(
                      pickerColor: currentBackgroundColor,
                      onColorChanged: (color) {
                        currentBackgroundColor = color;
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
                        itemCount: COLORLIST.reversed.toList().length,
                        itemBuilder: (BuildContext context, int index) {
                          /* Create a mini version of the home screen matching each 
                          * previous set of colours to give a visualisation to the user */
                          return SizedBox(
                            width: 305,
                            height: 180,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: COLORLIST.reversed.toList()[index][2],
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
                                    color: COLORLIST.reversed.toList()[index][1],
                                    child: Text(
                                      "Frankensteins  - a D&D 5e character builder:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 9,
                                        color: COLORLIST.reversed.toList()[index][0]),
                                      textAlign: TextAlign.center,
                                  )),
                                  
                                  /* Mini version of the page title bar. */
                                  Container(
                                    width: 305,
                                    height: 18,
                                    color: COLORLIST.reversed.toList()[index][1],
                                    child: Text("Main Menu",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        color: COLORLIST.reversed.toList()[index][0]
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
                                        Container(
                                          width: 60,
                                          height: 31,
                                          decoration: BoxDecoration(
                                            color: COLORLIST.reversed.toList()[index][1],
                                            borderRadius: const BorderRadius.all(Radius.circular(4))),
                                          child: Text("Create a \n character",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 10,
                                              color: COLORLIST.reversed.toList()[index][0]),
                                            textAlign: TextAlign.center)),
                                        
                                        /* Mini version of the button that takes the user to the search_for_content page */
                                        const SizedBox(width: 27.5),
                                        Container(
                                          width: 60,
                                          height: 31,
                                          decoration: BoxDecoration(
                                            color: COLORLIST.reversed.toList()[index][1],
                                            borderRadius: const BorderRadius.all(Radius.circular(4))),
                                          child: Text("Search for\nContent",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 10,
                                              color: COLORLIST.reversed.toList()[index][0]),
                                            textAlign: TextAlign.center
                                        )),

                                        /* Mini version of the button that takes the user to the my_characters page */
                                        const SizedBox(width: 27.5),
                                        Container(
                                          width: 60,
                                          height: 31,
                                          decoration: BoxDecoration(
                                            color: COLORLIST.reversed.toList()[index][1],
                                            borderRadius:const BorderRadius.all(Radius.circular(4))),
                                          child: Text("My\nCharacters",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 10,
                                              color: COLORLIST.reversed.toList()[index][0]),
                                            textAlign: TextAlign.center)),
                                      ],
                                )),
                                const SizedBox(height: 25),
                                Center(
                                  child: Row(
                                    children: [
                                      /* Mini version of the button that makes the download content popup */
                                      const SizedBox(width: 50),
                                      Container(
                                        width: 74,
                                        height: 31,
                                        decoration: BoxDecoration(
                                          color: COLORLIST.reversed.toList()[index][1],
                                          borderRadius: const BorderRadius.all(Radius.circular(4))),
                                        child: Text(
                                          "Download\nContent",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10,
                                            color: COLORLIST.reversed.toList()[index][0]),
                                          textAlign: TextAlign.center)),
                                      
                                      /* Mini version of the button that takes the user to the create_content page */
                                      const SizedBox(width: 27.5),
                                      Container(
                                        width: 74,
                                        height: 31,
                                        decoration: BoxDecoration(
                                          color: COLORLIST.reversed.toList()[index][1],
                                          borderRadius: const BorderRadius.all(Radius.circular(4))),
                                        child: Text("Create\nContent",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10,
                                            color: COLORLIST.reversed.toList()[index][0]
                                          ),
                                          textAlign: TextAlign.center)),
                                  ],
                                ))
                              ]),
                              onPressed: () {
                                setState(() {
                                  selectedIndex = index;
                                  currentTextColor = COLORLIST.reversed.toList()[index][0];
                                  currentBackingColor = COLORLIST.reversed.toList()[index][1];
                                  currentBackgroundColor = COLORLIST.reversed.toList()[index][2];
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
                      Homepage.textColor = currentTextColor;
                      Homepage.backingColor = currentBackingColor;
                      Homepage.backgroundColor = currentBackgroundColor;
                      
                      
                      // Put current colour scheme at the top of the list
                      COLORLIST.removeWhere((colours) =>
                          (colours.first.value == Homepage.textColor.value && 
                          colours[2].value == Homepage.backingColor.value && 
                          colours[3].value == Homepage.backgroundColor.value ));
                      COLORLIST.add([
                        Homepage.textColor,
                        Homepage.backingColor,
                        Homepage.backgroundColor
                      ]);
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

  List<Widget> styledSeperatedText(String text){
    return [
      Text(
        text,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 9),
  ];}
}

class ScreenTop extends StatelessWidget {
  final String? pagechoice;
  static Color textColor = Homepage.textColor;
  static Color backingColor = Homepage.backingColor;
  static Color backgroundColor = Homepage.backgroundColor;
  const ScreenTop({super.key, this.pagechoice});
  static const String appTitle = "Frankenstein's - a D&D 5e character builder";

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: themeNotifier,
      builder: (context, value, child) {
        return Scaffold(
        appBar: AppBar(
          foregroundColor: Homepage.textColor,
          backgroundColor: Homepage.backingColor,
          leading: IconButton(
              icon: (pagechoice == "Main Menu")
                  ? const Icon(Icons.image)
                  : const Icon(Icons.home),
              tooltip: (pagechoice == "Main Menu")
                  ? "Put logo here"
                  : "Return to the main menu",
              onPressed: () {
                if (pagechoice != "Main Menu") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ScreenTop(pagechoice: "Main Menu")));
                }
              }),
          title: const Center(child: Text(appTitle)),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: "Return to the previous page",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            IconButton(
                icon: const Icon(Icons.settings),
                tooltip: "Settings??",
                onPressed: () {
                  homepageKey.currentState?.showColorPicker(context);
                }),
          ],
        ),
        
        /* Take the user to the page they chose. */
        body: PAGELINKER[pagechoice]?.call(),
      );});
  }
}

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  MainMenupage createState() => MainMenupage();
}

class MainMenupage extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Homepage.backgroundColor,
      floatingActionButton: FloatingActionButton(
        tooltip: "Help and guidance",
        foregroundColor: Homepage.textColor,
        backgroundColor: Homepage.backingColor,
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
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Homepage.backingColor,
                  child: Text(
                    textAlign: TextAlign.center,
                    "Main Menu",
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
                  side: const BorderSide(width: 3.3, color: Colors.black),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScreenTop(
                            pagechoice: "Create a Character")),
                  );
                },
                child: Text(
                  textAlign: TextAlign.center,
                  "Create a \ncharacter",
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
                  side: const BorderSide(width: 3.3, color: Colors.black),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScreenTop(
                            pagechoice: "Search for Content")),
                  );
                },
                child: Text(
                  textAlign: TextAlign.center,
                  "Search for\ncontent",
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
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  side: const BorderSide(width: 3.3, color: Colors.black),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ScreenTop(pagechoice: "My Characters")),
                  );
                },
                child: Text(
                  textAlign: TextAlign.center,
                  "My \ncharacters",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700, color: Homepage.textColor),
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
                  padding: const EdgeInsets.fromLTRB(45, 25, 45, 25),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  side: const BorderSide(width: 3.3, color: Colors.black),
                ),
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    dialogTitle: 
                      "Navigate to and select a Json file to download the contents from, this content can then be used in your characters",
                    type: FileType.custom,
                    allowedExtensions: ["json"],
                  );
                  if (result != null) {
                    final targetFile = File(result.files.single.path ?? "PATH SHOULD NEVER OCCUR");

                    try {
                      addToGlobalsFromFile(targetFile);
                      await saveChanges();
                    }
                    catch (e) {
                      debugPrint("Error downloading content: $e");
                      //TODO(ADD POPUP)
                    }
                  }
                },
                child: Text(
                  "Download\n Content",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700, color: Homepage.textColor),
                ),
              ),
              const SizedBox(width: 100),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Homepage.backingColor,
                  padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  side: const BorderSide(width: 3.3, color: Colors.black),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ScreenTop(pagechoice: "Custom Content")),
                  );
                },
                child: Text(
                  textAlign: TextAlign.center,
                  'Create \ncontent',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700, color: Homepage.textColor),
                ),
              ),
            ],
          ),
        ],
      ));
  }

  void _showInfoAndHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            const Opacity(
              opacity: 0.5,
              child: ModalBarrier(
                dismissible: false,
                color: Colors.grey,
              ),
            ),
            AlertDialog(
              title: const Text("Help and information",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
              content: SingleChildScrollView(
                  child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    const Text(
                      "App overview",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    Row(children: const [
                      Expanded(
                        child: Text(
                          '''• Main Menu - This is the section you are currently in, \nit allows you to navigate between every section.''',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ]),
                    Row(children: const [
                      Expanded(
                        child: Text(
                          '''• Create a Character - This is the section to build your character,\nit contains tabs which will guide you through the creation process.''',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ]),
                    Row(children: const [
                      Expanded(
                        child: Text(
                          '''• Search for Content - This is the section to look through your content,\nit allows you to search through and delete much of that content.''',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ]),
                    Row(children: const [
                      Expanded(
                        child: Text(
                          '''• My Characters -  This is the section to look through your characters,\nit allows you to search through, delete, edit and get their PDF.''',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ]),
                    Row(children: const [
                      Expanded(
                        child: Text(
                          '''• Download Content -  This is a button to install content,\nit allows you to select content to install from your computer.''',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ]),
                    Row(children: const [
                      Expanded(
                        child: Text(
                          '''• Create Content -  This is the section to create new content, 
it takes you to another page to select the type of content. Once there,
you can create that type of content, saving it to your app.''',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ]),
                    const SizedBox(
                      height: 9,
                    ),
                    const Text(
                      "Report a bug or ask for help:",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    const Text(
                      '''This is an open source project, to report bugs, 
ask for help or suggest improvements please go to:
https://github.com/Elidcoder/Frankensteins-a-DandD-Character-Builder
''',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ])),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("Json format incorrect, reformat and try again!",
            style: TextStyle(
                color: Colors.red, fontSize: 45, fontWeight: FontWeight.w800)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }
}
