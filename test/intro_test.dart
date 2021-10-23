import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gift_quest/src/intro.dart';
import 'package:provider/provider.dart';
import 'package:gift_quest/src/models/data.dart';

Widget createIntroScreen() => ChangeNotifierProvider<Data>(
  create: (_) => Data(),
  child: const MaterialApp(
    home: Intro()
  ),
);

void main() {
  group('Intro Page Widget Tests', () {
    testWidgets('Testing if greetings Text shows up', (tester) async {  
      await tester.pumpWidget(createIntroScreen());
      expect(find.text('Greetings! This is app for creating and providing quests. If you have already got a QR code, please scan it and start your quest!'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });
    testWidgets('Testing if elevated button shows up', (tester) async {  
      await tester.pumpWidget(createIntroScreen());
      expect(find.text('I have QR code'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
    testWidgets('Testing if outlined button shows up', (tester) async {  
      await tester.pumpWidget(createIntroScreen());
      expect(find.text('Create new quest'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });
  });
}