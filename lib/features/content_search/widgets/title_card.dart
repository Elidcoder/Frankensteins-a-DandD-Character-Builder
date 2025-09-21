// External Imports
import "package:flutter/material.dart";

// Project Imports
import "../../../core/utils/style_utils.dart";

/* Build a card displaying a string. */
Center buildTitleCard(String listType) {
  return Center(
    child: FractionallySizedBox(
      widthFactor: 0.5,
      child: StyleUtils.buildStyledContainer(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: StyleUtils.backingColor,
          border: Border.all(color: StyleUtils.currentTextColor, width: 4),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
            child: StyleUtils.buildStyledLargeTextBox(
          text: listType,
          color: StyleUtils.currentTextColor,
        )),
      ),
    ),
  );
}
