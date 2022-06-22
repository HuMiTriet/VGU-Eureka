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

## Maps
### Default Map/Friend Map (Home Screen)

![Default Map/Friend Map (Home Screen)](./documentation/UI Design/FriendMap_HomeScreen.svg)

- Every time a user launches the app after logging in, this screen will be the first thing to appear. There are numerous buttons on it, all of which have different functions.
- The user uses this map to see their friends' locations.
- Press the "SOS Map" button in the lower middle of the screen to enter SOS Map.

### SOS Map

![SOS Map](./documentation/UI Design/SOS_Map_Screen.svg)

- All SOS public signals are represented as markers on this map. Users who want to help can pick at random one of the markers and do so.
- The former "SOS Map" button now becomes the "Default Map" button. Pressing it will bring users back to the Home Screen, which is the Default Map (or Friend Map).

## Setting

![Setting Screen](./documentation/UI Design/SettingScreen.svg)

- Both maps have a gear icon for a setting button. The Setting Screen will appear once you press it.
- Users can toggle on or off the app's notification and change the helper radius on this screen to alter the area in which they receive notifications about SOS public signals. By clicking the "Edit account" field, users can also make changes to their account information, which will take them to the Profile Editor Screen.

![Profile Editor Screen](./documentation/UI Design/ProfileEditorScreen.svg)

## Friends
### Friend List View

![Friend List](./documentation/UI Design/Friendlist&SearchScreen.svg)

- Both maps have a button with the icon friends at the bottom left. When you click it, the Friend List View will appear.
- The user's friend list can be found on this screen. The user and friend's chat room can be accessed by tapping any account in this list.
- A search field is also included. Searching for the user's friends using this field.
- "Add Friend" button allows you to search an unconnected account by email to "add friend" them.
- The Pending Friend Request field will keep track of and list all "add friend" requests. Once you press it, you can connect with anyone you want.


