# Database architecture

The entire project backend is based entirely on Google's SaaS and serverless
backend Firebase. 

This tech stack was chosen for its fast development speed and good documentations
in order to deliver the best possible product in a time frame of two months.

## Database

The app uses two firebase's database while using the app simultaneously:
- Realtime database
- Firestore database

For more differences between the two database refer to this [article](../Firebase_vs_Firestore.md)

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


