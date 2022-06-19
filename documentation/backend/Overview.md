# Database architecture

The entire project backend is based entirely on Google's SaaS and serverless
backend Firebase. 

This tech stack was chosen for its fast development speed and good documentations
in order to deliver the best possible product within a time frame of two months.

## Database
The app uses two of firebase's database:
- Realtime database
- Firestore database

# Differences between Firestore database and realtime database

## Realtime database (sometimes called simply Firebase)
- The original version of the firebase database

## Firestore
- The new version and built on top of realtime database 

## Differences

| Realtime Database (Firebase)                                                                                                                                            	| Firestore                                                                                            	|
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------	|------------------------------------------------------------------------------------------------------	|
| Data Structure: More structured data, data is organized within a hierarchy. Meaning when querying for data the database will only return the data on the requested hierarchy level. 	| Data Structure: Data composed of just json objects. Querying at a json root returns the entire json tree at that root 	|
|-----------------------------------------|------------------------------------------------------------|
| Pricing: based on storage and bandwidth | Pricing: based on the numbers of read and write operations |

## Similarities 
- Both have Client libraries that enable the local device to listen to changes
  in the remote database and update.

# Realtime database
Due to the differences in pricing of the two database, the two database is 
used for: 

- the realtime is used to constantly update the user coordinates (the update is
  done if the user has deviated 30 meters away from their original location).
  This database is chosen for this task because of its faster speed and does
  not incur financial cost for each read write operations.

- Firstore database is used for user's data storage as Firestore allows for
  advance queries as compare to realtime database. In addition the shallow
  queries of firestore means that clients query to the database will only get
  exactly what they need. Since client usually operates on battery operated 
  devices the need for limiting client data processing as much as possible is 
  paramount.


