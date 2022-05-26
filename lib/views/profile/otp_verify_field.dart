import 'dart:developer' as devtools show log;

import 'package:etoet/constants/routes.dart';
import 'package:etoet/services/auth/auth_provider.dart';
import 'package:etoet/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/auth/auth_user.dart';
import '../../services/database/firestore.dart';

class OTPVerifyView extends StatefulWidget {
  final AuthUser authUser;

  const OTPVerifyView({
    Key? key,
    required this.authUser,
  }) : super(key: key);

  @override
  State<OTPVerifyView> createState() => _OTPVerifyViewState();
}

class _OTPVerifyViewState extends State<OTPVerifyView> {
  late TextEditingController _controller1;
  late TextEditingController _controller2;
  late TextEditingController _controller3;
  late TextEditingController _controller4;
  late TextEditingController _controller5;
  late TextEditingController _controller6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Phone Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            const Text(
              'Verification',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Enter your OTP code number',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black38,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 28,
            ),
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _textFieldOTP(
                          first: true, last: false, controller: _controller1),
                      _textFieldOTP(
                          first: false, last: false, controller: _controller2),
                      _textFieldOTP(
                          first: false, last: false, controller: _controller3),
                      _textFieldOTP(
                          first: false, last: false, controller: _controller4),
                      _textFieldOTP(
                          first: false, last: false, controller: _controller5),
                      _textFieldOTP(
                          first: false, last: true, controller: _controller6),
                    ],
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final smsCode =
                            '${_controller1.text}${_controller2.text}${_controller3.text}${_controller4.text}${_controller5.text}${_controller6.text}';
                        await verifyPhoneNumber(smsCode);
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.purple),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(14.0),
                        child: Text(
                          'Verify',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            const Text(
              "Didn't you receive any code?",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black38,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 18,
            ),
            const Text(
              'Resend New Code',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _textFieldOTP({
    required bool first,
    required bool last,
    required TextEditingController controller,
  }) {
    return SizedBox(
      height: 65,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.isEmpty && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.purple),
                borderRadius: BorderRadius.circular(12)),
          ),
          controller: controller,
        ),
      ),
    );
  }

  Future<void> verifyPhoneNumber(String smsCode) async {
    devtools.log('smsCode: $smsCode');
    await AuthService.firebase().verifyPhoneNumber(
        phoneNumber: '+84' + widget.authUser.phoneNumber!,
        verificationCompleted: (credential) async {
          await Firestore.updateUserInfo(
            widget.authUser,
          );
          Navigator.of(context).pushNamed(profileRoute);
        },
        verificationFailed: (exception) {
          if (exception.code == 'invalid-phone-number') {
            devtools.log('The provided phone number is not valid.');
          } else if (exception.code == 'invalid-verification-code') {
            devtools.log('The verification code entered was invalid');
          }
        },
        codeSent: (verificationId, resendToken) async {
          devtools.log('codeSent: $verificationId, $resendToken');
          var credential = PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: smsCode);
          var userCred = FirebaseAuth.instance.signInWithCredential(credential);
          userCred.then((value) async {
            await Firestore.updateUserInfo(
              widget.authUser,
            );
            Navigator.of(context).pushNamed(profileRoute);
          });
        },
        codeAutoRetrievalTimeout: (verificationId) {
          devtools.log('codeAutoRetrievalTimeout: $verificationId');
        });
  }

  @override
  void initState() {
    super.initState();
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
    _controller3 = TextEditingController();
    _controller4 = TextEditingController();
    _controller5 = TextEditingController();
    _controller6 = TextEditingController();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    _controller6.dispose();
    super.dispose();
  }
}
