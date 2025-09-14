import 'package:flutter/material.dart';

import '../../../core/utils/style_utils.dart';
import "../../../models/character/character.dart";

/// Quick Edits tab widget for character editing
/// Handles level increases and experience adjustments
class QuickEditsTab extends StatefulWidget {
  final Character character;
  final String characterLevel;
  final VoidCallback onCharacterChanged;
  final ValueChanged<String> onCharacterLevelChanged;

  const QuickEditsTab({
    super.key,
    required this.character,
    required this.characterLevel,
    required this.onCharacterChanged,
    required this.onCharacterLevelChanged,
  });

  @override
  State<QuickEditsTab> createState() => _QuickEditsTabState();
}

class _QuickEditsTabState extends State<QuickEditsTab> {
  String? experienceIncrease;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        StyleUtils.buildStyledLargeTextBox(
            text: "${widget.character.characterDescription.name} is level ${int.parse(widget.characterLevel)} with ${widget.character.characterExperience} experience"),
        if (int.parse(widget.characterLevel) > widget.character.classLevels.fold(0, (val, acc) => val + acc)) ...[
          const SizedBox(height: 16),
          StyleUtils.buildStyledMediumTextBox(
              text: "${widget.character.characterDescription.name} has at least one unused level!!"),
        ],

        const SizedBox(height: 16),
        StyleUtils.buildStyledMediumTextBox(text: "Increase level by 1:"),
        const SizedBox(height: 8),
        OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: (int.parse(widget.characterLevel) < 20)
                  ? StyleUtils.backingColor
                  : const Color.fromARGB(247, 56, 53, 52),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              side: const BorderSide(
                  width: 3, color: Color.fromARGB(255, 27, 155, 10)),
            ),
            onPressed: () {
              if (int.parse(widget.characterLevel) < 20) {
                widget.onCharacterLevelChanged((int.parse(widget.characterLevel) + 1).toString());
              }
            },
            child: Icon(Icons.add, color: StyleUtils.currentTextColor, size: 37)),
        const SizedBox(height: 16),
        StyleUtils.buildStyledMediumTextBox(text: "Experience amount to add:"),
        const SizedBox(height: 8),
        SizedBox(
          width: 320,
          height: 50,
          child: StyleUtils.buildStyledTextField(
            hintText: "Amount of experience to add (number)",
            textController: TextEditingController(),
            textColor: StyleUtils.currentTextColor,
            backingColor: StyleUtils.backingColor,
            filled: true,
            onChanged: (experienceIncreaseEnteredValue) {
              setState(() {
                experienceIncrease = experienceIncreaseEnteredValue;
              });
            },
          ),
        ),
        const SizedBox(height: 20),
        StyleUtils.buildStyledMediumTextBox(text: "Confirm adding experience"),
        const SizedBox(height: 8),
        OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor:
                  (double.tryParse(experienceIncrease ?? "NOT NUMBER") !=
                          null)
                      ? StyleUtils.backingColor
                      : const Color.fromARGB(247, 56, 53, 52),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              side: const BorderSide(
                  width: 3, color: Color.fromARGB(255, 27, 155, 10)),
            ),
            onPressed: () {
              if (double.tryParse(experienceIncrease ?? "NOT NUMBER") != null) {
                widget.character.characterExperience += double.tryParse(
                        experienceIncrease ?? "NOT NUMBER") ??
                    0;
                widget.onCharacterChanged();
                //validate level
              }
            },
            child: Icon(Icons.add, color: StyleUtils.currentTextColor, size: 37))
      ],
    );
  }
}
