// External Imports
import "package:frankenstein/pdf/utils.dart";
import "package:pdf/widgets.dart";

// Project Imports
import "../../content_classes/all_content_classes.dart";

Widget buildThirdColumn(Character userCharacter) {
  return Container(
    alignment: Alignment.center,
    width: 155.0,
    child: Column(children: [
      Container(
        alignment: Alignment.center,
        height: 244.5,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.fromLTRB(7.5, 9, 7.5, 0),
        child: Column(children: [
          buildPersonalityTraitSection(userCharacter),
          
          SizedBox(height: 9),
          
          buildIdealsBox(userCharacter),
          SizedBox(height: 9),
          
          buildBondsBox(userCharacter),
          SizedBox(height: 9),
          
          buildFlawsBox(userCharacter),
        ])
      ),

      SizedBox(height: 8),
      buildFeaturesAndTraitsBox(userCharacter)
    ])
  );
}

Container buildPersonalityTraitSection(Character userCharacter) {
  return Container(
    alignment: Alignment.center,
    height: 66.0,
    padding: const EdgeInsets.fromLTRB(5, 2, 5, 0),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(2)),
      border: Border.all(width: 0.8)
    ),
    child: Column(children: [
      Text("Personality Trait:", style: const TextStyle(fontSize: 10)),
      Text(userCharacter.backgroundPersonalityTrait, style: const TextStyle(fontSize: 7)),
    ])
  );
}

Container buildInfoBox(String title, String content) {
  return Container(
    alignment: Alignment.center,
    height: 43.5,
    padding: const EdgeInsets.fromLTRB(5, 2, 5, 0),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(2)),
      color: PDF_BLACK,
      border: Border.all(width: 0.8)
    ),
    child: Column(children: [
      Text("$title:", style: const TextStyle(fontSize: 10)),
      Text(content, style: const TextStyle(fontSize: 6))
    ])
  );
}

Container buildBondsBox(Character userCharacter) {
  return buildInfoBox("Bonds", userCharacter.backgroundBond);
}

Container buildIdealsBox(Character userCharacter) {
  return buildInfoBox("Ideals", userCharacter.backgroundIdeal);
}

Container buildFlawsBox(Character userCharacter) {
  return buildInfoBox("Flaws", userCharacter.backgroundFlaw);
}

Container buildFeaturesAndTraitsBox(Character userCharacter) {
  return Container(
    alignment: Alignment.center,
    height: 375.5,
    padding: const EdgeInsets.fromLTRB(3, 2, 3, 0),
    decoration: BoxDecoration(border: Border.all(width: 0.8)),
    child: Column(children: [
      Text("Features & traits:"),
      Container(
        height: 359,
        child: Text(userCharacter.featuresAndTraits.join(",\n"), style: const TextStyle(fontSize: 6))
      )
    ])
  );
}
