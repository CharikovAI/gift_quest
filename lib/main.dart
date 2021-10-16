import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'src/intro.dart';
import 'src/quest.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Data(),
      child: MaterialApp(
          home: QuestApp()
      ),
    );
  }
}

class QuestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('es', ''), // Spanish, no country code
        Locale('ru', ''), // Russian, no country code
      ],
      home: Provider.of<Data>(context).questId?.isEmpty ?? true ? Intro() : Quest(questId: Provider.of<Data>(context).questId!)
    );
  }
}

class Data extends ChangeNotifier {
  String? questId;

  void updateStoredData(newQuestId) {
    questId = newQuestId;
    notifyListeners();
  }
}
