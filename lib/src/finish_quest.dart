import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'intro.dart';

class FinishQuest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("That's the end."),
            Text('Hope you have enjoyed your quest!'),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                  builder: (context) => Intro(),
                ), (route) => false);
              }, 
              child: Text('Close')
            )
          ],
        )
      )
    );
  }
}