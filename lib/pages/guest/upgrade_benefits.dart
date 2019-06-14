import 'package:flutter/material.dart';

class UpgradeBenefitsPage extends StatefulWidget {
  @override
  _UpgradeBenefitsPageState createState() => _UpgradeBenefitsPageState();
}

class _UpgradeBenefitsPageState extends State<UpgradeBenefitsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("مزايا الإشتراك في البرنامج"),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Text("1."),
              title: Text(
                  "عرض جميع الدروس والشروحات فيما يخص اختبار القدرات العامة."),
            ),
            ListTile(
              leading: Text("2."),
              title: Text("تأسيس وطرق سهلة ومميزة للحل."),
            ),
            ListTile(
              leading: Text("3."),
              title: Text(
                  "يمكنك التواصل والاستفسار مع المدربة في أي وقت من خلال التطبيق"),
            ),
            ListTile(
              leading: Text("4."),
              title: Text(
                  "البرنامج متكامل حيث سيغنيك عن شراء الكتب، الملازم، البحث عن التجميعات، إلخ .."),
            ),
            ListTile(
              leading: Text("5."),
              title: Text("مدة الاشتراك مفتوحة وغير محدودة."),
            ),
            ListTile(
              leading: Text("6."),
              title: Text(
                  "يوجد اختبار تقييم مستوى قبل الدروس واختبار نهائي لرؤية النتائج بعد الدروس."),
            ),
            ListTile(
              leading: Text("7."),
              title: Text(
                  "يوجد قسم للتدريبات مدرجة فيه جميع التجميعات والاسئلة المتوقعة للاختبار."),
            ),
          ],
        ),
      ),
    );
  }
}
