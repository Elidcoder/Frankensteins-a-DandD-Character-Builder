import "package:flutter/material.dart";

import "../../content_classes/all_content_classes.dart";
import "../../pdf_generator/pdf_final_display.dart";
import "../../storage/global_list_manager.dart";
import "../../theme/theme_manager.dart";
import "../../utils/style_utils.dart";
import "../../widgets/initial_top.dart";

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
  final String congratulationsTitle;
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
    required this.congratulationsTitle,
    this.isEditMode = false,
  });

  @override
  State<FinishingUpTab> createState() => _FinishingUpTabState();
}

class _FinishingUpTabState extends State<FinishingUpTab> {
  late Future<void> _initialisedCharacters;
  @override
  void initState() {
    super.initState();
    _initialisedCharacters = GlobalListManager().initialiseCharacterList();
  }

  @override
  Widget build(BuildContext context) {
    return StyleUtils.styledFutureBuilder(future: _initialisedCharacters, builder: (context) => Scaffold(
      backgroundColor: ThemeManager.instance.currentScheme.backgroundColour,
      // Floating pdf generator button
      floatingActionButton: FloatingActionButton(
        tooltip: "Generate a PDF",
        foregroundColor: ThemeManager.instance.currentScheme.textColour,
        backgroundColor: ThemeManager.instance.currentScheme.backingColour,
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
                  // Group selection dropdown (using efficiently cached GlobalListManager().groupList)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: (GlobalListManager().groupList.isNotEmpty)
                          ? ThemeManager.instance.currentScheme.backingColour
                          : const Color.fromARGB(247, 56, 53, 52),
                    ),
                    height: 45,
                    child: StyleUtils.buildBaseDropdownButton(
                        value: GlobalListManager().groupList.contains(widget.character.group) ? widget.character.group : null,
                        items: GlobalListManager().groupList.isNotEmpty ? GlobalListManager().groupList : null,
                        onChanged: (String? value) {
                          setState(() {
                            widget.character.group = value!;
                          });
                          widget.onCharacterChanged();
                        },
                        hintText: (GlobalListManager().groupList.isNotEmpty) ? " No matching group selected " : " No groups available "
                    ),
                  ),
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
                          backgroundColor: widget.canCreateCharacter ? ThemeManager.instance.currentScheme.backingColour : const Color.fromARGB(247, 56, 53, 52),
                          padding: const EdgeInsets.fromLTRB(45, 20, 45, 20),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10))),
                          side: const BorderSide(width: 3, color: Colors.black),
                        ),
                        child: StyleUtils.buildStyledHugeTextBox(
                          text: widget.isEditMode ? "Save Changes" : "Save Character", 
                          color: ThemeManager.instance.currentScheme.textColour
                        ),
                        onPressed: () async {
                          if (widget.canCreateCharacter) {
                            // Capture ScaffoldMessenger and Navigator before async operation
                            final scaffoldMessenger = ScaffoldMessenger.of(context);
                            final navigator = Navigator.of(context);
                            
                            // Save character using the new system only
                            final saveResult  = await GlobalListManager().saveCharacter(widget.character);
                            //final saveSuccess = await CharacterStorageService.saveCharacter(widget.character);

                            // If save was successful, update group list
                            // if (saveSuccess) {
                            //   updateGroupListFromNewSystem();// TODO(Dynamically update in save character)
                            // }
                            
                            // Check if widget is still mounted before using context
                            if (!mounted) return;
                            
                            if (saveResult) {
                              // Navigation back to main menu using captured navigator
                              navigator.pop();
                              navigator.push(
                                MaterialPageRoute(
                                    builder: (context) => InitialTop()),
                              );
                              _showCongratulationsDialog(context);
                            } else {
                              // Show error if save failed
                              scaffoldMessenger.showSnackBar(
                                SnackBar(
                                  content: Text('Failed to save character. Please try again.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
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
    ));
  }

  void _showCongratulationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StyleUtils.buildStyledAlertDialog(
        title: widget.congratulationsTitle,
        content: '',
        titleWidget: StyleUtils.buildStyledHugeTextBox(
          text: widget.congratulationsTitle,
          color: positiveColor,
        ),
        actions: [
          StyleUtils.buildStyledTextButton(
            text: 'Continue',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
