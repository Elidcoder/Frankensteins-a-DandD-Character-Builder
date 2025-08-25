// External Imports
import "package:frankenstein/storage/global_list_manager.dart" show GlobalListManager;
import "package:pdf/widgets.dart";

// Project Imports
import "../content_classes/all_content_classes.dart";

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
            width: 80.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...buildSavingThrowsColumn(userCharacter),
                ...buildSkillsColumn(userCharacter)
              ],
            ),
          ),
        ]),
      ),

      Container(
        alignment: Alignment.center,
        height: 48.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Inspiration
            buildInspirationBox(userCharacter),

            // Proficiency Bonus
            buildProficiencyBonusBox(userCharacter),
          ],
        ),
      ),
      
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

Widget buildAbilityScore(String name, int score, [bool small = false]) {
  return Container();
}

Container buildAbilityScoresColumn(Character userCharacter) {
  return Container();
}

List<Widget> buildSavingThrowsColumn(Character userCharacter) {
  return [];
}

List<Widget> buildSkillsColumn(Character userCharacter) {
  return [];
}

Container buildInspirationBox(Character userCharacter) {
  return Container();
}

Container buildProficiencyBonusBox(Character userCharacter) {
  return Container();
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

Widget buildOtherProficienciesBox(Character userCharacter) {
  return Container();
}
