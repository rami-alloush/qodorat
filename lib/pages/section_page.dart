import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qodorat/db.dart';
import 'package:qodorat/models.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sectionTitle),
      ),
      body: StreamProvider<List<Lesson>>.value(
        stream: db.streamLessons(widget.sectionCategory, widget.sectionIndex),
        child: LessonsList(),
      ),
    );
  }
}

class LessonsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var lessons = Provider.of<List<Lesson>>(context);

    return Container(
      child: lessons == null || lessons.isEmpty
          ? Center(child: Text("لا يوحد دروس"))
          : ListView(
              children: lessons.map((lesson) {
                return Card(
                  child: ListTile(
                    leading: Text(lesson.order.toString(),
                        style: TextStyle(fontSize: 50)),
                    title: Text(lesson.title),
//              onTap: () => DatabaseService().removeWeapon(user, weapon.id),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
