import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gift_quest/src/intro.dart';
import 'package:provider/provider.dart';
import 'package:gift_quest/src/models/data.dart';

Widget createIntroScreen() => ChangeNotifierProvider<Data>(
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
      child: const Intro(),
    )
  ),
);

void main() {
  group('Intro Page Widget Tests', () {
    testWidgets('Testing if greetings Text shows up', (tester) async {  
      await tester.pumpWidget(createIntroScreen());
      expect(find.text('Greetings! This is app for creating and providing quests. If you have already got a quest code or QR, please scan it and start your quest!'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });
    testWidgets('Testing if elevated button shows up', (tester) async {  
      await tester.pumpWidget(createIntroScreen());
      expect(find.text('I have the code'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
    testWidgets('Testing if outlined button shows up', (tester) async {  
      await tester.pumpWidget(createIntroScreen());
      expect(find.text('Create quest'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });
  });
}