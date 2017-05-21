//
//  EditProfileViewController.swift
//  DoggyDates
//
//  Created by Jayne Pietraszkiewicz on 12/5/17.
//  Copyright © 2017 Deakin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseStorage

class EditProfileViewController: UIViewController {
    
    
    @IBOutlet var petOwnerSC: UISegmentedControl!
    // fields for Pet Profile
    @IBOutlet var petImage: UIImageView!
    @IBOutlet var petDesciptionTxtFld: UITextField!
    @IBOutlet var petNameTxtFld: UITextField!
    @IBOutlet var petBreedTxtFld: UITextField!
    @IBOutlet var petAgeTxtFld: UITextField!
    @IBOutlet var petAgeSC: UISegmentedControl!
    @IBOutlet var petGenderSC: UISegmentedControl!
    @IBOutlet var aboutPetLbl: UILabel!
    @IBOutlet var petBreedLbl: UILabel!
    @IBOutlet var petNameLbl: UILabel!
    @IBOutlet var petAgeLbl: UILabel!
    @IBOutlet var petGenderLbl: UILabel!
    
    
    
    // fields for Owner Profile
    @IBOutlet var ownerImage: UIImageView!
    @IBOutlet var ownerNameLbl: UILabel!
    @IBOutlet var maritalSelectionSC: UISegmentedControl!
    @IBOutlet var ownerNameTxtFld: UITextField!
    @IBOutlet var ownerDescriptionTxtFld: UITextField!
    @IBOutlet var ownerDescriptionLbl: UILabel!
    @IBOutlet var ownerView: UIView!
    @IBOutlet var ownerSavedNameLbl: UILabel!
    @IBOutlet var ownerChangePhotoBtn: UIButton!

    
    @IBAction func saveChanges(_ sender: UIBarButtonItem) {
        let uid = FIRAuth.auth()?.currentUser?.uid
        // save profile image to firebase
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("pet_profile_images").child("\(imageName).png")
        if let uploadData = UIImagePNGRepresentation(self.petImage.image!) {
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error ?? "")
                    return
                }
                
                
                if let petProfileImageUrl = metadata?.downloadURL()?.absoluteString {
                    // pet information pre-loaded and available for editing.
                    let pNameChg = self.petNameTxtFld.text
                    let pAgeChg = self.petAgeTxtFld.text
                    let pBreedChg = self.petBreedTxtFld.text
                    let pBioChg = self.petDesciptionTxtFld.text
                    var pGenderChg : String!
                    var pAgeMYChg : String!
                    if self.petGenderSC.selectedSegmentIndex == 0 {
                        pGenderChg = "Male"
                    } else if self.petGenderSC.selectedSegmentIndex == 1 {
                        pGenderChg = "Female"
                    }
                    if self.petAgeSC.selectedSegmentIndex == 0 {
                        pAgeMYChg = "Months"
                    } else if self.petAgeSC.selectedSegmentIndex == 0 {
                        pAgeMYChg = "Years"
                    }
                    
                    let oName1Chg = self.ownerNameTxtFld.text
                    let oBioChg = self.ownerDescriptionTxtFld.text
                    
                    
                    
                    
                    
                    // values to be updated against user profile
                    let value1 = ["name1": oName1Chg]
                    let value2 = ["userBio": oBioChg]
                    let value3 = ["petName": pNameChg]
                    let value4 = ["petAge": pAgeChg]
                    let value5 = ["petBreed": pBreedChg]
                    let value6 = ["petAgeMMYY": pAgeMYChg]
                    let value7 = ["petGender": pGenderChg]
                    let value8 = ["petBio": pBioChg]

                    let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
                    changeRequest?.commitChanges(completion: { (error) in
                        if error != nil {
                            print(error ?? "")
                        }
                        else
                        {
                            let userRef = FIRDatabase.database().reference()//.child("users").child(uid)
                            userRef.child("users").child(uid!).setValue(value1)
                            userRef.child("users").child(uid!).setValue(value2)
                            userRef.child("users").child(uid!).setValue(value3)
                            userRef.child("users").child(uid!).setValue(value4)
                            userRef.child("users").child(uid!).setValue(value5)
                            userRef.child("users").child(uid!).setValue(value8)
                            userRef.child("users").child(uid!).setValue(value6)
                            userRef.child("users").child(uid!).setValue(value7)
                            print("Updated user information!")
                        }
                    })

                    
//                    self.updateUserIntoDatabaseWithUID(uid: uid!, values: value1, value2, value3, value4, value5, value6, value7, value8 as [String : AnyObject])
                    
                }
            })
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // set touch handler on profile image
        petImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handledSelectProfileImage)))
        petImage.isUserInteractionEnabled = true
        loadProfileData()
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func petOwnerChoiceSC(_ sender: UISegmentedControl) {
        switch petOwnerSC.selectedSegmentIndex {
        case 0:
            // hide owner fields
            ownerImage.isHidden = true
            ownerNameLbl.isHidden = true
            ownerNameTxtFld.isHidden = true
            maritalSelectionSC.isHidden = true
            ownerDescriptionTxtFld.isHidden = true
            ownerDescriptionLbl.isHidden = true
            ownerView.isHidden = true
            ownerSavedNameLbl.isHidden = true
            ownerChangePhotoBtn.isHidden = true
            // make pet related fields visible
            petImage.isHidden = false
            petDesciptionTxtFld.isHidden = false
            petNameTxtFld.isHidden = false
            petBreedTxtFld.isHidden = false
            petAgeTxtFld.isHidden = false
            petAgeSC.isHidden = false
            petGenderSC.isHidden = false
            aboutPetLbl.isHidden = false
            petBreedLbl.isHidden = false
            petNameLbl.isHidden = false
            petAgeLbl.isHidden = false
            petGenderLbl.isHidden = false
        case 1:
            // hide pet fields
            petImage.isHidden = true
            petDesciptionTxtFld.isHidden = true
            petNameTxtFld.isHidden = true
            petBreedTxtFld.isHidden = true
            petAgeTxtFld.isHidden = true
            petAgeSC.isHidden = true
            petGenderSC.isHidden = true
            aboutPetLbl.isHidden = true
            petBreedLbl.isHidden = true
            petNameLbl.isHidden = true
            petAgeLbl.isHidden = true
            petGenderLbl.isHidden = true
            // make owner related fields visible
            ownerImage.isHidden = false
            ownerNameLbl.isHidden = false
            ownerNameTxtFld.isHidden = false
            maritalSelectionSC.isHidden = false
            ownerDescriptionTxtFld.isHidden = false
            ownerDescriptionLbl.isHidden = false
            ownerView.isHidden = false
            ownerSavedNameLbl.isHidden = false
            ownerChangePhotoBtn.isHidden = false
        default: break
        }
        
    }
    
}
