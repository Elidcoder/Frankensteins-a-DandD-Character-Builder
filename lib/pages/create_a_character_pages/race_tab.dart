import "package:flutter/material.dart";

import "../../content_classes/all_content_classes.dart";
import "../../storage/global_list_manager.dart";
import "../../utils/style_utils.dart";

/// Race tab widget for character creation
/// Handles race and subrace selection, as well as ability score increases
class RaceTab extends StatefulWidget {
  final Character character;
  final VoidCallback onCharacterChanged;

  const RaceTab({
    super.key,
    required this.character,
    required this.onCharacterChanged,
  });

  @override
  State<RaceTab> createState() => _RaceTabState();
}

class _RaceTabState extends State<RaceTab> {
  late Future<void> _initialisedRaces;
  
  @override
  void initState() {
    super.initState();
    _initialisedRaces = GlobalListManager().initialiseRaceList();
  }
  
  @override
  Widget build(BuildContext context) {
    return StyleUtils.styledFutureBuilder(future: _initialisedRaces, builder: (context) => Column(
      children: [
        const SizedBox(height: 24),
        StyleUtils.buildStyledMediumTextBox(text: "Select a race:"),
        StyleUtils.buildStyledDropDown(
          initialValue: widget.character.race.name, 
          items: GlobalListManager().raceList, 
          onChanged: (String? value) {
            setState(() {
              widget.character.raceAbilityScoreIncreases = [0, 0, 0, 0, 0, 0];
              widget.character.race = GlobalListManager().raceList.singleWhere((x) => x.name == value);
              widget.character.subrace = widget.character.race.subRaces?.first;
              
              for (int i = 0; i < abilityScores.length; i++) {
                widget.character.raceAbilityScoreIncreases[i] = 
                  widget.character.race.raceScoreIncrease[i] + ((widget.character.subrace?.subRaceScoreIncrease[i]) ?? 0);

                widget.character.optionalOnesStates = [
                  [false, false, false, false, false, false],
                  [false, false, false, false, false, false],
                  [false, false, false, false, false, false],
                  [false, false, false, false, false, false],
                  [false, false, false, false, false, false]
                ];
                widget.character.optionalTwosStates = [
                  [false, false, false, false, false, false],
                  [false, false, false, false, false, false],
                  [false, false, false, false, false, false],
                  [false, false, false, false, false, false],
                  [false, false, false, false, false, false]
                ];
            }});
            widget.onCharacterChanged();
          }
        ),
        const SizedBox(height: 10),
        if (widget.character.race.subRaces != null) ...[
          StyleUtils.buildStyledSmallTextBox(text: "Select a subrace:"),
          const SizedBox(height: 10),
          StyleUtils.buildStyledDropDown(
            initialValue: widget.character.subrace?.name,
            items: widget.character.race.subRaces,
            onChanged: (String? value) {
              setState(() {
                widget.character.raceAbilityScoreIncreases = [0, 0, 0, 0, 0, 0];

                widget.character.subrace = widget.character.race.subRaces?.singleWhere((x) => x.name == value);
                for (int i = 0; i < abilityScores.length; i++) {
                  widget.character.raceAbilityScoreIncreases[i] =
                    (widget.character.subrace?.subRaceScoreIncrease[i] ?? 0) + widget.character.race.raceScoreIncrease[i];
                }
                widget.character.optionalOnesStates = [
                  [false, false, false, false, false, false],
                  [false, false, false, false, false, false],
                  [false, false, false, false, false, false],
                  [false, false, false, false, false, false],
                  [false, false, false, false, false, false]
                ];
                widget.character.optionalTwosStates = [
                  [false, false, false, false, false, false],
                  [false, false, false, false, false, false],
                  [false, false, false, false, false, false],
                  [false, false, false, false, false, false],
                  [false, false, false, false, false, false]
                ];
              });
              widget.onCharacterChanged();
            },
          ),
          const SizedBox(height: 10),
        ],
        if (widget.character.race.mystery1S + (widget.character.subrace?.mystery1S ?? 0) != 0) ...[
          StyleUtils.buildStyledSmallTextBox(text: "Choose which score(s) to increase by 1"),
          StyleUtils.buildNStyledAsiSelectors(
            numbItems: (widget.character.race.mystery1S + (widget.character.subrace?.mystery1S ?? 0)), 
            optionalStatesList: widget.character.optionalOnesStates!, 
            onPressed:(int choiceNumber, int index, bool isSelected) {
              setState(() {
                if (widget.character.optionalOnesStates![choiceNumber][index]) {
                  widget.character.raceAbilityScoreIncreases[index] -= 1;
                } else {
                  widget.character.raceAbilityScoreIncreases[index] += 1;
                  for (int buttonIndex = choiceNumber;
                      buttonIndex < widget.character.optionalOnesStates![choiceNumber].length;
                      buttonIndex++) {
                    if (widget.character.optionalOnesStates![choiceNumber][buttonIndex]) {
                      widget.character.optionalOnesStates![choiceNumber][buttonIndex] = false;
                      widget.character.raceAbilityScoreIncreases[buttonIndex] -= 1;
                    }
                  }
                }
                widget.character.optionalOnesStates![choiceNumber][index] = !widget.character.optionalOnesStates![choiceNumber][index];
              });
              widget.onCharacterChanged();
            }
          ),
        ],
        if (widget.character.race.mystery2S + (widget.character.subrace?.mystery2S ?? 0) != 0) ...[
          StyleUtils.buildStyledSmallTextBox(text: "Choose which score(s) to increase by 2"),
          StyleUtils.buildNStyledAsiSelectors(
            numbItems: (widget.character.race.mystery2S + (widget.character.subrace?.mystery2S ?? 0)), 
            optionalStatesList: widget.character.optionalTwosStates!,
            onPressed:(int choiceNumber, int index, bool isSelected) {
              setState(() {
                if (widget.character.optionalTwosStates![choiceNumber][index]) {
                  widget.character.raceAbilityScoreIncreases[index] -= 2;
                } else {
                  widget.character.raceAbilityScoreIncreases[index] += 2;
                  for (
                    int buttonIndex = choiceNumber;
                    buttonIndex < widget.character.optionalTwosStates![choiceNumber].length;
                    buttonIndex++
                    ) {
                      if (widget.character.optionalTwosStates![choiceNumber][buttonIndex]) {
                        widget.character.optionalTwosStates![choiceNumber][buttonIndex] = false;
                        widget.character.raceAbilityScoreIncreases[buttonIndex] -= 1;
                      }
                  }
                }
                widget.character.optionalTwosStates![choiceNumber][index] = !widget.character.optionalTwosStates![choiceNumber][index];
              });
              widget.onCharacterChanged();
            }
          )
        ]                
      ],
    ));
  }
}
