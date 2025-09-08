// External Imports
import "package:flutter/material.dart";

import "../../../models/character/character.dart";
// Project Imports
import "../../../shared/top_bar.dart";
import "../../../storage/global_list_manager.dart";
import "../../../theme/theme_manager.dart";
import "../../../utils/style_utils.dart";
import "../../pdf_export/screens/pdf_display_screen.dart";
import "character_editing_screen.dart";

/* This is a page where all characters created are displayed to be edited, viewed, deleted etc. */
class MyCharacters extends StatefulWidget {
  const MyCharacters({super.key});

  @override
  MainMyCharacters createState() => MainMyCharacters();
}

class MainMyCharacters extends State<MyCharacters> {
  String searchTerm = "";
  List<Character> _characters = [];
  late Future<void> _initializedCharacters;

  @override
  void initState() {
    super.initState();
    ThemeManager.instance.addListener(_onThemeChanged);
    _initializedCharacters = _loadCharacters();
  }
  
  Future<void> _loadCharacters() async {
    await GlobalListManager().initialiseCharacterList();
    await GlobalListManager().initialiseClassList();// Get rid of reference
    _characters = GlobalListManager().characterList;//TODO(REPLACE WITH CALLS TO CHARLIST)
    setState(() {
      
    });
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

    final filteredCharacters = _characters.where(
      (element) => element.characterDescription.name.toLowerCase().contains(searchTerm.toLowerCase())
    ).toList();

    return StyleUtils.styledFutureBuilder(
      future: _initializedCharacters,
      builder: (context) => StyleUtils.buildStyledScaffold(
        floatingActionButton: StyleUtils.buildStyledFloatingActionButton(
          tooltip: "Create a character",
          child: const Icon(Icons.person_add),
          onPressed: () {
            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegularTop(pagechoice: "Create a Character")
                ),
              );
            });
          },
        ),
        appBar: StyleUtils.buildStyledAppBar(
          title: "My Characters",
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          /* Character name search bar */
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchTerm = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search for characters using its names",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 15),
          
          /* Display users characters with action buttons. */
          Expanded(
            child: (_characters.isEmpty)
              ? Center(child: StyleUtils.buildStyledLargeTextBox(text: "You have no created characters to view"))
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  alignment: WrapAlignment.center,
                  children: List.generate(filteredCharacters.length, (index) {
                    return StyleUtils.buildStyledContainer(
                      width: 190,
                      height: 257,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 175.0,
                            height: 29,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: StyleUtils.buildStyledMediumTextBox(text: filteredCharacters[index].characterDescription.name)
                          )),

                          /* Character's Level */
                          StyleUtils.buildStyledSmallTextBox(text: "Level: ${filteredCharacters[index].classList.length}"),

                          /* Character's level in each class */
                          SizedBox(
                            width: 175.0,
                            height: 20,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: (filteredCharacters[index].classList.isNotEmpty) 

                              /* If the character has levels in >= 1 class, mach each class to its levels (if > 0) and pretty print them. */
                              ? StyleUtils.buildStyledTinyTextBox(
                                  text: GlobalListManager().classList.asMap().entries.where(
                                    (entry) => filteredCharacters[index].classLevels[entry.key] != 0
                                  ).map(
                                    (entry) =>"${entry.value.name}: ${filteredCharacters[index].classLevels[entry.key]}"
                                  ).join(", ")
                              )

                              /* If the character has levels in no classes. */
                              : StyleUtils.buildStyledTinyTextBox(text: "No Classes to display"),
                            )),

                          /* Character's Health */
                          StyleUtils.buildStyledSmallTextBox(text: "Health: ${filteredCharacters[index].maxHealth}"),

                          /* Character's Group */
                          SizedBox(
                            width: 175,
                            height: 20,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: StyleUtils.buildStyledSmallTextBox(text: "Group: ${filteredCharacters[index].group ?? "Not a part of a group"}")
                          )),

                          /* Open as PDF button */
                          buildCharacterActionButton("Open PDF", Colors.grey, () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PdfDisplay(character: filteredCharacters[index]),
                              ),
                            );
                          }),

                          /* Duplicate character button */
                          buildCharacterActionButton("Duplicate character", Colors.lightBlue, () async {
                            // Capture ScaffoldMessenger before async operation
                            final scaffoldMessenger = ScaffoldMessenger.of(context);
                            
                            try {
                              Character selectedCharacter = filteredCharacters[index];
                              Character duplicatedCharacter = selectedCharacter.getCopy();
                              
                              // Save using migration helper
                              final saveResult  = await GlobalListManager().saveCharacter(duplicatedCharacter); //TODO(ENSURE THIS WORKS CORRECTLY)
                              // final saveSuccess = await CharacterStorageService.saveCharacter(duplicatedCharacter);

                              if (saveResult) {
                                // Refresh the character list also reloads the grouplist
                                setState(() {});
                                //await _loadCharacters();// Should be uneeded as GlobalListManager().characterList updates grouplist
                              } else {
                                // Show error message using captured messenger
                                scaffoldMessenger.showSnackBar(
                                  const SnackBar(content: Text('Failed to duplicate character')),
                                );
                              }
                            } catch (e) {
                              debugPrint('Error duplicating character: $e');
                              // Show error message using captured messenger
                              scaffoldMessenger.showSnackBar(
                                const SnackBar(content: Text('Error duplicating character')),
                              );
                            }
                          }),

                          /* Edit character button */
                          buildCharacterActionButton("Edit Character", Colors.green, () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditTop(filteredCharacters[index]),
                              ),
                            ).then((_) => setState(() {}));
                          }),

                          /* Delete character button */
                          buildCharacterActionButton("Delete character", Colors.red, () async {
                            // Capture ScaffoldMessenger before async operation
                            final scaffoldMessenger = ScaffoldMessenger.of(context);

                            final characterToDelete = filteredCharacters[index];

                            /* Delete the character using the new system only. */
                            final success = await GlobalListManager().deleteCharacter(characterToDelete);
                            
                            if (success) {
                              /* Reload the character list to reflect changes and updates the grouplist. */
                              _characters = GlobalListManager().characterList;
                              setState(() {});
                            } else {
                              // Show error message if deletion failed
                              scaffoldMessenger.showSnackBar(
                                const SnackBar(content: Text('Failed to delete character')),
                              );
                            }
                          }),
                        ],
                      ));
                  }),
                ),
              )),
      ])));
  }

  /* Returns a button for putting inside the character's card */
  Widget buildCharacterActionButton(String label, Color backgroundColour, VoidCallback onPressed) {
  return OutlinedButton(
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: StyleUtils.currentTextColor, width: 0.6),
      backgroundColor: backgroundColour,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    onPressed: onPressed,
    child: SizedBox(
      width: 175,
      child: Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
    ),
  );
}
}
