//
//  SettingsMenuViewController.swift
//  DoggyDates
//
//  Created by Jayne Pietraszkiewicz on 11/5/17.
//  Copyright © 2017 Deakin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class SettingsMenuViewController: UIViewController{

    var users = [User]()
    
    @IBOutlet var petNameLbl: UILabel!
    @IBOutlet var ownerNameLbl: UILabel!
    @IBOutlet var petImageSmall: UIImageView!
    @IBOutlet var petImageLarge: UIImageView!
    @IBOutlet var ownerImage: UIImageView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkIfUserIsLoggedIn()
        fetchUser()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        navigationItem.title = "Settings"
        
        // set profile image to be circular
        ownerImage.layer.borderWidth = 1
        ownerImage.layer.masksToBounds = false
        ownerImage.layer.borderColor = UIColor.white.cgColor
        ownerImage.layer.cornerRadius = ownerImage.frame.height/2
        ownerImage.clipsToBounds = true
        
        petImageSmall.layer.borderWidth = 1
        petImageSmall.layer.masksToBounds = false
        petImageSmall.layer.borderColor = UIColor.white.cgColor
        petImageSmall.layer.cornerRadius = petImageSmall.frame.height/2
        petImageSmall.clipsToBounds = true
    }
    
    func fetchUser() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                //let user = User()
                //user.setValuesForKeys(dictionary)
                //self.users.append(user)
                //print(user.name1, user.email)
                
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
                self.petNameLbl.text = dictionary["petName"] as? String
                self.ownerNameLbl.text = dictionary["name1"] as? String
                
                
                if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                    self.ownerImage.loadImageUsingCacheWithURLString(urlString: profileImageUrl)
                }
                
                if let petProfileImageUrl = dictionary["petProfileImageUrl"] as? String {
                    self.petImageSmall.loadImageUsingCacheWithURLString(urlString: petProfileImageUrl)
                    self.petImageLarge.loadImageUsingCacheWithURLString(urlString: petProfileImageUrl)
                }
            }
            
        }, withCancel: nil)
    }
    
    func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            loadImages()
        }
        
    }
    
    func handleLogout() {
        do {
            try FIRAuth.auth()?.signOut()
            print("signed out!")
        } catch let logoutError {
            print(logoutError)
        }
        //let signInRegisterController = ViewController()
        present(ViewController(), animated: true, completion: nil)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
