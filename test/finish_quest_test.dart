import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gift_quest/src/finish_quest.dart';
import 'package:provider/provider.dart';
import 'package:gift_quest/src/models/data.dart';

Widget createFinishScreen() => ChangeNotifierProvider<Data>(
  create: (_) => Data(),
  child: MaterialApp(
    home: Localizations(
      delegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('en'),
      child: const FinishQuest(),
    )
  ),
);


void main() {
  group('Finish Quest Page Widget Tests', () {
    testWidgets('Testing if The end Text shows up', (tester) async {  
      await tester.pumpWidget(createFinishScreen());
      expect(find.text("That's the end."), findsOneWidget);
    });
    testWidgets('Testing if hope of enjoy Text shows up', (tester) async {  
      await tester.pumpWidget(createFinishScreen());
      expect(find.text("Hope you have enjoyed your quest!"), findsOneWidget);
    });
    testWidgets('Testing if elevated button shows up', (tester) async {  
      await tester.pumpWidget(createFinishScreen());
      expect(find.text('Close'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}