import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'src/intro.dart';
import 'src/quest.dart';
import 'src/quest_created.dart';
import 'src/models/data.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Data();
    return ChangeNotifierProvider(
      create: (context) => Data(),
      child: MaterialApp(
          home: QuestApp()
      ),
    );
  }
}

class QuestApp extends StatelessWidget {
  QuestApp({Key? key}) : super(key: key);
  
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
      home: Provider.of<Data>(context).questId.isEmpty ? 
        (Provider.of<Data>(context).createdQuestID.isEmpty ?
          const Intro() : QuestCreated(Provider.of<Data>(context).createdQuestID)
        ) : const Quest()
    );
  }
}