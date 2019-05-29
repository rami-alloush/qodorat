import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:qodorat/pages/intro_page.dart';

class LoginSignUpPage extends StatefulWidget {
  final auth = FirebaseAuth.instance;

  @override
  State<StatefulWidget> createState() => new _LoginSignUpPageState();
}

enum FormMode { LOGIN, SIGNUP }

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  // Initial form is login form
  FormMode _formMode = FormMode.LOGIN;
  bool _isIos;
  bool _isLoading;

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    new Timer(new Duration(milliseconds: 100), () {
      checkFirstSeen();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('اختبر قدراتك'),
        ),
        body: Builder(
            // Create an inner BuildContext so that the onPressed methods
            // can refer to the Scaffold with Scaffold.of().
            builder: (BuildContext context) {
          return Stack(
            children: <Widget>[
              _showBody(context),
              _showCircularProgress(),
            ],
          );
        }));
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
//    print("Seen? " + '$_seen');

    if (!_seen) {
      // Never saw intro
      prefs.setBool('seen', true);
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => IntroScreen()));
    }
  }

  Widget _showBody(BuildContext context) {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showLogo(),
              _showEmailInput(),
              _showPasswordInput(),
              _showErrorMessage(),
              _showPrimaryButton(),
              _showSecondaryButton(),
              RaisedButton(
                child: Text('دخول عشوائي (اختبار)'),
                onPressed: _signInAnonymously,
              )
            ],
          ),
        ));
  }

  void _signInAnonymously() {
    FirebaseAuth.instance.signInAnonymously();
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'logo',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 96.0,
        child: Image.asset('assets/logo.png'),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        focusNode: _emailFocus,
        autofocus: false,
        onFieldSubmitted: (term) =>
            FocusScope.of(context).requestFocus(_passFocus),
        decoration: InputDecoration(
            hintText: 'البريد الإلكتروني',
            icon: Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) =>
            value.isEmpty ? 'برجاء ادخال عنوان البريد الإلكتروني' : null,
        onSaved: (value) => _email = value,
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        focusNode: _passFocus,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'كلمة المرور',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'برجاء ادخال كلمة المرور' : null,
        onSaved: (value) => _password = value,
      ),
    );
  }

  Widget _showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.brown,
            child: _formMode == FormMode.LOGIN
                ? new Text('تسجيل الدخول',
                    style: new TextStyle(fontSize: 20.0, color: Colors.white))
                : new Text('إنشاء حساب',
                    style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: _validateAndSubmit,
          ),
        ));
  }

  Widget _showSecondaryButton() {
    return new FlatButton(
      child: _formMode == FormMode.LOGIN
          ? new Text('إنشاء حساب جديد',
              style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300))
          : new Text('لديك حساب؟ سجل الدخول',
              style:
                  new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
      onPressed: _formMode == FormMode.LOGIN
          ? _changeFormToSignUp
          : _changeFormToLogin,
    );
  }

  // Perform login or signup
  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
    });
    if (_validateAndSave()) {
      setState(() {
        _isLoading = true;
      });
      String userId = "";
      try {
        if (_formMode == FormMode.LOGIN) {
          FirebaseUser user = await widget.auth
              .signInWithEmailAndPassword(email: _email, password: _password);
          userId = user.uid;
          print('Signed in: $userId');
        } else {
          FirebaseUser user = await widget.auth.createUserWithEmailAndPassword(
              email: _email, password: _password);
          userId = user.uid;
          print('Signed up user: $userId');
          // Will be redirected from StartPage()
          user.sendEmailVerification();
          _showVerifyEmailSentDialog();
          setState(() {
            _isLoading = false;
          });
        }

        // Callback (not used)
        if (userId.length > 0 &&
            userId != null &&
            _formMode == FormMode.LOGIN) {
          print("Debug: " + "widget.onSignedIn()");
        }
      } catch (e) {
        print('Auth Error: $e');
        setState(() {
          _isLoading = false;
          if (_isIos) {
            _errorMessage = e.details;
          } else
            _errorMessage = e.message;
          switch (e.code) {
            case "ERROR_INVALID_EMAIL":
              _errorMessage = "البريد الإلكتروني غير صحيح";
              break;
            case "ERROR_USER_NOT_FOUND":
              _errorMessage = "لا يوجد مستخدم مسجل بهذا الحساب";
              break;
            case "ERROR_WEAK_PASSWORD":
              _errorMessage = "كلمة المرور ضعيفة. يجب ألا تقل عن 6 أحرف";
              break;
            case "ERROR_USER_DISABLED":
              _errorMessage = "تم إيقاف هذا الحساب. برجاء التواصل مع الإدارة";
              break;
          }
        });
      }
    }
  }

  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("تأكيد البريد الإلكتروني"),
          content: new Text(
              "تم إرسال رابط تأكيد البريد الإلكتروني. برجاء تأكيد البريد الإلكتروني حتى تتمكن من استخدام البرنامج."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("موافق"),
              onPressed: () {
                _changeFormToLogin();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _errorMessage,
            style: TextStyle(
                fontSize: 14.0,
                color: Colors.red,
                height: 1.0,
                fontWeight: FontWeight.w600),
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(8.0),
      );
    }
  }
}
