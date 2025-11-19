import "package:flutter/material.dart";

import "../../../core/services/global_list_manager.dart";
import "../../../core/theme/theme_manager.dart";
import "../../../core/utils/style_utils.dart";
import "../../../models/core/character/character.dart";
import "../widgets/spell_handling.dart";

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
  late Future<void> _initialisedSpells;

  /// Builds a horizontal scrollable list of spells for a given level
  Widget _buildSpellLevelList(int level) {
    final spellsAtLevel = widget.character.allSpellsSelected
        .where((element) => element.level == level)
        .toList();

    if (spellsAtLevel.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
        padding: const EdgeInsets.only(left: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* Level header with fixed width to prevent shifting */
            SizedBox(
              width: 150,
              child: StyleUtils.buildStyledSmallTextBox(
                text: level == 0 ? "Cantrips:" : "Level $level:",
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: spellsAtLevel.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: positiveColor,
                        side: BorderSide(
                          color:
                              ThemeManager.instance.currentScheme.backingColour,
                          width: 2,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          widget.character.allSpellsSelected
                              .remove(spellsAtLevel[index]);
                          // Find and update the spell list in allSpellsSelectedAsListsOfThings
                          for (final spellListData in widget
                              .character.allSpellsSelectedAsListsOfThings) {
                            if (spellListData[1]
                                .contains(spellsAtLevel[index])) {
                              spellListData[1].remove(spellsAtLevel[index]);
                              spellListData[2]++;
                            }
                          }
                          widget.onCharacterChanged();
                        });
                      },
                      child: Text(
                        spellsAtLevel[index].name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    _initialisedSpells = GlobalListManager().initialiseSpellList();
  }

  @override
  Widget build(BuildContext context) {
    return StyleUtils.styledFutureBuilder(
        future: _initialisedSpells,
        builder: (context) =>
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              /* If the character has nothing to do with spells this displays a message.  */
              if (widget.character.allSpellsSelected.isEmpty &&
                  widget
                      .character.allSpellsSelectedAsListsOfThings.isEmpty) ...[
                const SizedBox(height: 25),
                StyleUtils.buildStyledLargeTextBox(
                    text: "No spells selected or available"),
              ],

              /* Displays all the spells selected by the character and all the options available to allow new spell choices. */
              if (widget.character.allSpellsSelected.isNotEmpty ||
                  widget.character.allSpellsSelectedAsListsOfThings
                      .isNotEmpty) ...[
                StyleUtils.buildStyledLargeTextBox(
                    text: "Choose your spells from regular progression"),
                const SizedBox(height: 20),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /* Left side: Selected spells */
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              (widget.character.allSpellsSelected.isNotEmpty)
                                  ? StyleUtils.buildStyledMediumTextBox(
                                      text: "Spells learned:")
                                  : StyleUtils.buildStyledMediumTextBox(
                                      text: "No spells learned"),
                              const SizedBox(height: 15),
                              // Generate spell lists for each level (0-9)
                              for (int level = 0; level <= 9; level++)
                                _buildSpellLevelList(level),
                            ],
                          ),
                        ),
                      ),
                      /* Right side: Spell selection widgets */
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              ...widget
                                  .character.allSpellsSelectedAsListsOfThings
                                  .map((s) => SpellSelections(
                                      widget.character.allSpellsSelected, s))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ]
            ]));
  }
}
