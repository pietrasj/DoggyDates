//
//  CardView.swift
//  DoggyDates
//
//  Created by Jayne Pietraszkiewicz on 15/5/17.
//  Copyright © 2017 Deakin. All rights reserved.
//

import UIKit

public enum CardOption: String {
    case like1 = "LIKE"
    case dislike1 = "PASS"
}

class CardView: UIView {
    
    var greenLabel: CardViewLabel!
    var redLabel: CardViewLabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // card style
        
        self.backgroundColor = UIColor.white
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 10
        
        // PASS / LIKE labels on top left and right
        let padding: CGFloat = 20
        
        // LIKE
        greenLabel = CardViewLabel(origin: CGPoint(x: padding, y: padding), color: UIColor(red: 67/255, green: 136/255, blue: 204/255, alpha: 1.0))
        greenLabel.isHidden = true
        self.addSubview(greenLabel)
        
        // PASS
        redLabel = CardViewLabel(origin: CGPoint(x: frame.width - CardViewLabel.size.width - padding, y: padding), color: UIColor.red)
        redLabel.isHidden = true
        self.addSubview(redLabel)
 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showOptionLabel(option: CardOption) {
        if option == .like1 {
            
            greenLabel.text = option.rawValue
            
            // fade out redLabel
            if !redLabel.isHidden {
                UIView.animate(withDuration: 0.15, animations: {
                    self.redLabel.alpha = 0
                }, completion: { (_) in
                    self.redLabel.isHidden = true
                })
            }
            
            // fade in greenLabel
            if greenLabel.isHidden {
                greenLabel.alpha = 0
                greenLabel.isHidden = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.greenLabel.alpha = 1
                })
            }
            
        } else {
            
            redLabel.text = option.rawValue
            
            
            // fade out greenLabel
            if !greenLabel.isHidden {
                UIView.animate(withDuration: 0.15, animations: {
                    self.greenLabel.alpha = 0
                }, completion: { (_) in
                    self.greenLabel.isHidden = true
                })
            }
            
            // fade in redLabel
            if redLabel.isHidden {
                redLabel.alpha = 0
                redLabel.isHidden = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.redLabel.alpha = 1
                })
            }
        }
    }
    
    var isHidingOptionLabel = false
    
    func hideOptionLabel() {
        // fade out greenLabel
        if !greenLabel.isHidden {
            if isHidingOptionLabel { return }
            isHidingOptionLabel = true
            UIView.animate(withDuration: 0.15, animations: {
                self.greenLabel.alpha = 0
            }, completion: { (_) in
                self.greenLabel.isHidden = true
                self.isHidingOptionLabel = false
            })
        }
        // fade out redLabel
        if !redLabel.isHidden {
            if isHidingOptionLabel { return }
            isHidingOptionLabel = true
            UIView.animate(withDuration: 0.15, animations: {
                self.redLabel.alpha = 0
            }, completion: { (_) in
                self.redLabel.isHidden = true
                self.isHidingOptionLabel = false
            })
        }
    }
    
}

class CardViewLabel: UILabel {
    fileprivate static let size = CGSize(width: 150, height: 50)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // style of LIKE / PASS frame
        self.textColor = .white
        self.font = UIFont.boldSystemFont(ofSize: 48)
        self.textAlignment = .center
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.layer.zPosition = CGFloat(FLT_MAX)
    }
    
    convenience init(origin: CGPoint, color: UIColor) {
        
        self.init(frame: CGRect(x: origin.x, y: origin.y, width: CardViewLabel.size.width, height: CardViewLabel.size.height))
        self.backgroundColor = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
}
