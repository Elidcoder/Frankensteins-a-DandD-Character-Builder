// External Imports
import "package:flutter/material.dart";

// Project Imports
import "../../../models/content/base/content.dart";
import "../../../storage/global_list_manager.dart";
import "../../../theme/theme_manager.dart";
import "../../../utils/style_utils.dart";

/* This page allows users to view and delete their downloaded content. */
class SearchForContent extends StatefulWidget {
  const SearchForContent({super.key});

  @override
  SearchForContentState createState() => SearchForContentState();
}

class SearchForContentState extends State<SearchForContent> {
  String searchTerm = "";
  late Future<void> _initialisedContent;

  @override
  void initState() {
    super.initState();
    _initialisedContent = GlobalListManager().initialiseContentLists();
    ThemeManager.instance.addListener(_onThemeChanged);
  }
  
  @override
  void dispose() {
    ThemeManager.instance.removeListener(_onThemeChanged);
    super.dispose();
  }
  
  void _onThemeChanged() {
    setState(() {
      // Rebuild when theme changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return StyleUtils.styledFutureBuilder(future: _initialisedContent, builder: (context) => StyleUtils.buildStyledScaffold(
      appBar: StyleUtils.buildStyledAppBar(
        title: "Search for content",
        titleStyle: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w700,
          color: ThemeManager.instance.currentScheme.textColour,
        ),
      ),
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
              decoration: StyleUtils.buildDefaultInputDecoration(
                hintText: "Search for content using its names",
                prefixIcon: Icon(Icons.search, color: ThemeManager.instance.currentScheme.textColour),
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
                  ...buildFilteredContentCards(GlobalListManager().classList),

                  /* Display the spells. */ 
                  buildTitleCard("Spells"),
                  ...buildFilteredContentCards(GlobalListManager().spellList),

                  /* Display the feats. */ 
                  buildTitleCard("Feats"),
                  ...buildFilteredContentCards(GlobalListManager().featList),

                  /* Display the races. */ 
                  buildTitleCard("Races"),
                  ...buildFilteredContentCards(GlobalListManager().raceList),

                  /* Display the items. */ 
                  buildTitleCard("Items"),
                  ...buildFilteredContentCards(GlobalListManager().itemList),

                  /* Display the backgrounds. */ 
                  buildTitleCard("Backgrounds"),
                  ...buildFilteredContentCards(GlobalListManager().backgroundList)
                ],
              ),
            ),
          ),
        ],
      )));
  }

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
          child: Center(child: StyleUtils.buildStyledLargeTextBox(
            text: listType,
            color: StyleUtils.currentTextColor,
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
