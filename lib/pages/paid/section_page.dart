import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qodorattest/db.dart';
import 'package:qodorattest/models.dart';
import 'package:qodorattest/pages/paid/lesson_page.dart';
import 'package:qodorattest/pages/paid/exam_page.dart';

class SectionPage extends StatefulWidget {
  SectionPage({
    @required this.sectionCategory,
    @required this.sectionIndex,
    @required this.sectionTitle,
  });

  final sectionCategory;
  final sectionIndex;
  final sectionTitle;

  @override
  _SectionPageState createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();
    var user = Provider.of<FirebaseUser>(context);
    var examID = "pre_${widget.sectionCategory}_${widget.sectionIndex}";

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.sectionTitle),
        ),
        body: StreamBuilder(
          stream: db.streamScore(examID, user),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // Loading Complete and Data Present
              print(snapshot.data);
              return StreamProvider<List<Lesson>>.value(
                stream: db.streamLessons(
                    widget.sectionCategory, widget.sectionIndex),
                // Only show score for Trainings (no lessons)
                child: widget.sectionCategory == 3
                    ? Center(
                        child: Text(
                            "تم إكمال هذا التدريب بدرجة: ${snapshot.data.score}%"),
                      )
                    : Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "درجة الإختبار القبلي: ${snapshot.data.score}%"),
                          ),
                          Expanded(
                            child: LessonsList(),
                          ),
                        ],
                      ),
              );
            } else {
              // No Score
              return Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("يجب أخذ الأختبار أولاً"),
                  RaisedButton(
                      onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExamPage(
                                      examID: examID,
                                    )),
                          ),
                      child: Text("بدء الأختبار")),
                ],
              ));
            }
          },
        ));
  }
}

class LessonsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var lessons = Provider.of<List<Lesson>>(context);

    return Container(
      child: lessons == null || lessons.isEmpty
          ? Center(child: Text("لا يوجد دروس"))
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListView(
                  shrinkWrap: true,
                  children: lessons.map(
                    (lesson) {
                      return Card(
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
                      );
                    },
                  ).toList(),
                ),
                RaisedButton(
                  child: Text("إكمال الإختبار النهائي"),
                  onPressed: null,
                )
              ],
            ),
    );
  }
}
