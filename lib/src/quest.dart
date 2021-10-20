import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gift_quest/src/intro.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../main.dart';

class Quest extends StatefulWidget {
  const Quest({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => QuestState();
}

class QuestState extends State<Quest> {

  late String? questId;
  int currentStep = 0;

  bool _initialized = false;
  bool _error = false;

  TextEditingController answerController = TextEditingController();
  bool? answerValidator;

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

  void _showTipDialog(String tip) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Tip'),//Text(AppLocalizations.of(context)!.tip),
        content: InkWell(
          child: Text(
            tip,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },  
            child: const Text('OK'),
          ),
        ],
      ),
    ); 
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
    return Scaffold(
      body: Center(
        child: FutureBuilder<DocumentSnapshot>(
          future: users.doc(questId).get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>; 
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (currentStep == 0) ...[
                    Text("Greetings: ${data['greetings']}"),
                  ]
                  else ...[
                    Text("Question: ${data['steps'][(currentStep - 1).toString()]['question']}"),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: answerController,
                        autofocus: false,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)!.answer + '*',
                          labelStyle: (answerValidator ?? true) ? const TextStyle(color:Colors.grey) : const TextStyle(color:Colors.red),
                        ),
                        maxLines: 1,
                      )
                    ),  
                    if (data['steps'][(currentStep - 1).toString()]['tip']?.isNotEmpty ?? false) ...[
                      OutlinedButton(
                        onPressed: () {
                          _showTipDialog(data['steps'][(currentStep - 1).toString()]['tip']);
                        },
                        child: Text(AppLocalizations.of(context)!.tip),
                      )
                    ],
                  ],
                  ElevatedButton(onPressed:() {
                    if (currentStep == 0) {
                      setState(() {
                        currentStep += 1;
                      });
                      Provider.of<Data>(context, listen: false).updateCurrentStep();
                    }          
                    else if (currentStep < data['steps'].length) {
                      setState(() {
                        currentStep += 1;
                      });
                      Provider.of<Data>(context, listen: false).updateCurrentStep();
                    } else {
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                        builder: (context) => Intro(),
                      ), (route) => false);
                      Provider.of<Data>(context, listen: false).deleteStoredQuestId();
                    }
                  }, 
                  child: Text('Next'))
                ],
              );
            }

            return const CircularProgressIndicator();
          },
        )
      )
    );
  }
}