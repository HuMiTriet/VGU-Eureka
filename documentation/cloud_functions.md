# Terminology 

- Since firebase is a serverless service, the developer do not have direct
  access or control how the server is run, but instead they use cloud functions
  running on top of those servers to modify or change how the server behave.

- Cloud functions for Firebase is a thin wrapper around the Google Cloud functions
  service, where functions are hosted and run on google's infrastructure.

- The difference between them is that Cloud Functions for Firebase is more
  tightly integrated with the rest of the Firebase services and offer more
  configuration out of the box.

- Firebase SDK for Cloud Functions: provides the libraries that are used by the
  Cloud Functions for Firebase to access the firebase services with privileged
  access. Privileged access means that the cloud functions are not subjected to
  any securities rule that each of the service has, meaning the cloud functions
  acts with admin privileges.

## Summary of terminology:

- Google Cloud Functions: google services that let developer run functions on
  Google cloud infrastructure, without having to worry about server
  maintenance.

- Cloud Functions for Firebase: thin wrapper around Google Cloud Functions, 
  more tightly integrated with the rest of Firebase services.

- Firebase SDK for Cloud Functions: used by the Cloud Functions for Firebase 
  to access the Firebase's services without being constrained by the security
  rules

# Runtime environment 
- For now the Cloud Functions for Firebase only support for JavaScript via
  NodeJS, using other programming language is only supported for the Google
  Cloud Functions.

# Coding language
- All of the Cloud Functions code are written in Typescript a super set of 
  JavaScript that provides strong type annotations.

- The main reason for the choice of Typescript is that Google recommend it
  as the preferred language of choice. In addition, the strong typing helps
  with catching bugs and errors long before they are deployed. Furthermore,
  most of Google's libraries are also written in Typescript, so they provide
  type suggestions and completion for all the parameters.

- Finally, since all the Typescript is actually compiled to JavaScript code to
  be run in the cloud environment, so technically it is still running
  JavaScript.

# Cold Start
- Each functions of the Cloud Functions for Firebase is run on a separate cloud
  instance, meaning each cloud functions has its own CPU and memory resources 
  to use. Therefore, Google cannot keep all the cloud functions continuously 
  running all the time. After a certain period of inactivity the Cloud Function
  instance will be killed to save resources.

- Since each Cloud Functions are activated or called when a trigger is fired, 
  if the current instance is not running the server must then load all the 
  JavaScript then compile and run it. This delay between when the cloud 
  function is called and when it begins executing is called cold start.

# Method to minimize cold start
- There is no way to completely remove cold start all together, a developer can
  only optimize their code or reorganizing the code folder structure.

## Folder Structure
- At first all the code was written in the index.ts file, but after a while the
  code base started to grew and a single file where all the codes reside
  became unwieldy, hard to maintain. 

- Current folder structure is divided into many subfolders where each is 
  responsible for their respective task. The current index.ts file is only used
  to export all the functions to the Cloud Functions for Firebase.
  
# Writing a Cloud Function

- Each Cloud functions must have the relevant imports of the necessary
  libraries from "firebase-functions". This library provides all the tools to
  set up and use Firebase cloud functions.

- To communicate with all of the firebase services such as Firestore, Firebase
  Storage,etc. The "firebae-admin" must then be imported. This provides acces
  to all the firebase service with privileged access.

## Linter setup
- Linter is a programe that runs through the code base to flag warnings telling 
  that the code is not good, e.g., The code line is over 80 characters wide,
  etc. These error does not make or break the program but if implemented properly
  will result in cleaner code and improved correctness. However, the Typescript 
  compiler is quite strict in that it will not compile unless all the linters
  warnings are satisfied.

- There are two linters that can be used: eslint and eslint_d(recommended),
  both are preconfigured inside the eslintrc.js file.  The linter eslint_d is 
  recommended because it is much faster than eslint. The linter must be 
  installed manually if the text editor does not install it already.

## Code optimization
- Typescript or newer versions of Javascript support for async/await paradigms,
  to allow for asynchronous programming on JavaScript single threaded workload.

- In the following example demonstrate this:
``` ts
    // Store each of the user's friend promise into an array, for each
    // of the friend we query the database again for their fcm token
    const friendFcmTokenPromises: Promise<DocumentSnapshot>[] = [];
    // query the user friend collection for the uid -> find the fcm token
    userFriendCollectionSnapshot.forEach(async (oneFriend) => {
      const oneFcmToken = db.collection("users")
          .doc(oneFriend.data().friendUID)
          .collection("notification")
          .doc("fcm_token")
          .get();
      friendFcmTokenPromises.push(oneFcmToken);
    });
```

- Each of the FCM token (which unique identify a device in order to send the
  payload to the device) must be queried from the database. Hence, it is an
  async function. Instead of waiting for each of the Promises to finish 
  executing (meaning the successful retrieval of the FCM token), each Promise is
  then stored in an array of Promises.

``` ts
    const tokenSnapshot = await Promise.all(friendFcmTokenPromises);
```

- The function Promise.all() await for all the promise and will only be done
  until all the promises inside the array is fulfilled. This allows for 
  multiple FCM token to be queried simultaneously and not done sequentially as
  normally would. This is used both by to send public and private SOS signal, 
  because in both cases the user can have either a lot of friends or there is 
  a lot of nearby user to help the public SOS signal.
