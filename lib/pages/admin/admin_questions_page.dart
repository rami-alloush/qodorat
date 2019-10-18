import 'package:flutter/material.dart';
import 'package:qodorattest/db.dart';
import 'admin_add_question_page.dart';

// Pages for Question display and add btn
// Shown inside the PageView of sections
// and directly in Training pages
class QuestionsPage extends StatelessWidget {
  QuestionsPage({@required this.examID});

  final examID;

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: StadiumBorder(),
        child: Icon(
          Icons.add_circle,
          size: 20.0,
        ),
        onPressed: () =>
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddQuestion(
                      examID: examID,
                    ),
              ),
            ),
      ),
      body: StreamBuilder(
        stream: db.streamQuestions(examID),
        builder: (context, snapshot) {
          return Container(
            child: snapshot == null ||
                !snapshot.hasData ||
                snapshot.data.length == 0
                ? Center(child: Text("لا يوجد اسئلة"))
                : ListView(
              children: snapshot.data.map<Widget>((question) {
                return Dismissible(
                  key: Key(question.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment(0.9, 0.0),
                    child: Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                    ),
                  ),
                  direction: DismissDirection.startToEnd,
                  confirmDismiss: (DismissDirection direction) async {
                    // Show confirmation
                    if (await _showConfirmDeleteDialog(context, question)) {
                      // Remove the item from the data source.
                      db.deleteQuestion(examID, question);
                      // Then show a snackbar.
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "تم حذف السؤال: ${question.question}")));
                    }
                  },
                  child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Text("السؤال: ${question.question}"),
                                  Text("الإختيارات: ${question.choices}"),
                                  Text(
                                      "الإجابة الصحيحة: ${question.correctAnswer}"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Future<bool> _showConfirmDeleteDialog(BuildContext context, lesson) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("تأكيد حذف العنصر"),
          content: new Text(
              "سوف يتم حذف هذا العنصر نهائياً. لايمكن التراجع عن هذه العملية!"),
          actions: <Widget>[
            FlatButton(
              child: new Text("إلغاء"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            RaisedButton(
              child: new Text(
                "تأكيد الحذف",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // Close the Dialog
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
