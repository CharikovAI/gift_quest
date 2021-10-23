import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gift_quest/src/start_quest.dart';
import 'package:provider/provider.dart';
import 'package:gift_quest/src/models/data.dart';

Widget createQuestCreatedScreen() => ChangeNotifierProvider<Data>(
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
      child: const LoadQuest(),
    )
  ),
);

void main() {
  group('Start Quest Page Widget Tests', () {
    testWidgets('Testing if all widgets show up', (tester) async {  
      await tester.pumpWidget(createQuestCreatedScreen());
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}