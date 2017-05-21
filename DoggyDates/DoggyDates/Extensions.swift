//
//  Extensions.swift
//  DoggyDates
//
//  Created by Jayne Pietraszkiewicz on 11/5/17.
//  Copyright © 2017 Deakin. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithURLString(urlString: String) {
        
        self.image = nil
        
        // check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // otherwise fire off call to download images
        let url = NSURL(string: urlString)
        URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
            
            // download hit an error
            if error != nil {
                print(error ?? "")
                return
            }
            DispatchQueue.main.async {
                
                
                if let downloadImage = UIImage(data:data!) {
                    imageCache.setObject(downloadImage, forKey: urlString as AnyObject)
                    
                    self.image = downloadImage
                    
                }

            }
        }).resume()

    }
    
}
