//
//  ProfilePageThreeViewController.swift
//  DoggyDates
//
//  Created by Jayne Pietraszkiewicz on 4/5/17.
//  Copyright © 2017 Deakin. All rights reserved.
//

import UIKit

class ProfilePageThreeViewController: UIViewController {

    @IBOutlet weak var thanksLbl: UILabel!
    @IBOutlet weak var startSearchingLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // label text, span across multiple lines
        thanksLbl.numberOfLines = 0
        thanksLbl.text = "Thank you for\nSigning up!"
        startSearchingLbl.numberOfLines = 0
        startSearchingLbl.text = "Start searching for new\nfriends now!"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // when the start button is pressed
    @IBAction func startBtn(_ sender: UIButton) {
        // navigate to the Browsing View Controller
        //present(BrowseFriendsViewController(), animated: true, completion: nil)
        self.performSegue(withIdentifier: "startBrowsingSegue", sender: self)

    }
    
}
