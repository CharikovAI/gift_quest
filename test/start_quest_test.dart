import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gift_quest/src/start_quest.dart';
import 'package:provider/provider.dart';
import 'package:gift_quest/src/models/data.dart';

Widget createQuestCreatedScreen() => ChangeNotifierProvider<Data>(
  create: (_) => Data(),
  child: const MaterialApp(
    home: LoadQuest()
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