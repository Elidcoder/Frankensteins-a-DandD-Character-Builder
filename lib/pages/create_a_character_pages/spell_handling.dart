// External Imports
import "package:flutter/material.dart";
import "package:frankenstein/utils/style_utils.dart";

// Project Imports
import "create_a_character.dart";
import "../../content_classes/all_content_classes.dart";
import "../../theme/theme_manager.dart";

/* This creates a widget that represents a classes ability to gain spells. */
class SpellSelections extends StatefulWidget {
  final List<dynamic> thisDescription;
  final List<Spell> allSpells;
  const SpellSelections(this.allSpells, this.thisDescription, {super.key});
  @override
  SpellSelectionsState createState() => SpellSelectionsState(allSpells, thisDescription);
}

class SpellSelectionsState extends State<SpellSelections> {
  List<Spell> allSpellsSelected;
  // Formatted as: [name, [spelllist], numb, formula]
  List<dynamic> thisDescription;
  SpellSelectionsState(this.allSpellsSelected, this.thisDescription);

  // Filters out unavailable spells
  static List<Spell> allAvailableSpells = SPELLLIST.where((spell) => isAllowedContent(spell)).toList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 375,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
        body: Column(children: [
          const SizedBox(height: 20),
          /* Number of choices remaining */
          Text(
            "${thisDescription[2]} remaining ${thisDescription[0]} spell choices",
            style: TextStyle(color: ThemeManager.instance.currentScheme.backingColour, fontSize: 22, fontWeight: FontWeight.w700)
          ),
          
          /* List of spells */
          Container(
            height: 140,
            width: 300,
            decoration: BoxDecoration(
              color: unavailableColor,
              border: Border.all(color: Colors.black, width: 3),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: allAvailableSpells.length,
              itemBuilder: (context, index) {

                /* Button to select a spell after ensuring it is of a valid level */
                return OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: (thisDescription[1].contains(allAvailableSpells[index])
                      ? positiveColor
                      : (allSpellsSelected.contains(allAvailableSpells[index])
                        ? unavailableColor
                        : Colors.white))),
                  onPressed: () {
                    setState(
                      () {
                        if (thisDescription[1].contains(allAvailableSpells[index])) {
                          thisDescription[1].remove(allAvailableSpells[index]);
                          allSpellsSelected.remove(allAvailableSpells[index]);
                          thisDescription[2]++;
                        } else {
                          if (thisDescription[2] > 0) {
                            if (!allSpellsSelected.contains(allAvailableSpells[index])) {
                              thisDescription[1].add(allAvailableSpells[index]);
                              allSpellsSelected.add(allAvailableSpells[index]);
                              thisDescription[2] -= 1;
                            }
                          }
                        }
                        tabRebuildNotifier.value ++;
                      },
                    );
                  },
                  
                  /* Spell name */
                  child: Text(allAvailableSpells[index].name),
                );
              },
            ),
          ),
          
          ],
        )
      )));
  }
}

/* Retrieve a spell from a list. */
Spell listgetter(String spellname) {
  for (int x = 0; x < SPELLLIST.length; x++) {
    if (SPELLLIST[x].name == spellname) {
      return SPELLLIST[x];
    }
  }
  return SPELLLIST[0];
}

class ChoiceRow extends StatefulWidget {
  // Declare the input list of strings or lists of strings
  final List<dynamic>? x;

  const ChoiceRow({super.key, this.x, this.allSelected});
  final List<dynamic>? allSelected;
  @override
  ChoiceRowState createState() => ChoiceRowState(x: x, allSelected: allSelected);
}

class ChoiceRowState extends State<ChoiceRow> {
  // Declare the input list of strings or lists of strings
  final List<dynamic>? x;
  dynamic selected;
  final List<dynamic>? allSelected;

  ChoiceRowState({this.x, this.allSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeManager.instance.currentScheme.backgroundColour,
      body: SizedBox(
      height: 110,
      child: Column(children: [
        Text(
          x![0],
          style: TextStyle(color: ThemeManager.instance.currentScheme.backingColour, fontSize: 18, fontWeight: FontWeight.w700)
        ),
        SizedBox(
          height: 57,
          child: Center(
            child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              /* Use buildRows to create a row of buttons for each element in the x list */
              ...buildRows(context, x?.sublist(1)),
          ],
        )))
      ]),
    ));
  }

  List<Widget> buildRows(BuildContext context, List<dynamic>? inputStringLists) {
    return [for (var input in inputStringLists!)
      /* Check if it is a choice */
      if (!["Choice"].contains(input![0]))
        /* Unpack as non choice. */
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: (selected == input)
              ? const Color.fromARGB(255, 73, 244, 113): null,
          ),
          onPressed: () {
            setState(() {
              if (selected != null) {
                allSelected?.remove(input);
                if (selected == input) {
                  selected = null;
                } else {
                  selected = input;
                  allSelected?.add(input);
                }
              } else {
                selected = input;
                allSelected?.add(input);
              }
            });
          },
          child: Text(input[1]))

      /* Unpack as choice if it is one */
      else
        Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Column(children: [
            Text(input[1],
              style: TextStyle(
                color: ThemeManager.instance.currentScheme.backingColour,
                fontSize: 15,
                fontWeight: FontWeight.w700)),
            Row(children: [...buildRows(context, input.sublist(2))])
          ]),
        )
    ];
  }
}
