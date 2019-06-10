import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:shared_preferences/shared_preferences.dart';

// IntroScreen Code
class IntroScreen extends StatefulWidget {
  IntroScreen({Key key}) : super(key: key);

  @override
  IntroScreenState createState() => new IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "تعلّم",
        styleTitle: TextStyle(
            color: Colors.white,
            fontSize: 32.0,
            fontWeight: FontWeight.bold,),
        description: "تعلم كل ما يخط اختبار القدرات العامة سواء كمي أو لفظي",
        styleDescription: TextStyle(
            color: Colors.white,
            fontSize: 24.0,),
        pathImage: "assets/bulb.png",
        backgroundColor: Color(0xffb6dbce),
      ),
    );
    slides.add(
      new Slide(
        title: "تفاعل",
        styleTitle: TextStyle(
          color: Colors.white,
          fontSize: 32.0,
          fontWeight: FontWeight.bold,),
        description: "دروس تفاعليه لتثبيت المعلومة في كافة المستويات",
        styleDescription: TextStyle(
          color: Colors.white,
          fontSize: 24.0,),
        pathImage: "assets/pencil-clipart.png",
        backgroundColor: Color(0xffb3d5e9),
      ),
    );
    slides.add(
      new Slide(
        title: "قيّم",
        styleTitle: TextStyle(
          color: Colors.white,
          fontSize: 32.0,
          fontWeight: FontWeight.bold,),
        description:
            "اختبار قبل وبعد كل مستوى للتأكد من فهمك واستيعابك للمحتوى بشكل مثالي",
        styleDescription: TextStyle(
          color: Colors.white,
          fontSize: 24.0,),
        pathImage: "assets/paper-notes.png",
        backgroundColor: Color(0xffc0a9ca),
      ),
    );
  }

  void onDonePress() {
    Navigator.of(context).pop();
    updatePrefs();
  }

  Future updatePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('seen', true);
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      renderNextBtn: Icon(
        Icons.navigate_next,
        color: Colors.white,
      ),
      renderSkipBtn: Text(
        "إلغاء",
      ),
      renderDoneBtn: Text(
        "تم",
        style: TextStyle(color: Colors.white),
      ),
      onDonePress: this.onDonePress,

      // Dot indicator
      colorDot: Colors.grey,
      colorActiveDot: Colors.grey,
      sizeDot: 8.0,

      // Show or hide status bar
//      shouldHideStatusBar: true,
//      backgroundColorAllSlides: Colors.grey,
    );
  }
}
