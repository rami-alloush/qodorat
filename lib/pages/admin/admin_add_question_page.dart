import 'package:flutter/material.dart';
import 'package:qodorattest/db.dart';
import 'package:qodorattest/models.dart';

class AddQuestion extends StatefulWidget {
  AddQuestion({@required this.examID});

  final examID;

  @override
  _AddQuestionState createState() {
    return _AddQuestionState();
  }
}

class _AddQuestionState extends State<AddQuestion> {
  final _formKey = GlobalKey<FormState>();
  final db = DatabaseService();
  String _question;
  String _choice1;
  String _choice2;
  String _choice3;
  String _choice4;
  int _correctAnswer = 1;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    print(widget.examID);
    return Scaffold(
//        resizeToAvoidBottomPadding: false, // avoid keyboard overflow
      appBar: AppBar(
        title: Text("إضافة سؤال جديد"),
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
                    TextFormField(
                      maxLines: 1,
                      decoration: InputDecoration(
                          hintText: 'نص السؤال',
                          icon: Icon(
                            Icons.title,
                            color: Colors.grey,
                          )),
                      validator: (value) =>
                      value.isEmpty ? 'برجاء اضافة عنوان للدرس' : null,
                      onSaved: (value) => _question = value,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          hintText: 'الأختيار الأول',
                          icon: Icon(
                            Icons.text_fields,
                            color: Colors.grey,
                          )),
                      validator: (value) =>
                      value.isEmpty ? 'برجاء اضافة النص' : null,
                      onSaved: (value) => _choice1 = value,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          hintText: 'الأختيار الثاني',
                          icon: Icon(
                            Icons.text_fields,
                            color: Colors.grey,
                          )),
                      validator: (value) =>
                      value.isEmpty ? 'برجاء اضافة النص' : null,
                      onSaved: (value) => _choice2 = value,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          hintText: 'الأختيار الثالث',
                          icon: Icon(
                            Icons.text_fields,
                            color: Colors.grey,
                          )),
                      validator: (value) =>
                      value.isEmpty ? 'برجاء اضافة النص' : null,
                      onSaved: (value) => _choice3 = value,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          hintText: 'الأختيار الرابع',
                          icon: Icon(
                            Icons.text_fields,
                            color: Colors.grey,
                          )),
                      validator: (value) =>
                      value.isEmpty ? 'برجاء اضافة النص' : null,
                      onSaved: (value) => _choice4 = value,
                    ),
                    _showCorrectAnswer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: RaisedButton(
                          onPressed: () async {
                            // Validate returns true if the form is valid
                            if (_formKey.currentState.validate()) {
                              // If the form is valid, display a Snackbar.
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('جاري إضافة السؤال ...')));
                              // Save data to variables
                              _formKey.currentState.save();
                              // Add question to DB
                              var choices = [
                                _choice1,
                                _choice2,
                                _choice3,
                                _choice4
                              ];
                              await
                              db.createQuestion(
                                widget.examID,
                                Question(
                                  question: _question,
                                  choices: choices,
                                  correctAnswer: choices[_correctAnswer - 1],
                                ),
                              );
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text('إضافة السؤال'),
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

  _showCorrectAnswer() {
    return Row(
      children: <Widget>[
        Text("رقم الإجابة الصحيحة: "),
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () =>
              setState(
                    () => {if (_correctAnswer > 1) _correctAnswer--},
              ),
        ),
        Text(_correctAnswer.toString()),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () =>
              setState(
                    () => {if (_correctAnswer < 4) _correctAnswer++},
              ),
        )
      ],
    );
  }
}
