// login Exception
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// register Exception
class WeakPassowrdAuthException implements Exception {}

class EmailAlreadyInUsedAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// generic Exception

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
