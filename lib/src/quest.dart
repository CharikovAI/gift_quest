import 'package:flutter/material.dart';

class Quest extends StatefulWidget {
  final String questId;
  
  const Quest({Key? key, 
    required this.questId,  
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => QuestState();
}

class QuestState extends State<Quest> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text(''),
        ],
      ),
    );
  }
  
}