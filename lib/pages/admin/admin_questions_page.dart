import 'package:flutter/material.dart';
import 'package:qodorat/db.dart';

class QuestionsPage extends StatelessWidget {
  QuestionsPage({@required this.examID});

  final examID;

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();
    return StreamBuilder(
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
                              content: Text("تم حذف السؤال: ${question.question}")));
                        }
                      },
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text("السؤال: ${question.question}"),
                                Text("الإختيارات: ${question.choices}"),
                                Text("الإجابة الصحيحة: ${question.correctAnswer}"),
                              ],
                            ),
                          ],
                        )
                      ),
                    );
                  }).toList(),
                ),
        );
      },
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
