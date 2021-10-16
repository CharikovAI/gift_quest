import 'package:flutter/material.dart';
import 'package:gift_quest/src/intro.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class Quest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => QuestState();
}

class QuestState extends State<Quest> {

  late String? questId;

  @override
  Widget build(BuildContext context) {
    questId = Provider.of<Data>(context).questId;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text(''),
          ElevatedButton(onPressed:(){ 
            Provider.of<Data>(context, listen: false).updateStoredData('');
            Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Intro(),
                ));
          }, 
          child: Text(''))
        ],
      ),
    );
  }
  
}