import 'package:flutter/material.dart';

import "../../models/character/character.dart";
import '../../utils/style_utils.dart';

class BackstoryTab extends StatefulWidget {
  final Character character;
  final VoidCallback onCharacterChanged;

  const BackstoryTab({
    super.key,
    required this.character,
    required this.onCharacterChanged,
  });

  @override
  State<BackstoryTab> createState() => _BackstoryTabState();
}

class _BackstoryTabState extends State<BackstoryTab> {
  // Local controllers for text fields matching the original
  late TextEditingController ageEnterController;
  late TextEditingController heightEnterController;
  late TextEditingController weightEnterController;
  late TextEditingController eyeColourController;
  late TextEditingController skinEnterController;
  late TextEditingController hairEnterController;
  late TextEditingController backstoryEnterController;
  late TextEditingController additionalFeaturesEnterController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current character values
    ageEnterController = TextEditingController(text: widget.character.characterDescription.age);
    heightEnterController = TextEditingController(text: widget.character.characterDescription.height);
    weightEnterController = TextEditingController(text: widget.character.characterDescription.weight);
    eyeColourController = TextEditingController(text: widget.character.characterDescription.eyes);
    skinEnterController = TextEditingController(text: widget.character.characterDescription.skin);
    hairEnterController = TextEditingController(text: widget.character.characterDescription.hair);
    backstoryEnterController = TextEditingController(text: widget.character.characterDescription.backstory);
    additionalFeaturesEnterController = TextEditingController(text: widget.character.extraFeatures);
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    ageEnterController.dispose();
    heightEnterController.dispose();
    weightEnterController.dispose();
    eyeColourController.dispose();
    skinEnterController.dispose();
    hairEnterController.dispose();
    backstoryEnterController.dispose();
    additionalFeaturesEnterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(children: [
        // Character Description
        const SizedBox(height: 20, width: 10),
        StyleUtils.buildStyledHugeTextBox(text: "Character Information:"),
        const SizedBox(height: 10, width: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Age and Eyes
            Column(
              children: [
                StyleUtils.buildStyledMediumTextBox(text: "Age:"),
                const SizedBox(height: 10),
                StyleUtils.buildStyledSmallTextField(
                hintText: "Enter character's age", 
                textController: ageEnterController, 
                onChanged:(characterAgeEnteredValue) {
                    setState(() {
                      widget.character.characterDescription.age = characterAgeEnteredValue;
                      widget.onCharacterChanged();
                    });
                  }
                ),
                const SizedBox(height: 10),

                StyleUtils.buildStyledMediumTextBox(text: "Eyes:"),
                const SizedBox(height: 10),
                StyleUtils.buildStyledSmallTextField(
                hintText: "Describe your character's eyes", 
                textController: eyeColourController, 
                onChanged:(characterEyeEnteredValue) {
                    setState(() {
                      widget.character.characterDescription.eyes = characterEyeEnteredValue;
                      widget.onCharacterChanged();
                    });
                  }
                ),
              ],
            ),
            const SizedBox(width: 10, height: 100),

            // Height and Skin
            Column(
              children: [
                StyleUtils.buildStyledMediumTextBox(text: "Height:"),
                const SizedBox(height: 10),
                StyleUtils.buildStyledSmallTextField(
                hintText: "Enter character's height", 
                textController: heightEnterController, 
                onChanged:(characterHeightEnteredValue) {
                    setState(() {
                      widget.character.characterDescription.height = characterHeightEnteredValue;
                      widget.onCharacterChanged();
                    });
                  }
                ),
                const SizedBox(height: 10),

                StyleUtils.buildStyledMediumTextBox(text: "Skin:"),
                const SizedBox(height: 10),
                StyleUtils.buildStyledSmallTextField(
                hintText: "Describe your character's skin", 
                textController: skinEnterController, 
                onChanged:(characterSkinEnteredValue) {
                    setState(() {
                      widget.character.characterDescription.skin = characterSkinEnteredValue;
                      widget.onCharacterChanged();
                    });
                  }
                ),
              ],
            ),
            const SizedBox(width: 10, height: 100),

            // Weight and Hair
            Column(
              children: [
                StyleUtils.buildStyledMediumTextBox(text: "Weight:"),
                const SizedBox(height: 10),
                StyleUtils.buildStyledSmallTextField(
                hintText: "Enter character's weight", 
                textController: weightEnterController, 
                onChanged:(characterWeightEnteredValue) {
                    setState(() {
                      widget.character.characterDescription.weight = characterWeightEnteredValue;
                      widget.onCharacterChanged();
                    });
                  }
                ),
                const SizedBox(height: 10),

                StyleUtils.buildStyledMediumTextBox(text: "Hair:"),
                const SizedBox(height: 10),
                StyleUtils.buildStyledSmallTextField(
                hintText: "Describe your character's hair", 
                textController: hairEnterController, 
                onChanged:(characterHairEnteredValue) {
                    setState(() {
                      widget.character.characterDescription.hair = characterHairEnteredValue;
                      widget.onCharacterChanged();
                    });
                  }
                ),
              ],
            )
          ],
        ),

        // Character Backstory
        StyleUtils.buildStyledHugeTextBox(text: "Backstory:"),
        const SizedBox(height: 5),
        StyleUtils.buildStyledLargeTextField(
          hintText: 
            "Write out your character's backstory. This should be a description of their past, including but not limited to: Who raised them/ how were they raised, any serious traumas or achievements in their life and then linking to justify your/ having another, reason for being in the campaign.",
          textController: backstoryEnterController,
          onChanged: (backstoryEnteredValue) {
            setState(() {
              widget.character.characterDescription.backstory = backstoryEnteredValue;
              widget.onCharacterChanged();
            });
          }
        ),

        // Additional Features
        StyleUtils.buildStyledHugeTextBox(text: "Additional Features:"),
        const SizedBox(height: 5),
        StyleUtils.buildStyledLargeTextField(
          hintText: 
            "Write any additional features, skills or abilities which are not a part of the character's race/class/background etc. These should have been agreed apon by your DM or whoever is running the game.",
          textController: additionalFeaturesEnterController,
          onChanged: (extraFeaturesEnteredValue) {
            setState(() {
              widget.character.extraFeatures = extraFeaturesEnteredValue;
              widget.onCharacterChanged();
            });
          }
        ),
      ])
    );
  }
}
