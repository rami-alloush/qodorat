import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'package:qodorat/pages/admin/admin_section_page.dart';
import 'admin_questions_page.dart';

/// Main admin content page that displays
/// the main 3 cards for content
class ManageContent extends StatefulWidget {
  @override
  State createState() => _ManageContentState();
}

class _ManageContentState extends State<ManageContent> {
  final _controller = PageController(viewportFraction: 0.8);
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;
  final _kArrowColor = Colors.black.withOpacity(0.8);

  @override
  Widget build(BuildContext context) {
    _mySectionsCard(catNum, catList) {
      return Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        margin: EdgeInsets.all(10.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
                  color: Colors.grey,
                ),
            itemCount: catList.length,
            itemBuilder: (context, index) => ListTile(
                  title: Text(
                    "${catList[index]}",
                    style: TextStyle(fontSize: 24.0),
                  ),
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          // Control training page behavior
                          builder: (context) => catNum == 3
                              ? Scaffold(
                                  appBar: AppBar(
                                    title: Text('تدريب ${index + 1}'),
                                  ),
                                  body: QuestionsPage(
                                      examID: "pre_${catNum}_$index"),
                                )
                              : AdminSectionPage(
                                  sectionCategory: catNum,
                                  sectionIndex: index,
                                  sectionTitle: catList[index],
                                ),
                        ),
                      ),
                ),
          ),
        ),
      );
    }

    final List<Widget> _pages = <Widget>[
      _mySectionsCard(1, ["الحساب", "الجبر", "تحليل البيانات", "الهندسة"]),
      _mySectionsCard(2, [
        "التناظر اللفظي",
        "اكمال الجمل",
        "المفردة الشاذة",
        "استيعاب المقروء",
        "الخطأ السياقي"
      ]), 
      _mySectionsCard(3, [
        "تدريب 1",
        "تدريب 2",
        "تدريب 3",
        "تدريب 4",
        "تدريب 5",
        "تدريب 6",
        "تدريب 7",
        "تدريب 8",
        "تدريب 9",
        "تدريب 10"
      ]),
    ];

    return Scaffold(
      body: IconTheme(
        data: IconThemeData(color: _kArrowColor),
        child: Stack(
          children: <Widget>[
            PageView.builder(
//              physics: AlwaysScrollableScrollPhysics(),
              physics: BouncingScrollPhysics(),
              controller: _controller,
              itemCount: _pages.length,
              itemBuilder: (BuildContext context, int index) {
                return _pages[index];
              },
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: DotsIndicator(
                    controller: _controller,
                    itemCount: _pages.length,
                    onPageSelected: (int page) {
                      _controller.animateToPage(
                        page,
                        duration: _kDuration,
                        curve: _kCurve,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// An indicator showing the currently selected page of a PageController
class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.grey,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 8.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 2.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 25.0;

  Widget _buildDot(int index) {
    double selecteddot = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selecteddot;
    return Container(
      width: _kDotSpacing,
      child: Center(
        child: Material(
          color: color,
          type: MaterialType.circle,
          child: Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount, _buildDot),
    );
  }
}
