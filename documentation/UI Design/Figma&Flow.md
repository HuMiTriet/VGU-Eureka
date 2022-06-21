# Figma
We use Figma - the collaborative interface design tool - to sketch out the user interface so that frontend developers can build our app based on it.

Here is a link to the full design:
[Full Figma Design](https://www.figma.com/file/NZLZkFTP7KNEw5BcBRj76x/ETOET?node-id=0%3A1)

# Flow
## Log In
### Already have an account

![Log In Screen](./documentation/UI Design/LogInScreen.svg)

- If a user already has an account of Etoet but has never logged in before, this screen will be displayed first when they open the app.
- It also has two other options for logging in: by Facebook or Google account. 
- If the user doesn't have an Etoet account or wants to create one, tap on the underlined "Sign un" to move to the Registration Screen.

### Don't have an account / Create an account

![Registration Screen](./documentation/UI Design/RegistrationScreen.svg)

- After tapping the underlined "Sign up", this screen will show up. Users can now create an Etoet account by filling in all the required text boxes and clicking the Sign-up button. This action will lead the user to Number Verification Screen.
- It also has an underlined "Sign in" to return the Log In Screen when tapping it.

### Phone number verification

![Number Verification Screen](./documentation/UI Design/NumberVerificationScreen.svg)

- A 6-digit code will be sent to the user's device after clicking the "Sign up" button on the Registration Screen, based on the phone number they entered. Filling in the 6-digit code and pressing the "Submit" button allows users to verify their phone number.
- The application should return users to the Log In Screen if the digit code has been filled in correctly, indicating that they have successfully created an account. Users can now fill in text boxes with the same information they registered with, press the "Sign in" button, and the Home Screen, which is also friend map, should appear.