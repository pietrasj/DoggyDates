//
//  ImageCard.swift
//  DoggyDates
//
//  Created by Jayne Pietraszkiewicz on 15/5/17.
//  Copyright © 2017 Deakin. All rights reserved.
//

import UIKit

class ImageCard: CardView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // image
        let imageView = UIImageView(image: UIImage(named: "404776_10150823903140744_1654618485_n"))
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.black
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        
        imageView.frame = CGRect(x: 12, y: 12, width: self.frame.width - 24, height: self.frame.height - 103)
        self.addSubview(imageView)
        
        // text boxes - can use this to add labels for name, age etc
        
        let petNameLbl = UILabel()
        petNameLbl.text = "Zeus, 5 years old"
        petNameLbl.frame = CGRect(x: 12, y: imageView.frame.maxY + 15, width: 200, height: 24)
        self.addSubview(petNameLbl)
         /*
         let textBox2 = UIView()
         textBox2.backgroundColor = UIColor(red: 67/255, green: 79/255, blue: 182/255, alpha: 1.0)
         textBox2.layer.cornerRadius = 12
         textBox2.layer.masksToBounds = true
         
         textBox2.frame = CGRect(x: 12, y: textBox1.frame.maxY + 10, width: 120, height: 24)
         self.addSubview(textBox2)
         */
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

