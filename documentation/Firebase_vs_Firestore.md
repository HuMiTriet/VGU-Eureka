# Differences between Firestore database and realtime database

## Realtime database (sometimes called simply Firebase)
- The original version of the firebase database

## Firestore
- The new version and built on top of realtime database 

## Differences

| Realtime Database (Firebase)                                                                                                                                            	| Firestore                                                                                            	|
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------	|------------------------------------------------------------------------------------------------------	|
| Data Structure: More structure data, data is organized with a hierarchy, Meaning when querying for data the database only return the hierarchy level that is requested. 	| Data Structure: Data composed of just json objects. Querying for data returns the entire json object 	|
|-----------------------------------------|------------------------------------------------------------|
| Pricing: based on storage and bandwidth | Pricing: based on the numbers of read and write operations |

## Similarities 
- Both have Client libraries that enable the local device to listen to changes
  in the remote database and update.
