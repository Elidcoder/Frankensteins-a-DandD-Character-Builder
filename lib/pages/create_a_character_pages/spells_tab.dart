import "package:flutter/material.dart";
import "../../content_classes/all_content_classes.dart";
import "../../utils/style_utils.dart";
import "../../main.dart";
import "spell_handling.dart";

/// Spells tab widget for character creation
/// Displays spell selections organized by spell level and spell selection options
class SpellsTab extends StatefulWidget {
  final Character character;
  final VoidCallback onCharacterChanged;

  const SpellsTab({
    super.key,
    required this.character,
    required this.onCharacterChanged,
  });

  @override
  State<SpellsTab> createState() => _SpellsTabState();
}

class _SpellsTabState extends State<SpellsTab> {

  /// Builds a horizontal ListView of spells for a given level
  Widget _buildSpellLevelList(int level) {
    final spellsAtLevel = widget.character.allSpellsSelected
        .where((element) => element.level == level)
        .toList();
        
    if (spellsAtLevel.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(level == 0 ? "Cantrips:" : "Level $level Spells:"),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: spellsAtLevel.length,
            itemBuilder: (context, index) {
              return OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white),
                onPressed: () {},
                child: Text(spellsAtLevel[index].name),
              );
            },
          )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      /* If the character has nothing to do with spells this displays a message.  */
      if (widget.character.allSpellsSelected.isEmpty && widget.character.allSpellsSelectedAsListsOfThings.isEmpty) ...[
        const SizedBox(height: 25),
        StyleUtils.buildStyledHugeTextBox(text: "No spells selected or available"),
      ],
      
      /* Displays all the spells selected by the character and all the options available to allow new spell choices. */
      if (widget.character.allSpellsSelected.isNotEmpty || widget.character.allSpellsSelectedAsListsOfThings.isNotEmpty) ...[
        Text("Choose your spells from regular progression",
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: InitialTop.colourScheme.backingColour)),
        Row(children: [
          Expanded(child: Column(children: [
            (widget.character.allSpellsSelected.isNotEmpty) 
            ? StyleUtils.buildStyledLargeTextBox(text: "Spells learned:")
            : StyleUtils.buildStyledLargeTextBox(text: "No spells learned"),
            
            // Generate spell lists for each level (0-9)
            for (int level = 0; level <= 9; level++)
              _buildSpellLevelList(level),
          ])),
          Expanded(
            child: SingleChildScrollView(child: Column(
              children: [
              const SizedBox(height: 20),
              ...widget.character.allSpellsSelectedAsListsOfThings.map(
                (s) => SpellSelections(widget.character.allSpellsSelected, s)
              )
              ]
            )),
          )
        ]),
    ]]);
  }
}
