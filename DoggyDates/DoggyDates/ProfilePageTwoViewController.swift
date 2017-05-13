//
//  ProfilePageTwoViewController.swift
//  DoggyDates
//
//  Created by Jayne Pietraszkiewicz on 4/5/17.
//  Copyright © 2017 Deakin. All rights reserved.
//
//  Reference: (raise textfields above keyboard)
//  Satnam Sync 2016, How to make a UITextField move up when keyboard is present, published 24 February 2016, StackOverflow, retrieved 4 May 2017,
//  <http://stackoverflow.com/questions/1126726/how-to-make-a-uitextfield-move-up-when-keyboard-is-present>
//
//
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class ProfilePageTwoViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var petProfileImg: UIImageView!
    @IBOutlet weak var petSexSelected: UISegmentedControl!
    @IBOutlet weak var petNameTxtFld: UITextField!
    @IBOutlet weak var petAgeTxtFld: UITextField!
    @IBOutlet weak var petAgeSelected: UISegmentedControl!
    @IBOutlet weak var petBreedTxtFld: UITextField!
    @IBOutlet weak var disclaimerLbl: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // check if user is logged in
        if FIRAuth.auth()?.currentUser?.uid == nil {
            handleLogout()
        }
        
        // set touch handler on profile image
        petProfileImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handledSelectProfileImage)))
        petProfileImg.isUserInteractionEnabled = true
        
        // set profile image to be circular
        petProfileImg.layer.borderWidth = 1
        petProfileImg.layer.masksToBounds = false
        petProfileImg.layer.borderColor = UIColor.white.cgColor
        petProfileImg.layer.cornerRadius = petProfileImg.frame.height/2
        petProfileImg.clipsToBounds = true
        
        // styling for segmented control
        petSexSelected.layer.cornerRadius = 5.0
        petAgeSelected.layer.cornerRadius = 5.0
        
        
        // setup tap gesture for use when dismissing keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
        
        
        // Terms of Service and Privacy Policy label
        disclaimerLbl.numberOfLines = 0
        disclaimerLbl.text = "By confirming you agree to our Terms of Service \n and Privacy Policy"
        
        // Setting delegate of your UITextField to self in order to move up the view
        petNameTxtFld.delegate = self
        petAgeTxtFld.delegate = self
        petBreedTxtFld.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: 100)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 100)
    }
    
    // Lifting the view up above the keyboard
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
    
    // dismiss the keyboard when outside of text field
    func tap(gesture: UITapGestureRecognizer) {
        petNameTxtFld.resignFirstResponder()
        petAgeTxtFld.resignFirstResponder()
        petBreedTxtFld.resignFirstResponder()
    }
 

    @IBAction func profilePg2CompleteBtn(_ sender: UIButton) {
        // ensure data is linked to user that just registered
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        let petName = petNameTxtFld.text
        let petAge = petAgeTxtFld.text
        let petBreed = petBreedTxtFld.text
        var petSex = ""
        var petAgeMMYY = ""

    /*
        // determine the age range selected from the 2 segmented controls
        switch petSexSelected.selectedSegmentIndex {
        case 0:
            petSex = ("Male" as String)
        case 1:
            petSex = ("Female" as String)
        default: break
        }
    */
        
        // determine the age in months or years
        switch petAgeSelected.selectedSegmentIndex {
        case 0:
            petAgeMMYY = ("Months" as String)
        case 1:
            petAgeMMYY = ("Years" as String)
        default: break
        }
        
        // single male selected
        if petSexSelected.selectedSegmentIndex == 0 {
            let male = "Male"
            // save profile image to firebase
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("pet_profile_images").child("\(imageName).png")
            if let uploadData = UIImagePNGRepresentation(petProfileImg.image!) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error ?? "")
                        return
                    }
                    if let petProfileImageUrl = metadata?.downloadURL()?.absoluteString {
                        let values = ["petName": petName, "petAge": petAge, "petAgeMMYY": petAgeMMYY, "petGender": male, "petProfileImageUrl": petProfileImageUrl]
                        self.registerUserIntoDatabaseWithUID(uid: uid!, values: values as [String : AnyObject])
                    }
                })
            }
        }
            
            // single female selected
        else if petSexSelected.selectedSegmentIndex == 1 {
            let female = "Female"
            // save profile image to firebase
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("pet_profile_images").child("\(imageName).png")
            if let uploadData = UIImagePNGRepresentation(petProfileImg.image!) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error ?? "")
                        return
                    }
                    if let petProfileImageUrl = metadata?.downloadURL()?.absoluteString {
                        let values = ["petName": petName, "petAge": petAge, "petAgeMMYY": petAgeMMYY, "petGender": female, "petProfileImageUrl": petProfileImageUrl]
                        self.registerUserIntoDatabaseWithUID(uid: uid!, values: values as [String : AnyObject])
                    }
                })
            }
        }
    }

    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        
        let ref = FIRDatabase.database().reference(fromURL: "https://doggydates-384b3.firebaseio.com/")
        // create child nodes within firebase
        let usersReference = ref.child("users").child(uid)
        // save these values to firebase
        usersReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil {
                print(error ?? "")
                return
            }
            print("Added additional details to user")
            print(values)
        })
    }
    
    func handleLogout() {
        // sign user out
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        //let profilePageOne = ProfilePageOneViewController()
        //present(profilePageOne, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
