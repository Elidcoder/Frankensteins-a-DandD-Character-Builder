import 'package:flutter/material.dart';

import '../../../core/theme/theme_manager.dart';
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
  late TextEditingController experienceController;

  @override
  void initState() {
    super.initState();
    experienceController = TextEditingController();
  }

  @override
  void dispose() {
    experienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        StyleUtils.buildStyledMediumTextBox(
          text: "${widget.character.characterDescription.name} is level ${int.parse(widget.characterLevel)} with ${widget.character.characterExperience} experience"
        ),
        if (int.parse(widget.characterLevel) > widget.character.classLevels.fold(0, (val, acc) => val + acc)) ...[
          const SizedBox(height: 16),
          StyleUtils.buildStyledSmallTextBox(
            text: "${widget.character.characterDescription.name} has at least one unused level!!",
            color: ThemeManager.instance.currentScheme.backingColour
          ),
        ],

        const SizedBox(height: 16),
        StyleUtils.buildStyledSmallTextBox(
          text: "Increase level by 1:",
          color: ThemeManager.instance.currentScheme.backingColour
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: int.parse(widget.characterLevel) < 20 ? () {
            widget.onCharacterLevelChanged((int.parse(widget.characterLevel) + 1).toString());
          } : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeManager.instance.currentScheme.backingColour,
            foregroundColor: ThemeManager.instance.currentScheme.textColour,
          ),
          child: Icon(Icons.add, color: ThemeManager.instance.currentScheme.textColour, size: 37),
        ),
        const SizedBox(height: 16),
        StyleUtils.buildStyledSmallTextBox(
          text: "Experience amount to add:",
          color: ThemeManager.instance.currentScheme.backingColour
        ),
        const SizedBox(height: 8),
        StyleUtils.buildStyledSmallTextField(
          width: 320,
          hintText: "Amount of experience to add (number)",
          textController: experienceController,
          onChanged: (experienceIncreaseEnteredValue) {
            setState(() {
              experienceIncrease = experienceIncreaseEnteredValue;
            });
          },
        ),
        const SizedBox(height: 20),
        StyleUtils.buildStyledSmallTextBox(
          text: "Confirm adding experience",
          color: ThemeManager.instance.currentScheme.backingColour
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: double.tryParse(experienceIncrease ?? "NOT NUMBER") != null ? () {
            widget.character.characterExperience += double.tryParse(
                    experienceIncrease ?? "NOT NUMBER") ??
                0;
            widget.onCharacterChanged();
            //validate level
          } : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeManager.instance.currentScheme.backingColour,
            foregroundColor: ThemeManager.instance.currentScheme.textColour,
          ),
          child: Icon(Icons.add, color: ThemeManager.instance.currentScheme.textColour, size: 37),
        )
      ],
    );
  }
}
