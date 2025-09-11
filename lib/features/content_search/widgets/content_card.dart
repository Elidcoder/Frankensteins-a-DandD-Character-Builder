// External Imports
import "package:flutter/material.dart";

// Project Imports
import "../../../models/content/base/content.dart";
import "../../../utils/style_utils.dart";

/* Build a card for a piece of content that allows for viewing and deletion. */
Center buildContentCard(Content content, List<Content> list, void Function(Content) onDelete) {
  return Center(child: FractionallySizedBox(
    widthFactor: 0.5, 
    child: StyleUtils.buildStyledContainer(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: StyleUtils.backingColor,
        border: Border.all(color: StyleUtils.currentTextColor, width: 1.5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /* Display content info */
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(content.name, style: StyleUtils.buildDefaultTextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(content.sourceBook, style: StyleUtils.buildDefaultTextStyle(fontSize: 14).copyWith(fontStyle: FontStyle.italic)),
            ],
          ),

          /* Delete content button */
          Tooltip(
            message: "Delete ${content.name}", 
            child: ElevatedButton(
              onPressed: () => onDelete(content)
              ,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Icon(Icons.delete, color: Colors.white),
          ))
        ]
      )
  )));
}
