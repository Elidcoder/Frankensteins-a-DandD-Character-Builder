// External imports
import "dart:io" show File;
import "package:flutter/material.dart";
import "package:file_picker/file_picker.dart" show FilePicker, FileType;
import "package:flutter_colorpicker/flutter_colorpicker.dart" show ColorPicker;

// Project imports
import "colour_scheme_class/colour_scheme.dart";
import "file_manager/file_manager.dart";
import "top_bar.dart" show RegularTop;
import "theme/theme_manager.dart";
import "utils/style_utils.dart";

void main() {
  runApp(const FrankensteinApp());
}

class FrankensteinApp extends StatefulWidget {
  const FrankensteinApp({super.key});

  @override
  State<FrankensteinApp> createState() => _FrankensteinAppState();
}

class _FrankensteinAppState extends State<FrankensteinApp> {
  late Future<void> _initializationFuture;
  
  @override
  void initState() {
    super.initState();
    _initializationFuture = _initializeApp();
  }
  
  Future<void> _initializeApp() async {
    await initialiseGlobals();
    ThemeManager.instance.initialize();
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ThemeManagerWidget(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Frankenstein's - a D&D 5e character builder",
              theme: ThemeManager.instance.themeData,
              home: const InitialTop(),
            ),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    Text(
                      "Please wait while the application saves or loads data",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

/// Widget that manages theme changes and rebuilds the widget tree
class ThemeManagerWidget extends StatefulWidget {
  final Widget child;
  
  const ThemeManagerWidget({super.key, required this.child});
  
  @override
  State<ThemeManagerWidget> createState() => _ThemeManagerWidgetState();
}

class _ThemeManagerWidgetState extends State<ThemeManagerWidget> {
  @override
  void initState() {
    super.initState();
    ThemeManager.instance.addListener(_onThemeChanged);
  }
  
  @override
  void dispose() {
    ThemeManager.instance.removeListener(_onThemeChanged);
    super.dispose();
  }
  
  void _onThemeChanged() {
    setState(() {
      // Rebuild with new theme
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Frankenstein's - a D&D 5e character builder",
      theme: ThemeManager.instance.themeData,
      home: widget.child,
    );
  }
}

/* Create a GlobalKey for the state of InitialTop. */
final GlobalKey<InitialTopState> InitialTopKey = GlobalKey<InitialTopState>();

class InitialTop extends StatefulWidget {
  const InitialTop({super.key});
  @override
  InitialTopState createState() => InitialTopState();
}

class InitialTopState extends State<InitialTop> {
  static const String appTitle = "Frankenstein's - a D&D 5e character builder";

  @override
  void initState() {
    super.initState();
    ThemeManager.instance.addListener(_onThemeChanged);
  }
  
  @override
  void dispose() {
    ThemeManager.instance.removeListener(_onThemeChanged);
    super.dispose();
  }
  
  void _onThemeChanged() {
    setState(() {
      // Rebuild when theme changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return StyleUtils.buildStyledScaffold(
      appBar: StyleUtils.buildStyledAppBar(
        title: appTitle,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.image),
          tooltip: "Put logo here",
          onPressed: () {}
        ),
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
      body: const MainMenu(),
    );
  }

  /* Returns a popup that allows the user to change the app's colour scheme. */ 
  void showColorPicker(BuildContext context) {
    int? selectedIndex;
    ColourScheme currentScheme = ThemeManager.instance.currentScheme;
    
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
              backgroundColor: ThemeManager.instance.currentScheme.backgroundColour,
              title: Text("Settings", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: ThemeManager.instance.currentScheme.textColour)),
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
                  child: Text("Cancel", style: TextStyle(color: ThemeManager.instance.currentScheme.textColour)),
                ),
                TextButton(
                  onPressed: () {
                    // Update the theme using the theme manager
                    ThemeManager.instance.updateScheme(currentScheme);
                    Navigator.of(context).pop();
                  },
                  child: Text("Save settings", style: TextStyle(color: ThemeManager.instance.currentScheme.textColour)),
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
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: ThemeManager.instance.currentScheme.textColour),
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
  void initState() {
    super.initState();
    ThemeManager.instance.addListener(_onThemeChanged);
  }
  
  @override
  void dispose() {
    ThemeManager.instance.removeListener(_onThemeChanged);
    super.dispose();
  }
  
  void _onThemeChanged() {
    setState(() {
      // Rebuild when theme changes
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return StyleUtils.buildStyledScaffold(
      floatingActionButton: StyleUtils.buildStyledFloatingActionButton(
        onPressed: () {
          _showInfoAndHelp(context);
        },
        tooltip: "Help and guidance",
        child: const Icon(Icons.info),
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
              StyleUtils.buildStyledOutlinedButton(
                text: "Download\nContent",
                padding: const EdgeInsets.fromLTRB(45, 25, 45, 25),
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
  Widget buildStyledButton(String text, String pagechoice, BuildContext context){
    return StyleUtils.buildStyledOutlinedButton(
      text: text,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegularTop(pagechoice: pagechoice)),
        );
      },
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
