// External Imports
import "package:pdf/widgets.dart";

import "../../../../models/core/character/character.dart";
// Project Imports
import "first_column.dart";
import "header.dart";
import "second_column.dart";
import "third_column.dart";

/// Generates the first page of the character sheet
Page generatePage1(Character userCharacter) {
  return Page(
    build: (context) {
      return Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildHeader(userCharacter),
            SizedBox(height: 10),
            Container(
              alignment: Alignment.center,
              height: 628.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildFirstColumn(userCharacter),
                  buildSecondColumn(userCharacter),
                  buildThirdColumn(userCharacter)
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
