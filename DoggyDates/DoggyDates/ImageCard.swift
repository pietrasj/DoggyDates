//
//  ImageCard.swift
//  DoggyDates
//
//  Created by Jayne Pietraszkiewicz on 15/5/17.
//  Copyright © 2017 Deakin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class ImageCard: CardView {
    
    var users = [User]()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // check if user is logged in
        if FIRAuth.auth()?.currentUser?.uid == nil {
            print("User is not logged in")
        }
        
        // get pet profile imagesimage
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
            
            let petNameLbl = UILabel()
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                if let petProfileImageUrl = dictionary["petProfileImageUrl"] as? String {
                    
                    self.imageView.loadImageUsingCacheWithURLString(urlString: petProfileImageUrl)
                    self.imageView.contentMode = .scaleAspectFill
                    self.imageView.backgroundColor = UIColor.black
                    self.imageView.layer.cornerRadius = 5
                    self.imageView.layer.masksToBounds = true
                    
                    self.imageView.frame = CGRect(x: 12, y: 12, width: self.frame.width - 24, height: self.frame.height - 103)
                    self.addSubview(self.imageView)
                    self.addSubview(petNameLbl)
                }
                if snapshot != nil {
                    let pName = dictionary["petName"] as! String
                    let pAge = dictionary["petAge"] as! String
                    let pMY = dictionary["petAgeMMYY"] as! String
                    petNameLbl.text = "\(pName), \(pAge) \(pMY) old"
                    petNameLbl.frame = CGRect(x: 12, y: self.imageView.frame.maxY + 15, width: 200, height: 24)
                }
                
            }
            
            
        }, withCancel: nil)
 
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func fetchUser() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            //print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                for user in self.users {
                    user.setValuesForKeys(dictionary)
                    self.users.append(user)
                    print(user.name1)
                }
            }
            
        }, withCancel: nil)
    }
    
}

