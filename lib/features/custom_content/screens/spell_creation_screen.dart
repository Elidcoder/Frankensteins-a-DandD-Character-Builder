// External Imports
import "package:flutter/material.dart";
import "package:frankenstein/models/content/game_mechanics/spell/spell.dart"
    show Spell;

import "../../../core/services/global_list_manager.dart";
import "../../../core/theme/theme_manager.dart";
import "../../../core/utils/style_utils.dart";
import "../../home/widgets/initial_top.dart" show InitialTop;

class MakeASpell extends StatefulWidget {
  const MakeASpell({super.key});

  @override
  MainMakeASpell createState() => MainMakeASpell();
}

class MainMakeASpell extends State<MakeASpell> {
  late Future<void> _initialisedSpells;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController effectController = TextEditingController();
  final TextEditingController materialController = TextEditingController();
  final TextEditingController availableToController = TextEditingController();
  final TextEditingController castingController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController rangeController = TextEditingController();
  final TextEditingController rangeUnitController = TextEditingController();

  String? spellSchool;
  int? level;
  bool verbal = false;
  bool somatic = false;
  bool ritual = false;

  @override
  void initState() {
    super.initState();
    _initialisedSpells = GlobalListManager().initialiseSpellList();
  }

  @override
  void dispose() {
    nameController.dispose();
    effectController.dispose();
    materialController.dispose();
    availableToController.dispose();
    castingController.dispose();
    durationController.dispose();
    rangeController.dispose();
    rangeUnitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StyleUtils.styledFutureBuilder(
        future: _initialisedSpells,
        builder: (context) => StyleUtils.buildStyledScaffold(
            appBar: StyleUtils.buildStyledAppBar(
              title: "Create a Spell",
            ),
            body: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //const SizedBox(height: 30),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 450,
                              height: 50,
                              child: StyleUtils.buildStyledTextField(
                                hintText: "Spell name here e.g. My Spell",
                                textController: nameController,
                                textColor: StyleUtils.currentTextColor,
                                backingColor:
                                    (nameController.text.replaceAll(" ", "") !=
                                            "")
                                        ? StyleUtils.backingColor
                                        : Colors.red,
                                filled: true,
                                onChanged: (groupNameEnteredValue) {
                                  setState(() {});
                                },
                              ),
                            ),
                            SizedBox(
                                width: 170,
                                height: 70,
                                child: Column(children: [
                                  Text("Select spell school:",
                                      style: TextStyle(
                                          color: (spellSchool != null)
                                              ? ThemeManager.instance
                                                  .currentScheme.backingColour
                                              : Colors.red)),
                                  DropdownButton<String>(
                                      value: spellSchool,
                                      icon: Icon(Icons.arrow_drop_down,
                                          color: ThemeManager.instance
                                              .currentScheme.backingColour),
                                      elevation: 16,
                                      style: TextStyle(
                                          color: ThemeManager.instance
                                              .currentScheme.textColour,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 20),
                                      underline: Container(
                                        height: 2,
                                        color: ThemeManager.instance
                                            .currentScheme.backingColour,
                                      ),
                                      onChanged: (String? value) {
                                        setState(() {
                                          spellSchool = value!;
                                        });
                                      },
                                      items: [
                                        "Abjuration",
                                        "Conjuration",
                                        "Divination",
                                        "Enchantment",
                                        "Evocation",
                                        "Illusion",
                                        "Necromancy",
                                        "Transmutation"
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5)),
                                                color: ThemeManager
                                                    .instance
                                                    .currentScheme
                                                    .backingColour,
                                              ),
                                              width: 100,
                                              child: FittedBox(
                                                  child: Text(value,
                                                      style: TextStyle(
                                                          color: ThemeManager
                                                              .instance
                                                              .currentScheme
                                                              .textColour)))),
                                        );
                                      }).toList(),
                                      dropdownColor: ThemeManager
                                          .instance.currentScheme.backingColour)
                                ])),
                          ],
                        ),
                        SizedBox(
                          width: 620,
                          height: 70,
                          child: TextField(
                              controller: effectController,
                              maxLines: 4,
                              minLines: 4,
                              cursorColor: Colors.blue,
                              style: TextStyle(
                                  color: ThemeManager
                                      .instance.currentScheme.textColour),
                              decoration: InputDecoration(
                                  hintText:
                                      "Spell effect here e.g. A Magic shield appears, increasing your AC by 3 for the next minute",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: ThemeManager
                                          .instance.currentScheme.textColour),
                                  filled: true,
                                  fillColor: ThemeManager
                                      .instance.currentScheme.backingColour,
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))))),
                        ),

                        SizedBox(
                            width: 620,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  height: 70,
                                  child: Column(children: [
                                    Text("Select spell level:",
                                        style: TextStyle(
                                            color: (level != null)
                                                ? ThemeManager.instance
                                                    .currentScheme.backingColour
                                                : Colors.red)),
                                    DropdownButton<String>(
                                        value:
                                            (level == null) ? null : "$level",
                                        icon: Icon(Icons.arrow_drop_down,
                                            color: ThemeManager.instance
                                                .currentScheme.backingColour),
                                        elevation: 16,
                                        style: TextStyle(
                                            color: ThemeManager.instance
                                                .currentScheme.backingColour,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 20),
                                        underline: Container(
                                          height: 2,
                                          color: ThemeManager.instance
                                              .currentScheme.backingColour,
                                        ),
                                        onChanged: (String? value) {
                                          // This is called when the user selects an item.
                                          setState(() {
                                            level = int.parse(value!);
                                          });
                                        },
                                        items: [
                                          "0",
                                          "1",
                                          "2",
                                          "3",
                                          "4",
                                          "5",
                                          "6",
                                          "7",
                                          "8",
                                          "9"
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: ThemeManager
                                                      .instance
                                                      .currentScheme
                                                      .backingColour,
                                                ),
                                                width: 40,
                                                height: 27,
                                                child: FittedBox(
                                                    child: Text(value,
                                                        style: TextStyle(
                                                            color: ThemeManager
                                                                .instance
                                                                .currentScheme
                                                                .textColour)))),
                                          );
                                        }).toList(),
                                        dropdownColor: ThemeManager.instance
                                            .currentScheme.backingColour),
                                  ]),
                                ),
                                Expanded(
                                    child: CheckboxListTile(
                                        title: Text(" Somatic Component",
                                            style: TextStyle(
                                                color: ThemeManager
                                                    .instance
                                                    .currentScheme
                                                    .backingColour)),
                                        value: somatic,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            somatic = value ?? false;
                                          });
                                        },
                                        activeColor: ThemeManager.instance
                                            .currentScheme.backingColour,
                                        secondary: Icon(
                                            Icons.auto_stories_outlined,
                                            color: ThemeManager.instance
                                                .currentScheme.backingColour))),
                                Expanded(
                                  child: CheckboxListTile(
                                    title: Text(" Verbal Component",
                                        style: TextStyle(
                                            color: ThemeManager.instance
                                                .currentScheme.backingColour)),
                                    value: verbal,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        verbal = value ?? false;
                                      });
                                    },
                                    activeColor: ThemeManager
                                        .instance.currentScheme.backingColour,
                                    secondary: Icon(Icons.auto_stories_outlined,
                                        color: ThemeManager.instance
                                            .currentScheme.backingColour),
                                  ),
                                )
                              ],
                            )),
                        Row(
                          children: [
                            SizedBox(
                              width: 305,
                              height: 70,
                              child: TextField(
                                  controller: materialController,
                                  cursorColor: Colors.blue,
                                  style: TextStyle(
                                      color: ThemeManager
                                          .instance.currentScheme.textColour),
                                  decoration: InputDecoration(
                                      hintText:
                                          "Material: e.g. 3 100gp diamonds",
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: ThemeManager.instance
                                              .currentScheme.textColour),
                                      filled: true,
                                      fillColor: ThemeManager
                                          .instance.currentScheme.backingColour,
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12))))),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 305,
                              height: 70,
                              child: TextField(
                                  controller: availableToController,
                                  cursorColor: Colors.blue,
                                  style: TextStyle(
                                      color: ThemeManager
                                          .instance.currentScheme.textColour),
                                  decoration: InputDecoration(
                                      hintText:
                                          "Available to: Wizard, Sorcerer, ...",
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: ThemeManager.instance
                                              .currentScheme.textColour),
                                      filled: true,
                                      fillColor: ThemeManager
                                          .instance.currentScheme.backingColour,
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12))))),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 305,
                              height: 70,
                              child: TextField(
                                  controller: castingController,
                                  cursorColor: Colors.blue,
                                  style: TextStyle(
                                      color: ThemeManager
                                          .instance.currentScheme.textColour),
                                  decoration: InputDecoration(
                                      hintText:
                                          "Casting time: Number, Unit of time",
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: ThemeManager.instance
                                              .currentScheme.textColour),
                                      filled: true,
                                      fillColor: ThemeManager
                                          .instance.currentScheme.backingColour,
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12))))),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 305,
                              height: 70,
                              child: TextField(
                                  controller: durationController,
                                  cursorColor: Colors.blue,
                                  style: TextStyle(
                                      color: ThemeManager
                                          .instance.currentScheme.textColour),
                                  decoration: InputDecoration(
                                      hintText: "Duration: Number, Time period",
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: ThemeManager.instance
                                              .currentScheme.textColour),
                                      filled: true,
                                      fillColor: ThemeManager
                                          .instance.currentScheme.backingColour,
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12))))),
                            ),
                          ],
                        ),
                        SizedBox(
                            width: 620,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 192.5,
                                  height: 70,
                                  child: TextField(
                                      controller: rangeController,
                                      cursorColor: Colors.blue,
                                      style: TextStyle(
                                          color: ThemeManager.instance
                                              .currentScheme.textColour),
                                      decoration: InputDecoration(
                                          hintText:
                                              "Range: Touch / Self / Number",
                                          hintStyle: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: ThemeManager.instance
                                                  .currentScheme.textColour),
                                          filled: true,
                                          fillColor: _isValidRange()
                                              ? ThemeManager.instance
                                                  .currentScheme.backingColour
                                              : Colors.red,
                                          border: const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)))),
                                      onChanged: (_) => setState(() {})),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: 192.5,
                                  height: 70,
                                  child: TextField(
                                      controller: rangeUnitController,
                                      cursorColor: Colors.blue,
                                      style: TextStyle(
                                          color: ThemeManager.instance
                                              .currentScheme.textColour),
                                      decoration: InputDecoration(
                                          hintText: "Range unit e.g. ft",
                                          hintStyle: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: ThemeManager.instance
                                                  .currentScheme.textColour),
                                          filled: true,
                                          fillColor: _isValidRangeUnit()
                                              ? ThemeManager.instance
                                                  .currentScheme.backingColour
                                              : Colors.red,
                                          border: const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)))),
                                      onChanged: (_) => setState(() {})),
                                ),
                                Expanded(
                                    child: CheckboxListTile(
                                  title: Text(" Ritual ",
                                      style: TextStyle(
                                          color: ThemeManager.instance
                                              .currentScheme.backingColour)),
                                  value: ritual,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      ritual = value ?? false;
                                    });
                                  },
                                  activeColor: ThemeManager
                                      .instance.currentScheme.backingColour,
                                  secondary: Icon(Icons.auto_stories_outlined,
                                      color: ThemeManager.instance.currentScheme
                                          .backingColour),
                                )),
                              ],
                            )),
                        StyleUtils.buildStyledOutlinedButton(
                          text: "Save Spell",
                          backgroundColor: validateSpell()
                              ? StyleUtils.backingColor
                              : Colors.grey,
                          padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),
                          onPressed: () async {
                            if (!validateSpell()) return;

                            // Check if spell name already exists
                            if (GlobalListManager().spellList.any((spell) =>
                                spell.name == nameController.text.trim())) {
                              return;
                            }

                            // Create and save the new spell
                            final newSpell = Spell(
                              name: nameController.text.trim(),
                              sourceBook: "MADE BY USER",
                              range:
                                  "${rangeController.text.trim()} ${rangeUnitController.text.trim()}",
                              ritual: ritual,
                              spellSchool: spellSchool!,
                              effect: effectController.text.trim(),
                              availableTo: availableToController.text
                                  .split(',')
                                  .map((s) => s.trim())
                                  .where((s) => s.isNotEmpty)
                                  .toList(),
                              level: level!,
                              timings: [
                                ...castingController.text
                                    .split(',')
                                    .map((s) => s.trim()),
                                ...durationController.text
                                    .split(',')
                                    .map((s) => s.trim()),
                              ].where((s) => s.isNotEmpty).toList(),
                              somatic: somatic,
                              verbal: verbal,
                              material: materialController.text.trim().isEmpty
                                  ? null
                                  : materialController.text.trim(),
                            );
                            await GlobalListManager().saveSpell(newSpell);

                            if (!context.mounted) return;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const InitialTop()),
                            );
                            showCreationDialog(context);
                          },
                        )
                      ])
                ])));
  }

  void showCreationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StyleUtils.buildStyledAlertDialog(
        title: 'Success!',
        content: 'Success!',
        contentWidget: Text(
          'Spell created and added to your content!',
          style: StyleUtils.buildDefaultTextStyle(
            color: Colors.green,
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          StyleUtils.buildStyledTextButton(
            text: 'Continue',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  bool _isValidRange() {
    final range = rangeController.text.trim().toUpperCase();
    return range.isNotEmpty &&
        (['SELF', 'TOUCH'].contains(range) || double.tryParse(range) != null);
  }

  bool _isValidRangeUnit() {
    final range = rangeController.text.trim().toUpperCase();
    final rangeUnit = rangeUnitController.text.trim();
    return ['SELF', 'TOUCH'].contains(range) || rangeUnit.isNotEmpty;
  }

  bool validateSpell() {
    return nameController.text.trim().isNotEmpty &&
        level != null &&
        spellSchool != null &&
        _isValidRange() &&
        _isValidRangeUnit();
  }
}
