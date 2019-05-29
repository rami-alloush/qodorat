import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

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
        title: "تعلم",
        description: "تعلم كل ما يخط اختبار القدرات سواء كمي أو كيفي",
        pathImage: "assets/photo_eraser.png",
        backgroundColor: Color(0xfff5a623),
      ),
    );
    slides.add(
      new Slide(
        title: "تفاعل",
        description: "دروس تفاعليه لتثبيت المعلومة في كافة المستويات",
        pathImage: "assets/photo_pencil.png",
        backgroundColor: Color(0xff203152),
      ),
    );
    slides.add(
      new Slide(
        title: "قيّم",
        description:
        "اختبار قبل وبعد كل مستوى للتأكد من فهمك واستيعابك للمحتوى بشكل مثالي",
        pathImage: "assets/photo_ruler.png",
        backgroundColor: Color(0xff9932CC),
      ),
    );
  }

  void onDonePress() {
    print("Done intro");
    // First time user of the app
    Navigator.of(context).pop();
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
        "إلفاء",
      ),
      renderDoneBtn: Text(
        "تم",
        style: TextStyle(color: Colors.white),
      ),
      onDonePress: this.onDonePress,
    );
  }
}
