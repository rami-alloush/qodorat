import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qodorattest/pages/guest/upgrade_benefits.dart';
import 'package:qodorattest/pages/chat_start_page.dart';
import 'package:qodorattest/pages/guest/terms_and_conditions_page.dart';

class GuestHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GuestHomePageState();
}

class GuestHomePageState extends State<GuestHomePage>
    with TickerProviderStateMixin {
  List<AppPage> _items;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _items = [
      new AppPage(
          icon: new Icon(Icons.stars),
          title: 'مزايا الإشتراك',
          color: Colors.lightGreen,
          body: UpgradeBenefitsPage(),
          vsync: this),
      new AppPage(
          icon: new Icon(Icons.import_contacts),
          title: 'الشروط والأحكام',
          color: Colors.lightGreen,
          body: TAndRPage(),
          vsync: this),
      new AppPage(
        icon: new Icon(Icons.chat),
        title: 'المحادثة',
        color: Colors.lightGreen,
        body: StartChatPage(),
        vsync: this,
      ),
      new AppPage(
        icon: new Icon(Icons.info_outline),
        title: 'معلومات',
        color: Colors.lightGreen,
        body: Center(
            child: RaisedButton(
                child: Text('تسجيل الخروج'),
                onPressed: FirebaseAuth.instance.signOut)),
        vsync: this,
      ),
    ];

    for (AppPage view in _items) view.controller.addListener(this._rebuild);

    _items[_currentIndex].controller.value = 1.0;
  }

  void _rebuild() {
    setState(() {});
  }

  @override
  void dispose() {
    for (AppPage page in _items) {
      page.controller.dispose();
    }

    super.dispose();
  }

  Widget _buildPageStack() {
    final List<Widget> transitions = <Widget>[];

    for (int i = 0; i < _items.length; i++) {
      transitions.add(IgnorePointer(
          ignoring: _currentIndex != i,
          child: _items[i].buildTransition(context)));
    }
    return new Stack(children: transitions);
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar navBar = new BottomNavigationBar(
      items: _items.map((page) {
        return page.item;
      }).toList(),
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.shifting,
      onTap: (int) {
        setState(() {
          _items[_currentIndex].controller.reverse();
          _currentIndex = int;
          _items[_currentIndex].controller.forward();
        });
      },
    );

    return new Scaffold(
//      appBar: AppBar(
//        title: Text("لوحة الضيف"),
//        backgroundColor: _mainColor,
//      ),
      body: new Center(
        child: _buildPageStack(),
      ),
      bottomNavigationBar: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Material(child: navBar),
        ],
      ),
    );
  }
}

class AppPage {
  final Widget _icon; // ignore: unused_field
  final String _title; // ignore: unused_field
  final Color _color; // ignore: unused_field
  final AnimationController controller;
  final BottomNavigationBarItem item;
  final Widget body;
  CurvedAnimation _animation;

  AppPage(
      {Widget icon, String title, Color color, this.body, TickerProvider vsync})
      : this._icon = icon,
        this._title = title,
        this._color = color,
        this.controller = new AnimationController(
            vsync: vsync, duration: Duration(milliseconds: 300)),
        this.item = new BottomNavigationBarItem(
          icon: icon,
          title: new Text(title),
          backgroundColor: color,
        ) {
    _animation =
        new CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
  }

  FadeTransition buildTransition(BuildContext context) {
    return new FadeTransition(
      opacity: _animation,
      child: body,
    );
  }
}
