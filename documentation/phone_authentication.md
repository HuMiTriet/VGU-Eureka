# Phone Number Authentication
- One more step to use Etoet is to add phone number, so that if some one wants to help, they can either contact the person or directly call them by phone.

- When login to the app in the first time, the account may not have the phone number at first, but they can navigate to the login page and add their phone number.

- Luckily, Firebase also has phone number authentication that can send OTP via SMS. Users can then verify their phone number through this process.

- Flutter also has libraries that can trigger the Firebase phone authentication. For our application, we use [firebase_auth 3.3.14](https://pub.dev/packages/firebase_auth) for phone number verification and 
## Configuration
- First and foremost, enable Phone as a Sign-in method in the [Firebase console](https://console.firebase.google.com/u/0/project/_/authentication/providers).
![Enable Phone Firebase](/documentation/Collections/enable_phone_auth.png)

- For Android, it is crucial to set application SHA-1 fingerprint in `Firebase console`. We have instructions in [Google Sign In Authentication](/documentation/google_authentication.md).

## Usage
- The below code shows the process of verifying phone number:

1. After the user has typed in their phone number, trigger the verification process
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
- Verification ID and OTP code from the user will be used to verify user's phone number.
- An OTP code will be sent to the user's phone number. User will be navigated to Verification View.
![Verification view](/documentation/Collections/phone_verification_view.png)

- User will then use the OTP code sent by Firebase to type in the blank field in verification view.  
![OTP](/documentation/Collections/OTP.png)

- Then, the verification ID in the first step with the OTP code from user's phone will be verified:
```dart
var phoneCred = PhoneAuthProvider.credential(
    verificationId: verificationId, smsCode: otpCode);
``` 
- The phone credential obtained from the code above will be linked with the user's account. If the user already have a verified phone number, the old phone number will be replaced by the new one.   
![Phone linked with account](/documentation/Collections/phone_linked_account.png)