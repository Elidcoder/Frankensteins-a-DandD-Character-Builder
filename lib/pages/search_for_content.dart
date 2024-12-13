import 'package:flutter/material.dart';
import "package:frankenstein/main.dart";

class SearchForContent extends StatelessWidget {
  const SearchForContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Homepage.backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Homepage.backingColor,
                    child: Text(
                      textAlign: TextAlign.center,
                      'Search for content',
                      style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.w700,
                          color: Homepage.textColor),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
