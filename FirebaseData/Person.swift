//
//  Person.swift
//  FirebaseData
//
//  Created by Shiv Kalola on 6/20/18.
//  Copyright © 2018 Shiv Kalola. All rights reserved.
//

import Foundation
import UIKit

struct Person {
    var uid: UUID
    var name: String
    var age: String
    var gender: String
    var hobbies: String
    var image: String
    var imageURL: String

    init(uid: UUID = UUID(), name: String, age: String, gender: String, hobbies: String, image: String, imageURL: String) {
    self.uid = uid
    self.name = name
    self.age = age
    self.gender = gender
    self.hobbies = hobbies
    self.image = image
    self.imageURL = imageURL
    }
}

// MARK: - FirebaseConvertible
extension Person: FirebaseConvertible {
  var json: [String: Any] {
    return [
      "uid": uid.uuidString,
      "name": name,
      "age": age,
      "gender": gender,
      "hobbies": hobbies,
      "image": image,
      "imageURL": imageURL
    ]
  }
  
  init(dictionary: [String: Any]) {
    guard let uuidString = dictionary["uid"] as? String, let uid = UUID(uuidString: uuidString) else { fatalError() }
    self.uid = uid
    guard let name = dictionary["name"] as? String else { fatalError() }
    self.name = name
    guard let age = dictionary["age"] as? String else { fatalError() }
    self.age = age
    guard let gender = dictionary["gender"] as? String else { fatalError() }
    self.gender = gender
    guard let hobbies = dictionary["hobbies"] as? String else { fatalError() }
    self.hobbies = hobbies
    guard let image = dictionary["image"] as? String else { fatalError() }
    self.image = image
    guard let imageURL = dictionary["imageURL"] as? String else { fatalError() }
    self.imageURL = imageURL
  }
}
