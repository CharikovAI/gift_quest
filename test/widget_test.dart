import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import '../lib/main.dart';
import '../lib/src/intro.dart';

Widget createHomeScreen() => ChangeNotifierProvider<Data>(
      create: (context) => Data(),
      child: MaterialApp(
        home: QuestApp(),
      ),
    );

void main() {
  group('Home Page Widget Tests', () {
    testWidgets('Testing if greetings Text shows up', (tester) async {  
      await tester.pumpWidget(createHomeScreen());
      expect(find.byType(ElevatedButton), findsOneWidget);
    }); 
  });
}