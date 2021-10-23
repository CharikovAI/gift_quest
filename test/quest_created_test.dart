import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:gift_quest/src/quest_created.dart';
import 'package:provider/provider.dart';
import 'package:gift_quest/src/models/data.dart';

Widget createQuestCreatedScreen(String questId) => ChangeNotifierProvider<Data>(
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
      child:  QuestCreated(questId),
    )
  ),
);

void main() {
  String questId = 'testId';
  group('Quest Created Page Widget Tests', () {
    testWidgets('Testing if all widgets show up', (tester) async {  
      await tester.pumpWidget(createQuestCreatedScreen(questId));
      expect(find.text("You've created a quest. Please save the id or qr code and share it to your friend."), findsOneWidget);
      expect(find.byType(QrImage), findsOneWidget);
      expect(find.text(questId), findsOneWidget);
      expect(find.byIcon(Icons.copy), findsOneWidget);
      await tester.tap(find.byIcon(Icons.copy).first);
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Copied'), findsOneWidget);
      expect(find.text("Please save the code ot take a screenshot of this screen. After pressing this button it will be impossible to restore your code."), findsOneWidget);
      expect(find.text('I saved the code'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}