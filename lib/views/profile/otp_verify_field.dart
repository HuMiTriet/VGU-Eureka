/* import 'dart:developer' as devtools show log;

import 'package:etoet/constants/routes.dart';
import 'package:etoet/services/auth/auth_service.dart';
import 'package:etoet/services/auth/auth_user.dart';
import 'package:etoet/services/database/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OTPVerifyView extends StatefulWidget {
  const OTPVerifyView({Key? key, required this.authUser}) : super(key: key);

  final AuthUser authUser;
  @override
  State<OTPVerifyView> createState() => _OTPVerifyViewState();
}

class _OTPVerifyViewState extends State<OTPVerifyView> {
  late TextEditingController OTP_controller_1;
  late TextEditingController OTP_controller_2;
  late TextEditingController OTP_controller_3;
  late TextEditingController OTP_controller_4;
  late TextEditingController OTP_controller_5;
  late TextEditingController OTP_controller_6;

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
                          first: true,
                          last: false,
                          controller: OTP_controller_1),
                      _textFieldOTP(
                          first: false,
                          last: false,
                          controller: OTP_controller_2),
                      _textFieldOTP(
                          first: false,
                          last: false,
                          controller: OTP_controller_3),
                      _textFieldOTP(
                          first: false,
                          last: false,
                          controller: OTP_controller_4),
                      _textFieldOTP(
                          first: false,
                          last: false,
                          controller: OTP_controller_5),
                      _textFieldOTP(
                          first: false,
                          last: true,
                          controller: OTP_controller_6),
                    ],
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
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

  Widget _textFieldOTP(
      {required bool first,
      required bool last,
      required TextEditingController controller}) {
    return SizedBox(
      height: 65,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          controller: controller,
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
        ),
      ),
    );
  }

  Future<void> verifyPhoneNumber(String smsCode) async {
    devtools.log('smsCode: $smsCode');
    await AuthService.firebase().verifyPhoneNumber(
        phoneNumber: widget.authUser.phoneNumber!,
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
          try {
            var userCred = AuthService.firebase()
                .signInWithCredential(credential: credential);
            userCred.then((value) async {
              await Firestore.updateUserInfo(
                widget.authUser,
              );
              Navigator.of(context).pushNamed(profileRoute);
            });
          } on FirebaseAuthException catch (e) {
            if (e.code == 'account-exists-with-different-credential') {
              devtools.log('account-exists-with-different-credential');
            } else if (e.code == 'invalid-verification-code') {
              devtools.log('invalid-verification-code');
            } else if (e.code == 'invalid-verification-id') {
              devtools.log('invalid-verification-id');
            } else if (e.code == 'missing-verification-code') {
              devtools.log('missing-verification-code');
            } else if (e.code == 'missing-verification-id') {
              devtools.log('missing-verification-id');
            } else if (e.code == 'network-request-failed') {
              devtools.log('network-request-failed');
            }
          }
        },
        codeAutoRetrievalTimeout: (verificationId) {
          devtools.log('codeAutoRetrievalTimeout: $verificationId');
        });
  }

  @override
  void initState() {
    super.initState();
    OTP_controller_1 = TextEditingController();
    OTP_controller_2 = TextEditingController();
    OTP_controller_3 = TextEditingController();
    OTP_controller_4 = TextEditingController();
    OTP_controller_5 = TextEditingController();
    OTP_controller_6 = TextEditingController();
  }

  @override
  void dispose() {
    OTP_controller_1.dispose();
    OTP_controller_2.dispose();
    OTP_controller_3.dispose();
    OTP_controller_4.dispose();
    OTP_controller_5.dispose();
    OTP_controller_6.dispose();
    super.dispose();
  }
}
 */