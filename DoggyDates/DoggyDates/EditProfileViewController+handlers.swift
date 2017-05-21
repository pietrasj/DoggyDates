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
            
            //print(snapshot)
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let pName = dictionary["petName"] as! String
                let pAge = dictionary["petAge"] as! String
                let pMY = dictionary["petAgeMMYY"] as! String
                self.petNameLbl.text = "\(pName), \(pAge) \(pMY) old"
                
                let oName1 = dictionary["name1"] as! String
                let oName2 = dictionary["name2"] as! String
                let oAge = dictionary["dob"] as! String
                
                
                if oName2 != "" {
                    self.ownerNameLbl.text = "\(oName1) & \(oName2) - \(oAge)"
                } else {
                    self.ownerNameLbl.text = "\(oName1)"
                }
                
                
                
//                if let profileImageUrl = dictionary["profileImageUrl"] as? String {
//                    self.ownerImage.loadImageUsingCacheWithURLString(urlString: profileImageUrl)
//                }
                
                if let petProfileImageUrl = dictionary["petProfileImageUrl"] as? String {
                    self.petImage.loadImageUsingCacheWithURLString(urlString: petProfileImageUrl)
                    self.petImage.contentMode = UIViewContentMode.scaleAspectFit
                }
            }
            
        }, withCancel: nil)
    }
    
    
}
