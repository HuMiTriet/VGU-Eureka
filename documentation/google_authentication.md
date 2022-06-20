# Google Sign In Authentication
- Aside from traditional password sign in, our application also let users authenticate with Firebase using their Google Accounts.

- For our project, we use [google_sign_in 5.3.1](https://pub.dev/packages/google_sign_in) for our Google Sign In process.

## Configuration
- For Android applications, to use Google Sign in, you need to specify your application's SHA-1 fingerprint inside both your project and the Firebase console. Google Play Services like Google Sign In require you to provide the SHA-1 of your signing certificate so they can create an OAuth2 client and API key for your application.

### SHA-1 fingerprint
- Details of [how to generate SHA-1 key](https://developers.google.com/android/guides/client-auth)
- Since the project is short-term and for education-purpose only, we have no other option than placing the [generated SHA-1 key](/android/app/debug-keystore.jks) inside of the project, so that anyone that has permission to clone the project can have this key.
- We also need to place the SHA-1 fingerprint in the signin method in the Firebase console [settings page](https://console.firebase.google.com/u/0/project/_/settings/general).
- When the signing function is invoked, the app will take the key from your project compare with the key in the Firebase console. If both are similar, the Google Sign In UI will be invoked.
- The code below shows how the project can get the SHA-1 key specified in [build.gradle](/android/app/build.gradle) file:
```gradle
signingConfigs {
        debug{
            storeFile file("debug-keystore.jks")
            storePassword 'android'
            keyAlias 'androiddebugkey'
            keyPassword 'android'
        }
    }
```
### Enable Google as a Sign In method
- In the [Firebase console](https://console.firebase.google.com), open the Auth section.
- On the Sign in method tab, enable the Google sign-in method and click Save.

## Sign in with Google account
- After having done all the configuration, you can now use the Google as a sign-in method.
- The following code will demonstrate the process:
```dart
// Trigger the authentication flow
    _googleUser = await GoogleSignIn(
      clientId:
        // client id of the application
          '344264346912-1qh85k7a5tpslbfk37p0ojs3hfik6t10.apps.googleusercontent.com',
        // scopes are the permissions that Google ask the user if they allows the application to share it
      scopes: <String>[
        'email',
      ],
    ).signIn();

    // Obtain the auth details from the request
    // It contains access token and id token for retrieving credential for the application to use for signing in user to Firebase
    _googleAuth = await _googleUser?.authentication;

    // Create a new credential using access token and id token
    final credential = GoogleAuthProvider.credential(
      accessToken: _googleAuth?.accessToken,
      idToken: _googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    // This UserCredential is used to obtain user information to create new user in Firestore
    final user = (await FirebaseAuth.instance.signInWithCredential(credential))
        .user as User;
    // New AuthUser created
    final authUser = AuthUser(
        isEmailVerified: user.emailVerified,
        uid: user.uid,
        email: user.email,
        phoneNumber: user.phoneNumber,
        displayName: user.displayName);
    // Check if this user exists
    var userExists = Firestore.userExists(authUser.uid);
    userExists.then((value) => {
          if (value)
          // Update their info such as name, email, etc...
            {Firestore.updateUserInfo(authUser)}
          else
          // Add them to Firestore if they are new user
            {Firestore.addUserInfo(authUser)}
        });
    // Navigating to the main screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => MainView(),
      ),
      (route) => false,
    );
```