import "package:flutter/material.dart";

import "../../content_classes/all_content_classes.dart";
import "../../services/global_list_manager.dart";
import "../../utils/style_utils.dart";

/// Background tab widget for character creation
/// Handles background selection, personality traits, bonds, flaws, skills, and languages
class BackgroundTab extends StatefulWidget {
  final Character character;
  final VoidCallback onCharacterChanged;

  const BackgroundTab({
    super.key,
    required this.character,
    required this.onCharacterChanged,
  });

  @override
  State<BackgroundTab> createState() => _BackgroundTabState();
}

class _BackgroundTabState extends State<BackgroundTab> {
  late Future<void> _initialisedBackgrounds;
  
  List<bool> get backgroundSelectedSkills {
    List<String> options = widget.character.background.optionalSkillProficiencies;
    return options.map((x) => widget.character.skillsSelected.contains(x)).toList();
  }

  List<bool> get backgroundSelectedLanguages {
    List<String> options = widget.character.background.getLanguageOptions();
    return options.map((x) => widget.character.languageChoices.contains(x)).toList();
  }
  
  @override
  void initState() {
    super.initState();
    _initialisedBackgrounds = GlobalListManager().initialiseBackgroundList();
  }

  @override
  Widget build(BuildContext context) {

    return StyleUtils.styledFutureBuilder(
      future: _initialisedBackgrounds, 
      builder: (context) => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(height: 24),
            StyleUtils.buildStyledMediumTextBox(text: "Select your character's background"),
            const SizedBox(height: 8),
            StyleUtils.buildStyledDropDown(
              selectedValue: widget.character.background.name, 
              options: GlobalListManager().backgroundList.map((bg) => bg.name).toList(), 
              hintText: "Select background",
              onChanged: (String? value) {                            
                setState(() {
                  widget.character.background = GlobalListManager().backgroundList.singleWhere((x) => x.name == value);
                  widget.character.backgroundPersonalityTrait = widget.character.background.personalityTrait.first;
                  widget.character.backgroundIdeal = widget.character.background.ideal.first;
                  widget.character.backgroundBond = widget.character.background.bond.first;
                  widget.character.backgroundFlaw = widget.character.background.flaw.first;
                  widget.character.skillsSelected.clear();
                  widget.character.languageChoices.clear();
                  // TODO: Original code had backgroundSelectedSkills; statement here - now handled by setState() and reactive getters
                });
                widget.onCharacterChanged();
              }
            ),
            
            //Personality Trait
            StyleUtils.buildLabeledDropdown(
              label: "Select your character's personality trait",
              options: widget.character.background.personalityTrait, 
              selectedValue: widget.character.backgroundPersonalityTrait,
              onChanged: (String? value) {
                setState(() {
                  widget.character.backgroundPersonalityTrait = widget.character.background
                          .personalityTrait
                          .singleWhere((x) => x == value);
                });
                widget.onCharacterChanged();
              }
            ),
            
            //Ideal
            StyleUtils.buildLabeledDropdown(
              label: "Select your character's ideal",
              options: widget.character.background.ideal,
              selectedValue: widget.character.backgroundIdeal,
              onChanged: (String? value) {
                setState(() {
                  widget.character.backgroundIdeal = widget.character.background.ideal
                          .singleWhere((x) => x == value);
                });
                widget.onCharacterChanged();
              }
            ),
            
            //Bond
            StyleUtils.buildLabeledDropdown(
              label: "Select your character's bond",
              options: widget.character.background.bond, 
              selectedValue: widget.character.backgroundBond,
              onChanged: (String? value) {
                setState(() {
                  widget.character.backgroundBond = widget.character.background.bond
                            .singleWhere((x) => x == value);
                });
                widget.onCharacterChanged();
              }
            ),
            
            //Flaw
            StyleUtils.buildLabeledDropdown(
              label: "Select your character's flaw",
              options: widget.character.background.flaw, 
              selectedValue: widget.character.backgroundFlaw,
              onChanged: (String? value) {
                setState(() {
                  widget.character.backgroundFlaw = widget.character.background.flaw
                            .singleWhere((x) => x == value);
                });
                widget.onCharacterChanged();
              }
            ),
            
            // Select background provided skills if the character gets some and there are options for skills
            if (widget.character.background.numberOfSkillChoices != 0 && widget.character.background.optionalSkillProficiencies.isNotEmpty) ...[
              StyleUtils.buildStyledSmallTextBox(text: "Pick ${(widget.character.background.numberOfSkillChoices)} skill(s) to gain proficiency in"),
              const SizedBox(height: 7),
              StyleUtils.buildStyledToggleSelector(
                options: widget.character.background.optionalSkillProficiencies,
                selectedValues: widget.character.skillsSelected.toList(),
                onToggle: (String skill) {
                  setState(() {
                    if (widget.character.skillsSelected.contains(skill)) {
                      widget.character.skillsSelected.remove(skill);
                    } else {
                      widget.character.skillsSelected.add(skill);
                      if (widget.character.skillsSelected.length > widget.character.background.numberOfSkillChoices) {
                        widget.character.skillsSelected.removeFirst();
                      }
                    }
                    // TODO: Original code had backgroundSelectedSkills; statement here - now handled by setState() and reactive getters
                  });
                  widget.onCharacterChanged();
                }
              ) 
            ],

            // Select background provided languages
            if (widget.character.background.numberOfLanguageChoices != 0) ...[
              StyleUtils.buildStyledSmallTextBox(text: "Pick ${(widget.character.background.numberOfLanguageChoices)} language(s) to learn"),
              const SizedBox(height: 7),
              StyleUtils.buildStyledToggleSelector(
                options: widget.character.background.getLanguageOptions(),
                selectedValues: widget.character.languageChoices.toList(),
                onToggle: (String language) {
                  setState(() {
                    if (widget.character.languageChoices.contains(language)) {
                      widget.character.languageChoices.remove(language);
                    } else {
                      widget.character.languageChoices.add(language);
                      if (widget.character.languageChoices.length > widget.character.background.numberOfLanguageChoices) {
                        widget.character.languageChoices.removeFirst();
                      }
                    }
                  });
                  widget.onCharacterChanged();
                }
              )
            ]
          ],
        )
      ));
  }
}
