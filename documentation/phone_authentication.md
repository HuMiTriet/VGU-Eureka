# Phone Number Authentication
- One more step to use Etoet is to add a phone number, so that if someone wants to help, they can contact that person or call directly by phone.

- When logging into the app for the first time, the account may not have a phone number at first, but they can navigate to the login page and add their phone number.

- Fortunately, Firebase also has phone number verification that can send OTP via SMS. The user can then verify their phone number through this process.

- Flutter also has libraries that can enable Firebase phone authentication. For our application we use[firebase_auth 3.3.14](https://pub.dev/packages/firebase_auth) for phone number verification.
## Configuration
- First and foremost, enable Phone as a Sign-in method in the [Firebase console](https://console.firebase.google.com/u/0/project/_/authentication/providers).
![Enable Phone Firebase](/documentation/Collections/enable_phone_auth.png)

- For Android, it is crucial to set application SHA-1 fingerprint in `Firebase console`. We have instructions in [Google Sign In Authentication](/documentation/google_authentication.md).

## Usage
- The below code shows the process of verifying phone number:

1. After the user enters their phone number, trigger the verification process
```dart
await AuthService.firebase().verifyPhoneNumber(
    phoneNumber: '+84${_phoneNumber.text}',
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
```
- Verification ID and OTP from the user will be used to verify the user's phone number.
- An OTP will be sent to the user's phone number. The user will be navigated to the Verification View.

![Verification view](/documentation/Collections/phone_verification_view.png)

- The user will then use the OTP sent by Firebase to enter in the empty field in the verification view.  
![OTP](/documentation/Collections/OTP.png)

- Then, the verification ID in the first step with the OTP code from user's phone will be verified:
```dart
var phoneCred = PhoneAuthProvider.credential(
    verificationId: verificationId, smsCode: otpCode);
``` 
- Phone credential obtained from the above code will be linked to the user's account. If the user already has a verified phone number, the old phone number will be replaced with the new one.
![Phone linked with account](/documentation/Collections/phone_linked_account.png)