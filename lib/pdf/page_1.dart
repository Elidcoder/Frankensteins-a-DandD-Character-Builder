// External Imports
import "package:pdf/widgets.dart";

// Project Imports
import "../content_classes/all_content_classes.dart";
import "page_1_components.dart";

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
