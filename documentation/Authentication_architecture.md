# Concrete Authentication provider - AuthProvider - AuthService- UI
# (WIP) Authentication 

Currently Authentication is provided solely by Firebase. 

From the perspective of the UI layer, mainly in the pages: login, verify email,
register, reset, password all contact to the authentication via the AuthService
interface.

## Concrete Authentication Provider
For our application it is only firebase, provide either authentication via token
return the user object as a json class which will then be translated to a user object of class AuthUser.
