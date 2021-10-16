import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gift_quest/src/start_quest.dart';

import 'quest_creation.dart';

class Intro extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Happy Questday!'),
      ),
      body: Center(child: 
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(AppLocalizations.of(context)!.introduction),
            ),
            ElevatedButton(
              //style: style,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LoadQuest(),
                ));
              },
              child: Text(AppLocalizations.of(context)!.iHaveQR),
            ),
            OutlinedButton(
              //style: style,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => QuestCreation(),
                ));
              },
              child: Text(AppLocalizations.of(context)!.createQuest),
            ),
          ],
        ),
      ),
    );
  }
}