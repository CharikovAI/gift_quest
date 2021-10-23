import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gift_quest/src/intro.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'finish_quest.dart';
import 'models/data.dart';

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
  bool answerValidator = true;

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
    setStep();
  }

  void setStep() {
    setState(() {
      currentStep = Provider.of<Data>(context, listen: false).currentStep ?? 0;
    });
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
        title: Text(AppLocalizations.of(context)!.tip),
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
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    ); 
  }

  void _checkAnswer(String correctAnswer) {
    if (answerController.text.toLowerCase() != correctAnswer.toLowerCase()) {
      setState(() {
        answerValidator = false;
      });
    }
    else {
      setState(() {
        answerValidator = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_error) {
      return const CircularProgressIndicator();
    }

    if (!_initialized) {
      return const CircularProgressIndicator();
    }

    CollectionReference quests = FirebaseFirestore.instance.collection('quests');
    questId = Provider.of<Data>(context).questId;
    return Scaffold(
      body: Center(
        child: FutureBuilder<DocumentSnapshot>(
          future: quests.doc(questId).get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.somethingWentWrong),
                    ElevatedButton(onPressed:() {
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                              builder: (context) => const Intro(),
                            ), (route) => false);
                      }, 
                      child: Text(AppLocalizations.of(context)!.toFirstScreen))
                  ],);
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.questDoesnotExist),
                    ElevatedButton(onPressed:() {
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                              builder: (context) => const Intro(),
                            ), (route) => false);
                      }, 
                      child: Text(AppLocalizations.of(context)!.back))
                  ],);
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>; 
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (currentStep == 0) ...[
                    Text("${data['greetings']}"),
                  ]
                  else ...[
                    Text(AppLocalizations.of(context)!.detailQuestion(currentStep, data['steps'].length, data['steps'][(currentStep - 1).toString()]['question'])),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: answerController,
                        autofocus: false,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)!.answer + '*',
                          labelStyle: (!answerValidator) ? const TextStyle(color:Colors.red) : null,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: answerValidator ? Colors.blue : Colors.red),
                          ),
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
                      _checkAnswer(data['steps'][(currentStep - 1).toString()]['answer']);
                      if (answerValidator) {
                        setState(() {
                          currentStep += 1;
                        });
                        Provider.of<Data>(context, listen: false).updateCurrentStep();
                        answerController.clear();
                      }
                    } else {
                      _checkAnswer(data['steps'][(currentStep - 1).toString()]['answer']);
                      if (answerValidator) {
                        Provider.of<Data>(context, listen: false).deleteStoredQuestId();
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                          builder: (context) => const FinishQuest(),
                        ), (route) => false);
                      }
                    }
                  }, 
                  child: Text(AppLocalizations.of(context)!.next))
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