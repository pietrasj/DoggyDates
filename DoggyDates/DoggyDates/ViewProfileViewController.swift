//
//  ViewProfileViewController.swift
//  DoggyDates
//
//  Created by Jayne Pietraszkiewicz on 12/5/17.
//  Copyright © 2017 Deakin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewProfileViewController: UIViewController {

    var users = [User]()
    
    @IBOutlet var petImageLarge: UIImageView!
    @IBOutlet var petNameLbl: UILabel!
    @IBOutlet var petDescriptionLbl: UILabel!
    @IBOutlet var ownerImage: UIImageView!
    @IBOutlet var ownerNameLbl: UILabel!
    @IBOutlet var ownerDesciptionLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        fetchUser()
        
        // set profile image to be circular
        ownerImage.layer.borderWidth = 1
        ownerImage.layer.masksToBounds = false
        ownerImage.layer.borderColor = UIColor.white.cgColor
        ownerImage.layer.cornerRadius = ownerImage.frame.height/2
        ownerImage.clipsToBounds = true
    }
    
    
    func handleBack() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func handleEdit() {
        
    }
    
    func fetchUser() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let user = User()
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                print(user.name1, user.email)
                
                // reloading table in dispatch queue so app doesn't crash
                DispatchQueue.main.async {
                    self.loadImages()
                }
            }
            
        }, withCancel: nil)
    }
    
    func loadImages() {
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
                
                
                
                if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                    self.ownerImage.loadImageUsingCacheWithURLString(urlString: profileImageUrl)
                }
                
                if let petProfileImageUrl = dictionary["petProfileImageUrl"] as? String {
                    self.petImageLarge.loadImageUsingCacheWithURLString(urlString: petProfileImageUrl)
                }
            }
            
        }, withCancel: nil)
    }
    
    func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            print("User is not logged in")
            present(ViewController(), animated: true, completion: nil)
        }
        
    }
}
