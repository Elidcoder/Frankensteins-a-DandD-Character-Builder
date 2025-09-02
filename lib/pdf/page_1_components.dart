// External Imports
import "package:frankenstein/storage/global_list_manager.dart" show GlobalListManager;
import "package:pdf/pdf.dart" show PdfColor;
import "package:pdf/widgets.dart";

// Project Imports
import "../content_classes/all_content_classes.dart";
import "pdf_utils.dart";

Widget buildHeader(Character userCharacter) {
  return Container(
    alignment: Alignment.center,
    height: 80.0,
    width: 500.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(width: 0.8),
    ),
    child: Row(children: [
      SizedBox(width: 20),
      Container(
          alignment: Alignment.center,
          height: 60.0,
          width: 145.0,
          child: Column(children: [
            Container(
                alignment: Alignment.center,
                height: 14.0,
                width: 140.0,
                child: Text(
                  "DUNGEONS & DRAGONS",
                  style: TextStyle(
                      fontSize: 11.0,
                      fontWeight: FontWeight.bold),
                )),
            Container(
                alignment: Alignment.center,
                height: 14.0,
                width: 90.0,
                child: Text(
                  "Character name:",
                  style: const TextStyle(fontSize: 8.0),
                )),
            Container(
              alignment: Alignment.center,
              height: 15.0,
              width: 140.0,

              //child: Text(" ${userCharacter.name}")
              child: (userCharacter.characterDescription.name.replaceAll(" ", "") ==
                      "")
                  ? Text(
                      "No data to display",
                    )
                  : Text(
                      userCharacter.characterDescription.name,
                      style: const TextStyle(
                          decoration: TextDecoration.underline),
                    ),
            ),
          ])),
      Container(
          alignment: Alignment.center,
          height: 80.0,
          width: 105.0,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 15),
                Container(
                    alignment: Alignment.center,
                    height: 11.0,
                    width: 80.0,
                    child: Text(
                      "Class and Level:",
                      style: const TextStyle(fontSize: 8.0),
                    )),
                Container(
                    alignment: Alignment.center,
                    height: 17.0,
                    width: 90.0,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: (userCharacter.classLevels
                              .any((x) => x != 0))
                          ? Text(
                              GlobalListManager().classList
                                  .asMap()
                                  .entries
                                  .where((entry) =>
                                      userCharacter.classLevels[
                                          entry.key] !=
                                      0)
                                  .map((entry) =>
                                      "${entry.value.name}: ${userCharacter.classLevels[entry.key]}")
                                  .join(", "),
                              style: const TextStyle(
                                decoration:
                                    TextDecoration.underline,
                              ),
                            )
                          : Text(
                              "No data to display",
                            ),
                    )),
                Container(
                    alignment: Alignment.center,
                    height: 11.0,
                    width: 80.0,
                    child: Text(
                      "Race:",
                      style: const TextStyle(fontSize: 8.0),
                    )),
                Container(
                    alignment: Alignment.center,
                    height: 17.0,
                    width: 90.0,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                          (userCharacter.subrace == null)
                              ? userCharacter.race.name
                              : "${userCharacter.race.name} (${userCharacter.subrace!.name})",
                          style: const TextStyle(
                              decoration:
                                  TextDecoration.underline)),
                    )),
              ])),
      Container(
          alignment: Alignment.center,
          height: 80.0,
          width: 105.0,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 15),
                Container(
                    alignment: Alignment.center,
                    height: 11.0,
                    width: 80.0,
                    child: Text(
                      "Background:",
                      style: const TextStyle(fontSize: 8.0),
                    )),
                Container(
                  alignment: Alignment.center,
                  height: 20.0,
                  width: 90.0,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(userCharacter.background.name,
                        style: const TextStyle(
                            decoration:
                                TextDecoration.underline)),
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    height: 11.0,
                    width: 80.0,
                    child: Text(
                      "Alignment:",
                      style: const TextStyle(fontSize: 8.0),
                    )),
                Container(
                    alignment: Alignment.center,
                    height: 20.0,
                    width: 90.0,
                    child: Text("N/A",
                        style: const TextStyle(
                            decoration:
                                TextDecoration.underline))),
              ])),
      Container(
          alignment: Alignment.center,
          height: 80.0,
          width: 105.0,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 15),
                Container(
                    alignment: Alignment.center,
                    height: 11.0,
                    width: 80.0,
                    child: Text(
                      "Player name:",
                      style: const TextStyle(fontSize: 8.0),
                    )),
                Container(
                  alignment: Alignment.center,
                  height: 20.0,
                  width: 90.0,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: (userCharacter.playerName
                                .replaceAll(" ", "") ==
                            "")
                        ? Text(
                            "No data to display",
                          )
                        : Text(
                            userCharacter.playerName,
                            style: const TextStyle(
                              decoration:
                                  TextDecoration.underline,
                            ),
                          ),
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    height: 11.0,
                    width: 80.0,
                    child: Text(
                      "Experience points:",
                      style: const TextStyle(fontSize: 8.0),
                    )),
                Container(
                  alignment: Alignment.center,
                  height: 20.0,
                  width: 90.0,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                        "${userCharacter.characterExperience}",
                        style: const TextStyle(
                            decoration:
                                TextDecoration.underline)),
                  ),
                ),
              ])),
    ]));
}

Widget borderedSection(String title, List<Widget> children, {double height = 200.0}) {
  return Container(
    height: height,
    decoration: BoxDecoration(border: Border.all(width: 0.8)),
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        ...children,
      ],
    ),
  );
}

Widget buildFirstColumn(Character userCharacter) {
  return Container(
    alignment: Alignment.center,
    width: 155.0,
    child: Column(children: [
      // Top box - Ability Scores and Skills
      Container(
        alignment: Alignment.center,
        height: 448.0,
        child: Row(children: [
          // Ability Scores column
          buildAbilityScoresColumn(userCharacter),
          // Saving throws and skills column
          Container(
            padding: const EdgeInsets.fromLTRB(3, 3, 3, 0),
            alignment: Alignment.center,
            width: 95.0,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildInspirationBanner(userCharacter),
                  buildProficiencyBonusBanner(userCharacter),
                  buildSavingThrowsColumn(userCharacter),
                  buildSkillsColumn(userCharacter)
              ],
            ),
          ),
        ]),
      ),

      buildPassivePerceptionBanner(userCharacter),

      // Other proficiencies and languages
      buildOtherProficienciesBox(userCharacter),
    ]),
  );
}

Widget buildSecondColumn(Character userCharacter) {
  return Container();
}

Widget buildThirdColumn(Character userCharacter) {
  return Container();
}

Container buildAbilityScoresColumn(Character userCharacter) {
  Widget buildAbilityScore(String name, int score) {
    bool small = name.length > 10;
    return Container(
      height: 63,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(width: 0.8),
        color: const PdfColor.fromInt(0xffffffff),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(name, style: TextStyle(fontSize: small ? 8 : 10)),
          Text(
            "$score",
            style: const TextStyle(fontSize: 23)
          ),
          Container(
            height: 13,
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(width: 0.8)),
            child: Text(formatNumber(modifierFromAbilityScore[score] ?? 0)))
        ]));
  }
  var ASboxes = userCharacter.abilityScores.asMap().map((index, ability) => MapEntry(index, buildAbilityScore(ability.name, ability.value + userCharacter.raceAbilityScoreIncreases[index] + userCharacter.featsASIScoreIncreases[index]))).values.toList();
  return Container(
    alignment: Alignment.center,
    width: 60.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      color: const PdfColor.fromInt(0xff9c9995),
    ),
    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ASboxes,
    ),
  );
}


Container buildSavingThrowsColumn(Character userCharacter) {

  Container buildSavingThrowLine(AbilityScore abilityScore, int index) {
    bool isProficient = userCharacter.savingThrowProficiencies.contains(abilityScore.name);
    return Container(
      height: 14,
      child: Row(children: [
          Text(
            (isProficient) ? "  X " : "  O ",
            style: const TextStyle(fontSize: 6.4)
          ),
          Text(
            "${formatNumber(modifierFromAbilityScore[abilityScore.value + userCharacter.raceAbilityScoreIncreases[index] + userCharacter.featsASIScoreIncreases[index]] ?? 0 + (isProficient as int) * (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))} ",
            style: const TextStyle(decoration: TextDecoration.underline, fontSize: 6.4)
          ),
          Text(
            " ${abilityScore.name} ",
            style: const TextStyle(fontSize: 6.4)
          ),
      ]));
  }

  var SavingThrowBoxes = userCharacter.abilityScores.asMap().map(
    (index, ability) => MapEntry(index, buildSavingThrowLine(ability, index))
  ).values.toList();
  
  return Container(
    height: 100,
    decoration: BoxDecoration(border: Border.all(width: 0.8)),
    child: Column(children: [
      Container(
        height: 16,
        child: Center(
          child: Text(
            "Saving throws",
            style: const TextStyle(fontSize: 12)
          )
        )
      ),
      ...SavingThrowBoxes
    ]));
}

//TODO(PULL IN WITH REFACTORED ABILITY SCORES)
enum Ability {
  STRENGTH(0, 'Str'),
  DEXTERITY(1, 'Dex'),
  CONSTITUTION(2, 'Con'),
  INTELLIGENCE(3, 'Int'),
  WISDOM(4, 'Wis'),
  CHARISMA(5, 'Cha');

  const Ability(this.value, this.shortName);

  /// 0..5
  final int value;
  final String shortName;

  /// Optional helper: reverse-lookup by value.
  static Ability fromValue(int v) =>
      Ability.values.firstWhere((a) => a.value == v);
}

Container buildSkillsColumn(Character userCharacter) {
  final classSkills = (userCharacter.classList.isNotEmpty)
    ? GlobalListManager().classList.firstWhere((element) => userCharacter.classList.isNotEmpty && element.name == userCharacter.classList.first).optionsForSkillProficiencies.where(
      (element) => userCharacter.classSkillsSelected[GlobalListManager().classList.firstWhere(
        (element) => userCharacter.classList.isNotEmpty && element.name == userCharacter.classList.first
      ).optionsForSkillProficiencies.indexOf(element)]).toList()
    : [];

  List<String> skills = [
    ...userCharacter.skillProficiencies,
    ...userCharacter.background.initialProficiencies,
    ...classSkills,
    ...userCharacter.skillsSelected
  ];

  Map<Ability, int> abilityValues = Ability.values.asMap().map((key, ability) => MapEntry(ability, userCharacter.abilityScores[ability.value].value + userCharacter.raceAbilityScoreIncreases[ability.value] + userCharacter.featsASIScoreIncreases[ability.value]));

  int totalLevel = userCharacter.classLevels.reduce((a, b) => a + b);
  int profBonus = proficiencyBonus[totalLevel] ?? 2;

  Widget buildSkillLine(String skillName, Ability ability) {
    int abilityScore = abilityValues[ability] ?? 0;
    int mod = modifierFromAbilityScore[abilityScore] ?? 0;
    bool proficient = skills.contains(skillName);
    int score = mod + (proficient ? profBonus : 0);
    return Container(
      height: 13,
      child: Row(children: [
        Text(proficient ? "  X " : "  O ", style: const TextStyle(fontSize: 6.4)),
        Text(
          "${formatNumber(score)} ",
          style: const TextStyle(decoration: TextDecoration.underline, fontSize: 6.4),
        ),
        Text(" $skillName ", style: const TextStyle(fontSize: 6.4)),
        Text("(${ability.shortName})", style: const TextStyle(fontSize: 6.4)),
      ]),
    );
  }

  return Container(
    height: 260,
    decoration: BoxDecoration(border: Border.all(width: 0.8)),
    child: Column(
      children: [
        Container(
          child: Center(
            child: Text("Skills", style: const TextStyle(fontSize: 14))
          )
        ),
        buildSkillLine("Acrobatics", Ability.DEXTERITY),
        buildSkillLine("Animal Handling", Ability.WISDOM),
        buildSkillLine("Arcana", Ability.INTELLIGENCE),
        buildSkillLine("Athletics", Ability.STRENGTH),
        buildSkillLine("Deception", Ability.CHARISMA),
        buildSkillLine("History", Ability.INTELLIGENCE),
        buildSkillLine("Insight", Ability.WISDOM),
        buildSkillLine("Intimidation", Ability.CHARISMA),
        buildSkillLine("Investigation", Ability.INTELLIGENCE),
        buildSkillLine("Medicine", Ability.WISDOM),
        buildSkillLine("Nature", Ability.INTELLIGENCE),
        buildSkillLine("Perception", Ability.WISDOM),
        buildSkillLine("Performance", Ability.CHARISMA),
        buildSkillLine("Persuasion", Ability.CHARISMA),
        buildSkillLine("Religion", Ability.INTELLIGENCE),
        buildSkillLine("Sleight of Hand", Ability.DEXTERITY),
        buildSkillLine("Stealth", Ability.DEXTERITY),
        buildSkillLine("Survival", Ability.WISDOM),
      ]
    ),
  );
}

Container buildBanner(Text value, Text label, [bool isBig = false]) {
  double boxSize = isBig ? 26 : 22;
  return Container(
    height: 26,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: boxSize,
          height: boxSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.0),
            border: Border.all(width: 0.8)
          ),
          child: value),
        Container(
          alignment: Alignment.center,
          width: isBig ? 129 : 68,
          height: isBig ? 20 : 16,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(2.0),
              bottomRight: Radius.circular(2.0),
            ),
            border: Border.all(width: 0.8)
          ),
          child: label
        ),
      ]
    )
  );
}

Container buildProficiencyBonusBanner(Character userCharacter) {
  return buildBanner(
    Text(
      (userCharacter.inspired)
        ? "X"
        : "",
      style: const TextStyle(fontSize: 13)
    ),
    Text(
      " Proficiency Bonus",
      style: const TextStyle(fontSize: 7.6)
    )
  );
}

Container buildInspirationBanner(Character userCharacter) {
  return buildBanner(
    Text(
      formatNumber(
        proficiencyBonus[userCharacter.classLevels.reduce(
          (value, element) => value + element
        )] as int
      ),
      style: const TextStyle(fontSize: 13)
    ),
    Text(
      " Inspiration",
      style: const TextStyle(fontSize: 9.4)
    )
  );
}

Container buildPassivePerceptionBanner(Character userCharacter) {
  return Container(
    alignment: Alignment.center,
    height: 48.0,
    child: buildBanner(
      Text(
        "${10 + (modifierFromAbilityScore[userCharacter.wisdom.value + userCharacter.raceAbilityScoreIncreases[4] + userCharacter.featsASIScoreIncreases[4]] ?? 0 + (userCharacter.skillProficiencies.contains("Perception") as int) * (proficiencyBonus[userCharacter.classLevels.reduce((value, element) => value + element)] as int))}",
        style: const TextStyle(fontSize: 13),
      ),
      Text(
        " Passive Perception (Wisdom) ",
        style: const TextStyle(fontSize: 8.8)
      ),
      true
    )
  );
}

Widget buildOtherProficienciesBox(Character userCharacter) {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
    height: 132.0,
    decoration: BoxDecoration(border: Border.all(width: 0.8)),
    child: Column(children: [
      Text("Other proficiencies & languages:", style: const TextStyle(fontSize: 10.5)),
      Container(
        height: 117,
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Text(
          "Other proficiencies - ${[
            ...userCharacter.background.toolProficiencies,
            ...userCharacter.race.toolProficiencies ?? [],
            ...userCharacter.subrace?.toolProficiencies ?? [],
            ...userCharacter.mainToolProficiencies
          ].join(", ")}\nLanguages Known - ${<dynamic>{...userCharacter.languagesKnown, ...userCharacter.languageChoices}.join(", ")}",
          style: const TextStyle(fontSize: 8)
        )
      )
    ])
  );
}

Widget buildSavingThrow(String name, AbilityScore abilityScore, bool isProficient) {
  return Container();
}

Widget buildStatBox(String label, String value) {
  return Container();
}

Widget buildCoinField(String coinType, String value) {
  return Container();
}

Widget buildSkill(String skillName, AbilityScore abilityScore, bool isProficient) {
  return Container();
}


