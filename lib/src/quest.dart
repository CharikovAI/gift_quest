import 'package:flutter/material.dart';

class Quest extends StatefulWidget {
  final String questId;
  
  const Quest({Key? key, 
    required this.questId,  
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => QuestState(questId);
}

class QuestState extends State<Quest> {
  QuestState(this.questId);

  final String questId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const <Widget>[
          Text(''),
        ],
      ),
    );
  }
  
}