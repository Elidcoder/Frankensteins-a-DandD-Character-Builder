import 'package:flutter/material.dart';
import '../colour_scheme_class/colour_scheme.dart';
import '../theme/theme_manager.dart';
import '../utils/style_utils.dart';
import 'main_menu.dart';
import 'simple_color_picker.dart';

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

  /// Shows the color picker dialog for theme selection
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
                StyleUtils.buildStyledAlertDialog(
                  title: "Settings",
                  content: '',
                  contentWidget: SingleChildScrollView(
                    child: Column(
                      children: [
                        /* Selection of backing colour */
                        ...StyleUtils.buildStyledSeperatedText("Select box colours:"),
                        SimpleColorPicker(
                          currentColor: currentScheme.backingColour,
                          onColorChanged: (color) {
                            setState(() {
                              currentScheme.backingColour = color;
                            });
                          },
                        ),

                        /* Selection of text colour */
                        ...StyleUtils.buildStyledSeperatedText("Select text colour:"),
                        SimpleColorPicker(
                          currentColor: currentScheme.textColour,
                          onColorChanged: (color) {
                            setState(() {
                              currentScheme.textColour = color;
                            });
                          },
                        ),

                        /* Selection of background colour */
                        ...StyleUtils.buildStyledSeperatedText("Select background colour:"),
                        SimpleColorPicker(
                          currentColor: currentScheme.backgroundColour,
                          onColorChanged: (color) {
                            setState(() {
                              currentScheme.backgroundColour = color;
                            });
                          },
                        ),

                        /* User can instead make use of a previous colour combination. */
                        ...StyleUtils.buildStyledSeperatedText("Or choose a theme:"),
                        SizedBox(
                          height: 300,
                          width: 307,
                          child: ListView.separated(
                            separatorBuilder: (BuildContext context, int index) {
                              return const SizedBox(height: 15);
                            },
                            itemCount: THEMELIST.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _buildThemePreview(index, selectedIndex, setState, currentScheme);
                            },
                          )
                        ),
                      ]
                    )
                  ),
                  actions: [
                    StyleUtils.buildStyledTextButton(
                      text: "Cancel",
                      onPressed: () {Navigator.of(context).pop();},
                    ),
                    StyleUtils.buildStyledTextButton(
                      text: "Save settings",
                      onPressed: () {
                        // Update the theme using the theme manager
                        ThemeManager.instance.updateScheme(currentScheme);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            );
          }
        );
      },
    );
  }

  /// Builds a theme preview button for the color picker
  Widget _buildThemePreview(int index, int? selectedIndex, StateSetter setState, ColourScheme currentScheme) {
    final theme = THEMELIST.reversed.toList()[index];
    
    return SizedBox(
      width: 305,
      height: 180,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: theme.backgroundColour,
          side: (selectedIndex == index) 
            ? BorderSide(width: 7, color: Colors.amber) 
            : BorderSide(width: 0.7, color: Colors.black),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        ),
        child: Column(
          children: [
            /* Mini app title bar */
            StyleUtils.buildStyledContainer(
              width: 305,
              height: 18,
              backgroundColor: theme.backingColour,
              child: StyleUtils.buildStyledTinyTextBox(
                text: "Frankensteins - a D&D 5e character builder:",
                color: theme.textColour,
              ),
            ),
            
            /* Mini page title bar */
            StyleUtils.buildStyledContainer(
              width: 305,
              height: 18,
              backgroundColor: theme.backingColour,
              child: StyleUtils.buildStyledSmallTextBox(
                text: "Main Menu",
                color: theme.textColour,
              ),
            ),
            
            const SizedBox(height: 28),

            /* Mini buttons */
            Center(
              child: Row(
                children: [
                  const SizedBox(width: 21),
                  _buildMiniButton("Create a\ncharacter", theme),
                  const SizedBox(width: 27.5),
                  _buildMiniButton("Search for\nContent", theme),
                  const SizedBox(width: 27.5),
                  _buildMiniButton("My\nCharacters", theme)
                ],
              )
            ),
            
            const SizedBox(height: 25),
            
            Center(
              child: Row(
                children: [
                  const SizedBox(width: 50),
                  _buildMiniButton("Download\nContent", theme),
                  const SizedBox(width: 27.5),
                  _buildMiniButton("Create\nContent", theme)
                ],
              )
            ),
          ]
        ),
        onPressed: () {
          setState(() {
            selectedIndex = index;
            currentScheme = theme;
          });
        },
      )
    );
  }

  /// Builds a mini button for theme preview
  Widget _buildMiniButton(String text, ColourScheme theme) {
    return StyleUtils.buildStyledContainer(
      width: 61,
      height: 31,
      backgroundColor: theme.backingColour,
      borderRadius: BorderRadius.circular(4),
      child: StyleUtils.buildStyledTinyTextBox(
        text: text,
        color: theme.textColour,
      ),
    );
  }
}

