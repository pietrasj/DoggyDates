//
//  EditProfileViewController.swift
//  DoggyDates
//
//  Created by Jayne Pietraszkiewicz on 12/5/17.
//  Copyright © 2017 Deakin. All rights reserved.
//

import UIKit

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
