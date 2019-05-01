import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Explicit
  final formKey = GlobalKey<FormState>();
  String nameString, emailString, passwordString;

  // For Firebase
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  // For Snackbar
  final snackBarKey = GlobalKey<ScaffoldState>();

  Widget passwordTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(60.0),
            borderSide: BorderSide(width: 2.0, color: Colors.red),
          ),
          labelText: 'Password : ',
          hintText: 'Your Password',
          icon: Icon(
            Icons.keyboard,
            color: Colors.blue,
          )),
      validator: (String value) {
        if (value.length <= 5) {
          return "Please Type Password more 6 Charactors";
        }
      },
      onSaved: (String value) {
        passwordString = value;
      },
    );
  }

  Widget emailTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(60.0),
              borderSide: BorderSide(width: 1.0, color: Colors.grey)),
          labelText: 'Email : ',
          hintText: 'you@email.com',
          icon: Icon(
            Icons.android,
            color: Colors.green,
          )),
      validator: (String value) {
        if (value.length == 0) {
          return 'Please Enter an Email';
        } else if (!((value.contains('@')) && (value.contains('.')))) {
          return 'Please Fill an Email Format';
        }
      },
      onSaved: (String value) {
        emailString = value;
      },
    );
  }

  Widget nameTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(width: 3.0, color: Colors.green)),
          labelText: 'Name',
          hintText: 'Type Your Name',
          icon: Icon(
            Icons.face,
            color: Colors.red,
          )),
      validator: (String value) {
        if (value.length == 0) {
          return 'Please Fill Name in the Blank';
        }
      },
      onSaved: (String value) {
        nameString = value;
      },
    );
  }

  Widget uploadButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      tooltip: 'Upload To Firebase',
      onPressed: () {
        print('You Click Upload');
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          print(
              'name = $nameString, email = $emailString, password = $passwordString');
          uploadValueToFirebase(context);
        }
      },
    );
  }

  void uploadValueToFirebase(BuildContext context) async {
    FirebaseUser firebaseUser = await firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailString, password: passwordString)
        .then((user) {
      print('Register Success With ===>>> $user');

      addValueToDatabaseFire(context);

      //Navigator.pop(context);
    }).catchError((error) {
      String errorString = error.message;
      print('HAVE ERROR ===>>> $errorString');
      showSnackBar(errorString);
    });
  }

  void addValueToDatabaseFire(BuildContext context) async{
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    String uidString = firebaseUser.uid.toString();
    print('uidString ===>>> $uidString');

    // Create Map Type
    Map<String, String> map = Map();
    map['name'] = nameString;
    map['Nation'] = 'Thai';

    // Update Date to Firebase
    await firebaseDatabase.reference().child(uidString).set(map);
    
    Navigator.pop(context);
  }


  void showSnackBar(String messageString) {
    SnackBar snackBar = SnackBar(
      duration: Duration(seconds: 10),
      backgroundColor: Colors.red[900],
      content: Text(messageString),
      action: SnackBarAction(
        label: 'Close',
        onPressed: (){},
      ),
    );
    snackBarKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: snackBarKey,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.orange[900],
          title: Text('Register'),
          actions: <Widget>[uploadButton(context)],
        ),
        body: Form(
          key: formKey,
          child: Container(
            decoration: BoxDecoration(
                gradient: RadialGradient(
                    colors: [Colors.white, Colors.blue],
                    radius: 2.0,
                    center: Alignment(0, 0))),
            padding: EdgeInsets.all(50.0),
            child: Column(
              children: <Widget>[
                nameTextFormField(),
                Container(
                  margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: emailTextFormField(),
                ),
                passwordTextFormField()
              ],
            ),
          ),
        ));
  }
}
