import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class TAndRPage extends StatefulWidget {
  @override
  _TAndRPageState createState() => _TAndRPageState();
}

class _TAndRPageState extends State<TAndRPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الشروط والأحكام"),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Text("1."),
              title: Text(
                  "قيمة الاشتراك ٣٠٠ ريال سعودي يتم تحويلها بعد التحدث مع المدربة وأخذ تفاصيل الحساب البنكي."),
            ),
            ListTile(
              leading: Text("2."),
              title: Text(
                  "في حالة الدفع يتم استخدام الحساب مرة واحدة من قبل جهاز واحد فقط."),
            ),
            ListTile(
              leading: Text("3."),
              title: Text(
                  "عليك ان تتعهد ان لا تتداول اي فيديو او صور تخص التطبيق بأي شكل من الأشكال."),
            ),
            ListTile(
              title: Text("جميع حقوق النشر محفوظة لدى (رؤيا علاء بابور)"),
            ),
            ListTile(
              title: Text(
                "تم تنفيذ التطبيق عن طريق هابي كود www.happyc0de0.com",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.blue,
                ),
              ),
              onTap: () => launch('http://www.happyc0de0.com'),
            ),
            ListTile(
              title: Text(
                "برمجة وتطوير (م. رامي علوش)",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.blue,
                ),
              ),
              onTap: () {
                launch('mailto:IT@RMAsoft.NET');
              },
            ),
          ],
        ),
      ),
    );
  }
}
