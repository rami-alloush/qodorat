import 'package:flutter/material.dart';
import 'backdrop.dart';
import 'package:qodorat/bloc/scroll_bloc.dart';

class UpgradeBenefitsPage extends StatefulWidget {
  @override
  _UpgradeBenefitsPageState createState() => _UpgradeBenefitsPageState();
}

class _UpgradeBenefitsPageState extends State<UpgradeBenefitsPage> {
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
          title: "My Page Title",
        ),
        backTitle: Text(
          'مزايا الإشتراك',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        // Titles
        Padding(
            padding: const EdgeInsets.only(left: 48.0, bottom: 16.0),
            child: CrossFadeTransition(
              alignment: Alignment.centerLeft,
              progress: _controller,
              children: [
                Text(
                  "منهج متكامل",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "اختبارات عملية",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "تقييم للأداء",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w700),
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
                    child: Text("المحتوى هنا"),
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
                    child: Text("المحتوى هنا"),
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
                    child: Text("المحتوى هنا"),
                  ),
                ),
              ]),
        ),
      ],
    );
  }
}
