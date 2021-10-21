import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'dart:async';

import 'quest_created.dart';                   

class StoreQuest extends StatelessWidget {
  const StoreQuest(this.steps, this.greetings, {Key? key}) : super(key: key);
  
  final List<Step> steps;
  final String greetings;

  @override
  Widget build(BuildContext context) {
    CollectionReference quests = FirebaseFirestore.instance.collection('quests');

    Future<String> addUser() {
      return quests
        .add({
          'greetings': greetings,
          'steps': {
            for (int i = 0; i < steps.length; i++)
              i.toString(): {
                'question': steps[i].question,
                'answer': steps[i].answer,
                'tip': steps[i].tip
              }
          },
        })
        .then((value) {return value.id;})
        .catchError((error) => {});
    }

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.confirmQuestCreation),
      content: Text(AppLocalizations.of(context)!.impossibleToEditAfterConfirmation),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context)!.cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(AppLocalizations.of(context)!.confirm),
          onPressed: () async {
            var res = await addUser();
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
              builder: (context) => QuestCreated(res),
            ), (route) => false);
          },
        ),
      ],
    );
  }
}

class QuestCreation extends StatefulWidget {
  const QuestCreation({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => QuestCreationState();
}

class QuestCreationState extends State<QuestCreation> {

  bool _initialized = false;
  bool _error = false;

  List<Step> steps = [];
  late TextEditingController greetingsController = TextEditingController();

  bool greetingsValidator = true;

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

  _addStep() async {
    final step = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StepDialog(null, null, null)),
    );

    if (step != null) {
      setState(() {
        steps.add(step);
      });
    }
  }

  _editStep(int index) async {
    final step = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StepDialog(steps[index].question, steps[index].answer, steps[index].tip)),
    );

    if (step != null) {
      setState(() {
        steps[index] = step;
      });
    }
  }

  _storeNewQuest() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StoreQuest(steps, greetingsController.text))
    );
  }

  _checkGreetingsValidator() {
    if (greetingsController.text.isEmpty) {
      setState(() {
        greetingsValidator = false;
      });
    }
    else {
      setState(() {
        greetingsValidator = true;
      });
    }
  }

  Widget _buildItem(BuildContext context, int index) {
    final step = steps[index];

    return 
      Column(
        children:[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(step.question),
                  Text(step.answer),
                  Text(step.tip!),
                ],),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => _editStep(index), 
                    icon: const Icon(Icons.edit)
                  ),
                  IconButton(
                    onPressed: () => setState(() {
                      steps.removeAt(index);
                      final snackBar = SnackBar(
                        content: Text(AppLocalizations.of(context)!.stepDeleted),
                        action: SnackBarAction(
                          label: AppLocalizations.of(context)!.undo,
                          onPressed: () {},
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }), 
                    icon: const Icon(Icons.delete)
                  ),
                ],
              ),
          ],), 
          const Divider(),
      ]);
  }

  @override
  Widget build(BuildContext context) {
    if(_error) {
      return const CircularProgressIndicator();
    }

    if (!_initialized) {
      return const CircularProgressIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.createNewQuest),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  autofocus: false,
                  controller: greetingsController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.yourGreetings + '*',
                    labelStyle: (!greetingsValidator) ? const TextStyle(color:Colors.red) : null,
                    focusedBorder: OutlineInputBorder(
                      borderSide:  (!greetingsValidator) ?  const BorderSide(color: Colors.red) : const BorderSide(color: Colors.blue),
                    ),
                  ),
                  maxLines: 2,
                ),
              ),
              Text(AppLocalizations.of(context)!.steps + ':'),
              if (steps.isNotEmpty) 
                for (int i = 0; i < steps.length; i++)
                  _buildItem(context, i)
              else 
                Text(AppLocalizations.of(context)!.youDontHaveSteps, textAlign: TextAlign.center,),
              ElevatedButton(
                onPressed: () {
                  _checkGreetingsValidator();
                  if (greetingsValidator) {
                    _storeNewQuest();
                  }
                },
                child: Text(AppLocalizations.of(context)!.createQuest)
              )
          ],),
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _addStep,
      ),
    );
  } 
}

class Step {
  Step({required this.question, required this.answer, this.tip});

  String question;
  String answer;
  String? tip;
  @override
  String toString() {
    return 'question: $question, answer: $answer, tip: $tip';
  }
}

// ignore: must_be_immutable
class StepDialog extends StatefulWidget {
  StepDialog(this.question, this.answer, this.tip, {Key? key}) : super(key: key);
  String? question;
  String? answer;
  String? tip;

  @override
  State<StepDialog> createState() => StepDialogState();
}

class StepDialogState extends State<StepDialog> {

  TextEditingController questionController = TextEditingController();
  TextEditingController answerController= TextEditingController();
  TextEditingController tipController = TextEditingController();

  bool questionValidator = true;
  bool answerValidator = true;

  @override
  void initState() {
    questionController = TextEditingController(text: widget.question);
    answerController= TextEditingController(text: widget.answer);
    tipController = TextEditingController(text: widget.tip);
    super.initState();
  }

  _checkInputs() {
    if (questionController.text.isEmpty) {
      setState(() {
        questionValidator = false;
      });
    } 
    else {
      questionValidator = true;
    }
    if (answerController.text.isEmpty) {
      setState(() {
        answerValidator = false;
      });
    } 
    else {
      answerValidator = true;
    }
  }
  


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.addStep),
      content: Column(children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: questionController,
            autofocus: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.question + '*',
              labelStyle: (!questionValidator) ? const TextStyle(color:Colors.red) : null,
              focusedBorder: OutlineInputBorder(
                borderSide:  (!questionValidator) ?  const BorderSide(color: Colors.red) : const BorderSide(color: Colors.blue),
              ),
            ),
            maxLines: 2,
          ),
        ),
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
                borderSide:  (!answerValidator) ?  const BorderSide(color: Colors.red) : const BorderSide(color: Colors.blue),
              ),
            ),
            maxLines: 2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: tipController,
            autofocus: false,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.tip,
            ),
            maxLines: 2,
          ),
        ),
      ],),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context)!.cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(widget.question == null ? AppLocalizations.of(context)!.add: AppLocalizations.of(context)!.edit),
          onPressed: () {
            _checkInputs();
            if (questionValidator && answerValidator) {
              final step = Step(question: questionController.text, answer: answerController.text, tip: tipController.text);
              Navigator.of(context).pop(step);
            }
          },
        ),
      ],
    );
  }
}