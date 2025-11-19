import 'package:flutter/material.dart';
import 'package:frankenstein/features/character_creation/screens/character_creation_screen.dart'
    show CreateACharacter;
import 'package:frankenstein/features/character_management/screens/view_characters_screen.dart'
    show MyCharacters;
import 'package:frankenstein/features/content_search/screens/content_search_screen.dart'
    show SearchForContent;
import 'package:frankenstein/features/custom_content/screens/overview_screen.dart'
    show CustomContent;

import '../../../core/theme/theme_manager.dart';
import '../../../core/utils/style_utils.dart';
import '../../../shared/widgets/top_bar.dart';

/// Displays the main menu with navigation buttons and help dialog
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
            child: const Icon(Icons.info)),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 80),

            /* Row containing the create character, search for content and my characters buttons. */
            _buildMainNavigationRow(context),
            const SizedBox(height: 120),

            /* Row containing the download content and create content buttons */
            _buildSecondaryNavigationRow(context),
          ],
        ));
  }

  /// Builds the main navigation row with primary action buttons
  Widget _buildMainNavigationRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildNavigationButton(
            "Create a \ncharacter", () => CreateACharacter(), context),
        const SizedBox(width: 120),
        _buildNavigationButton(
            "Search for\ncontent", () => SearchForContent(), context),
        const SizedBox(width: 120),
        _buildNavigationButton("My \ncharacters", () => MyCharacters(), context)
      ],
    );
  }

  /// Builds the secondary navigation row with utility buttons
  Widget _buildSecondaryNavigationRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // /* Sharing content button */
        // _buildNavigationButton(
        //     "Share \ncontent", () => SharingContent(), context),
        const SizedBox(width: 100),
        /* Create content button */
        _buildNavigationButton(
            "Create \ncontent", () => CustomContent(), context)
      ],
    );
  }

  /// Builds a navigation button that takes the user to another page
  Widget _buildNavigationButton(
      String text, Widget Function() pagechoice, BuildContext context) {
    return StyleUtils.buildStyledOutlinedButton(
      text: text,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RegularTop(pagechoice: pagechoice)),
        );
      },
    );
  }

  /// Displays a popup with helpful information for new users
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
            StyleUtils.buildStyledAlertDialog(
              title: "Help and information",
              content: '',
              contentWidget: SingleChildScrollView(
                  child: Column(children: [
                /* App overview section */
                StyleUtils.buildStyledMediumTextBox(text: "App overview"),
                const SizedBox(height: 9),
                ..._buildHelpSections(),
                const SizedBox(height: 9),

                /* Bug report section */
                StyleUtils.buildStyledMediumTextBox(
                    text: "Report a bug or ask for help:"),
                const SizedBox(height: 9),
                StyleUtils.buildStyledSmallTextBox(
                  text:
                      '''This is an open source project, to report bugs, \nask for help or suggest improvements please go to:\nhttps://github.com/Elidcoder/Frankensteins-a-DandD-Character-Builder''',
                ),
              ])),
              actions: [
                StyleUtils.buildStyledTextButton(
                  text: "OK",
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Builds the help sections for the info dialog
  List<Widget> _buildHelpSections() {
    final helpItems = [
      "• Main Menu - This is the section you are currently in, \nit allows you to navigate between every section.",
      "• Create a Character - This is the section to build your character,\nit contains tabs which will guide you through the creation process.",
      "• Search for Content - This is the section to look through your content,\nit allows you to search through and delete much of that content.",
      "• My Characters - This is the section to look through your characters,\nit allows you to search through, delete, edit and get their PDF.",
      "• Share Content - This is a section to manage shared content,\nit allows you to download content from JSON files to use in your characters.",
      "• Create Content - This is the section to create new content,\nit takes you to another page to select the type of content. Once there,\nyou can create that type of content, saving it to your app.",
    ];

    return helpItems
        .map((item) => Row(
              children: [
                Expanded(child: StyleUtils.buildStyledSmallTextBox(text: item))
              ],
            ))
        .toList();
  }
}
