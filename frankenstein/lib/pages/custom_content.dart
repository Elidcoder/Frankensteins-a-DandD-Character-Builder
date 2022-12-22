import 'package:flutter/material.dart';

class CustomContent extends StatelessWidget {
  const CustomContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.blue,
                child: const Text(
                  textAlign: TextAlign.center,
                  'Custom content',
                  style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
