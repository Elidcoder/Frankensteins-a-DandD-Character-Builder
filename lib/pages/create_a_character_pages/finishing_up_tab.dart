import "package:flutter/material.dart";
import "../../content_classes/all_content_classes.dart";
import "../../utils/style_utils.dart";
import "../../main.dart";
import "../../file_manager/file_manager.dart";
import "../../pdf_generator/pdf_final_display.dart";

/// Finishing Up tab widget for character creation
/// Handles group selection, character saving, and build checklist
class FinishingUpTab extends StatefulWidget {
  final Character character;
  final TextEditingController groupEnterController;
  final bool canCreateCharacter;
  final int pointsRemaining;
  final int numberOfRemainingFeatOrASIs;
  final bool remainingAsi;
  final int charLevel;
  final VoidCallback onCharacterChanged;
  final void Function(BuildContext) showCongratulationsDialog;
  final bool isEditMode;

  const FinishingUpTab({
    super.key,
    required this.character,
    required this.groupEnterController,
    required this.canCreateCharacter,
    required this.pointsRemaining,
    required this.numberOfRemainingFeatOrASIs,
    required this.remainingAsi,
    required this.charLevel,
    required this.onCharacterChanged,
    required this.showCongratulationsDialog,
    this.isEditMode = false,
  });

  @override
  State<FinishingUpTab> createState() => _FinishingUpTabState();
}

class _FinishingUpTabState extends State<FinishingUpTab> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: InitialTop.colourScheme.backgroundColour,
      // Floating pdf generator button
      floatingActionButton: FloatingActionButton(
        tooltip: "Generate a PDF",
        foregroundColor: InitialTop.colourScheme.textColour,
        backgroundColor: InitialTop.colourScheme.backingColour,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PdfPreviewPage(
                  character: widget.character),
            ),
          );
        },
        child: const Icon(Icons.picture_as_pdf),
      ),
      body: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const Expanded(child: SizedBox()),
        Expanded(
            flex: 5,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 20,
                children: [
                  const SizedBox(height: 20),
                  StyleUtils.buildStyledHugeTextBox(text: "Add your character to a group:"),
                  StyleUtils.buildStyledMediumTextBox(text: "Select an existing group:"),
                  // Group selection dropdown and input field
                  Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5)),
                      color: (GROUPLIST.isNotEmpty)
                          ? InitialTop.colourScheme.backingColour
                          : const Color.fromARGB(247, 56, 53, 52),
                    ),
                    height: 45,
                    child: StyleUtils.buildBaseDropdownButton(
                      value: GROUPLIST.contains(widget.character.group) ? widget.character.group : null, 
                      items: GROUPLIST.isNotEmpty ? GROUPLIST : null, 
                      onChanged: (String? value) {
                        setState(() {
                          widget.character.group = value!;
                        });
                        widget.onCharacterChanged();
                      },
                      hintText: (GROUPLIST.isNotEmpty) ? " No matching group selected " : " No groups available "
                  )),
                  StyleUtils.buildStyledMediumTextBox(text: "Or create a new one:"),
                  StyleUtils.buildStyledSmallTextField(
                    width: 300,
                    hintText: "Enter a group",
                    textController: widget.groupEnterController,
                    onChanged: (groupNameEnteredValue) {
                      setState(() {
                        widget.character.group = groupNameEnteredValue;
                      });
                      widget.onCharacterChanged();
                    }
                  ),
                  // Character save button
                  Tooltip(
                      message: widget.canCreateCharacter? 
                        (widget.isEditMode ? "This button will save your character edits and return you to the main menu." : "This button will save your character putting it into the Json and then send you back to the main menu.") : 
                        (widget.isEditMode ? "You must complete the required tabs before saving your character edits" : "You must complete the required tabs before saving your character"),
                      child: ElevatedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: widget.canCreateCharacter ? InitialTop.colourScheme.backingColour : unavailableColor,
                          padding: const EdgeInsets.fromLTRB(45, 20, 45, 20),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10))),
                          side: const BorderSide(width: 3, color: Colors.black),
                        ),
                        child: StyleUtils.buildStyledHugeTextBox(
                          text: widget.isEditMode ? "Save Changes" : "Save Character", 
                          color: InitialTop.colourScheme.textColour
                        ),
                        onPressed: () {
                          if (widget.canCreateCharacter) {
                            setState(() {
                              if (widget.isEditMode) {
                                // Update existing character in the list
                                int characterIndex = CHARACTERLIST.indexWhere((c) => c.uniqueID == widget.character.uniqueID);
                                if (characterIndex != -1) {
                                  CHARACTERLIST[characterIndex] = widget.character;
                                } else {
                                  // Fallback: add if not found (shouldn't happen in normal edit flow)
                                  CHARACTERLIST.add(widget.character);
                                }
                              } else {
                                // Create new character
                                CHARACTERLIST.add(widget.character);
                              }
                              
                              // Update group list
                              GROUPLIST = GROUPLIST.where((element) => [
                                for (var x in CHARACTERLIST) x.group
                              ].contains(element)).toList();
                              if ((!GROUPLIST.contains(widget.character.group)) &&
                                  widget.character.group != null &&
                                  widget.character.group!.replaceAll(" ", "") != "") {
                                GROUPLIST.add(widget.character.group!);
                              }
                              
                              saveChanges();
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InitialTop()),
                              );
                              widget.showCongratulationsDialog(context);
                            });
                          }
                        },
                      ))
                ])),
        Expanded(
            flex: 7,
            child: Column(
              spacing: 20,
              children: [
                const SizedBox(height: 20),
                StyleUtils.buildStyledHugeTextBox(text: "Build checklist:"),
                
                // Show basics check only in creation mode
                if (!widget.isEditMode)
                  StyleUtils.makeOptionalText(condition: widget.character.basicsComplete, trueText: "Filled in all basic information", falseText: "Haven't filled in all necessary basics"),

                // Show ability scores check only in creation mode
                if (!widget.isEditMode)
                  StyleUtils.makeRequiredText(condition: (widget.pointsRemaining == 0), trueText: "Used all ability score points", falseText: "${widget.pointsRemaining} unspent ability score points"),
                
                //ASI+feats
                (widget.numberOfRemainingFeatOrASIs == 0)
                  ? StyleUtils.makeRequiredText(
                      condition: !widget.remainingAsi, 
                      trueText: "Made all ASI/Feats selections", 
                      falseText: "You have an unused ASI"
                    )
                  : StyleUtils.buildStyledMediumTextBox(
                    text: "You have ${widget.numberOfRemainingFeatOrASIs} ASI/Feat (s) remaining", 
                    color: negativeColor
                    ),

                //Class
                StyleUtils.makeRequiredText(
                  condition: (widget.charLevel <= widget.character.classList.length),
                  trueText: "Made all level selections", 
                  falseText: "${widget.charLevel - widget.character.classList.length} unused level${(widget.charLevel > 1)? "s":""}"
                ),

                //Equipment
                StyleUtils.makeRequiredText(
                  condition: widget.character.chosenAllEqipment,
                  trueText: "Made all equipment selections", 
                  falseText: "Missed ${widget.character.equipmentSelectedFromChoices.where((element) => element.length == 2).toList().length} equipment choice(s)"
                ),
                
                // Spells
                StyleUtils.makeRequiredText(
                  condition: widget.character.chosenAllSpells,
                  trueText: "Made all spells selections", 
                  falseText: "Missed ${(widget.character.allSpellsSelectedAsListsOfThings.fold(0, (a, b) => a + (b[2] as int)))} spells"),                            

                // Show backstory check - in edit mode, users can edit backstory via the backstory tab
                StyleUtils.makeOptionalText(
                  condition: widget.character.backstoryComplete,
                  trueText: "Completed backstory", 
                  falseText: "Haven't filled in all backstory information"
                )
        ]))
      ]),
    );
  }
}
