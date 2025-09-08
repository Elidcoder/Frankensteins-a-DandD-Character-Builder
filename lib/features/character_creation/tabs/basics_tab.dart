import "package:flutter/material.dart";

import "../../../models/character/character.dart";
import "../../../utils/style_utils.dart";

/// Basics tab widget for character creation
/// Handles character info, leveling method, and build parameters
class BasicsTab extends StatefulWidget {
  final Character character;
  final String? levellingMethod;
  final String? characterLevel;
  final TextEditingController nameEnterController;
  final TextEditingController playerNameEnterController;
  final TextEditingController genderEnterController;
  final TextEditingController experienceEnterController;
  final int numberOfRemainingFeatOrASIs;
  final VoidCallback onCharacterChanged;
  final void Function(String?) onLevellingMethodChanged;
  final void Function(String?) onCharacterLevelChanged;
  final void Function(int) onNumberOfRemainingFeatOrASIsChanged;

  const BasicsTab({
    super.key,
    required this.character,
    required this.levellingMethod,
    required this.characterLevel,
    required this.nameEnterController,
    required this.playerNameEnterController,
    required this.genderEnterController,
    required this.experienceEnterController,
    required this.numberOfRemainingFeatOrASIs,
    required this.onCharacterChanged,
    required this.onLevellingMethodChanged,
    required this.onCharacterLevelChanged,
    required this.onNumberOfRemainingFeatOrASIsChanged,
  });

  @override
  State<BasicsTab> createState() => _BasicsTabState();
}

class _BasicsTabState extends State<BasicsTab> {

  int get charLevel {
    return int.parse(widget.characterLevel ?? "1");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          const SizedBox(height: 65),
          Row(
            children: [
              Expanded(
                  child: Column(children: [
                //title
                StyleUtils.buildSectionHeader("Character info"),
                const SizedBox(height: 25),
                //Character name input
                StyleUtils.buildStyledSmallTextField(
                  hintText: "Enter character's name", 
                  textController: widget.nameEnterController, 
                  onChanged: (characterNameEnteredValue) {
                    setState(() {
                      widget.character.characterDescription.name = characterNameEnteredValue;
                    });
                    widget.onCharacterChanged();
                  }
                ),
                const SizedBox(height: 15),
                //Player name input
                StyleUtils.buildStyledSmallTextField(
                  hintText: "Enter the player's name", 
                  textController: widget.playerNameEnterController, 
                  onChanged: (playerNameEnteredValue) {
                    setState(() {
                      widget.character.playerName = playerNameEnteredValue;
                    });
                    widget.onCharacterChanged();
                  }
                ),
                const SizedBox(height: 15),
                //Character gender input
                StyleUtils.buildStyledSmallTextField(
                  hintText: "Enter the character's gender", 
                  textController: widget.genderEnterController, 
                  onChanged:  (characterGenderEnteredValue) {
                    setState(() {
                      widget.character.characterDescription.gender = characterGenderEnteredValue;
                    });
                    widget.onCharacterChanged();
                  }
                ),
                const SizedBox(height: 15),
                //exp/levels section
                SizedBox(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //use experience
                      StyleUtils.buildStyledRadioListTile(
                        title: "Use experience",
                        value: "Experience",
                        groupValue: widget.levellingMethod,
                        onChanged: (value) {
                          widget.onLevellingMethodChanged(value.toString());
                        },
                      ),
                      const SizedBox(height: 15),
                      //Experience enterence option if experience is selected
                      //otherwise display the use levels radio tile
                      Container(
                        child: (widget.levellingMethod == "Experience") ? 
                          StyleUtils.buildStyledSmallTextField(
                            hintText: "Enter the character's exp", 
                            textController: widget.experienceEnterController, 
                            onChanged:  (characterExperienceEnteredValue) {
                              setState(() {
                                //FUTUREPLAN(Implement the experience levelling alternative);
                              });
                              widget.onCharacterChanged();
                            }
                          ) : 
                          StyleUtils.buildStyledRadioListTile(
                            title: "Use levels",
                            value: "Levels",
                            groupValue: widget.levellingMethod,
                            onChanged: (value) {
                              widget.onLevellingMethodChanged(value.toString());
                            },
                          )
                      ),
                      const SizedBox(height: 5),
                      //levels radio tile if experience is selected
                      //otherwise the levels selection option
                      Container(
                        child: (widget.levellingMethod == "Experience") ? 
                          StyleUtils.buildStyledRadioListTile(
                            title: "Use levels",
                            value: "Levels",
                            groupValue: widget.levellingMethod,
                            onChanged: (value) {
                              widget.onLevellingMethodChanged(value.toString());
                            },
                          ) : Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                              color: StyleUtils.backingColor,
                            ),
                            height: 45,
                            child: DropdownButton<String>(
                              alignment: Alignment.center,
                              value: widget.characterLevel,
                              icon: Icon(Icons.arrow_drop_down, color: StyleUtils.currentTextColor),
                              elevation: 16,
                              style: TextStyle(
                                color: StyleUtils.currentTextColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 20),
                              underline: const SizedBox(),
                              onChanged: (String? value) {
                                widget.onCharacterLevelChanged(value);
                              },
                              items: [for (var i = charLevel; i <= 20; i += 1) i.toString()]
                                .toList()
                                .map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Align(
                                      child: Text(value,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: StyleUtils.currentTextColor,
                                          decoration: TextDecoration.underline,
                                        ))),
                                  );
                                }).toList(),
                              dropdownColor: StyleUtils.backingColor
                            ),
                          ),
                      ),
                      const SizedBox(height: 10),
                    ]))
              ])),
              Expanded(
                  child: Column(
                children: [
                  StyleUtils.buildSectionHeader("Build Parameters"),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: 325,
                    child: Column(
                      children: [
                        StyleUtils.buildStyledCheckboxListTile(
                          title: "Feats in use", 
                          value: widget.character.featsAllowed ?? false, 
                          onChanged: (bool? value) {
                            setState(() {
                              widget.character.featsAllowed = value;
                            });
                            widget.onCharacterChanged();
                          }
                        ),
                        const SizedBox(height: 15),
                        StyleUtils.buildStyledCheckboxListTile(
                          title: "Use average for hit dice", 
                          value: widget.character.averageHitPoints ?? false, 
                          onChanged: (bool? value) {
                            setState(() {
                              widget.character.averageHitPoints = value;
                            });
                            widget.onCharacterChanged();
                          }
                        ),
                        const SizedBox(height: 15),
                        StyleUtils.buildStyledCheckboxListTile(
                          title: "Allow multiclassing", 
                          value: widget.character.multiclassing ?? false, 
                          onChanged: (bool? value) {
                            setState(() {
                              widget.character.multiclassing = value;
                            });
                            widget.onCharacterChanged();
                          }
                        ),
                        const SizedBox(height: 15),
                        StyleUtils.buildStyledCheckboxListTile(
                          title: "Use milestone levelling", 
                          value: widget.character.milestoneLevelling ?? false, 
                          onChanged: (bool? value) {
                            setState(() {
                              widget.character.milestoneLevelling = value;
                            });
                            widget.onCharacterChanged();
                          }
                        ),
                        const SizedBox(height: 15),
                        StyleUtils.buildStyledCheckboxListTile(
                          title: "Use created content", 
                          value: widget.character.useCustomContent ?? false, 
                          onChanged: (bool? value) {
                            setState(() {
                              widget.character.useCustomContent = value;
                            });
                            widget.onCharacterChanged();
                          }
                        ),
                        const SizedBox(height: 15),
                        StyleUtils.buildStyledCheckboxListTile(
                          title: "Use optional class features", 
                          value: widget.character.optionalClassFeatures ?? false, 
                          onChanged: (bool? value) {
                            setState(() {
                              widget.character.optionalClassFeatures = value;
                            });
                            widget.onCharacterChanged();
                          }
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              )),
              Expanded(
                  child: Column(
                  children: [
                  StyleUtils.buildSectionHeader("Rarer Parameters"),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: 325,
                    child: Column(
                      children: [
                        StyleUtils.buildStyledCheckboxListTile(
                          title: "Use critical role content", 
                          value: widget.character.criticalRoleContent ?? false, 
                          onChanged: (bool? value) {
                            setState(() {
                              widget.character.criticalRoleContent = value;
                            });
                            widget.onCharacterChanged();
                          }
                        ),
                        const SizedBox(height: 15),
                        StyleUtils.buildStyledCheckboxListTile(
                          title: "Use encumberance rules", 
                          value: widget.character.encumberanceRules ?? false, 
                          onChanged: (bool? value) {
                            setState(() {
                              widget.character.encumberanceRules = value;
                            });
                            widget.onCharacterChanged();
                          }
                        ),
                        const SizedBox(height: 15),
                        StyleUtils.buildStyledCheckboxListTile(
                          title: "Incude coins' weights", 
                          value: widget.character.includeCoinsForWeight ?? false, 
                          onChanged: (bool? value) {
                            setState(() {
                              widget.character.includeCoinsForWeight = value;
                            });
                            widget.onCharacterChanged();
                          }
                        ),
                        const SizedBox(height: 15),
                        StyleUtils.buildStyledCheckboxListTile(
                          title: "Use UA content", 
                          value:  widget.character.unearthedArcanaContent ?? false, 
                          onChanged: (bool? value) {
                            setState(() {
                               widget.character.unearthedArcanaContent = value;
                            });
                            widget.onCharacterChanged();
                          }
                        ),
                        const SizedBox(height: 15),
                        StyleUtils.buildStyledCheckboxListTile(
                          title: "Allow firearms", 
                          value:  widget.character.firearmsUsable ?? false, 
                          onChanged: (bool? value) {
                            setState(() {
                               widget.character.firearmsUsable = value;
                            });
                            widget.onCharacterChanged();
                          }
                        ),
                        const SizedBox(height: 15),
                        StyleUtils.buildStyledCheckboxListTile(
                          title: "Give an extra feat at lvl 1", 
                          value:  widget.character.extraFeatAtLevel1 ?? false, 
                          onChanged: (bool? value) {
                            setState(() {
                              if (widget.character.classList.isNotEmpty) {
                                if (widget.character.extraFeatAtLevel1 ?? false) {
                                  if (widget.numberOfRemainingFeatOrASIs > 0) {
                                    widget.onNumberOfRemainingFeatOrASIsChanged(widget.numberOfRemainingFeatOrASIs - 1);
                                    widget.character.extraFeatAtLevel1 = false;
                                  }
                                } else {
                                  widget.character.extraFeatAtLevel1 = true;
                                  widget.onNumberOfRemainingFeatOrASIsChanged(widget.numberOfRemainingFeatOrASIs + 1);
                                }
                              } else {
                                widget.character.extraFeatAtLevel1 =
                                    !(widget.character.extraFeatAtLevel1 ?? false);
                              }
                            });
                            widget.onCharacterChanged();
                          }
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ))
            ],
          )
        ],
      ),
    );
  }
}
