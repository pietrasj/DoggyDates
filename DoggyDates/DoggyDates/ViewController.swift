//
//  ViewController.swift
//  DoggyDates
//
//  Created by Jayne Pietraszkiewicz on 3/5/17.
//  Copyright © 2017 Deakin. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate {

    @IBOutlet weak var loginBoxImg: UIImageView!
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var connectBtnLbl: UIButton!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var loginRegSC: UISegmentedControl!
    @IBOutlet weak var loadSpinner: UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set segmented control to rounded corners
        loginRegSC.layer.cornerRadius = 5.0
        loginRegSC.selectedSegmentIndex = 0

        // declare the FB Button
        let loginButton = FBSDKLoginButton()
        // add button to the view
        view.addSubview(loginButton)
        // button location on screen
        loginButton.frame = CGRect(x: 25, y: 495, width: 325, height: 40)
        loginButton.delegate = self
        // set read permissions
        loginButton.readPermissions = ["email", "public_profile"]
        
        // setup tap gesture for use when dismissing keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
        
        // Setting delegate of your UITextField to self in order to move up the view
        emailTxtFld.delegate = self
        passwordTxtFld.delegate = self
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
        emailTxtFld.resignFirstResponder()
        passwordTxtFld.resignFirstResponder()
    }


    // required for LoginButtonDelegate
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User has logged out of Facebook")
    }
    
    // required for LoginButtonDelegate. Handles what occurs when button is tapped.
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
        }
        
        print("Successfully logged into Facebook")
        showEmailAddress()
    }

    func showEmailAddress() {
        // obtain FB access token
        let accessToken = FBSDKAccessToken.current()
        // make the access token more secure
        guard let accessTokenString = accessToken?.tokenString else { return }
        // set credentials
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        // call firebase method to log FB user into Firebase DB
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("something went wrong with our FB user: ", error ?? "")
            }
            // successfully logged in
            self.performSegue(withIdentifier: "loginToBrowseSegue", sender: self)
            //print("Successfully logged in with our FB user")
        })
        
        // graph request to obtain email of user.
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start {
            (connection, result, err) in
            
            if err != nil {
                print("failed to start graph request", err ?? "")
                return
            }
            // print results of facebook login
            print(result ?? "")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginRegSegCtrl(_ sender: UISegmentedControl) {
        if loginRegSC.selectedSegmentIndex == 0 {
            loginBoxImg.image = UIImage(named: "signupbox")
            forgotPassword.isHidden = true
            connectBtnLbl.setTitle("Register", for: .normal)
        }
        else
        {
            loginBoxImg.image = UIImage(named: "signinbox")
            forgotPassword.isHidden = false
            connectBtnLbl.setTitle("Sign in", for: .normal)
        }
        
    }

    func handleLogin() {
        // make form safer by adding guard statement
        guard let email = emailTxtFld.text, let password = passwordTxtFld.text else {
            print("Form is not valid")
            return
        }
        
        // log user in with registered credentials
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error != nil {
                print(error ?? "")
            }
            self.loadSpinner.stopAnimating()
            // successfully logged in
            self.performSegue(withIdentifier: "loginToBrowseSegue", sender: self)
            //print("User has logged in successfully")
        })
    }
    
    func handleRegister() {
        // make form safer by adding guard statement
        guard let email = emailTxtFld.text, let password = passwordTxtFld.text else {
            print("Form is not valid")
            return
        }
        
        // register user in firebase
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error != nil {
                print(error ?? "")
                return
            }
            // get user's uid in order to organise Firebase
            guard let uid = user?.uid else {
                return
            }
            
            // successfully authorised user. save users to Firebase database
            let ref = FIRDatabase.database().reference(fromURL: "https://doggydates-384b3.firebaseio.com/")
            // create child nodes within firebase
            let usersReference = ref.child("users").child(uid)
            // save these values to firebase
            let values = ["email": email]
            usersReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    self.loadSpinner.stopAnimating()
                    return
                }
                self.loadSpinner.stopAnimating()
                self.performSegue(withIdentifier: "LoginRegToProfileOneSegue", sender: self)
            })
        })
    }
    
    @IBAction func connectBtn(_ sender: UIButton) {
        if loginRegSC.selectedSegmentIndex == 0 {
            spinnerAnimation()
            handleRegister()
        } else {
            spinnerAnimation()
            handleLogin()
        }
    }
    
    func spinnerAnimation() {
        loadSpinner.isHidden = false
        // if loadSpinner is not animated
        if loadSpinner.isAnimating == false {
            // start animation
            loadSpinner.startAnimating()
        }
    }
    
    // called in the unwind segue - exit Profile Page One
    @IBAction func unWindSegue(segue : UIStoryboardSegue){
        loadSpinner.isHidden = true
    }
    
    @IBAction func forgotPWBtn(_ sender: UIButton) {
    }
    
}

