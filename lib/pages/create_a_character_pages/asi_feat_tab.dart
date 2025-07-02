import "package:flutter/material.dart";
import "../../content_classes/all_content_classes.dart";
import "../../utils/style_utils.dart";
import "../../main.dart";
import "spell_handling.dart"; // For ChoiceRow

/// ASI and Feats tab widget for character creation
/// Handles ability score improvements and feat selection
class AsiFeatTab extends StatefulWidget {
  final Character character;
  final int numberOfRemainingFeatOrASIs;
  final bool remainingAsi;
  final List<Widget> widgetsInPlay;
  final VoidCallback onCharacterChanged;
  final Function(int) onRemainingFeatOrASIsChanged;
  final Function(bool) onRemainingAsiChanged;
  final Function(List<Widget>) onWidgetsInPlayChanged;

  const AsiFeatTab({
    super.key,
    required this.character,
    required this.numberOfRemainingFeatOrASIs,
    required this.remainingAsi,
    required this.widgetsInPlay,
    required this.onCharacterChanged,
    required this.onRemainingFeatOrASIsChanged,
    required this.onRemainingAsiChanged,
    required this.onWidgetsInPlayChanged,
  });

  @override
  State<AsiFeatTab> createState() => _AsiFeatTabState();
}

class _AsiFeatTabState extends State<AsiFeatTab> {
  
  Map<String, bool> get featFilters {
    return {
      "Half Feats": true,
      "Full Feats": true
    };
  }

  List<Feat> get filteredFeats {
    List<Feat> feats = FEATLIST.where((feat) => 
      (feat.isHalfFeat && featFilters["Half Feats"]!) || 
      (!feat.isHalfFeat && featFilters["Full Feats"]!)
    ).toList();
    return feats;
  }

  Container buildAsiBlock({
    required AbilityScore score,
  }) {
    int index = abilityScores.indexOf(score.name);
    bool scoreBelowMax = (score.value + widget.character.featsASIScoreIncreases[index] < 20);
    return Container(
      height: 136,
      width: 160,
      decoration: BoxDecoration(
        color: InitialTop.colourScheme.backingColour,
        border: Border.all(color: Colors.black, width: 1.6),
        borderRadius: const BorderRadius.all(
          Radius.circular(5)
        ),
      ),
      child: Column(children: [
        StyleUtils.buildStyledMediumTextBox(text: score.name, color: InitialTop.colourScheme.textColour),
        StyleUtils.buildStyledTextBox(text: "+${widget.character.featsASIScoreIncreases[index]}", size: 45, color: InitialTop.colourScheme.textColour),
        OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: ((!widget.remainingAsi && widget.numberOfRemainingFeatOrASIs == 0) || !(scoreBelowMax))
                ? unavailableColor
                : InitialTop.colourScheme.backingColour,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))
                ),
              side: const BorderSide(width: 3, color: positiveColor),
            ),
            onPressed: () {
              setState(() {
                if (scoreBelowMax) {
                  if (widget.remainingAsi) {
                    widget.onRemainingAsiChanged(false);
                    widget.character.featsASIScoreIncreases[index]++;
                  } else if (widget.numberOfRemainingFeatOrASIs > 0) {
                    widget.onRemainingFeatOrASIsChanged(widget.numberOfRemainingFeatOrASIs - 1);
                    widget.onRemainingAsiChanged(true);
                    widget.character.featsASIScoreIncreases[index]++;
                  }
                }
              });
              widget.onCharacterChanged();
            },
            child: const Icon(Icons.add, color: Colors.white, size: 32)),
      ]),
    );
  }

  SizedBox buildAsiBlockRow({
    required AbilityScore scoreLeft,
    required AbilityScore scoreRight,
  }) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildAsiBlock(score: scoreLeft),
          const SizedBox(width: 10),
          buildAsiBlock(score: scoreRight),
        ],
      )
    );
  }

  OutlinedButton buildBinarySelectorButton({
    required String key
  }) {
    return StyleUtils.buildBinarySelectorButton(
      key: key, 
      filterMap: featFilters, 
      onToggle: () {
        setState(() {
          featFilters[key] = !featFilters[key]!;
        });
      });
  }

  Widget? levelGainParser(List<dynamic> x, Class selectedClass) {
    //TODO: This is a copy of the levelGainParser method from the main create_a_character file
    //      Consider refactoring to avoid duplication if this becomes complex
    if (x[0] == "Level") {
      return null;
    } else if (x[0] == "Nothing") {
      return null;
    } else if (x[0] == "Bonus") {
      widget.character.featuresAndTraits.add("${x[1]}: ${x[2]}");
    } else if (x[0] == "AC") {
      widget.character.ACList.add([x[1], x[2]]);
    } else if (x[0] == "Speed") {
      widget.character.speedBonuses[x[1]]?.add(x[2]);
    } else if (x[0] == "Money") {
      widget.character.currency[x[1]] = widget.character.currency[x[1]]! + int.parse(x[2]);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          const SizedBox(height: 24),
          StyleUtils.buildStyledHugeTextBox(text: "${widget.numberOfRemainingFeatOrASIs} options remaining"),
          const SizedBox(height: 6),
          Row(
            children: [
              /* Display ASI options. */
              Expanded(
                child: SizedBox(
                  height: 550,
                  child: Column(
                    children: [
                      if (widget.remainingAsi)
                        StyleUtils.buildStyledLargeTextBox(text: "You have an unused ASI")
                      else  
                        StyleUtils.buildStyledHugeTextBox(text: "ASI's"),
                      const SizedBox(height: 8),
                      buildAsiBlockRow(scoreLeft: widget.character.strength, scoreRight: widget.character.intelligence),
                      const SizedBox(height: 10),
                      buildAsiBlockRow(scoreLeft: widget.character.dexterity, scoreRight: widget.character.wisdom),
                      const SizedBox(height: 10),
                      buildAsiBlockRow(scoreLeft: widget.character.constitution, scoreRight: widget.character.charisma)
                    ],
                  )
                )
              ),

              /* If feats are allowed display feats options. */
              if (widget.character.featsAllowed ?? false)
                Expanded(
                  child: SizedBox(
                    height: 550,
                    child: Column(
                      children: [
                        /* Title */
                        StyleUtils.buildStyledLargeTextBox(text: "Select Feats:"),
                        const SizedBox(height: 8),

                        /* Filters for the feat selection box */
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildBinarySelectorButton(key: "Full Feats"),                 
                              buildBinarySelectorButton(key: "Half Feats"),
                          ])),
                        const SizedBox(height: 10),

                        /* Feat selection box */
                        Container(
                          height: 140,
                          width: 300,
                          decoration: BoxDecoration(
                            color: unavailableColor,
                            border: Border.all(color: Colors.black, width: 3),
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: filteredFeats.length,
                            itemBuilder: (context, index) {
                              return Tooltip(
                                message: filteredFeats[index].display,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    /* Create a colouring gradient for feats that can be selected multiple times */
                                    backgroundColor: (widget.character.featsSelected.where((feat) => feat[0].name == filteredFeats[index].name).isNotEmpty) ? Color.fromARGB(
                                      100 + (((widget.character.featsSelected.where((feat) => feat[0].name == filteredFeats[index].name).length) / filteredFeats[index].numberOfTimesTakeable) * 155).ceil(),
                                      0,
                                      50 + (((widget.character.featsSelected.where((feat) => feat[0].name == filteredFeats[index].name).length) / filteredFeats[index].numberOfTimesTakeable) * 205).ceil(),
                                      0
                                    )
                                    : Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      /* Check there are choices available for the feat. */
                                      if (widget.numberOfRemainingFeatOrASIs > 0) {
                                        /* Check the feat hasn't been chosen its maximum amount of times. */
                                        if (widget.character.featsSelected.where(
                                          (element) => element[0].name == filteredFeats[index].name
                                        ).length < filteredFeats[index].numberOfTimesTakeable) {

                                          /* Select the feat */
                                          widget.onRemainingFeatOrASIsChanged(widget.numberOfRemainingFeatOrASIs - 1);
                                          widget.character.featsSelected.add([filteredFeats[index]]);

                                          /* Add any necessary choices to the widgetsInPlay */
                                          List<Widget> newWidgets = List.from(widget.widgetsInPlay);
                                          for (List<dynamic> x in filteredFeats[index].abilities) {
                                            if (x.first == "Choice") {
                                              newWidgets.add(SizedBox(height: 80, child: ChoiceRow(x: x.sublist(1), allSelected: widget.character.allSelected)));
                                            } else {
                                              levelGainParser(x, CLASSLIST[index]);
                                            }
                                          }
                                          widget.onWidgetsInPlayChanged(newWidgets);
                                        }
                                      }
                                    });
                                    widget.onCharacterChanged();
                                  },
                                  child: StyleUtils.buildStyledTinyTextBox(text: filteredFeats[index].name)
                                ),
                              );
                            },
                          ),
                        ),

                        /* Display the feats the character already has */
                        if (widget.character.featsSelected.isNotEmpty) ...[
                          StyleUtils.buildStyledLargeTextBox(text: "Selected Feat${displayPlural(widget.character.featsSelected)}:"),
                          SizedBox(
                            height: 50,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: widget.character.featsSelected.length,
                              itemBuilder: (context, index) {
                                return Tooltip(
                                  message: FEATLIST.singleWhere((feat) => feat.name == widget.character.featsSelected[index][0].name).display,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: InitialTop.colourScheme.backingColour,
                                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                      side: BorderSide(color: Colors.black, width: 2),
                                    ),
                                    onPressed: () {},
                                    child: StyleUtils.buildStyledSmallTextBox(text: widget.character.featsSelected[index][0].name, color: InitialTop.colourScheme.textColour)
                                  )
                                );
                              },
                            )
                          ),
                        ],
                      ],
                    )
                  )
                ),
            ],
          )
        ],
      )
    );
  }
}
