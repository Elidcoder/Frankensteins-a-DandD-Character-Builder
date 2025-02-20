// External Imports
import 'package:flutter/material.dart';

// Project Imports
import "../main.dart";
import '../content_classes/all_content_classes.dart';

class SearchForContent extends StatefulWidget {
  const SearchForContent({super.key});

  @override
  SearchForContentState createState() => SearchForContentState();
}

class SearchForContentState extends State<SearchForContent> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Homepage.backingColor,
        title: Text(
          textAlign: TextAlign.center,
          'Search for content',
          style: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.w700,
            color: Homepage.textColor),
        )),
      backgroundColor: Homepage.backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search field at the top
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search content...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          // Content list wrapped in an Expanded SingleChildScrollView
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /* Display the classes. */
                  ...buildFilteredContentCards(CLASSLIST),
                  /* Display the spells. */ 
                  ...buildFilteredContentCards(SPELLLIST),
                  /* Display the feaets. */ 
                  ...buildFilteredContentCards(FEATLIST),
                  /* Display the races. */ 
                  ...buildFilteredContentCards(RACELIST),
                  /* Display the items. */ 
                  ...buildFilteredContentCards(ITEMLIST),
                  /* Display the backgrounds. */ 
                  ...buildFilteredContentCards(BACKGROUNDLIST)
                ],
              ),
            ),
          ),
        ],
      ));
  }

  List<Widget> buildFilteredContentCards(List<Content> list) {
    final filtered = list.where((item) {
      final query = searchQuery.toLowerCase();
      return item.name.toLowerCase().contains(query) ||
             item.sourceBook.toLowerCase().contains(query);
    }).toList();
    return filtered.map((item) => buildContentCard(item, list)).toList();
  }

  Widget buildContentCard(Content content, List<Content> list) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey, width: 1.5),
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
          ElevatedButton(
            onPressed: () {
              setState(() {
                list.remove(content);
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
