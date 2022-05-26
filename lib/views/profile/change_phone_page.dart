// ignore_for_file: prefer_const_constructors
import 'dart:developer' as devtools show log;

import 'package:etoet/services/auth/auth_user.dart';
import 'package:etoet/views/profile/otp_verify_field.dart';
import 'package:etoet/views/profile/verification_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePhoneNumberPage extends VerificationView {
  const ChangePhoneNumberPage({
    Key? key,
    required String title,
    required AuthUser user,
  }) : super(
          key: key,
          title: title,
          user: user,
        );

  @override
  _ChangePhoneNumberPageState createState() => _ChangePhoneNumberPageState();
}

class _ChangePhoneNumberPageState extends State<ChangePhoneNumberPage> {
  late TextEditingController _phoneNumber;
  @override
  Widget build(BuildContext context) {
    // throw UnimplementedError();
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
        child: Column(
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.number,
              style: TextStyle(),
              decoration: InputDecoration(
                hintText: 'Enter your phone number',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10)),
                prefix: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('+84'),
                ),
              ),
              controller: _phoneNumber,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  var newAuthUser = AuthUser(
                    isEmailVerified: widget.user.isEmailVerified,
                    uid: widget.user.uid,
                    email: widget.user.email,
                    phoneNumber: _phoneNumber.text,
                    displayName: widget.user.displayName,
                    photoURL: widget.user.photoURL,
                  );
                  devtools.log('newAuthUser: ${newAuthUser.toString()}');
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OTPVerifyView(
                        authUser: newAuthUser,
                      ),
                    ),
                  );
                },
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(14),
                  child: Text('Send'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneNumber.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _phoneNumber = TextEditingController();
    super.initState();
  }
}
