# Password Sign in Authentication
- Since Firebase supports Flutter, there are various dependencies (libraries) that help us to make the sign in process go smoothly. For our application, we use [firebase_auth 3.3.14](https://pub.dev/packages/firebase_auth). 

- In order to use any of the sign in authentication methods provided by Firebase, enabling the method in the [Firebase console](https://firebase.google.com/docs/auth/flutter/password-auth) is the initial step.

- After doing so, we just need to add the dependency to the [pubspec.yaml](/pubspec.yaml) file to use the firebase_auth library.

- Our password sign in process for a new user consists of three parts: registration, email validation, sign in with valid account.

## Registration
- In this steps, our application will take email and password as inputs of new user.

- User password must be strong enough to be eligible for a proper password: minimum length is 6, at least 2 uppercase letters, at least 3 characters, at least 1 special character. The user also need to confirm their password.

- Input in an already-used email will invoke the registration function to output to the UI to warning the user that they need to choose another email.

## Email validation
- After successfully follow the registration steps, new user will be created and a function will be invoked to send a verification email. Only new user account with their email verified are considered valid account and they can sign in to the app.

- The following code will demonstrate the process of sending verification email:
```dart
    // Create new user base on the information provided by the user
    var user = await AuthService.firebase().createUser(
        email: email,
        password: password,
        displayName: username,
    );
    // Send verification email
    AuthService.firebase().sendEmailVerification();
```
- The user will be prompted to check their email inbox to verify their email address.
![Verification Email](/documentation/verification_email.png)
## Sign in
- After users having their email verified, they can now continue to login to the application using their registered email and password.

- The email and password will be passed into a function to invoke the application to either continue or notify the user that they typed in the wrong password.

- The code below shows how user can login to the application
```dart
await AuthService.firebase().login(
    email: email,
    : password,
    );
// Take user information to create an AuthUser
final user =
    Provider.of<AuthUser?>(context, listen: false);

if (user?.isEmailVerified ?? false) {
    // user is verified
    // user login to the application
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MainView(),
            ),
            (route) => false,
        );
} else {
    // user is NOT verified
    // Navigate user to the verify email view
    Navigator.pushNamedAndRemoveUntil(
        context,
        verifyEmailRoute,
        (route) => false,
        arguments: user,
    );
}
```