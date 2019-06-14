import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qodorat/db.dart';
import 'package:qodorat/models.dart';

var questionNumber = 0;
var finalScore = 0;
var questions;

class ExamPage extends StatefulWidget {
  ExamPage({@required this.examID});

  final examID;

  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();
    print(widget.examID);

    return Scaffold(
      body: StreamBuilder(
        stream: db.streamQuestions(widget.examID),
        builder: (context, snapshot) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
                appBar: AppBar(
                  title: Text("الاختبار"),
                  leading: IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () => _showConfirmExitDialog(context),
                  ),
                ),
                body: snapshot == null ||
                        !snapshot.hasData ||
                        snapshot.data.length == 0
                    ? Center(child: Text("لا يوجد اسئلة"))
                    : _showQuestions(snapshot.data)),
          );
        },
      ),
    );
  }

  _showQuestions(data) {
    questions = data;
    return Container(
      margin: const EdgeInsets.all(10.0),
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "سؤال رقم: ${questionNumber + 1} من ${questions.length}",
                  style: TextStyle(fontSize: 22.0),
                ),
                Text(
                  "النتيجة: $finalScore",
                  style: TextStyle(fontSize: 22.0),
                )
              ],
            ),
          ),
          Divider(),
          Text(
            questions[questionNumber].question,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          Padding(padding: EdgeInsets.all(10.0)),
          //button 1
          MaterialButton(
            minWidth: 200.0,
            color: Colors.blueGrey,
            onPressed: () {
              if (questions[questionNumber].choices[0] ==
                  questions[questionNumber].correctAnswer) {
                debugPrint("Correct");
                finalScore++;
              } else {
                debugPrint("Wrong");
              }
              updateQuestion();
            },
            child: Text(
              questions[questionNumber].choices[0],
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
          ),

          //button 2
          MaterialButton(
            minWidth: 200.0,
            color: Colors.blueGrey,
            onPressed: () {
              if (questions[questionNumber].choices[1] ==
                  questions[questionNumber].correctAnswer) {
                debugPrint("Correct");
                finalScore++;
              } else {
                debugPrint("Wrong");
              }
              updateQuestion();
            },
            child: Text(
              questions[questionNumber].choices[1],
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
          ),

          //button 3
          MaterialButton(
            minWidth: 200.0,
            color: Colors.blueGrey,
            onPressed: () {
              if (questions[questionNumber].choices[2] ==
                  questions[questionNumber].correctAnswer) {
                debugPrint("Correct");
                finalScore++;
              } else {
                debugPrint("Wrong");
              }
              updateQuestion();
            },
            child: Text(
              questions[questionNumber].choices[2],
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
          ),

          //button 4
          MaterialButton(
            minWidth: 200.0,
            color: Colors.blueGrey,
            onPressed: () {
              if (questions[questionNumber].choices[3] ==
                  questions[questionNumber].correctAnswer) {
                debugPrint("Correct");
                finalScore++;
              } else {
                debugPrint("Wrong");
              }
              updateQuestion();
            },
            child: Text(
              questions[questionNumber].choices[3],
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void updateQuestion() {
    setState(() {
      if (questionNumber == questions.length - 1) {
        print("End of questions");
        _showCompletionDialog(context);
      } else {
        questionNumber++;
      }
    });
  }

  void _showConfirmExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("تأكيد الخروج من الاختبار"),
          content: Text(
              "هل انت متأكد من الخروج من الإختبار؟ سوف يتم مسح كل اجاباتك ولن تستطيع الإطلاع على الدروس"),
          actions: <Widget>[
            FlatButton(
              child: Text("إلغاء"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              child: Text(
                "خروج",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                resetQuiz();
              },
            ),
          ],
        );
      },
    );
  }

  void _showCompletionDialog(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    var percentage = finalScore / questions.length * 100;
    final db = DatabaseService();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("تم اكمال الاختبار"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                  "تهانينا! تم اكمال الاختبار بنجاح. عدد الإجابات الصحيحة هو $finalScore من اصل ${questions.length}."),
              Text("نسبتك المؤية هي: ${percentage.toStringAsFixed(2)}%"),
              Text("يمكنك الآن الإطلاع على الدروس الخاصة بهذا القسم."),
            ],
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text(
                "موافق",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                db.updateScoreOnDB(widget.examID, user, percentage);
                resetQuiz();
              },
            ),
          ],
        );
      },
    );
  }

  void resetQuiz() {
    setState(() {
      Navigator.pop(context);
      finalScore = 0;
      questionNumber = 0;
    });
  }
}
