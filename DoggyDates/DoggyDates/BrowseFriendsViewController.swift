//
//  BrowseFriendsViewController.swift
//  DoggyDates
//
//  Created by Jayne Pietraszkiewicz on 10/5/17.
//  Copyright © 2017 Deakin. All rights reserved.
//

import UIKit

class BrowseFriendsViewController: UIViewController {

    // divisor variable for image rotation.
    var divisor: CGFloat!
    var anotherDivisor: CGFloat!
    var judgementDivisor: CGFloat!
    var anotherJudgementDivisor: CGFloat!
    
    @IBOutlet var cardStack: UIView!
    
    @IBOutlet var judgementImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // calculation for gradual rotation of card to 35 degrees (0.61 radian)
        divisor = (view.frame.width / 2) / 0.61
        anotherDivisor = (view.frame.width / 2) / -0.61
        // calculation for gradual rotation of judgement image 0.35 radian
        judgementDivisor = (view.frame.width / 2) / 0.50
        // calculation for gradual rotation of judgement image 0.35 radian
        anotherJudgementDivisor = (view.frame.width / 2) / -0.50
        
    }
    
    
    @IBAction func panGesture(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        
        // check if card centre is greater than view controller centre
        let xFromCentre = card.center.x - view.center.x
        
        // determine card centre
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        // card view rotation
        card.transform = CGAffineTransform(rotationAngle: xFromCentre / divisor)
        judgementImage.transform = CGAffineTransform(rotationAngle: xFromCentre / judgementDivisor)
        
        // if card centre is greater than view centre, show LIKE, else show PASS
        if xFromCentre > 0 {
            judgementImage.image = UIImage(named: "like")
            // offset Like image
            judgementImage.center = CGPoint(x: card.center.x - 20, y: 60)
        } else {
            judgementImage.image = UIImage(named: "pass")
            // offset Pass image
            judgementImage.center = CGPoint(x: card.center.x - 20, y: 60)
        }
        
        // set Like / Pass image alpha depending on how far it is moved left or right
        judgementImage.alpha = abs(xFromCentre) / view.center.x
        
        // if gesture is ended...
        if sender.state == UIGestureRecognizerState.ended {
            
            if card.center.x < 50 {
                // move card off to the left of the screen
                UIView.animate(withDuration: 0.5, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    card.alpha = 0
                })
                return
            } else if card.center.x > (view.frame.width - 50) {
                // move card off to the right of the screen
                UIView.animate(withDuration: 0.5, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                })
                return
            }
            
            // if touch gesture has ended by dragging off the screen or letting go, reset card view back to centre and hide LIKE or PASS
            UIView.animate(withDuration: 0.2, animations: {
                card.center = self.view.center
                self.judgementImage.alpha = 0
                card.transform = CGAffineTransform.identity
            })
        }
    }
    
    @IBAction func crossBtn(_ sender: UIButton) {
        // perform same animations as swipe gesture
        let middle = view.frame.width / 2
        
        // move card off to the right of the screen
        UIView.animate(withDuration: 0.5, animations: {
            self.cardStack.center = CGPoint(x: self.cardStack.center.x - 200, y: self.cardStack.center.y + 75)
            self.cardStack.alpha = 0
            // card view rotation
            self.cardStack.transform = CGAffineTransform(rotationAngle: middle / self.anotherDivisor)
            self.judgementImage.transform = CGAffineTransform(rotationAngle: middle / self.anotherJudgementDivisor)
            self.judgementImage.image = UIImage(named: "pass")
            self.judgementImage.alpha = 1
            // offset Like image
            self.judgementImage.center = CGPoint(x: self.cardStack.center.x - 50, y: 60)
        })
        return
    }
    
    
    @IBAction func heartBtn(_ sender: UIButton) {
        // perform same animations as swipe gesture
        let middle = view.frame.width / 2
        
        // move card off to the right of the screen
        UIView.animate(withDuration: 0.5, animations: {
            self.cardStack.center = CGPoint(x: self.cardStack.center.x + 200, y: self.cardStack.center.y + 75)
            self.cardStack.alpha = 0
            // card view rotation
            self.cardStack.transform = CGAffineTransform(rotationAngle: middle / self.divisor)
            self.judgementImage.transform = CGAffineTransform(rotationAngle: middle / self.judgementDivisor)
            self.judgementImage.image = UIImage(named: "like")
            self.judgementImage.alpha = 1
            // offset Like image
            self.judgementImage.center = CGPoint(x: self.cardStack.center.x - 50, y: 60)
        })
        return
    }
    
    @IBAction func infoBtn(_ sender: UIButton) {
        
        
        
        
    }
    
    
    // called in the unwind segue - exit Profile Page One
    @IBAction func unWindSegue(segue : UIStoryboardSegue){
    }
    
}
