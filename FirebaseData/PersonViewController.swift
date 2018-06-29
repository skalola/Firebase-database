//
//  PersonViewController.swift
//  FirebaseData
//
//  Created by Shiv Kalola on 6/20/18.
//  Copyright © 2018 Shiv Kalola. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage


final class PersonViewController: UIViewController, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet fileprivate var tableView: UITableView!
    
    // Setup sorting
    @IBOutlet var youngest: UIButton!
    @IBOutlet var oldest: UIButton!
    @IBOutlet var nameAtoZ: UIButton!
    @IBOutlet var nameZtoA: UIButton!
    @IBOutlet var sortByMale: UIButton!
    @IBOutlet var sortByFemale: UIButton!
    @IBOutlet var clearSort: UIButton!
    
    
    // Sort by name
    @IBAction func sortByAtoZ(_ sender: UITapGestureRecognizer) {
        self.people = self.people.sorted(by: {
            // A to Z
            $0.name < $1.name
        })
        nameAtoZ.isHidden = true
        nameZtoA.isHidden = false
        print(self.people, "Sorting A to Z")
        self.tableView.reloadData()
    }
    
    @IBAction func sortByZtoA(_ sender: UITapGestureRecognizer) {
        self.people = self.people.sorted(by: {
            // Z to A
            $0.name > $1.name
        })
        nameAtoZ.isHidden = false
        nameZtoA.isHidden = true
        print(self.people, "Sorting Z to A")
        self.tableView.reloadData()
    }
    
    // Sort by age
    @IBAction func sortByYoungest(_ sender: UITapGestureRecognizer) {
        self.people = self.people.sorted(by: {
            // Youngest
            $0.age < $1.age
        })
        youngest.isHidden = true
        oldest.isHidden = false
        print(self.people, "sort by youngest")
        self.tableView.reloadData()
    }
    
    @IBAction func sortByOldest(_ sender: UITapGestureRecognizer) {
        self.people = self.people.sorted(by: {
            // Oldest
            $0.age > $1.age
        })
        youngest.isHidden = false
        oldest.isHidden = true
        print(self.people, "sort by oldest")
        self.tableView.reloadData()
    }
    
    // Sort by gender
    @IBAction func sortByMales(_ sender: UITapGestureRecognizer) {
        self.people = self.people.sorted(by: {
            // By Males
            $0.gender > $1.gender
        })
        sortByMale.isHidden = true
        sortByFemale.isHidden = false
        print(self.people, "sort by males")
        self.tableView.reloadData()
    }
    
    @IBAction func sortByFemale(_ sender: UITapGestureRecognizer) {
        self.people = self.people.sorted(by: {
            // By Females
            $0.gender < $1.gender
        })
        sortByMale.isHidden = false
        sortByFemale.isHidden = true
        print(self.people, "sort by females")
        self.tableView.reloadData()
    }

    // Clear sort
    @IBAction func clearSorting(_ sender: UITapGestureRecognizer) {
        self.people = self.people.sorted(by: {
            // Sort table by default
            $0.name < $1.name
        })
        print(self.people, "sort table with default settings")
        self.tableView.reloadData()
    }
    
    var updateHobbiesLabel = "new hobbies"
    
    fileprivate var people: [Person] = []
    fileprivate let personRef = Database.database().reference().child("people")
    fileprivate var handles: [DatabaseHandle] = []
    fileprivate var keyArray:[String] = []
    fileprivate var imagePicker : UIImagePickerController = UIImagePickerController()
    fileprivate let store = Storage.storage()
    fileprivate let storeRef = Storage.storage().reference()
}

// MARK: - @IBOutlets
public class ListCell: UITableViewCell {
    @IBOutlet var imageToPost: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var hobbiesLabel: UILabel!
    @IBOutlet var uidLabel: UILabel!
}

// MARK: - Life Cycle
extension PersonViewController {
    override func viewDidLoad() {
    super.viewDidLoad()
    
    // for handles use `viewWillAppear` rather than `viewDidLoad`
    personRef.observe(.childAdded, with: { snapshot in
      guard let personDict = snapshot.value as? [String: Any] else { return print("couldn't cast") }
      let person = Person(dictionary: personDict)
      self.people.append(person)
      self.personRef.keepSynced(true)
      self.tableView.insertRows(at: [IndexPath(row: self.people.count - 1, section: 0)], with: .automatic)
    })
        
    // Initialize library
    imagePicker.delegate = self
    
    // Enable edit button
    // self.navigationItem.leftBarButtonItem = self.editButtonItem
    
    // Manage selection during editing mode
    self.tableView.allowsSelection = true
    self.tableView.allowsSelectionDuringEditing = true
        
    // Set Table datasource and delegate
    tableView.delegate = self
    tableView.dataSource = self
    
    // Clean up sort buttons
    nameZtoA.isHidden = true
    sortByMale.isHidden = true
    youngest.isHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            handles.forEach {
            personRef.removeObserver(withHandle: $0)
        }
    }
}

extension UIImageView{
    func setImageFromURl(stringImageUrl url: String){
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                self.image = UIImage(data: data as Data)
            }
        }
    }
}
// MARK: - UITableViewDataSource
extension PersonViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath as IndexPath) as! ListCell
        
        //Style updates based on gender
        let personsGender = people[indexPath.row].gender.uppercased()
  
            let firstChar = personsGender[personsGender.startIndex]
            if (firstChar == "M") {
                cell.uidLabel?.backgroundColor = #colorLiteral(red: 0.156888558, green: 0.6709039746, blue: 0.9176470588, alpha: 1)
                cell.uidLabel?.textColor = #colorLiteral(red: 0.156888558, green: 0.6709039746, blue: 0.9176470588, alpha: 1)
            }
            if (firstChar == "F") {
                cell.uidLabel?.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
                cell.uidLabel?.textColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            }
        
        //Get firebase reference data to populate cell
        cell.imageToPost.setImageFromURl(stringImageUrl: "\(people[indexPath.row].imageURL).")
        cell.uidLabel?.text = "\(personRef.childByAutoId().key)"
        cell.hobbiesLabel?.text = "\(people[indexPath.row].hobbies)."
        cell.nameLabel?.text = "\(people[indexPath.row].name.capitalized), \(firstChar), \(people[indexPath.row].age)."
        
        return cell
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    /* ENABLE DELETE */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            //Delete from Firebase Database
            getAllKeys()
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                self.personRef.child(self.keyArray[indexPath.row]).removeValue()
                self.people.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
                self.keyArray = []
            })
            
            //Delete from Firebase Storage
            let imageRef = storeRef.child("\(people[indexPath.row].image)")
            imageRef.delete { error in
                if let error = error {
                    // Uh-oh, an error occurred!
                } else {
                    // File deleted successfully
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Get keys from dictionary
    func getAllKeys() {
        personRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                let key = snap.key
                self.keyArray.append(key)
            }
        })
    }
    
    /* NAVIGATION */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showPerson", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
 
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let profile = segue.destination as! ProfileViewController

            // Store and pass labels to the profile view
            profile.personName = people[indexPath.row].name
            profile.personAge = people[indexPath.row].age
            profile.personGender = people[indexPath.row].gender
            profile.personHobbies = people[indexPath.row].hobbies
            profile.personImage = people[indexPath.row].image
            profile.personImageURL = people[indexPath.row].imageURL
        }
    }
    @IBAction func sendToProfile(_ sender: UIStoryboardSegue) {
        guard let profileVC = sender.source as? ProfileViewController else {return}
//        personRef.observe(.childChanged, with: { (snapshot) -> Void in
//            print(snapshot.value)
//        })
        UserDefaults.standard.set(updateHobbiesLabel, forKey: "updateHobbies")
        
    }
}


// MARK: - @IBActions
extension PersonViewController {
    @IBAction func addButtonTapped() {
        //First alert to add a person
        let alertController = UIAlertController(title: "Add a Person", message: nil, preferredStyle: .alert)
        
        //Add Name Field
        alertController.addTextField { textField in
            textField.text = "Name"
        }
        //Add Age Field
        alertController.addTextField { textField in
            textField.text = "Age"
        }
        //Add Gender Field
        alertController.addTextField { textField in
            textField.text = "Gender"
        }
        //Add Hobbies Field
        alertController.addTextField { textField in
            textField.text = "Hobbies"
        }
        //Add Image Field
        let imageName = "placeholder-pic"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(frame: CGRect(x: 15, y: 15, width: 25, height: 25))
        imageView.image = image
        alertController.view.addSubview(imageView)

        //Get images from device photo library
        let libraryAction : UIAlertAction = UIAlertAction(title: "Choose from Photos", style: .default, handler: {(libraryAction) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) == true {
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true)
                
                //Store user inputs to NSUserDefaults
                guard let name = alertController.textFields?[0].text else { fatalError() }
                guard let age = alertController.textFields?[1].text else { fatalError() }
                guard let gender = alertController.textFields?[2].text else { fatalError() }
                guard let hobbies = alertController.textFields?[3].text else { fatalError() }

                UserDefaults.standard.set(name, forKey: "name")
                UserDefaults.standard.set(age, forKey: "age")
                UserDefaults.standard.set(gender, forKey: "gender")
                UserDefaults.standard.set(hobbies, forKey: "hobbies")
            }
        })
       
        
        //Setup Alert actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
        
    }
    
    
    // Firebase image storage and database reference
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let profileImageFromPicker = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            //Get image metadata
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            //Add metadata to Firebase Storage
            let imageData: Data = UIImageJPEGRepresentation(profileImageFromPicker, 0.5)!
            let imageName = personRef.childByAutoId().key
            let store = Storage.storage()
            let storeRef = store.reference().child("images/\(imageName).jpg")
            let _ = storeRef.putData(imageData, metadata: metadata) { (metadata, error) in
                guard let _ = metadata else {
                    print("error occurred: \(error.debugDescription)")
                    return
                }
                
                // MARK: - GET DOWNLOAD URL
                storeRef.downloadURL { (url, error) in
                    //use this url to access your image
                    let downloadUrl = url!.absoluteString
                    //print(downloadUrl)
                    
                    //Return UserDefaults here
                    let defaults = UserDefaults.standard
                    guard let name = defaults.value(forKey: "name") else { fatalError() }
                    guard let age = defaults.value(forKey: "age") else { fatalError() }
                    guard let gender = defaults.value(forKey: "gender") else { fatalError() }
                    guard let hobbies = defaults.value(forKey: "hobbies") else { fatalError() }
              
                    let person = Person(
                        name: name as! String,
                        age: age as! String,
                        gender: gender as! String,
                        hobbies: hobbies as! String,
                        image: "images/\(imageName).jpg",
                        imageURL: downloadUrl
                    )
                    Server.save(person: person)
                    
                    //Flush UserDefaults
                    defaults.removeObject(forKey: "name")
                    defaults.removeObject(forKey: "age")
                    defaults.removeObject(forKey: "gender")
                    defaults.removeObject(forKey: "hobbies")
                    defaults.synchronize()
          
                    return
                }
            }
        }
        picker.dismiss(animated: true, completion: nil);
    }

}
