//
//  ProfilePageOneViewController+handlers.swift
//  DoggyDates
//
//  Created by Jayne Pietraszkiewicz on 10/5/17.
//  Copyright © 2017 Deakin. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseDatabase

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handledSelectProfileImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker : UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            petImage.image = selectedImage
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancelled picker")
        dismiss(animated: true, completion: nil)
    }
    
    func loadProfileData() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
            
            // load Pet and Owner information into text fields
            
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let pName = dictionary["petName"] as! String
                let pAge = dictionary["petAge"] as! String
                let pMY = dictionary["petAgeMMYY"] as! String
                let pGender = dictionary["petGender"] as! String
                let pBreed = dictionary["petBreed"] as! String
                let pBioChg = dictionary["petBio"] as! String
                let oName1 = dictionary["name1"] as! String
                let oBioChg = dictionary["userBio"] as! String
                
                    self.maritalSelectionSC.selectedSegmentIndex = 0
                    self.ownerNameTxtFld.text = "\(oName1)"
                    self.ownerSavedNameLbl.text = "\(oName1)"
                self.ownerDescriptionTxtFld.text = "\(oBioChg)"
                    
                if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                    self.ownerImage.loadImageUsingCacheWithURLString(urlString: profileImageUrl)
                    self.ownerImage.contentMode = UIViewContentMode.scaleAspectFit
                }
                
                self.petNameTxtFld.text = "\(pName)"
                self.petAgeTxtFld.text = "\(pAge)"
                self.petBreedTxtFld.text = "\(pBreed)"
                self.petDesciptionTxtFld.text = "\(pBioChg)"
                switch self.petAgeSC.selectedSegmentIndex {
                case 0:
                    if pMY == "Months" {
                        self.petAgeSC.selectedSegmentIndex = 0
                    }
                case 1:
                    if pMY == "Years" {
                        self.petAgeSC.selectedSegmentIndex = 1
                    }
                default: break
                }
                switch self.petGenderSC.selectedSegmentIndex {
                case 0:
                    if pGender == "Male" {
                        self.petAgeSC.selectedSegmentIndex = 0
                    }
                case 1:
                    if pGender == "Female" {
                        self.petAgeSC.selectedSegmentIndex = 1
                    }
                default: break
                }
                
                if let petProfileImageUrl = dictionary["petProfileImageUrl"] as? String {
                    self.petImage.loadImageUsingCacheWithURLString(urlString: petProfileImageUrl)
                    self.petImage.contentMode = UIViewContentMode.scaleAspectFit
                }
                
                
            }
            
        }, withCancel: nil)
    }
    
    
}
