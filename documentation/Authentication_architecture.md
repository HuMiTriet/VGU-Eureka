# Concrete Authentication provider - AuthProvider - AuthService- UI
# (WIP) Authentication 

- Currently Authentication is provided solely by Firebase. 

- From the perspective of the UI layer, mainly in the pages: login, verify email,
register, reset, password all contact to the authentication via the AuthService
interface.

- In order to use any of the sign in methods provided by Firebase, you will need to enable them in Firebase console.

[Reference](https://firebase.google.com/docs/auth/android/firebaseui)

- Our application provides two different types of authentication: password authentication and third-party providers authentication. 

- Third-party providers authentication consists of logging in using either Google account or Facebook account.

1. [Password Sign In Authentication](./documentation/password_authentication.md) 

2. [Google Sign In Authentication](./documentation/google_authentication.md) 

3. [Facebook Sign In Authentication](./documentation/facebook_authentication.md) 

- In order to use Etoet, users also need to add their phone.
[Phone number authentication](/documentation/phone_authentication.md)


## Concrete Authentication Provider
- For our application it is only firebase, provide either authentication via token
return the user object as a json class which will then be translated to a user object of class AuthUser. 
