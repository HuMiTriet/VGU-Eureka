import 'dart:developer' as devtools show log;

import 'package:etoet/services/auth/auth_service.dart';
import 'package:etoet/views/profile/verification_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

import '../../services/auth/auth_user.dart';

class ChangePassPage extends VerificationView {
  const ChangePassPage({
    Key? key,
    required String title,
    required AuthUser user,
  }) : super(
          key: key,
          title: title,
          user: user,
        );

  @override
  _ChangePassPageState createState() => _ChangePassPageState();
}

class _ChangePassPageState extends State<ChangePassPage> {
  bool currentPasswordIsValid = true;

  bool inlandScapeMode(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  double getWidgetWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  double getWidgetHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  double getSpaceRatioToWidgetHeight(BuildContext context,
          {double ratio = 0.03}) =>
      getWidgetHeight(context) * ratio;

  late final TextEditingController _currentPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _comfirmNewPasswordController;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            /// for the appbar
            Container(
              height: 50,
              color: const Color.fromARGB(255, 247, 224, 120),
              child: Row(
                children: <Widget>[
                  TextButton(
                      child: const Icon(Icons.close, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Text(
                    widget.title,
                    style: const TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 25),
                    child: Column(
                      children: <Widget>[
                        // text field for input password
                        TextFormField(
                          obscureText: true,
                          autocorrect: false,
                          enableSuggestions: false,
                          controller: _currentPasswordController,
                          decoration: InputDecoration(
                            label: const Text('Current Password'),
                            errorText:
                                currentPasswordIsValid ? null : 'Invalid',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your new password';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: getSpaceRatioToWidgetHeight(context)),
                        // text field for input new password
                        TextFormField(
                          obscureText: true,
                          autocorrect: false,
                          enableSuggestions: false,
                          controller: _newPasswordController,
                          decoration: const InputDecoration(
                            label: Text('New Password'),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your new password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: getSpaceRatioToWidgetHeight(context),
                        ),

                        FlutterPwValidator(
                          controller: _newPasswordController,
                          minLength: 6,
                          uppercaseCharCount: 2,
                          numericCharCount: 3,
                          specialCharCount: 1,
                          width: getWidgetWidth(context),
                          height: getWidgetHeight(context) * 0.15,
                          // if in langscape mode should be getWidgetWidth(context) * 0.6
                          // but i dont know how to dynamically assigned it yet
                          onSuccess: () {},
                        ),

                        SizedBox(height: getSpaceRatioToWidgetHeight(context)),

                        // text field for input comfirm password
                        TextFormField(
                          obscureText: true,
                          autocorrect: false,
                          enableSuggestions: false,
                          controller: _comfirmNewPasswordController,
                          decoration: const InputDecoration(
                            label: Text('Confirm New Password'),
                          ),
                          validator: (value) {
                            return _comfirmNewPasswordController.text ==
                                    _newPasswordController.text
                                ? null
                                : 'Passwords do not match';
                          },
                        ),

                        SizedBox(
                          height: getSpaceRatioToWidgetHeight(context),
                        ),

                        OutlinedButton(
                          child: const Text('Save'),
                          style: TextButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 247, 224, 120)),
                          onPressed: () async {
                            currentPasswordIsValid =
                                await AuthService.firebase()
                                    .validateEnteredPassword(
                                        _currentPasswordController.text);

                            setState(() {});

                            if (_formKey.currentState!.validate()) {}
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _comfirmNewPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _comfirmNewPasswordController.dispose();
  }
}
