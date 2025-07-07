// External Imports
import "package:flutter/material.dart";

// Project Imports
import "../../content_classes/all_content_classes.dart";
import "../../theme/theme_manager.dart";

/* This page allows users to view and delete their downloaded content. */
class SearchForContent extends StatefulWidget {
  const SearchForContent({super.key});

  @override
  SearchForContentState createState() => SearchForContentState();
}

class SearchForContentState extends State<SearchForContent> {
  String searchTerm = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: ThemeManager.instance.currentScheme.textColour,
        backgroundColor: ThemeManager.instance.currentScheme.backingColour,
        title: Text(
          textAlign: TextAlign.center,
          "Search for content",
          style: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.w700,
            color: ThemeManager.instance.currentScheme.textColour),
        )),
      backgroundColor: ThemeManager.instance.currentScheme.backgroundColour,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* Contents name search bar */
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchTerm = value;
                });
              },
              decoration: InputDecoration(
                hintText:  "Search for content using its names",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          /* All content matching the search displayed as cards. */
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /* Display the classes. */
                  buildTitleCard("Classes"),
                  ...buildFilteredContentCards(CLASSLIST),

                  /* Display the spells. */ 
                  buildTitleCard("Spells"),
                  ...buildFilteredContentCards(SPELLLIST),

                  /* Display the feaets. */ 
                  buildTitleCard("Feats"),
                  ...buildFilteredContentCards(FEATLIST),

                  /* Display the races. */ 
                  buildTitleCard("Races"),
                  ...buildFilteredContentCards(RACELIST),

                  /* Display the items. */ 
                  buildTitleCard("Items"),
                  ...buildFilteredContentCards(ITEMLIST),

                  /* Display the backgrounds. */ 
                  buildTitleCard("Backgrounds"),
                  ...buildFilteredContentCards(BACKGROUNDLIST)
                ],
              ),
            ),
          ),
        ],
      ));
  }

  /* Build a card displaying a string. */
  Center buildTitleCard(String listType) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.5,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: ThemeManager.instance.currentScheme.backingColour,
            border: Border.all(color: ThemeManager.instance.currentScheme.textColour, width: 4),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(child:Text(
            listType,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: ThemeManager.instance.currentScheme.textColour),
          )),
        ),
      ),
    );
  }

  /* Generate a list of cards displaying a piece of content. */
  List<Center> buildFilteredContentCards(List<Content> list) {
    final filtered = list.where((item) {
      final query = searchTerm.toLowerCase();
      return item.name.toLowerCase().contains(query) ||
             item.sourceBook.toLowerCase().contains(query);
    }).toList();
    return filtered.map((item) => buildContentCard(item, list)).toList();
  }

  /* Build a card for a piece of content that allows for viewing and deletion. */
  Center buildContentCard(Content content, List<Content> list) {
    return Center(child:FractionallySizedBox(
      widthFactor: 0.5, 
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: ThemeManager.instance.currentScheme.backingColour,
          border: Border.all(color: ThemeManager.instance.currentScheme.textColour, width: 1.5),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /* Display content info */
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(content.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(content.sourceBook, style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 14)),
              ],
            ),

            /* Delete content button */
            Tooltip(
              message: "Delete ${content.name}", 
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    list.remove(content);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Icon(Icons.delete, color: Colors.white),
            ))
          ]
        )
    )));
  }
}
