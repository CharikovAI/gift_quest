import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        //Locale('es', ''), // Spanish, no country code
        Locale('ru', ''), // Russian, no country code
      ],
      home: Provider.of<Data>(context).questId?.isEmpty ?? true ? Intro() : Quest()
    );
  }
}

class Data extends ChangeNotifier {
  String? questId;
  int? currentStep;

  Data() {
    init();
  }

  init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    questId = prefs.getString('questId');
    currentStep = prefs.getInt('currentStep');
    notifyListeners();
  }
  
  setStoredQuestId(String newQuestId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    questId = newQuestId;
    currentStep = 0;
    await prefs.setString('questId', newQuestId);
    await prefs.setInt('currentStep', 0);
    notifyListeners();
  }

  updateCurrentStep() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentStep =  prefs.getInt('currentStep') ?? 0;
    await prefs.setInt('currentStep', currentStep + 1);
    currentStep += 1;
    notifyListeners();
  }

  deleteStoredQuestId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    questId = null;
    currentStep = 0;
    await prefs.setString('questId', '');
    await prefs.setInt('currentStep', 0);
    notifyListeners();
  }
}
