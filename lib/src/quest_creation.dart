import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'dart:async';                   

class StoreQuest extends StatelessWidget {
  final List<Step> steps;
  StoreQuest(this.steps);

  @override
  Widget build(BuildContext context) {
    CollectionReference quests = FirebaseFirestore.instance.collection('quests');

    Future<void> addUser() {
      return quests
        .add({
          // TODO: change id settings
          'id': 1,
          // TODO: add greetings
          'steps': {
            for (int i = 0; i < steps.length; i++)
              i.toString(): {
                'question': steps[i].question,
                'answer': steps[i].answer,
                'tip': steps[i].tip
              }
          }, // Stokes and Sons
        })
        .then((value) => {})
        .catchError((error) => {});
    }

    return AlertDialog(
      title: Text('Confirm quest creation'),
      content: Text("It's impossible to edit quest after confirmation"),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Confirm'),
          onPressed: () {
            addUser();
            // TODO: navigate to qr code with the link of created quest
            Navigator.of(context).pop();
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
    final step = await showDialog<Step>(
      context: context,
      builder: (BuildContext context) {
        return TodoDialog(null, null, null);
      },
    );

    if (step != null) {
      setState(() {
        steps.add(step);
      });
    }
  }

  _editStep(int index) async {
    final step = await showDialog<Step>(
      context: context,
      builder: (BuildContext context) {
        return TodoDialog(steps[index].question, steps[index].answer, steps[index].tip);
      },
    );

    if (step != null) {
      setState(() {
        steps[index] = step;
      });
    }
  }

  _storeNewQuest() {
    showDialog<StoreQuest>(
      context: context,
      builder: (BuildContext context) {
        return StoreQuest(steps);
      },
    );
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
        title: const Text('Create new quest'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  autofocus: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Your greeting to quest'//AppLocalizations.of(context)!.question + '*',
                  ),
                  maxLines: 2,
                ),
              ),
              const Text('Steps:'),
              if (steps.isNotEmpty) 
                for (int i = 0; i < steps.length; i++)
                  _buildItem(context, i)
              else 
                const Text('You have not any steps yet. \nPress + button to add first step.'),
              ElevatedButton(
                onPressed: () => _storeNewQuest(), 
                child: const Text('Create quest')
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

class TodoDialog extends StatelessWidget {
  TodoDialog(this.question, this.answer, this.tip, {Key? key}) : super(key: key);

  String? question;
  String? answer;
  String? tip;
  
  
  late TextEditingController questionController = TextEditingController();
  late TextEditingController answerController = TextEditingController();
  late TextEditingController tipController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    questionController = TextEditingController(text: question);
    answerController= TextEditingController(text: answer);
    tipController = TextEditingController(text: tip);
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
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: question == null ? const Text('Add'): const Text('Edit'),
          onPressed: () {
            final step = Step(question: questionController.text, answer: answerController.text, tip: tipController.text);
            Navigator.of(context).pop(step);
          },
        ),
      ],
    );
  }
}