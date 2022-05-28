// ignore_for_file: prefer_const_constructors
import 'dart:developer' as devtools show log;

import 'package:etoet/constants/routes.dart';
import 'package:etoet/services/auth/auth_service.dart';
import 'package:etoet/services/auth/auth_user.dart';
import 'package:etoet/services/database/firestore.dart';
import 'package:etoet/views/profile/verification_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class ChangePhoneNumberPage extends VerificationView {
  final String title;
  final AuthUser user;

  const ChangePhoneNumberPage({
    Key? key,
    required this.title,
    required this.user,
  }) : super(
          key: key,
          title: title,
          user: user,
        );

  @override
  _ChangePhoneNumberPageState createState() => _ChangePhoneNumberPageState();
}

class _ChangePhoneNumberPageState extends State<ChangePhoneNumberPage> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  late TextEditingController _phoneNumber;
  late TextEditingController OTP_controller_1;
  late TextEditingController OTP_controller_2;
  late TextEditingController OTP_controller_3;
  late TextEditingController OTP_controller_4;
  late TextEditingController OTP_controller_5;
  late TextEditingController OTP_controller_6;

  bool showLoading = false;
  late String verificationId;

  @override
  Widget build(BuildContext context) {
    return showLoading
        ? Scaffold(
            body: SafeArea(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
            ? getMobileFormWidget(context)
            : getOtpFormWidget(context);
  }

  // ignore: type_annotate_public_apis
  Widget getMobileFormWidget(context) {
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
                  setState(() {
                    showLoading = true;
                  });
                  await AuthService.firebase().verifyPhoneNumber(
                      phoneNumber: '+84' + _phoneNumber.text,
                      verificationCompleted: (phoneAuthCredential) async {
                        setState(() {
                          showLoading = false;
                        });
                      },
                      verificationFailed: (verificationFailed) async {
                        setState(() {
                          showLoading = false;
                        });
                        devtools.log('${verificationFailed.message}');
                      },
                      codeSent: (verificationId, resendToken) async {
                        setState(() {
                          showLoading = false;
                          currentState =
                              MobileVerificationState.SHOW_OTP_FORM_STATE;
                          this.verificationId = verificationId;
                        });
                      },
                      codeAutoRetrievalTimeout: (verificationId) async {});
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

  // ignore: type_annotate_public_apis
  Widget getOtpFormWidget(context) {
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
              padding: const EdgeInsets.all(5),
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
                      onPressed: () async {
                        final otpCode =
                            '${OTP_controller_1.text}${OTP_controller_2.text}${OTP_controller_3.text}${OTP_controller_4.text}${OTP_controller_5.text}${OTP_controller_6.text}';
                        var phoneCred = PhoneAuthProvider.credential(
                            verificationId: verificationId, smsCode: otpCode);
                        try {
                          final userCred = await FirebaseAuth
                              .instance.currentUser
                              ?.linkWithCredential(phoneCred);
                          if (userCred != null) {
                            var newAuthUser = AuthUser(
                              isEmailVerified: widget.user.isEmailVerified,
                              uid: widget.user.uid,
                              email: widget.user.email,
                              phoneNumber: _phoneNumber.text,
                              displayName: widget.user.displayName,
                              photoURL: widget.user.photoURL,
                            );
                            var userExists =
                                Firestore.userExists(newAuthUser.uid);
                            userExists.then((value) => {
                                  if (value)
                                    {
                                      devtools.log('User exists'),
                                      Firestore.updateUserInfo(newAuthUser)
                                    }
                                  else
                                    {
                                      devtools.log('New user'),
                                      Firestore.addUserInfo(newAuthUser)
                                    }
                                });
                          } else {
                            devtools.log(
                                'There might be a problem with phone authentication. Navigating to profile page');
                            Navigator.of(context).pushNamed(profileRoute);
                          }
                          Navigator.of(context).pushNamed(profileRoute);
                        } on FirebaseAuthException catch (e) {
                          devtools.log('${e.message}');
                        }
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

  Widget _textFieldOTP(
      {required bool first,
      required bool last,
      required TextEditingController controller}) {
    // ignore: sized_box_for_whitespace
    return Container(
      height: 50,
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

  @override
  void dispose() {
    _phoneNumber.dispose();
    OTP_controller_1.dispose();
    OTP_controller_2.dispose();
    OTP_controller_3.dispose();
    OTP_controller_4.dispose();
    OTP_controller_5.dispose();
    OTP_controller_6.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _phoneNumber = TextEditingController();
    OTP_controller_1 = TextEditingController();
    OTP_controller_2 = TextEditingController();
    OTP_controller_3 = TextEditingController();
    OTP_controller_4 = TextEditingController();
    OTP_controller_5 = TextEditingController();
    OTP_controller_6 = TextEditingController();
    super.initState();
  }
}
