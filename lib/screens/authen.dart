import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import '../screens/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/my_service.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  // For Form
  final formKey = GlobalKey<FormState>();

  // Constant
  String titleHaveSpace = 'กรอกให้ครบ';
  String titleEmailFalse = 'กรอกรูปแบบอีเมลล์';
  String titlePasswordFalse = 'รหัสต้องมากกว่า 6 ตัว';

  // Explicit
  String emailString, passwordString;

  // For Firebase
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // For SnackBar
  final snackBarKey = GlobalKey<ScaffoldState>();

  //Initial Method
  @override
  void initState() {
    super.initState();
    print('initState Work');

    checkStatus(context);
  }

  Future checkStatus(BuildContext context) async {
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    if (firebaseUser != null) {
      goToService(context);
    }
  }

  void goToService(BuildContext context) {
    var serviceRout =
        MaterialPageRoute(builder: (BuildContext context) => MyService());
    Navigator.of(context)
        .pushAndRemoveUntil(serviceRout, (Route<dynamic> route) => false);
  }

  // About Widget Method
  Widget signUpButton(BuildContext context) {
    return RaisedButton.icon(
        icon: Icon(Icons.android),
        label: Text('Sign Up'),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        color: Colors.red,
        onPressed: () {
          print('You Click Sign Up');
          var registerRoute =
              MaterialPageRoute(builder: (BuildContext context) => Register());
          Navigator.of(context).push(registerRoute);
        });
  }

  Widget signInButton(BuildContext context) {
    return RaisedButton.icon(
      label: Text('Sign In'),
      icon: Icon(Icons.account_circle),
      color: Colors.green,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      onPressed: () {
        print('You Click SignIn');
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          print('email ===>>> $emailString, password ===>>> $passwordString');
          checkAuthen(context);
        }
      },
    );
  }

  void checkAuthen(BuildContext context) async {
    FirebaseUser firebaseUser = await firebaseAuth
        .signInWithEmailAndPassword(
            email: emailString, password: passwordString)
        .then((objValue) {
      print('Login Success ===>>> ${objValue.toString()}');
      // Route Without Arrow BAck
      var myServiceRoute =
          MaterialPageRoute(builder: (BuildContext context) => MyService());
      Navigator.of(context)
          .pushAndRemoveUntil(myServiceRoute, (Route<dynamic> route) => false);
    }).catchError((objValue) {
      String error = objValue.message;
      print('Errorr ===>>> $error');
      showSnackbar(error);
    });
  }

  void showSnackbar(String messageString) {
    SnackBar snackBar = new SnackBar(
      duration: Duration(seconds: 10),
      backgroundColor: Colors.red[900],
      content: Text(messageString),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
      ),
    );
    snackBarKey.currentState.showSnackBar(snackBar);
  }

  Widget passwordTextFormField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
          labelText: 'Password : ', hintText: 'More 6 Charactors'),
      validator: (String value) {
        if (value.length <= 5) {
          return titlePasswordFalse;
        }
      },
      onSaved: (String value) {
        passwordString = value;
      },
    );
  }

  Widget emailTextFormField() {
    return TextFormField(
      decoration:
          InputDecoration(labelText: 'Email : ', hintText: 'you@email.com'),
      validator: (String value) {
        if (value.length == 0) {
          return titleHaveSpace;
        } else if (!((value.contains('@')) && (value.contains('.')))) {
          return titleEmailFalse;
        }
      },
      onSaved: (String value) {
        emailString = value;
      },
    );
  }

  Widget showAppName() {
    return Text(
      'Palm Flutter',
      style: TextStyle(
          fontFamily: 'Schoolbell',
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          color: Colors.blue[900]),
    );
  }

  Widget showLogo() {
    return Image.asset('images/logo.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: snackBarKey,
        resizeToAvoidBottomPadding: false,
        body: Form(
          key: formKey,
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.blue[200], Colors.white],
                    begin: Alignment(-1, -1))),
            padding: EdgeInsets.only(top: 100.0),
            alignment: Alignment(0, -1),
            child: Column(
              children: <Widget>[
                Container(width: 200.0, height: 200.0, child: showLogo()),
                Container(
                    margin: EdgeInsets.only(top: 15.0), child: showAppName()),
                Container(
                    margin: EdgeInsets.only(left: 50.0, right: 50.0),
                    child: emailTextFormField()),
                Container(
                    margin: EdgeInsets.only(left: 50.0, right: 50.0),
                    child: passwordTextFormField()),
                Container(
                    margin: EdgeInsets.only(left: 50.0, right: 50.0),
                    child: Row(children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 4.0),
                          child: signInButton(context),
                        ),
                      ),
                      Expanded(child: signUpButton(context))
                    ]))
              ],
            ),
          ),
        ));
  }
}
