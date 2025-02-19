// External Imports
import "package:flutter/material.dart";

// Project Imports
import "my_character_pages/all_my_character_pages.dart";
import '../content_classes/all_content_classes.dart';
import "../pdf_generator/pdf_final_display.dart";
import "../main.dart";
import "../file_manager.dart";

class MyCharacters extends StatefulWidget {
  const MyCharacters({super.key});

  @override
  MainMyCharacters createState() => MainMyCharacters();
}

class MainMyCharacters extends State<MyCharacters> {
  String searchTerm = "";
  @override
  void initState() {
    super.initState();
    updateGlobals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Homepage.backgroundColor,
      floatingActionButton: FloatingActionButton(
        tooltip: "Create a character",
        foregroundColor: Homepage.textColor,
        backgroundColor: Homepage.backingColor,
        onPressed: () {
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ScreenTop(pagechoice: "Create a Character")
              ),
            );
          });
        },
        child: const Icon(Icons.person_add),
      ),
      appBar: AppBar(
        foregroundColor: Homepage.textColor,
        backgroundColor: Homepage.backingColor,
        title: const Center(
          child: Text(
            textAlign: TextAlign.center,
            "My Characters",
            style: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        /* Character name search bar */
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
            child: Container(
              height: 50,
              color: Colors.grey,
              child: SizedBox(
                width: 150,
                child: TextField(
                  cursorColor: Homepage.textColor,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Character name here",
                    hintStyle: TextStyle(fontWeight: FontWeight.w700, color: Homepage.textColor),
                    filled: true,
                    fillColor: Colors.grey,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(12)))
                  ),
                  onChanged: (searchEnteredValue) {
                    setState(() {
                      searchTerm = searchEnteredValue;
                    });
                  }),
              ),
          )),
        ]),
        const SizedBox(height: 15),
        /* Display users characters with action buttons. */
        (CHARACTERLIST.isEmpty)
            ? Text("You have no created characters to view", style: TextStyle(color: Homepage.backingColor, fontSize: 25, fontWeight: FontWeight.w700))
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.center,
                children: List.generate(CHARACTERLIST.where(
                  (element) => element.characterDescription.name.contains(searchTerm)
                ).toList().length, (index) {
                  return Container(
                    width: 190,
                    height: 279,
                    decoration: BoxDecoration(
                      color: Homepage.backingColor,
                      border: Border.all(color: Homepage.textColor, width: 2),
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
                              CHARACTERLIST.where(
                                (element) => element.characterDescription.name.contains(searchTerm)
                              ).toList()[index].characterDescription.name,
                              style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: Homepage.textColor)
                        ))),

                        /* Character's Level */
                        Text(
                          "Level: ${CHARACTERLIST.where(
                            (element) => element.characterDescription.name.contains(searchTerm)
                          ).toList()[index].classList.length}",
                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Homepage.textColor)
                        ),

                        /* Character's level in each class */
                        SizedBox(
                          width: 175.0,
                          height: 20,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: (CHARACTERLIST.where(
                              (element) => element.characterDescription.name.contains(searchTerm)
                            ).toList()[index].classList.isNotEmpty) 

                            /* If the character has levels in >= 1 class, mach each class to its levels (if > 0) and pretty print them. */
                            ? Text(
                                CLASSLIST.asMap().entries.where(
                                  (entry) => CHARACTERLIST.where(
                                    (char) => char.characterDescription.name.contains(searchTerm)
                                  ).toList()[index].classLevels[entry.key] != 0
                                ).map(
                                  (entry) =>"${entry.value.name}: ${CHARACTERLIST.where(
                                    (element) => element.characterDescription.name.contains(searchTerm)
                                  ).toList()[index].classLevels[entry.key]}"
                                ).join(", "),
                                style: TextStyle(fontWeight: FontWeight.w700,color: Homepage.textColor)
                            )

                            /* If the character has levels in no classes. */
                            : Text(
                              "No Classes to display",
                              style: TextStyle(fontWeight: FontWeight.w700,color: Homepage.textColor)
                            ),
                          )),

                        /* Character's Health */
                        Text(
                          "Health: ${CHARACTERLIST.where(
                            (element) => element.characterDescription.name.contains(searchTerm)
                          ).toList()[index].maxHealth}",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Homepage.textColor)
                        ),

                        /* Character's Group */
                        SizedBox(
                          width: 175,
                          height: 20,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Group: ${CHARACTERLIST.where(
                                (element) => element.characterDescription.name.contains(searchTerm)
                              ).toList()[index].group ?? "Not a part of a group"}",
                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Homepage.textColor)
                        ))),

                        /* Generate echo button */
                        OutlinedButton(
                          // TODO(IMPLEMENT THIS)
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Homepage.textColor, width: 0.6),
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                          ),
                          onPressed: () {},
                          child: const SizedBox(
                            width: 175,
                            child: Text(
                                textAlign: TextAlign.center,
                                "Generate echo",
                                style:
                                    TextStyle(color: Colors.white))
                        )),

                        /* Open as PDF button */
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Homepage.textColor, width: 0.6),
                            backgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PdfPreviewPage(character: CHARACTERLIST.where(
                                  (element) => element.characterDescription.name.contains(searchTerm)
                                ).toList()[index])),
                            );
                          },
                          child: const SizedBox(
                            width: 175,
                            child: Text(
                              textAlign: TextAlign.center,
                              "Open PDF",
                              style: TextStyle(color: Colors.white)
                        ))),

                        /* Duplicate character button */
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Homepage.textColor, width: 0.6),
                            backgroundColor: Colors.lightBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                          ),
                          onPressed: () {
                            setState(() {
                              /* Add the duplicated character to CHARACTERLIST */
                              Character selectedCharacter = CHARACTERLIST.where(
                                (element) => element.characterDescription.name.contains(searchTerm)
                              ).toList()[index];
                              CHARACTERLIST.add(selectedCharacter.getCopy());
                              saveChanges();

                              /* Show the duplication dialog */
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
                              showStyledDialogue(
                                context, 
                                const Text(
                                  'Character duplicated!',
                                  style: TextStyle(color: Colors.green, fontSize: 50, fontWeight: FontWeight.w800)
                              ));
                            });
                          },
                          child: const SizedBox(
                            width: 175,
                            child: Text(
                              textAlign: TextAlign.center,
                              "Duplicate character",
                              style:TextStyle(color: Colors.white))
                        )),

                        /* Edit character button */
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Homepage.textColor, width: 0.6),
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                            ),
                            onPressed: () {
                              /* Navigate to the character editing page */
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Edittop(CHARACTERLIST.where(
                                    (element) => element.characterDescription.name.contains(searchTerm)
                                  ).toList()[index])),
                              );
                            },
                            child: const SizedBox(
                              width: 175,
                              child: Text(
                                textAlign: TextAlign.center,
                                "Edit Character",
                                style:TextStyle(color: Colors.white))
                        )),

                        /* Delete character button */
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Homepage.textColor, width: 0.6),
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                          ),
                          onPressed: () {
                            setState(() {
                              /* Locate the character being deleted. */
                              final int charIndex = CHARACTERLIST.indexWhere(
                                (character) => character.uniqueID == CHARACTERLIST.where(
                                  (element) => element.characterDescription.name.contains(searchTerm)
                                ).toList()[index].uniqueID
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
                              
                              /* Save changes and show deletion dialogue. */
                              saveChanges();
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Homepage()),
                              );
                              showStyledDialogue(
                                context, 
                                const Text(
                                  'Character deleted!', 
                                  style: TextStyle(color: Colors.red, fontSize: 50, fontWeight: FontWeight.w800) 
                              ));
                            });
                          },
                          child: const SizedBox(
                            width: 175,
                            child: Text(
                              textAlign: TextAlign.center,
                              "Delete character",
                              style: TextStyle(color: Colors.white))
                        )),
                      ],
                    ));
                }),
              ),
            ),
      ]));
  }

  void showStyledDialogue(BuildContext context, Text styledText) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: styledText,
        actions: [
          TextButton(
            onPressed: () {Navigator.of(context).pop();},
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
