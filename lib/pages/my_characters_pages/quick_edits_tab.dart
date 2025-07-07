import 'package:flutter/material.dart';
import '../../content_classes/character/character.dart';
import '../../theme/theme_manager.dart';

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
        Text(
            "${widget.character.characterDescription.name} is level ${int.parse(widget.characterLevel)} with ${widget.character.characterExperience} experience",
            style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w700,
                color: ThemeManager.instance.currentScheme.backingColour)),
        if (int.parse(widget.characterLevel) > widget.character.classLevels.fold(0, (val, acc) => val + acc)) ...[
          const SizedBox(height: 16),
          Text("${widget.character.characterDescription.name} has at least one unused level!!",
              style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  color: ThemeManager.instance.currentScheme.backingColour)),
        ],

        const SizedBox(height: 16),
        Text("Increase level by 1:  ",
            style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w600,
                color: ThemeManager.instance.currentScheme.backingColour)),
        const SizedBox(height: 8),
        OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: (int.parse(widget.characterLevel) < 20)
                  ? ThemeManager.instance.currentScheme.backingColour
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
            child: Icon(Icons.add, color: ThemeManager.instance.currentScheme.textColour, size: 37)),
        const SizedBox(height: 16),
        Text("Experience amount to add:  ",
            style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w600,
                color: ThemeManager.instance.currentScheme.backingColour)),
        const SizedBox(height: 8),
        SizedBox(
          width: 320,
          height: 50,
          child: TextField(
              cursorColor: ThemeManager.instance.currentScheme.backingColour,
              style: TextStyle(
                color: ThemeManager.instance.currentScheme.textColour,
              ),
              decoration: InputDecoration(
                  hintText: "Amount of experience to add (number)",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: ThemeManager.instance.currentScheme.textColour),
                  filled: true,
                  fillColor: ThemeManager.instance.currentScheme.backingColour,
                  border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius:
                          BorderRadius.all(Radius.circular(12)))),
              onChanged: (experienceIncreaseEnteredValue) {
                setState(() {
                  experienceIncrease = experienceIncreaseEnteredValue;
                });
              }),
        ),
        const SizedBox(height: 20),
        Text("Confirm adding experience",
            style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w600,
                color: ThemeManager.instance.currentScheme.backingColour)),
        const SizedBox(height: 8),
        OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor:
                  (double.tryParse(experienceIncrease ?? "NOT NUMBER") !=
                          null)
                      ? ThemeManager.instance.currentScheme.backingColour
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
            child: Icon(Icons.add, color: ThemeManager.instance.currentScheme.textColour, size: 37))
      ],
    );
  }
}
