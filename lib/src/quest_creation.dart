import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuestCreation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => QuestCreationState();
}

class QuestCreationState extends State<QuestCreation> {

  List<Step> steps = [];

  _addStep() async {
    final step = await showDialog<Step>(
      context: context,
      builder: (BuildContext context) {
        return NewTodoDialog();
      },
    );

    if (step != null) {
      setState(() {
        steps.add(step);
      });
    }

    print(steps);
  }

  Widget _buildItem(BuildContext context, int index) {
    final todo = steps[index];

    return _tile(context, todo.question, todo.answer, todo.tip);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    // TODO: implement toString
    return 'question: $question, answer: $answer, tip: $tip';
  }
}

class NewTodoDialog extends StatelessWidget {
  
  final questionController = TextEditingController();
  final answerController = TextEditingController();
  final tipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.addStep),
      content: Column(children: [
        Padding(
          padding: EdgeInsets.all(10),
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
          padding: EdgeInsets.all(10),
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
          padding: EdgeInsets.all(10),
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
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Add'),
          onPressed: () {
            final step = Step(question: questionController.text, answer: answerController.text, tip: tipController.text);
            //controller.clear();

            Navigator.of(context).pop(step);
          },
        ),
      ],
    );
  }
}

ListTile _tile(BuildContext context, String question, String answer, String? tip) => ListTile(
  title: Text(question,
    style: const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 15,
      color: Color(0xffbb9f89)
    )
  ),
  subtitle: Text(answer,
    style: const TextStyle(color: Color(0xfffaede3))
  ),
);