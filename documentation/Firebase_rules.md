# Security rules for Firebase

```js
      allow read, write: if 
        request.auth != null;
}
```
Allowing the user to read write only if they have been signed in.

