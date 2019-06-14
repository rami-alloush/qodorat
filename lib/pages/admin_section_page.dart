import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qodorat/db.dart';
import 'package:qodorat/models.dart';
import 'package:qodorat/pages/lesson_page.dart';
import 'package:qodorat/pages/exam_page.dart';

class AdminSectionPage extends StatefulWidget {
  AdminSectionPage({
    @required this.sectionCategory,
    @required this.sectionIndex,
    @required this.sectionTitle,
  });

  final sectionCategory;
  final sectionIndex;
  final sectionTitle;
  final db = DatabaseService();

  @override
  _AdminSectionPageState createState() => _AdminSectionPageState();
}

class _AdminSectionPageState extends State<AdminSectionPage> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    var examID = "pre_${widget.sectionCategory}_${widget.sectionIndex}";

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.sectionTitle}'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.content_paste)),
              Tab(icon: Icon(Icons.question_answer)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildLessonsList(),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }

  _buildLessonsList() {
    final db = DatabaseService();
    return StreamBuilder(
        stream: widget.db
            .streamLessons(widget.sectionCategory, widget.sectionIndex),
        builder: (context, snapshot) {
          return Container(
            child: snapshot == null ||
                    !snapshot.hasData ||
                    snapshot.data.length == 0
                ? Center(child: Text("لا يوجد دروس"))
                : ListView(
                    children: snapshot.data.map<Widget>((lesson) {
                      return Dismissible(
                        key: Key(lesson.id),
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
                          if (await _showConfirmDeleteDialog(context, lesson)) {
                            // Remove the item from the data source.
                            db.deleteLesson(lesson);
                            // Then show a snackbar.
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text("تم حذف: ${lesson.title}")));
//                            print("Deleted!");
                          }
                        },
                        child: Card(
                          child: ListTile(
                            leading: Text(
                              lesson.order.toString(),
                            ),
                            title: Text(lesson.title),
                            onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LessonPage(lesson)),
                                ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          );
        });
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
