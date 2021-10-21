import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'intro.dart';

class FinishQuest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.theEnd),
            Text(AppLocalizations.of(context)!.hopeYouHaveEnjoyed),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                  builder: (context) => Intro(),
                ), (route) => false);
              }, 
              child: Text(AppLocalizations.of(context)!.close)
            )
          ],
        )
      )
    );
  }
}