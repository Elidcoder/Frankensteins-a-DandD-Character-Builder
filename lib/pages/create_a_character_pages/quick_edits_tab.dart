import 'package:flutter/material.dart';
import '../../content_classes/character/character.dart';
import '../../main.dart';
import '../../utils/style_utils.dart';

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
            color: InitialTop.colourScheme.backingColour
          ),
        ],

        const SizedBox(height: 16),
        StyleUtils.buildStyledSmallTextBox(
          text: "Increase level by 1:",
          color: InitialTop.colourScheme.backingColour
        ),
        const SizedBox(height: 8),
        StyleUtils.buildStyledButton(
          enabled: int.parse(widget.characterLevel) < 20,
          onPressed: () {
            if (int.parse(widget.characterLevel) < 20) {
              widget.onCharacterLevelChanged((int.parse(widget.characterLevel) + 1).toString());
            }
          },
          child: Icon(Icons.add, color: InitialTop.colourScheme.textColour, size: 37),
        ),
        const SizedBox(height: 16),
        StyleUtils.buildStyledSmallTextBox(
          text: "Experience amount to add:",
          color: InitialTop.colourScheme.backingColour
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
          color: InitialTop.colourScheme.backingColour
        ),
        const SizedBox(height: 8),
        StyleUtils.buildStyledButton(
          enabled: double.tryParse(experienceIncrease ?? "NOT NUMBER") != null,
          onPressed: () {
            if (double.tryParse(experienceIncrease ?? "NOT NUMBER") != null) {
              widget.character.characterExperience += double.tryParse(
                      experienceIncrease ?? "NOT NUMBER") ??
                  0;
              widget.onCharacterChanged();
              //validate level
            }
          },
          child: Icon(Icons.add, color: InitialTop.colourScheme.textColour, size: 37),
        )
      ],
    );
  }
}
