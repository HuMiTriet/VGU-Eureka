# Concrete Authentication provider - AuthProvider - AuthService- UI
# (WIP) Authentication 

- Currently Authentication is provided solely by Firebase. 

- From the perspective of the UI layer, mainly in the pages: login, verify email,
register, reset, password all contact to the authentication via the AuthService
interface.

## Concrete Authentication Provider
- For our application it is only firebase, provide either authentication via token
return the user object as a json class which will then be translated to a user object of class AuthUser. 

- Our application provides two different types of authentication: password authentication and third-party providers authentication. 

- Third-party providers authentication consists of logging in using either Google account or Facebook account.

1. [Password Sign In Authentication](./documentation/password_authentication.md) 

2. [Google Sign In Authentication](./documentation/google_authentication.md) 

3. [Facebook Sign In Authentication](./documentation/facebook_authentication.md) 

