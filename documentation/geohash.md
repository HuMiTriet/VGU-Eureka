# Motivation

Since one of the app core features is that it can send a [public SOS
signal](../README.md#Public SOS signal). Therefore, we need a way to do:

- Query only the necessary or visible amount of other users' information to
  draw them on the map
- Filter out users who are eligible to receive the Public SOS signal, meaning
  users that are within a 20kms radius from the help signal because the maximum
  help distance is 20km. For more information on the maximum help distance and
  help distance please refer to the [README.md](../README.md). This is a
  necessary step as opposed to the alternative is to go through every single
  user of the app and then check to see if their help distance is larger than
  the distance between them and the signal source. Using geohash helps us with
  the scalability of our app.

# How geohash works:

Geohash is a technique to convert from a latitude and longitude point to a
string that can be used to compare or see how far away two points are on a map.

Geohash divides the surface of the globe into 4x8 sectors each with its own
character denoting that sector, these characters are called "Geohash alphabet".
The alphabet includes all numbers from 0-9 and all characters except "a", "i",
"l" and "o".

Each of the geohash sector is then further divided into another 4x8 geohash
map, then once again each of these sub-sectors has its own character from the
"geohash alphabet". This process can continue in a fractal pattern, resulting
in an ever lengthening geohash string. However in this project we use a geohash
string with length of 9 characters.

[video explanation](https://www.youtube.com/watch?v=UaMzra18TD8) explaining geohash

# Geohash for Cloud Functions:

For the cloud functions, the implementation for the geohash is done/used via
the geofire-common npm dependency, written by Google.

```json
    "geofire-common": "^5.2.0"
```

First we must get all of the user within a 20km rardius from the source of the
help signal. This is done by the following code:

```ts
const bounds = geofire.geohashQueryBounds(center, radius);

// Promise to store all of the candidate helper's FCM token
const helperCandidatePromise: Promise<admin.database.DataSnapshot>[] = [];
const rootRef = rt.ref("users");

for (const b of bounds) {
  const query = rootRef.orderByChild("geohash").startAt(b[0]).endAt(b[1]);

  helperCandidatePromise.push(query.get());
  console.log("one candidate added");
}
```

The first line with the functions geohashQueryBounds(center, radius); creates 2
pairs of geohashes. With each of the pairs limiting the latitudinal and
longitudinal axis respectively. These four points will create the circle of a
specified radius.

Since the realtime database can not do advance querying features such as search
for a json object based on the value inside of the key value pair, like in
Firestore; the indexing of the database is change in order to do this.

By default the Firebase realtime database index each json object according to
their keys. The index is then changed based on the geohash of each users, if
two users have the same geohash then it will continute to order based on the
users' keys.

```json
 "users" : {
      ".indexOn": ["geohash"]
    },
```

This change of index is done so that user who are closer to each other, meaning
they have more similar strings of geohashes, are placed closer inside the
database.

The next step is to eliminate false positive and chose only those whose distance
is smaller than their help radius.

```ts
const distanceInKm = geofire.distanceBetween([lat, lng], center);
```

# Geohash for Flutter:

For creating geohash from a latitude and longitude point, a Flutter plugin called [Geoflutterfire](https://pub.dev/packages/geoflutterfire), by noeatsleepteam.com is used.

## How to use

First import the plugin:

```dart
import 'package:geoflutterfire/geoflutterfire.dart';
```

Then to get geohash, a GeoFirePoint is needed to be created:

```dart
var geoFirePoint = GeoFirePoint(latitude, longitude);
```

Finally from the GeoFirePoint, we can get geohash:

```dart
var geohash = geoFirePoint.hash;
```

With the plugin, a listener to get all the data that have geohash can be queried from Firestore, for example:

```dart
static StreamSubscription querySignalInRadius(
      {required double lat, required double lng, double radius = 5.0}) {
    var center = GeoFirePoint(lat, lng);
    var field = 'position';
    var subcription = geoflutterfire
        .collection(collectionRef: firestoreReference)
        .within(center: center, radius: radius, field: field, strictMode: true)
        .listen((event) {});
    return subcription;
  }
```

In this function, to listen to signal in a radius, a center point, radius, and reference to the Firestore are required.

- The center point in the application is the user's location
- The Firestore reference is the emergency branch
- And the radius can be asigned using the field helpRange defined for each user.

So using this listener, every new emergency signal which is in the radius around the user will be shown on the map in SOS state.
