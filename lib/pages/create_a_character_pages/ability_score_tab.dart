import "package:flutter/material.dart";
import "../../main.dart";
import "../../content_classes/all_content_classes.dart";
import "../../utils/style_utils.dart";

/// Ability Score tab widget for character creation
/// Handles ability score point allocation using the point-buy system
class AbilityScoreTab extends StatefulWidget {
  final Character character;
  final int pointsRemaining;
  final Function(int) onPointsRemainingChanged;

  const AbilityScoreTab({
    super.key,
    required this.character,
    required this.pointsRemaining,
    required this.onPointsRemainingChanged,
  });

  @override
  State<AbilityScoreTab> createState() => _AbilityScoreTabState();
}

class _AbilityScoreTabState extends State<AbilityScoreTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(children: [
        const SizedBox(height: 29),
        Text(
          textAlign: TextAlign.center,
          "Points remaining: ${widget.pointsRemaining}",
          style: TextStyle(fontSize: 50, fontWeight: FontWeight.w700, color: InitialTop.colourScheme.backingColour),
        ),
        const SizedBox(height: 35),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 10,
            children: [
              const SizedBox(width: 0),
              buildAbilityScoreBlock(score: widget.character.strength),
              buildAbilityScoreBlock(score: widget.character.dexterity),
              buildAbilityScoreBlock(score: widget.character.constitution),
              buildAbilityScoreBlock(score: widget.character.intelligence),
              buildAbilityScoreBlock(score: widget.character.wisdom),
              buildAbilityScoreBlock(score: widget.character.charisma)
            ],
        ))
      ]),
    );
  }

  Column buildAbilityScoreBlock({
    required AbilityScore score,
  }) {
    
    // Increment/decrement logic helper methods
    void decrementScore() {
      if (score.value > 8) {
        score.value--;
        widget.onPointsRemainingChanged(widget.pointsRemaining + score.abilityScoreCost);
      }
    }

    void incrementScore() {
      if (score.value < 15) {
        final cost = score.abilityScoreCost;
        if (cost <= widget.pointsRemaining) {
          widget.onPointsRemainingChanged(widget.pointsRemaining - cost);
          score.value ++;
        }
      }
    }

    bool canAdd = score.value < 15;
    bool canRemove = 8 < score.value;
    int index = abilityScores.indexOf(score.name);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Name
        StyleUtils.buildStyledHugeTextBox(text: score.name),
        const SizedBox(height: 25),

        // Base value & increment/decrement buttons
        Container(
          height: 128.2,
          width: 135.2,
          decoration: BoxDecoration(
            color: InitialTop.colourScheme.backingColour,
            border: Border.all(color: Colors.black, width: 1.6),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Column(
            children: [
              // Current Value
              Text(
                textAlign: TextAlign.center,
                "${score.value}",
                style: TextStyle(
                    fontSize: 65,
                    fontWeight: FontWeight.w700,
                    color: InitialTop.colourScheme.textColour),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // If only one button available, centre it
                  if (!canAdd || !canRemove)
                    const SizedBox(height: 20, width: 33.8),

                  // Decrement Button
                  if (canRemove)
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: InitialTop.colourScheme.backingColour,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        side: const BorderSide(
                          width: 3,
                          color: negativeColor,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          decrementScore();
                        });
                      },
                      child: const Icon(Icons.remove, color: Colors.white),
                    ),

                  // Increment Button
                  if (canAdd)
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            (score.abilityScoreCost > widget.pointsRemaining)
                                ? unavailableColor 
                                : InitialTop.colourScheme.backingColour,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        side: const BorderSide(
                          width: 3,
                          color: positiveColor,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          incrementScore();
                        });
                      },
                      child: const Icon(Icons.add, color: Colors.white),
                    )
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Race and Feat Increases
        Row(
        crossAxisAlignment: CrossAxisAlignment.center, 
        children: [
          const SizedBox(width: 19),
          Text(
            textAlign: TextAlign.center,
            " (+${widget.character.raceAbilityScoreIncreases[index]}) ",
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          Text(
            textAlign: TextAlign.center,
            " (+${widget.character.featsASIScoreIncreases[index]}) ",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
              color: InitialTop.colourScheme.backingColour,
            ),
          ),
        ]),

        const SizedBox(height: 10),

        // Final displayed total
        Container(
          width: 90,
          height: 80,
          decoration: BoxDecoration(
            color: InitialTop.colourScheme.backingColour,
            border: Border.all(color: Colors.black, width: 1.6),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Text(
            (score.value + widget.character.raceAbilityScoreIncreases[index] + widget.character.featsASIScoreIncreases[index]).toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.w700,
              color: InitialTop.colourScheme.textColour,
            ),
          ),
        ),
      ],
    );
  }
}
