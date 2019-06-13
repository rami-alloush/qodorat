import 'package:flutter/material.dart';
import 'backdrop.dart';
import 'package:qodorat/bloc/scroll_bloc.dart';
import 'package:qodorat/pages/section_page.dart';

class PaidLessonsPage extends StatefulWidget {
  @override
  _PaidLessonsPageState createState() => _PaidLessonsPageState();
}

class _PaidLessonsPageState extends State<PaidLessonsPage> {
  final GlobalKey<BackDropState> _backdropKey = GlobalKey<BackDropState>();

  ScrollBloc scrollBloc;

  @override
  void initState() {
    super.initState();
    scrollBloc = ScrollBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackDrop(
        key: _backdropKey,
        scrollBloc: scrollBloc,
        backLayer: MyBackLayer(
          title: "صفحة الدروس",
        ),
        backTitle: Text(
          'الدروس',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}

class MyBackLayer extends StatefulWidget {
  MyBackLayer({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  MyBackLayerState createState() => MyBackLayerState();
}

class MyBackLayerState extends State<MyBackLayer>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  PageController _pageController;
  List<DateTime> days;

  @override
  void initState() {
    super.initState();
    int initialPage = 0;
    if (_pageController != null) {
      _pageController.removeListener(_handlePageScroll);
    }
    _pageController = PageController(
        viewportFraction: 0.8, initialPage: initialPage, keepPage: true)
      ..addListener(_handlePageScroll);
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this, value: 0.0);
    _controller.value = 0;
  }

  @override
  void dispose() {
    _pageController.removeListener(_handlePageScroll);
    _controller.dispose();
    super.dispose();
  }

  void _handlePageScroll() {
    _controller.value = (_pageController.position.pixels /
            _pageController.position.maxScrollExtent)
        .clamp(0.0, 1.0)
        .abs();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[_buildPageSelector(context, _controller)],
      ),
    );
  }

  Widget _buildPageSelector(
      BuildContext context, AnimationController controller) {
    const List _Cat1Sections = ["هندسة", "جبر", "حساب", "تحليل بيانات"];
    const List _Cat2Sections = [
      "التناظر اللفظي",
      "اكمال الجمل",
      "المفردة الشاذة",
      "استيعات المقروء",
      "الخطأ السياقي"
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Titles
        Padding(
            padding: const EdgeInsets.only(right: 48.0),
            child: CrossFadeTransition(
              progress: _controller,
              children: [
                Column(
                  children: <Widget>[
                    Text(
                      "الاختبار الكمي",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40.0,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "الاختبار اللفظي",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40.0,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "التدريبات",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40.0,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            )),
        // Content
        SizedBox.fromSize(
          size: Size.fromHeight(MediaQuery.of(context).size.height * 0.575),
          child: PageView(
              scrollDirection: Axis.horizontal,
              controller: _pageController,
              children: [
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  margin: EdgeInsets.all(10.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                            color: Colors.grey,
                          ),
                      itemCount: _Cat1Sections.length,
                      itemBuilder: (context, index) => ListTile(
                            title: Text(
                              "${_Cat1Sections[index]}",
                              style: TextStyle(fontSize: 24.0),
                            ),
                            onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SectionPage(
                                          sectionCategory: 1,
                                          sectionIndex: index,
                                          sectionTitle: _Cat1Sections[index],
                                        ),
                                  ),
                                ),
                          ),
                    ),
                  ),
                ),
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  margin: EdgeInsets.all(10.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                              color: Colors.grey,
                            ),
                        itemCount: _Cat2Sections.length,
                        itemBuilder: (context, index) => ListTile(
                              title: Text(
                                "${_Cat2Sections[index]}",
                                style: TextStyle(fontSize: 24.0),
                              ),
                              onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SectionPage(
                                            sectionCategory: 2,
                                            sectionIndex: index,
                                            sectionTitle: _Cat2Sections[index],
                                          ),
                                    ),
                                  ),
                            ),
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  margin: EdgeInsets.all(10.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                              color: Colors.grey,
                            ),
                        itemCount: 10,
                        itemBuilder: (context, index) => ListTile(
                              title: Text(
                                "تدريب ${index + 1}",
                                style: TextStyle(fontSize: 24.0),
                              ),
                              onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SectionPage(
                                            sectionCategory: 3,
                                            sectionIndex: index,
                                            sectionTitle: "تدريب ${index + 1}",
                                          ),
                                    ),
                                  ),
                            ),
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      ],
    );
  }
}
