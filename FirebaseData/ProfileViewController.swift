//
//  ProfileViewController.swift
//  FirebaseData
//
//  Created by Shiv Kalola on 6/20/18.
//  Copyright © 2018 Shiv Kalola. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class ProfileViewController: UIViewController, UINavigationControllerDelegate  {
    
    @IBOutlet var profileImageURL: UIImageView!
    @IBOutlet var profileName: UILabel!
    @IBOutlet var profileAge: UILabel!
    @IBOutlet var profileHobbies: UILabel!
    @IBOutlet var profileGender: UILabel!
    @IBOutlet var hobbiesTextField: UITextField!
    @IBOutlet var profileImage: UILabel!
    
    // Use placeholders to receive data from last view
    var personName = "Name"
    var personAge = "Age"
    var personGender = "Gender"
    var personHobbies = "Hobbies"
    var personImage = "Image"
    var personImageURL = "Image-URL"
    
    // Setup Firebase Database references
    fileprivate var people: [Person] = []
    fileprivate let personRef = Database.database().reference().child("people")
    fileprivate var handles: [DatabaseHandle] = []
    fileprivate var keyArray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Style updates based on gender
        let personsGender = personGender.uppercased()
        let firstChar = personsGender[personsGender.startIndex]
        if (firstChar == "M") {
            //view.backgroundColor = #colorLiteral(red: 0.156888558, green: 0.6709039746, blue: 0.9176470588, alpha: 1)
            profileImage.backgroundColor = #colorLiteral(red: 0.156888558, green: 0.6709039746, blue: 0.9176470588, alpha: 1)
            profileImage.textColor = #colorLiteral(red: 0.156888558, green: 0.6709039746, blue: 0.9176470588, alpha: 1)
        }
        if (firstChar == "F") {
            //view.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            profileImage.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            profileImage.textColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
        
        // Setup cell
        profileName.text = "\(personName.capitalized)"
        profileAge.text = "\(personAge)"
        profileGender.text = "\(firstChar)"
        profileHobbies.text = "\(personHobbies)"
        profileImage.text = "\(personImage)"
        profileImageURL.setImageFromURl(stringImageUrl: "\(personImageURL).")
        
        // Enable edit button
        self.navigationItem.rightBarButtonItem = self.editButtonItem

        hobbiesTextField.isHidden = true
    }
    override func setEditing (_ editing:Bool, animated:Bool){
        super.setEditing(editing,animated:animated)
        if(self.isEditing) {
            self.editButtonItem.title = "Save"
            
            // Hide hobbies label, show textField input
            hobbiesTextField.text = profileHobbies.text
            hobbiesTextField.isHidden = false
            profileHobbies.isHidden = true
            
        } else {
            // Show updated Hobbies label and hide textField input
            hobbiesTextField.isHidden = true
            profileHobbies.text = hobbiesTextField.text
            profileHobbies.isHidden = false
            
            // Save changes to Firebase Database
            personRef.queryOrdered(byChild: "image").queryEqual(toValue: personImage).observe(.value, with: { snapshot in
                for child in snapshot.children{
                    let snap = child as! DataSnapshot
                    let key = snap.key
                    self.personRef.child(key).updateChildValues(["hobbies" : self.hobbiesTextField.text])
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let profile = segue.destination as! PersonViewController
            // Store and pass labels to the profile view
            profile.updateHobbiesLabel = profileHobbies.text!
    }
}

