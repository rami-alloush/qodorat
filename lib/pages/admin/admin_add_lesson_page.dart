import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:qodorattest/db.dart';
import 'package:qodorattest/models.dart';

class AddLesson extends StatefulWidget {
  AddLesson(
      {@required this.sectionCategory,
      @required this.sectionIndex,
      this.lessonCount});

  final sectionCategory;
  final sectionIndex;
  final lessonCount;

  @override
  _AddLessonState createState() {
    return _AddLessonState();
  }
}

class _AddLessonState extends State<AddLesson> {
  final _formKey = GlobalKey<FormState>();
  final db = DatabaseService();
  int _lessonOrder;
  String _title;
  String _videoURL;
  String _exploratoryText1;
  String _exploratoryText2;

  @override
  void initState() {
    _lessonOrder = widget.lessonCount + 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
//        resizeToAvoidBottomPadding: false, // avoid keyboard overflow
      appBar: AppBar(
        title: Text("إضافة درس جديد"),
      ),
      body: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              // avoid keyboard overflow
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _showLessonOrder(),
                    TextFormField(
                      maxLines: 1,
                      decoration: InputDecoration(
                          hintText: 'عنوان الدرس',
                          icon: Icon(
                            Icons.title,
                            color: Colors.grey,
                          )),
                      validator: (value) =>
                          value.isEmpty ? 'برجاء اضافة عنوان للدرس' : null,
                      onSaved: (value) => _title = value,
                    ),
                    TextFormField(
                      maxLines: 1,
                      decoration: InputDecoration(
                          hintText: 'رابط الفيديو',
                          icon: Icon(
                            Icons.video_library,
                            color: Colors.grey,
                          )),
                      validator: (value) => value.isEmpty ||
                              YoutubePlayer.convertUrlToId(value) == null
                          ? 'برجاء اضافة رابط يوتيوب صحيح'
                          : null,
                      onSaved: (value) => _videoURL = value,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          hintText: 'الشرح الأساسي',
                          icon: Icon(
                            Icons.text_fields,
                            color: Colors.grey,
                          )),
                      validator: (value) =>
                          value.isEmpty ? 'برجاء اضافة النص' : null,
                      onSaved: (value) => _exploratoryText1 = value,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          hintText: 'الشرح الإضافي',
                          icon: Icon(
                            Icons.text_fields,
                            color: Colors.grey,
                          )),
                      onSaved: (value) => _exploratoryText2 = value,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: RaisedButton(
                          onPressed: () async {
                            // Validate returns true if the form is valid
                            if (_formKey.currentState.validate()) {
                              // If the form is valid, display a Snackbar.
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('جاري إضافة الدرس ...')));
                              // Save data to variables
                              _formKey.currentState.save();
                              // Add lesson to DB
                              await db.createLesson(
                                Lesson(
                                  title: _title,
                                  videoURL: _videoURL,
                                  exploratoryText1: _exploratoryText1,
                                  exploratoryText2: _exploratoryText2,
                                  order: _lessonOrder,
                                  sectionCategory: widget.sectionCategory,
                                  sectionIndex: widget.sectionIndex,
                                ),
                              );
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text('إضافة الدرس'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _showLessonOrder() {
    return Row(
      children: <Widget>[
        Text("ترتيب الدرس: "),
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () => setState(() => _lessonOrder--),
        ),
        Text(_lessonOrder.toString()),
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () => setState(() => _lessonOrder++))
      ],
    );
  }
}
