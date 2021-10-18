import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
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
  int currentStep = 0;

  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_error) {
      return const CircularProgressIndicator();
    }

    if (!_initialized) {
      return const CircularProgressIndicator();
    }

    CollectionReference users = FirebaseFirestore.instance.collection('quests');
    questId = Provider.of<Data>(context).questId;

    return 
     ChangeNotifierProvider(
      create: (context) => Data(),
      child: FutureBuilder<DocumentSnapshot>(
      future: users.doc(questId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>; 

          return Scaffold(
            body: Column(
              children: <Widget>[
                if (currentStep == 0) ...[
                  Text("Greetings: ${data['greetings']}"),
                  Text(currentStep.toString()),
                ]
                else ...[
                  Text("Question: ${data['steps'][(currentStep - 1).toString()]['question']}"),
                ],
                ElevatedButton(onPressed:() {             
                  if (currentStep < data['steps'].length) {
                    setState(() {
                      currentStep += 1;
                    });
                    Provider.of<Data>(context, listen: false).updateCurrentStep();
                  } else {
                    Provider.of<Data>(context, listen: false).updateStoredData('');
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Intro(),
                    ));
                  }
                }, 
                child: Text('Next'))
              ],
            ),
          );
        }
        return Text("loading");
      },
    ));
  }
}