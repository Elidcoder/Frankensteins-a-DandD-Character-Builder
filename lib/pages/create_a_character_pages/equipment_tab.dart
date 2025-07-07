import "package:flutter/material.dart";
import "../../content_classes/all_content_classes.dart";
import "../../utils/style_utils.dart";
import "../../theme/theme_manager.dart";

/// Equipment tab widget for character creation
/// Handles equipment purchasing, filtering, and selection from background/class choices
class EquipmentTab extends StatefulWidget {
  final Character character;
  final List<String> coinTypesSelected;
  final VoidCallback onCharacterChanged;
  final Function(List<String>) onCoinTypesChanged;

  const EquipmentTab({
    super.key,
    required this.character,
    required this.coinTypesSelected,
    required this.onCharacterChanged,
    required this.onCoinTypesChanged,
  });

  @override
  State<EquipmentTab> createState() => _EquipmentTabState();
}

class _EquipmentTabState extends State<EquipmentTab> {
  
  List<Item> get filteredItems {
    return ITEMLIST.where((element) =>
      ((element.equipmentType.contains("Armour") && element.equipmentType.any((item) => widget.character.armourList.contains(item))) 
      || (element.equipmentType.contains("Weapon") && element.equipmentType.any((item) => widget.character.weaponList.contains(item))) 
      || (element.equipmentType.contains("Item") && ((widget.character.itemList.contains("Stackable") && element.stackable) 
      || (widget.character.itemList.contains("Unstackable") && !element.stackable)))) && widget.coinTypesSelected.contains(element.cost[1] as String)
      ).toList();
  }

  Widget makeStyledFilterToggle(String label, List<String> filters) {
    return StyleUtils.makeStyledFilterToggle(
      label,
      filters,
      () {
        setState(() {
          if (filters.contains(label)) {
            filters.remove(label);
          } else {
            filters.add(label);
          }
        });
        widget.onCharacterChanged();
      },
    );
  }

  Widget makeCoinFilterToggle(String label) {
    return StyleUtils.makeStyledFilterToggle(
      label,
      widget.coinTypesSelected,
      () {
        setState(() {
          List<String> newCoinTypes = List.from(widget.coinTypesSelected);
          if (newCoinTypes.contains(label)) {
            newCoinTypes.remove(label);
          } else {
            newCoinTypes.add(label);
          }
          widget.onCoinTypesChanged(newCoinTypes);
        });
      },
    );
  }

  String produceEquipmentOptionDescription(List list) {
    // Initialize an empty string to store the result
    String result = '';

    // Iterate through the list
    for (int i = 0; i < list.length; i++) {
      // Check if the current element is a number
      if (list[i] is num) {
        // Append the current number and string pair to the result string
        result += '${list[i]}x${list[i + 1]}';

        // Skip over the next element (the string)
        i++;
      } else {
        // Append just the current string to the result string
        result += '${list[i]}';
      }

      // If this is not the last element, add a comma and space separator
      if (i != list.length - 1) result += ', ';
    }

    // Return the final formatted string
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Row(children: [
        Expanded(flex: 2, child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child:SizedBox(
            height: 435,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /* Title */
                const SizedBox(height: 9),
                StyleUtils.buildStyledLargeTextBox(text: "Purchase Equipment"),

                /* Display the characters available money */
                const SizedBox(height: 6),
                Text(
                  "You have ${widget.character.currency["Platinum Pieces"]} platinum, ${widget.character.currency["Gold Pieces"]} gold, ${widget.character.currency["Electrum Pieces"]} electrum, ${widget.character.currency["Silver Pieces"]} silver and ${widget.character.currency["Copper Pieces"]} copper pieces to spend",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: ThemeManager.instance.currentScheme.backingColour)
                ),
                
                /* Row of buttons for Armour, Weapons & Items */
                const SizedBox(height: 6),
                SizedBox(
                  width: 956,
                  child: Row(children: [

                    /* Buttons for armour. */
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: (widget.character.armourList.length == 4)
                          ? ThemeManager.instance.currentScheme.backingColour
                          : unavailableColor),
                      onPressed: () {
                        setState(() {
                          /* If all types of armour are selected, clear filters. */
                          if (widget.character.armourList.length == 4) {
                            widget.character.armourList.clear();

                          /* Otherwise add all types of armour to the filters. */
                          } else {
                            widget.character.armourList = [
                              "Heavy",
                              "Light",
                              "Medium",
                              "Shield"
                            ];
                          }
                        });
                        widget.onCharacterChanged();
                      },
                      
                      child: SizedBox(
                        width: 370,
                        height: 63,
                        child: Column(
                          children: [
                            /* Title */
                            Text("Armour", style: TextStyle(color: ThemeManager.instance.currentScheme.textColour,fontSize: 22)),
                            Row(
                              children: [

                                /* Button to toggle the light armour filter */
                                makeStyledFilterToggle("Light", widget.character.armourList),

                                /* Button to toggle the medium armour filter */
                                makeStyledFilterToggle("Medium", widget.character.armourList),
                                
                                /* Button to toggle the Heavy armour filter */
                                makeStyledFilterToggle("Heavy", widget.character.armourList),

                                /* Button to toggle the shield filter */
                                makeStyledFilterToggle("Shield", widget.character.armourList),
                              ],
                            )
                          ],
                        )),
                    ),
                    const SizedBox(width: 2),

                    /* Buttons for weapons. */
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: (widget.character.weaponList.length == 2)
                          ? ThemeManager.instance.currentScheme.backingColour
                          : unavailableColor),
                      onPressed: () {
                        setState(() {
                          if (widget.character.weaponList.length == 2) {
                            widget.character.weaponList.clear();
                          } else {
                            widget.character.weaponList = ["Ranged", "Melee"];
                          }
                        });
                        widget.onCharacterChanged();
                      },
                      child: SizedBox(
                        width: 192,
                        height: 63,
                        child: Column(
                          children: [
                            /* Title */
                            Text("Weapon", style: TextStyle(color: ThemeManager.instance.currentScheme.textColour, fontSize: 22)),
                            Row(
                              children: [

                                /* Button to toggle the ranged filter */
                                makeStyledFilterToggle("Ranged", widget.character.weaponList),

                                /* Button to toggle the melee filter */
                                makeStyledFilterToggle("Melee", widget.character.weaponList),
                              ],
                            )
                          ],
                        )),
                    ),
                    const SizedBox(width: 2),

                    /* Buttons for items. */
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                          (widget.character.itemList.length == 2)
                            ? ThemeManager.instance.currentScheme.backingColour
                            : unavailableColor),
                      onPressed: () {
                        setState(() {
                          if (widget.character.itemList.length == 2) {
                            widget.character.itemList.clear();
                          } else {
                            widget.character.itemList = [
                              "Stackable",
                              "Unstackable"
                            ];
                          }
                        });
                        widget.onCharacterChanged();
                      },
                      child: SizedBox(
                        width: 246,
                        height: 63,
                        child: Column(
                          children: [
                            Text("Items", style: TextStyle(color: ThemeManager.instance.currentScheme.textColour, fontSize: 22)),
                            Row(
                              children: [

                                /* Button to toggle the stackable filter */
                                makeStyledFilterToggle("Stackable", widget.character.itemList),

                                /* Button to toggle the unstackable filter */
                                makeStyledFilterToggle("Unstackable", widget.character.itemList),
                              ],
                            )
                          ],
                        )),
                    ),
                  ]),
                ),
                const SizedBox(height: 4),

                /* Buttons for costs. */
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: (widget.coinTypesSelected.length == 5)
                      ? ThemeManager.instance.currentScheme.backingColour
                      : unavailableColor),
                  onPressed: () {
                    setState(() {
                      /* If all types of coins are selected, clear filters. */
                      if (widget.coinTypesSelected.length == 5) {
                        widget.onCoinTypesChanged([]);
                      /* Otherwise add all types of coins to the filters. */
                      } else {
                        widget.onCoinTypesChanged([
                          "Platinum",
                          "Gold",
                          "Electrum",
                          "Silver",
                          "Copper"
                        ]);
                      }
                    });
                  },
                  child: SizedBox(
                    width: 483,
                    height: 63,
                    child: Column(
                      children: [
                        /* Title */
                        Text("Coin types", style: TextStyle(color: ThemeManager.instance.currentScheme.textColour, fontSize: 22)),
                        Row(
                          children: [

                            /* Button to select items that cost platinum. */
                            makeCoinFilterToggle("Platinum"),

                            /* Button to select items that cost gold. */
                            makeCoinFilterToggle("Gold"),

                            /* Button to select items that cost electrum. */
                            makeCoinFilterToggle("Electrum"),

                            /* Button to select items that cost silver. */
                            makeCoinFilterToggle("Silver"),

                            /* Button to select items that cost copper. */
                            makeCoinFilterToggle("Copper")
                          ],
                        )
                      ],
                    )),
                ),

                /* Display the filtered items */
                const SizedBox(height: 4),
                Container(
                    padding: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: ThemeManager.instance.currentScheme.backgroundColour,
                      border: Border.all(color: Colors.black, width: 1.6),
                      borderRadius: const BorderRadius.all(Radius.circular(5))
                    ),
                    height: 200,
                    width: 600,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        alignment: WrapAlignment.center,
                        children: List.generate(filteredItems.length, (index) {
                          return OutlinedButton(
                            style: OutlinedButton.styleFrom(backgroundColor: ThemeManager.instance.currentScheme.backingColour),

                            /* If the character has enough money of the correct denomination than the purchase is made. */
                            onPressed: () {
                              setState(() {
                                if (filteredItems[index].cost[0] <= widget.character.currency["${filteredItems[index].cost[1]} Pieces"]) {
                                  widget.character.currency["${filteredItems[index].cost[1]} Pieces"] = 
                                    widget.character.currency["${filteredItems[index].cost[1]} Pieces"]! - (filteredItems[index].cost[0] as int);
                                  if (filteredItems[index]
                                      .stackable) {
                                    if (widget.character.stackableEquipmentSelected.containsKey(filteredItems[index].name)) {
                                      widget.character.stackableEquipmentSelected[filteredItems[index].name] = widget.character.stackableEquipmentSelected[filteredItems[index].name]! +1;
                                    } else {
                                      widget.character.stackableEquipmentSelected[filteredItems[index].name] = 1;
                                    }
                                  } else {
                                    widget.character.unstackableEquipmentSelected.add(filteredItems[index]);
                                  }
                                }
                              });
                              widget.onCharacterChanged();
                            },

                            /* Item name and price. */
                            child: Text(
                              "${filteredItems[index].name}: ${filteredItems[index].cost[0]}x${filteredItems[index].cost[1]}",
                              style: TextStyle(color: ThemeManager.instance.currentScheme.textColour)),
                          );
                        }),
                      )))
              ])))),

        /* Selection of item options from class and background */
        Expanded(
            child: SizedBox(
                height: 435,
                child: Column(
                  children: [
                    /* Title */
                    const SizedBox(height: 9),
                    StyleUtils.buildStyledMediumTextBox(text: "Choose equipment from options gained:"),
                    const SizedBox(height: 6),

                    /* A column containing each choice as a pair of buttons */
                    (widget.character.equipmentSelectedFromChoices.isEmpty) 
                      ? StyleUtils.buildStyledSmallTextBox(text: "No equipment choices available")
                      : SizedBox(
                        height: 300,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              for (var i = 0; i < widget.character.equipmentSelectedFromChoices.length; i++) 
                                (widget.character.equipmentSelectedFromChoices[i].length == 2)
                                  ? SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(children: [

                                        /* Button for the first option */
                                        ElevatedButton(
                                          style: OutlinedButton.styleFrom(backgroundColor: ThemeManager.instance.currentScheme.backingColour),
                                          onPressed: () {
                                            setState(() {
                                              widget.character.equipmentSelectedFromChoices[i] = [widget.character.equipmentSelectedFromChoices[i][0]];
                                            });
                                            widget.onCharacterChanged();
                                          },
                                          child: Text(
                                            produceEquipmentOptionDescription(widget.character.equipmentSelectedFromChoices[i][0]),
                                            style: TextStyle(color: ThemeManager.instance.currentScheme.textColour)
                                          ),
                                        ),

                                        /* Button for the second option */
                                        ElevatedButton(
                                          style: OutlinedButton.styleFrom(backgroundColor: ThemeManager.instance.currentScheme.backingColour),
                                          onPressed: () {
                                            setState(() {
                                              widget.character.equipmentSelectedFromChoices[i] = [widget.character.equipmentSelectedFromChoices[i][1]];
                                            });
                                            widget.onCharacterChanged();
                                          },
                                          child: Text(
                                            produceEquipmentOptionDescription(widget.character.equipmentSelectedFromChoices[i][1]),
                                            style: TextStyle(color: ThemeManager.instance.currentScheme.textColour)
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Text(
                                    produceEquipmentOptionDescription(widget.character.equipmentSelectedFromChoices[i][0]),
                                    style: TextStyle(color: ThemeManager.instance.currentScheme.backingColour, fontWeight: FontWeight.w700)
                                  ),
                            ],
                          ),
                        ),
                      )
                  ],
                ))),
        ],
      )
    );
  }
}
