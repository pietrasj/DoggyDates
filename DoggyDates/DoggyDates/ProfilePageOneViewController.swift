//
//  ProfilePageOneViewController.swift
//  DoggyDates
//
//  Created by Jayne Pietraszkiewicz on 3/5/17.
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
import FirebaseDatabase
import FirebaseStorage

class ProfilePageOneViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var maritalStatusSelected: UISegmentedControl!
    @IBOutlet weak var singleFNameTxtFld: UITextField!
    @IBOutlet weak var singleDoBTxtFld: UITextField!
    @IBOutlet weak var coupleOneFNameTxtFld: UITextField!
    @IBOutlet weak var coupleTwoFNTxtFld: UITextField!
    @IBOutlet weak var coupleLbl: UILabel!
    @IBOutlet weak var coupleAgeSelected: UISegmentedControl!
    @IBOutlet weak var coupleAgeSelected2: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check if user is logged in
        if FIRAuth.auth()?.currentUser?.uid == nil {
            handleLogout()
        }
        
        // set touch handler on profile image
        profileImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handledSelectProfileImage)))
        profileImg.isUserInteractionEnabled = true
        
        
        // set profile image to be circular
        profileImg.layer.borderWidth = 1
        profileImg.layer.masksToBounds = false
        profileImg.layer.borderColor = UIColor.white.cgColor
        profileImg.layer.cornerRadius = profileImg.frame.height/2
        profileImg.clipsToBounds = true
        
        // styling for segmented control
        maritalStatusSelected.layer.cornerRadius = 5.0
        coupleAgeSelected.layer.cornerRadius = 5.0
        coupleAgeSelected2.layer.cornerRadius = 5.0

        
        // setup tap gesture for use when dismissing keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
        
        // Setting delegate of your UITextField to self in order to move up the view
        singleFNameTxtFld.delegate = self
        singleDoBTxtFld.delegate = self
        coupleOneFNameTxtFld.delegate = self
        coupleTwoFNTxtFld.delegate = self
    }
    
    @IBAction func pageOneBack(_ sender: UIButton) {
        handleLogout()
        print("Logged out")
    }

    @IBAction func profilePgOneNextBtn(_ sender: UIButton) {
        // ensure data is linked to user that just registered
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        let name1 = singleFNameTxtFld.text
        // set and enter empty string for 2nd name for single user
        let name2 = ""
        let birth = singleDoBTxtFld.text
        let couple1Name = coupleOneFNameTxtFld.text
        let couple2Name = coupleTwoFNTxtFld.text
        var coupleAge = ""
        
        // determine the age range selected from the 2 segmented controls
        if coupleAgeSelected.selectedSegmentIndex != -1 {
            switch coupleAgeSelected.selectedSegmentIndex {
            case 0:
                coupleAge = ("18-25 yrs" as String)
            case 1:
                coupleAge = ("25-30 yrs" as String)
            case 2:
                coupleAge = ("30-35 yrs" as String)
            default: break
            }
        } else if coupleAgeSelected2.selectedSegmentIndex != -1 {
            
            switch coupleAgeSelected2.selectedSegmentIndex {
            case 0:
                coupleAge = ("35-40 yrs" as String)
            case 1:
                coupleAge = ("40-50 yrs" as String)
            case 2:
                coupleAge = ("50+ yrs" as String)
            default: break
            }
        }
        
        // single male selected
        if maritalStatusSelected.selectedSegmentIndex == 0 {
            let male = "male"
            // save profile image to firebase
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).png")
            if let uploadData = UIImagePNGRepresentation(profileImg.image!) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error ?? "")
                        return
                    }
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        let values = ["name1": name1, "name2": name2,"dob": birth, "gender": male, "profileImageUrl": profileImageUrl]
                        self.registerUserIntoDatabaseWithUID(uid: uid!, values: values as [String : AnyObject])
                    }
                })
            }
        }
        
            // single female selected
        else if maritalStatusSelected.selectedSegmentIndex == 1 {
            let female = "female"
            // save profile image to firebase
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).png")
            if let uploadData = UIImagePNGRepresentation(profileImg.image!) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error ?? "")
                        return
                    }
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        let values = ["name1": name1, "name2": name2,"dob": birth, "gender": female, "profileImageUrl": profileImageUrl]
                        self.registerUserIntoDatabaseWithUID(uid: uid!, values: values as [String : AnyObject])
                    }
                })
            }
        }
            // couple selected
        else if maritalStatusSelected.selectedSegmentIndex == 2 {
            let couple = "couple"
            // save profile image to firebase
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).png")
            if let uploadData = UIImagePNGRepresentation(profileImg.image!) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error ?? "")
                        return
                    }
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        let values = ["name1": couple1Name, "name2": couple2Name,"dob": coupleAge, "gender": couple, "profileImageUrl": profileImageUrl]
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
        singleFNameTxtFld.resignFirstResponder()
        singleDoBTxtFld.resignFirstResponder()
        coupleOneFNameTxtFld.resignFirstResponder()
        coupleTwoFNTxtFld.resignFirstResponder()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func maritalStatusSegmentCtrl(_ sender: UISegmentedControl) {
        
        // switch statement depending on which marial status is selected
        switch maritalStatusSelected.selectedSegmentIndex {
        case 0:
            // show FName and DoB fields
            singleFNameTxtFld.isHidden = false
            singleDoBTxtFld.isHidden = false
            // hide couple text fields
            coupleOneFNameTxtFld.isHidden = true
            coupleTwoFNTxtFld.isHidden = true
            coupleLbl.isHidden = true
            coupleAgeSelected.isHidden = true
            coupleAgeSelected2.isHidden = true
        case 1:
            // show FName and DoB fields
            singleFNameTxtFld.isHidden = false
            singleDoBTxtFld.isHidden = false
            // hide couple text fields
            coupleOneFNameTxtFld.isHidden = true
            coupleTwoFNTxtFld.isHidden = true
            coupleLbl.isHidden = true
            coupleAgeSelected.isHidden = true
            coupleAgeSelected2.isHidden = true
        case 2:
            // hide FName and DoB fields
            singleFNameTxtFld.isHidden = true
            singleDoBTxtFld.isHidden = true
            // show couple text fields
            coupleOneFNameTxtFld.isHidden = false
            coupleTwoFNTxtFld.isHidden = false
            coupleLbl.isHidden = false
            coupleAgeSelected.isHidden = false
            coupleAgeSelected2.isHidden = false
            
        default: break
            
        }
    }
    
    @IBAction func coupleAgeSegmentedCtrl(_ sender: UISegmentedControl) {
        if sender.tag == 0 {
            self.coupleAgeSelected2.selectedSegmentIndex = -1
        }
        else if sender.tag == 1
        {
            self.coupleAgeSelected.selectedSegmentIndex = -1
        }
        
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
