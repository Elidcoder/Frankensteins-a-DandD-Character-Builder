import 'package:flutter/material.dart';

class RollDice extends StatelessWidget {
  const RollDice({Key? key}) : super(key: key);

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
                  'Roll dice',
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
