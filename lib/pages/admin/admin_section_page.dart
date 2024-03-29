import 'package:flutter/material.dart';
import 'package:qodorattest/db.dart';
import 'package:qodorattest/pages/paid/lesson_page.dart';
import 'package:qodorattest/pages/admin/admin_add_lesson_page.dart';
import 'admin_questions_page.dart';

// Displays the main section page with 3 PageViews
class AdminSectionPage extends StatelessWidget {
  AdminSectionPage({
    @required this.sectionCategory,
    @required this.sectionIndex,
    @required this.sectionTitle,
  });

  final sectionCategory;
  final sectionIndex;
  final sectionTitle;
  final db = DatabaseService();
  var lessonCount;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('$sectionTitle'),
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.content_paste)),
                  Tab(icon: Icon(Icons.question_answer)),
                  Tab(icon: Icon(Icons.grade)),
                ],
              ),
              actions: <Widget>[],
            ),
            body: TabBarView(
              children: [
                _buildLessonsList(context),
                QuestionsPage(examID: "pre_${sectionCategory}_$sectionIndex"),
                QuestionsPage(examID: "post_${sectionCategory}_$sectionIndex"),
              ],
            ),
          );
        },
      ),
    );
  }

  _buildLessonsList(context) {
    final db = DatabaseService();
    return Scaffold(
      floatingActionButton: _addFAB(context),
      body: StreamBuilder(
          stream: db.streamLessons(sectionCategory, sectionIndex),
          builder: (context, snapshot) {
            snapshot.data != null
                ? lessonCount = snapshot.data.length
                : lessonCount = 0;
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
                            if (await _showConfirmDeleteDialog(
                                context, lesson)) {
                              // Remove the item from the data source.
                              db.deleteLesson(lesson);
                              // Then show a snackbar.
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text("تم حذف: ${lesson.title}")));
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
                                        builder: (context) =>
                                            LessonPage(lesson)),
                                  ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            );
          }),
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

  Widget _addFAB(context) {
    return FloatingActionButton(
      shape: StadiumBorder(),
//        backgroundColor: Colors.redAccent,
      child: Icon(
        Icons.add_circle,
        size: 20.0,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddLesson(
                  sectionCategory: sectionCategory,
                  sectionIndex: sectionIndex,
                  lessonCount: lessonCount,
                ),
          ),
        );
      },
    );
  }
}
