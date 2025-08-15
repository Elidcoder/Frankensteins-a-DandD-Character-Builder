import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:frankenstein/storage/global_list_manager.dart' show GlobalListManager;

import '../theme/theme_manager.dart';
import '../utils/style_utils.dart';
import 'top_bar.dart';

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
        onPressed: (
          
        ) {
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
          _buildMainNavigationRow(context),
          
          const SizedBox(height: 120),

          /* Row containing the download content and create content buttons */
          _buildSecondaryNavigationRow(context),
        ],
      )
    );
  }

  /// Builds the main navigation row with primary action buttons
  Widget _buildMainNavigationRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildNavigationButton("Create a \ncharacter", "Create a Character", context),
        const SizedBox(width: 120),
        _buildNavigationButton("Search for\ncontent", "Search for Content", context),
        const SizedBox(width: 120),
        _buildNavigationButton("My \ncharacters", "My Characters", context)
      ],
    );
  }

  /// Builds the secondary navigation row with utility buttons
  Widget _buildSecondaryNavigationRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /* Download content button */
        StyleUtils.buildStyledOutlinedButton(
          text: "Download\nContent",
          padding: const EdgeInsets.fromLTRB(45, 25, 45, 25),
          onPressed: () => _handleDownloadContent(context),
        ),
        const SizedBox(width: 100),
        /* Create content button */
        _buildNavigationButton("Create \ncontent", "Custom Content", context)
      ],
    );
  }

  /// Builds a navigation button that takes the user to another page
  Widget _buildNavigationButton(String text, String pagechoice, BuildContext context) {
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

  /// Handles the download content file picker functionality
  Future<void> _handleDownloadContent(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: "Navigate to and select a Json file to download the contents from, this content can then be used in your characters",
      type: FileType.custom,
      allowedExtensions: ["json"],
    );

    if (result != null) {
      final targetFile = File(result.files.single.path ?? "PATH SHOULD NEVER OCCUR");

      try {
        await GlobalListManager().loadContentFromFile(targetFile);
        // loadContentFromFile updates all the content
      } catch (e) {
        if (mounted) {
          // ignore: use_build_context_synchronously (mounted check ensures correctness)
          _showErrorDialog(context);
        }
      }
    }
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
                child: Column(
                  children: [
                    /* App overview section */
                    StyleUtils.buildStyledMediumTextBox(text: "App overview"),
                    const SizedBox(height: 9),
                    
                    ..._buildHelpSections(),
                    
                    const SizedBox(height: 9),

                    /* Bug report section */
                    StyleUtils.buildStyledMediumTextBox(text: "Report a bug or ask for help:"),
                    const SizedBox(height: 9),
                    
                    StyleUtils.buildStyledSmallTextBox(
                      text: '''This is an open source project, to report bugs, \nask for help or suggest improvements please go to:\nhttps://github.com/Elidcoder/Frankensteins-a-DandD-Character-Builder''',
                    ),
                  ]
                )
              ),
              actions: [
                StyleUtils.buildStyledTextButton(
                  text: "OK",
                  onPressed: () {Navigator.of(context).pop();},
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
      "• Download Content - This is a button to install content,\nit allows you to select content to install from your computer.",
      "• Create Content - This is the section to create new content,\nit takes you to another page to select the type of content. Once there,\nyou can create that type of content, saving it to your app.",
    ];

    return helpItems.map((item) => 
      Row(
        children: [
          Expanded(
            child: StyleUtils.buildStyledSmallTextBox(text: item)
          )
        ],
      )
    ).toList();
  }

  /// Display an error dialog letting the user know that the download was bad
  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StyleUtils.buildStyledAlertDialog(
        title: "Error",
        content: "Json format incorrect, reformat and try again!",
        titleWidget: StyleUtils.buildStyledLargeTextBox(
          text: "Json format incorrect, reformat and try again!",
          color: Colors.red,
        ),
        actions: [
          StyleUtils.buildStyledTextButton(
            text: "Continue",
            onPressed: () {Navigator.of(context).pop();},
          ),
        ],
      ),
    );
  }
}
