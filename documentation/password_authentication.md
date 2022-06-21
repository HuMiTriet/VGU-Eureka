# Password Sign in Authentication
- Since Firebase supports Flutter, there are various dependencies (libraries) that help us to make the sign in process go smoothly. For our application, we use [firebase_auth 3.3.14](https://pub.dev/packages/firebase_auth). 

- In order to use any of the sign in authentication methods provided by Firebase, enabling the method in the [Firebase console](https://firebase.google.com/docs/auth/flutter/password-auth) is the initial step.

- After doing so, we just need to add the dependency to the [pubspec.yaml](/pubspec.yaml) file to use the firebase_auth library.

- Our password login process for new users consists of three parts: registration, email verification, login with a valid account.

## Registration
- In this step, our application will take the new user's email and password as input.

- User password must be strong enough to qualify as an appropriate password: minimum length 6, at least 2 uppercase letters, at least 3 characters, at least 1 special character. Users also need to confirm their password.

![Registration](/documentation/Collections/registration.png)

- Input in an already used email will invoke the registration function that outputs the UI to warn the user that they need to choose another email.

![Invalid Email](/documentation/Collections/invalid_email.png)

## Email validation
- After successfully performing the registration steps, a new user will be created and a function will be called to send a verification email. Only user accounts that have their email verified are considered valid accounts and they can log in to the app

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
- Once the user is email verified, they can now continue to log in to the app with their registered email and password.

- The email and password will be passed into a function that invokes the application to continue or notifies the user that they have entered the wrong password.

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