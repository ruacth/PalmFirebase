import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
            )));
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
    );
  }

  Widget uploadButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      tooltip: 'Upload To Firebase',
      onPressed: () {
        print('You Click Upload');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
        title: Text('Register'),
        actions: <Widget>[uploadButton()],
      ),
      body: Container(
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
    );
  }
}
