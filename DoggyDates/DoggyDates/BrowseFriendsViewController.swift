//
//  BrowseFriendsViewController.swift
//  DoggyDates
//
//  Created by Jayne Pietraszkiewicz on 10/5/17.
//  Copyright © 2017 Deakin. All rights reserved.
//
//  Reference:
//  Moeykens, M 2017, iOS Tinder-Like Swipe - Part 1- UIPanGestureRecognizer (Xcode 8, Swift 3), YouTube, retrieved on 13 May 2017, <https://youtu.be/0fXR-Ksuqo4>
//
//  Saoudrizwan 2017, Card Slider for Swift, GitHub.com, retrieved 13 May 2017, <https://github.com/saoudrizwan/CardSlider>
//
//
//


import UIKit
import Firebase
import FirebaseDatabase

class BrowseFriendsViewController: UIViewController {

    // divisor variable for image rotation.
    var divisor: CGFloat!
    var anotherDivisor: CGFloat!
    
    @IBOutlet var noMoreLbl: UILabel!
    
    var users = [User]()
    var cards = [ImageCard]()
    
    // Scale and alpha of successive cards visible to the user
    let cardAttributes: [(downscale: CGFloat, alpha: CGFloat)] = [(1, 1), (1, 1), (1, 1), (1, 1)]
    let cardInteritemSpacing: CGFloat = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // rotate card to the right on button click
        divisor = (view.frame.width / 2) / 0.61
        // rotate card to the left on button click
        anotherDivisor = (view.frame.width / 2) / -0.61
        
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)

        // 1. create a deck of cards
        for _ in 1...5 {
            let count = cards.count
            let card = ImageCard(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 60, height: self.view.frame.height * 0.6))
            cards.append(card)
            if count == 0 {
                noMoreLbl.text = "No more friends to display at this time.\nCheck back later!"
                noMoreLbl.numberOfLines = 0
                noMoreLbl.isHidden = false                
            }
        }
        
        // 2. layout the first 4 cards for the user
        layoutCards()
    }
    
    // Set up the frames, alphas, and transforms of the first 4 cards on the screen
    func layoutCards() {
        // frontmost card (first card of the deck)
        let firstCard = cards[0]
        self.view.addSubview(firstCard)
        firstCard.layer.zPosition = CGFloat(cards.count)
        firstCard.center = self.view.center
        firstCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGesture)))
        
        // the next 3 cards in the deck
        for i in 1...3 {
            if i > (cards.count - 1) { continue }
            let card = cards[i]
            card.layer.zPosition = CGFloat(cards.count - i)
            
            // here we're just getting some hand-picked values from cardAttributes (an array of tuples)
            // which will tell us the attributes of each card in the 4 cards visible to the user
            let downscale = cardAttributes[i].downscale
            let alpha = cardAttributes[i].alpha
            card.transform = CGAffineTransform(scaleX: downscale, y: downscale)
            card.alpha = alpha
            
            // position each card so there's a set space (cardInteritemSpacing) between each card, to give it a fanned out look
            card.center.x = self.view.center.x
            card.frame.origin.y = cards[0].frame.origin.y - (CGFloat(i) * cardInteritemSpacing)
            // workaround: scale causes heights to skew so compensate for it with some tweaking
            if i == 3 {
                card.frame.origin.y += 1.5
            }
            self.view.addSubview(card)
        }
        
        // make sure that the first card in the deck is at the front
        self.view.bringSubview(toFront: cards[0])
    }

    // This is called whenever the front card is swiped off the screen or is animating away from its initial position.
    // showNextCard() adds the next card to the 4 visible cards and animates each card to move forward.
    func showNextCard() {
        let animationDuration: TimeInterval = 0.2
        // animate each card to move forward one by one
        for i in 1...3 {
            if i > (cards.count - 1) { continue }
            let card = cards[i]
            let newDownscale = cardAttributes[i - 1].downscale
            let newAlpha = cardAttributes[i - 1].alpha
            UIView.animate(withDuration: animationDuration, delay: (TimeInterval(i - 1) * (animationDuration / 2)), usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
                card.transform = CGAffineTransform(scaleX: newDownscale, y: newDownscale)
                card.alpha = newAlpha
                if i == 1 {
                    card.center = self.view.center
                } else {
                    card.center.x = self.view.center.x
                    card.frame.origin.y = self.cards[1].frame.origin.y - (CGFloat(i - 1) * self.cardInteritemSpacing)
                }
            }, completion: { (_) in
                if i == 1 {
                    card.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.panGesture)))
                }
            })
        }
        
        // add a new card (now the 4th card in the deck) to the very back
        if 4 > (cards.count - 1) {
            if cards.count != 1 {
                self.view.bringSubview(toFront: cards[1])
            }
            return
        }
        let newCard = cards[4]
        newCard.layer.zPosition = CGFloat(cards.count - 4)
        let downscale = cardAttributes[3].downscale
        let alpha = cardAttributes[3].alpha
        
        // initial state of new card
        newCard.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        newCard.alpha = 0
        newCard.center.x = self.view.center.x
        newCard.frame.origin.y = cards[1].frame.origin.y - (4 * cardInteritemSpacing)
        self.view.addSubview(newCard)
        
        // animate to end state of new card
        UIView.animate(withDuration: animationDuration, delay: (3 * (animationDuration / 2)), usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
            newCard.transform = CGAffineTransform(scaleX: downscale, y: downscale)
            newCard.alpha = alpha
            newCard.center.x = self.view.center.x
            newCard.frame.origin.y = self.cards[1].frame.origin.y - (3 * self.cardInteritemSpacing) + 1.5
        }, completion: nil)
        
        // first card needs to be in the front for proper interactivity
        self.view.bringSubview(toFront: cards[1])
    }
    
    // Whenever the front card is off the screen, this method is called in order to remove the card from our data structure and from the view.
    func removeOldFrontCard() {
        cards[0].removeFromSuperview()
        cards.remove(at: 0)
    }

    // This function continuously checks to see if the card's center is on the screen anymore. If it finds that the card's center is not on screen, then it triggers removeOldFrontCard() which removes the front card from the data structure and from the view.
    func hideFrontCard() {
        if #available(iOS 10.0, *) {
            var cardRemoveTimer: Timer? = nil
            cardRemoveTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { [weak self] (_) in
                guard self != nil else { return }
                if !(self!.view.bounds.contains(self!.cards[0].center)) {
                    cardRemoveTimer!.invalidate()
                    UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: { [weak self] in
                        guard self != nil else { return }
                        self!.cards[0].alpha = 0.0
                        }, completion: { [weak self] (_) in
                            self!.removeOldFrontCard()
                    })
                }
            })
        } else {
            // fallback for earlier versions
            UIView.animate(withDuration: 0.2, delay: 1.5, options: [.curveEaseIn], animations: {
                self.cards[0].alpha = 0.0
            }, completion: { (_) in
                self.removeOldFrontCard()
            })
        }
    }

    // UIKit dynamics variables that we need references to.
    var dynamicAnimator: UIDynamicAnimator!
    var cardAttachmentBehavior: UIAttachmentBehavior!
    
    @IBAction func panGesture(_ sender: UIPanGestureRecognizer) {

        // distance user must pan right or left to trigger an option
        let requiredOffsetFromCenter: CGFloat = 10
        
        let panLocationInView = sender.location(in: view)
        let panLocationInCard = sender.location(in: cards[0])
        
        // depending on what state the pan gesture is at, depends on what action is taken
        switch sender.state {
        
        // gesture begin
        case .began:
            dynamicAnimator.removeAllBehaviors()
            let offset = UIOffsetMake(panLocationInCard.x - cards[0].bounds.midX, panLocationInCard.y - cards[0].bounds.midY);
            // card is attached to center
            cardAttachmentBehavior = UIAttachmentBehavior(item: cards[0], offsetFromCenter: offset, attachedToAnchor: panLocationInView)
            dynamicAnimator.addBehavior(cardAttachmentBehavior)
            
        // gesture changed
        case .changed:
            cardAttachmentBehavior.anchorPoint = panLocationInView
            
                // if card center is moved to the right of the middle, show LIKE label
            if cards[0].center.x > (self.view.center.x + requiredOffsetFromCenter) {
                cards[0].showOptionLabel(option: .like1)
            
                // if card center is moved to the left of the middle, show PASS label
            } else if cards[0].center.x < (self.view.center.x - requiredOffsetFromCenter) {
                cards[0].showOptionLabel(option: .dislike1)
            } else {
                // if neither, hide both labels
                cards[0].hideOptionLabel()
            }
        
        // gesture has ended
        case .ended:
            dynamicAnimator.removeAllBehaviors()
            
            // if card is moved from centre and not off the screen...
            if !(cards[0].center.x > (self.view.center.x + requiredOffsetFromCenter) || cards[0].center.x < (self.view.center.x - requiredOffsetFromCenter)) {
                // snap card back to center
                let snapBehavior = UISnapBehavior(item: cards[0], snapTo: self.view.center)
                dynamicAnimator.addBehavior(snapBehavior)
                
            // else flick card off the screen
            } else {
                let velocity = sender.velocity(in: self.view)
                let pushBehavior = UIPushBehavior(items: [cards[0]], mode: .instantaneous)
                pushBehavior.pushDirection = CGVector(dx: velocity.x/10, dy: velocity.y/10)
                pushBehavior.magnitude = 175
                dynamicAnimator.addBehavior(pushBehavior)
                // spin after throwing
                var angular = CGFloat.pi / 2 // angular velocity of spin
                
                let currentAngle: Double = atan2(Double(cards[0].transform.b), Double(cards[0].transform.a))
                
                if currentAngle > 0 {
                    angular = angular * 1
                } else {
                    angular = angular * -1
                }
                let itemBehavior = UIDynamicItemBehavior(items: [cards[0]])
                itemBehavior.friction = 0.2
                itemBehavior.allowsRotation = true
                itemBehavior.addAngularVelocity(CGFloat(angular), for: cards[0])
                dynamicAnimator.addBehavior(itemBehavior)
                
                // hide that top card
                hideFrontCard()
                // bring second card to top
                showNextCard()
            }
        default: break
        }
    }
    
    @IBAction func crossBtn(_ sender: UIButton) {
        let middle = view.frame.width / 2
        
        UIView.animate(withDuration: 0.75) {
            self.cards[0].center = CGPoint(x: self.view.center.x - 200, y: self.view.center.y + 75)
            self.cards[0].alpha = 0
            let scale = min(60/abs(middle),1)
            self.cards[0].transform = CGAffineTransform(rotationAngle: middle / self.anotherDivisor).scaledBy(x: scale, y: scale)
        }
        // hide that top card
        hideFrontCard()
        // bring second card to top
        showNextCard()
    }
    
    
    @IBAction func heartBtn(_ sender: UIButton) {
        let middle = view.frame.width / 2
        
        UIView.animate(withDuration: 0.75) {
            self.cards[0].center = CGPoint(x: self.view.center.x + 200, y: self.view.center.y + 75)
            self.cards[0].alpha = 0
            let scale = min(60/abs(middle),1)
            self.cards[0].transform = CGAffineTransform(rotationAngle: middle / self.divisor).scaledBy(x: scale, y: scale)
        }
        // hide that top card
        hideFrontCard()
        // bring second card to top
        showNextCard()
    }
    
    @IBAction func infoBtn(_ sender: UIButton) {
        
        
        
        
    }
    
    
    // called in the unwind segue - exit Profile Page One
    @IBAction func unWindSegue(segue : UIStoryboardSegue){
    }
    
}
