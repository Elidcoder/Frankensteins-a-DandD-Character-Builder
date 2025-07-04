// External Imports
import "package:flutter/material.dart";

// Project Imports
import "../../top_bar.dart";
import "../../file_manager/file_manager.dart";
import "../../main.dart" show InitialTop;
import "edit_character.dart";
import "../../pdf_generator/pdf_final_display.dart";
import "../../content_classes/all_content_classes.dart";

/* This is a page where all characters created are displayed to be edited, viewed, deleted etc. */
class MyCharacters extends StatefulWidget {
  const MyCharacters({super.key});

  @override
  MainMyCharacters createState() => MainMyCharacters();
}

class MainMyCharacters extends State<MyCharacters> {
  String searchTerm = "";

  @override
  Widget build(BuildContext context) {
    final filteredCharacters = CHARACTERLIST.where(
      (element) => element.characterDescription.name.toLowerCase().contains(searchTerm.toLowerCase())
    ).toList();
    return Scaffold(
      backgroundColor: InitialTop.colourScheme.backgroundColour,
      floatingActionButton: FloatingActionButton(
        tooltip: "Create a character",
        foregroundColor: InitialTop.colourScheme.textColour,
        backgroundColor: InitialTop.colourScheme.backingColour,
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
        child: const Icon(Icons.person_add),
      ),
      appBar: AppBar(
        foregroundColor: InitialTop.colourScheme.textColour,
        backgroundColor: InitialTop.colourScheme.backingColour,
        title: const Center(
          child: Text(
            textAlign: TextAlign.center,
            "My Characters",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
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
          child: (CHARACTERLIST.isEmpty)
            ? Center(child: Text("You have no created characters to view", style: TextStyle(color: InitialTop.colourScheme.backingColour, fontSize: 25, fontWeight: FontWeight.w700)))
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.center,
                children: List.generate(filteredCharacters.length, (index) {
                  return Container(
                    width: 190,
                    height: 247,
                    decoration: BoxDecoration(
                      color: InitialTop.colourScheme.backingColour,
                      border: Border.all(color: InitialTop.colourScheme.textColour, width: 2),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 175.0,
                          height: 29,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              filteredCharacters[index].characterDescription.name,
                              style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: InitialTop.colourScheme.textColour)
                        ))),

                        /* Character's Level */
                        Text(
                          "Level: ${filteredCharacters[index].classList.length}",
                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: InitialTop.colourScheme.textColour)
                        ),

                        /* Character's level in each class */
                        SizedBox(
                          width: 175.0,
                          height: 20,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: (filteredCharacters[index].classList.isNotEmpty) 

                            /* If the character has levels in >= 1 class, mach each class to its levels (if > 0) and pretty print them. */
                            ? Text(
                                CLASSLIST.asMap().entries.where(
                                  (entry) => filteredCharacters[index].classLevels[entry.key] != 0
                                ).map(
                                  (entry) =>"${entry.value.name}: ${filteredCharacters[index].classLevels[entry.key]}"
                                ).join(", "),
                                style: TextStyle(fontWeight: FontWeight.w700,color: InitialTop.colourScheme.textColour)
                            )

                            /* If the character has levels in no classes. */
                            : Text(
                              "No Classes to display",
                              style: TextStyle(fontWeight: FontWeight.w700,color: InitialTop.colourScheme.textColour)
                            ),
                          )),

                        /* Character's Health */
                        Text(
                          "Health: ${filteredCharacters[index].maxHealth}",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: InitialTop.colourScheme.textColour)
                        ),

                        /* Character's Group */
                        SizedBox(
                          width: 175,
                          height: 20,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Group: ${filteredCharacters[index].group ?? "Not a part of a group"}",
                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: InitialTop.colourScheme.textColour)
                        ))),

                        /* Open as PDF button */
                        buildCharacterActionButton("Open PDF", Colors.grey, () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PdfPreviewPage(character: filteredCharacters[index]),
                            ),
                          );
                        }),

                        /* Duplicate character button */
                        buildCharacterActionButton("Duplicate character", Colors.lightBlue, () {
                          setState(() {
                            Character selectedCharacter = filteredCharacters[index];
                            CHARACTERLIST.add(selectedCharacter.getCopy());
                            saveChanges();
                          });
                        }),

                        /* Edit character button */
                        buildCharacterActionButton("Edit Character", Colors.green, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTop(filteredCharacters[index]),
                            ),
                          );
                        }),

                        /* Delete character button */
                        buildCharacterActionButton("Delete character", Colors.red, () {
                          setState(() {
                            /* Locate the character being deleted. */
                            final int charIndex = CHARACTERLIST.indexWhere(
                              (character) => character.uniqueID == filteredCharacters[index].uniqueID
                            );
                            final String? charGroup = CHARACTERLIST[charIndex].group;

                            /* Remove the character. */
                            if (charIndex != -1) {
                              CHARACTERLIST.removeAt(charIndex);
                            }

                            /* Clean up unused groups. */
                            if (!CHARACTERLIST.any((character) => character.group == charGroup)) {
                              GROUPLIST.remove(charGroup);
                            }
                            
                            /* Save changes. */
                            saveChanges();
                          });
                        }),
                      ],
                    ));
                }),
              ),
            )),
      ]));
  }

  /* Returns a button for putting inside the character's card */
  Widget buildCharacterActionButton(String label, Color backgroundColour, VoidCallback onPressed) {
  return OutlinedButton(
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: InitialTop.colourScheme.textColour, width: 0.6),
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
