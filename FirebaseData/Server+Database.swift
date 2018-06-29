//
//  Server+Database.swift
//  FirebaseData
//
//  Created by Shiv Kalola on 6/20/18.
//  Copyright © 2018 Shiv Kalola. All rights reserved.
//

import Firebase

protocol FirebaseConvertible {
  var json: [String: Any] { get }
  
  init(dictionary: [String: Any])
}

extension Server {
    private static var rootRef: DatabaseReference {
        return Database.database().reference()
  }
  
    private static var personRef: DatabaseReference {
    return Server.rootRef.child("people")
  }
  
    private static var notesRef: DatabaseReference {
    return Server.rootRef.child("notes")
  }
  
  /// Saves the `Person` to `Firebase`. Despite pushing data to the cloud, this call is very fast; `Firebase` will do the network calls on a background thread.
  ///
  /// - parameter person: A `Person` type.
  static func save(person: Person) {
    Server.personRef.childByAutoId().setValue(person.json)
  }
}
