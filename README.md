# FirebaseDatabase
Demonstrating how to push and retrieve a list of data from [Firebase](https://firebase.google.com), a backend solution by Google.

## Server.swift

The `Server.swift` file contains a barebones `Server` enum:

```swift
enum Server {}
```

## Server+Database.swift

The `Server+Database.swift` file manages the communication between the app and Firebase for pushing/fetching of data. This is an **extension** of the `Server` enum, with the sole responsibility of handling networking.

### FirebaseConvertible

Model objects for this app conform to a custom protocol, the `FirebaseConvertible` protocol:

```swift
protocol FirebaseConvertible {
  var json: [String: Any]
  init(dictionary: [String: Any] 
}
```

### Requirements
1. Use ​Firebase ​as ​your ​REST ​API ​and ​database. http://firebase.io/
2. You ​will ​need ​to ​create ​a ​list ​view ​of ​profiles.
3. Each ​profile ​should ​have ​all ​of ​the ​following ​information:

a. A ​unique ​integer ​ID
b. Gender ​(Male/Female)
c. Name

d. Age
e. Profile ​Image
f. Hobbies

4. Each ​profile ​should ​display ​its ​respective ​background ​color
a. Males ​profiles ​should ​have ​a ​blue ​background
b. Female ​profiles ​should ​have ​a ​pink ​background
5. A ​user ​should ​be ​able ​to:
a. Filter ​the ​list ​to ​show ​only ​male ​or ​female ​profiles.
b. Clear ​the ​filter ​to ​show ​all ​profiles.
c. Sort ​the ​list ​by ​age ​ascending ​or ​descending.
d. Sort ​the ​list ​by ​name ​ascending ​or ​descending.
e. Remove ​any ​sorts ​and ​go ​back ​to ​the ​default.
f. Add ​a ​new ​profile ​using ​an ​overlay.
g. Tap ​on ​a ​profile ​and ​go ​to ​a ​profile ​view.
h. Remove ​a ​profile ​from ​the ​profile ​view.
i. Update ​a ​profile’s ​hobbies ​from ​the ​profile ​view
6. The ​profile ​view ​should ​display ​the ​following ​information:

a. Gender
b. Name
c. Age

d. Profile ​Image
e. Hobbies

7. The ​list ​should ​be ​sorted ​by ​ID, ​ascending ​by ​default.
8. Any ​changes ​to ​the ​profiles ​should ​be ​reflected ​across ​all ​running ​instances ​of ​the ​app ​in
real ​time ​without ​requiring ​user ​interaction.
