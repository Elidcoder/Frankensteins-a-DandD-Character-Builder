import 'package:flutter/material.dart';
import 'package:frankenstein/core/services/global_list_manager.dart'
    show GlobalListManager;
import 'package:frankenstein/features/home/index.dart';

import '../../../core/theme/colour_scheme.dart';
import '../../../core/theme/theme_manager.dart';
import '../../../core/utils/style_utils.dart';
import '../../../shared/widgets/simple_color_picker.dart';

/// Global key for the InitialTop widget
final GlobalKey<InitialTopState> InitialTopKey = GlobalKey<InitialTopState>();

/// The initial top-level page that displays the main menu and settings
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
        smallTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.image),
            tooltip: "Put logo here",
            onPressed: () {}),
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

  /// Shows the color picker dialog for theme selection
  void showColorPicker(BuildContext context) {
    int? selectedIndex;
    // Create a copy of the current scheme so we can modify it without affecting the original
    ColourScheme currentScheme = ColourScheme(
      textColour: ThemeManager.instance.currentScheme.textColour,
      backingColour: ThemeManager.instance.currentScheme.backingColour,
      backgroundColour: ThemeManager.instance.currentScheme.backgroundColour,
    );

    // Create a fixed color scheme for the dialog so it doesn't change as user picks colors
    final dialogScheme = ColourScheme(
      backingColour: Colors.grey[300]!,
      textColour: Colors.black,
      backgroundColour: Colors.white,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Stack(
            children: [
              const Opacity(
                  opacity: 0.5,
                  child: ModalBarrier(dismissible: false, color: Colors.grey)),
              AlertDialog(
                backgroundColor: dialogScheme.backgroundColour,
                title: Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: dialogScheme.textColour,
                  ),
                ),
                content: SingleChildScrollView(
                    child: Column(children: [
                  /* Selection of backing colour */
                  const SizedBox(height: 16),
                  Text(
                    "Select box colours:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: dialogScheme.textColour,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SimpleColorPicker(
                    key: ValueKey(
                        'backing_${currentScheme.backingColour.value}'),
                    currentColor: currentScheme.backingColour,
                    onColorChanged: (color) {
                      setState(() {
                        currentScheme.backingColour = color;
                      });
                    },
                  ),

                  /* Selection of text colour */
                  const SizedBox(height: 16),
                  Text(
                    "Select text colour:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: dialogScheme.textColour,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SimpleColorPicker(
                    key: ValueKey('text_${currentScheme.textColour.value}'),
                    currentColor: currentScheme.textColour,
                    onColorChanged: (color) {
                      setState(() {
                        currentScheme.textColour = color;
                      });
                    },
                  ),

                  /* Selection of background colour */
                  const SizedBox(height: 16),
                  Text(
                    "Select background colour:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: dialogScheme.textColour,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SimpleColorPicker(
                    key: ValueKey(
                        'background_${currentScheme.backgroundColour.value}'),
                    currentColor: currentScheme.backgroundColour,
                    onColorChanged: (color) {
                      setState(() {
                        currentScheme.backgroundColour = color;
                      });
                    },
                  ),

                  /* User can instead make use of a previous colour combination. */
                  const SizedBox(height: 16),
                  Text(
                    "Or choose a theme:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: dialogScheme.textColour,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                      height: 300,
                      width: 307,
                      child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 15);
                        },
                        itemCount: GlobalListManager().themeList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return SizedBox(
                              width: 305,
                              height: 180,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: GlobalListManager()
                                      .themeList
                                      .reversed
                                      .toList()[index]
                                      .backgroundColour,
                                  /* Highlight the selected colour with a thicker boarder */
                                  side: (selectedIndex == index)
                                      ? BorderSide(
                                          width: 7, color: Colors.amber)
                                      : BorderSide(
                                          width: 0.7, color: Colors.black),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                ),
                                child: Column(children: [
                                  /* Mini and simplified version of the app title bar. */
                                  Container(
                                      width: 305,
                                      height: 18,
                                      color: GlobalListManager()
                                          .themeList
                                          .reversed
                                          .toList()[index]
                                          .backingColour,
                                      child: Text(
                                        "Frankensteins  - a D&D 5e character builder:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 9,
                                            color: GlobalListManager()
                                                .themeList
                                                .reversed
                                                .toList()[index]
                                                .textColour),
                                        textAlign: TextAlign.center,
                                      )),

                                  /* Mini version of the page title bar. */
                                  Container(
                                      width: 305,
                                      height: 18,
                                      color: GlobalListManager()
                                          .themeList
                                          .reversed
                                          .toList()[index]
                                          .backingColour,
                                      child: Text("Main Menu",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12,
                                              color: GlobalListManager()
                                                  .themeList
                                                  .reversed
                                                  .toList()[index]
                                                  .textColour),
                                          textAlign: TextAlign.center)),
                                  const SizedBox(height: 28),

                                  /* Mini versions of the buttons on the main page. */
                                  Center(
                                      child: Row(
                                    children: [
                                      /* Mini version of the button that takes the user to the create_a_character page */
                                      const SizedBox(width: 21),
                                      buildStyledMockButton(
                                          "Create a \n character",
                                          GlobalListManager()
                                              .themeList
                                              .reversed
                                              .toList()[index]),

                                      /* Mini version of the button that takes the user to the search_for_content page */
                                      const SizedBox(width: 27.5),
                                      buildStyledMockButton(
                                          "Search for\nContent",
                                          GlobalListManager()
                                              .themeList
                                              .reversed
                                              .toList()[index]),

                                      /* Mini version of the button that takes the user to the my_characters page */
                                      const SizedBox(width: 27.5),
                                      buildStyledMockButton(
                                          "My\nCharacters",
                                          GlobalListManager()
                                              .themeList
                                              .reversed
                                              .toList()[index])
                                    ],
                                  )),
                                  const SizedBox(height: 25),
                                  Center(
                                      child: Row(
                                    children: [
                                      /* Mini version of the button that makes the download content popup */
                                      const SizedBox(width: 50),
                                      buildStyledMockButton(
                                          "Download\nContent",
                                          GlobalListManager()
                                              .themeList
                                              .reversed
                                              .toList()[index]),

                                      /* Mini version of the button that takes the user to the create_content page */
                                      const SizedBox(width: 27.5),
                                      buildStyledMockButton(
                                          "Create\nContent",
                                          GlobalListManager()
                                              .themeList
                                              .reversed
                                              .toList()[index])
                                    ],
                                  )),
                                ]),
                                onPressed: () {
                                  setState(() {
                                    selectedIndex = index;
                                    // Create a copy of the selected theme instead of referencing it directly
                                    final selectedTheme = GlobalListManager()
                                        .themeList
                                        .reversed
                                        .toList()[index];
                                    currentScheme = ColourScheme(
                                      textColour: selectedTheme.textColour,
                                      backingColour:
                                          selectedTheme.backingColour,
                                      backgroundColour:
                                          selectedTheme.backgroundColour,
                                    );
                                  });
                                },
                              ));
                        },
                      )),
                ])),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: dialogScheme.textColour),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Update the theme using the theme manager
                      ThemeManager.instance.updateScheme(currentScheme);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Save settings",
                      style: TextStyle(color: dialogScheme.textColour),
                    ),
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
  Widget buildStyledMockButton(String text, ColourScheme scheme) {
    return Container(
        width: 61,
        height: 31,
        decoration: BoxDecoration(
            color: scheme.backingColour,
            borderRadius: const BorderRadius.all(Radius.circular(4))),
        child: Text(text,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 10,
                color: scheme.textColour),
            textAlign: TextAlign.center));
  }
}
