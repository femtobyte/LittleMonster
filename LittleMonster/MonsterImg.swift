//
//  MonsterImg.swift
//  LittleMonster
//
//  Created by C Sinclair on 11/9/15.
//  Copyright © 2015 femtobyte. All rights reserved.
//

import Foundation
import UIKit

class MonsterImg: UIImageView{
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    func playIdleAnimation(anim: String){
        self.image = UIImage(named: "\(anim).png")        //sets default image for when not animating
        self.animationImages = nil
        
        var imgArray = [UIImage]()                      //  make temp array, add 4 images of a set of 4 in asset folder for animation
        for var x = 1; x <= 4; x++ {
            let img = UIImage(named: "\(anim)\(x).png")    //  loop thru and assign images individually, then in next line, add to the array
            imgArray.append(img!)                       //  ok to use ! here, as you know you have the images in your asset folder
        }
        
        self.animationImages = imgArray                 //  add images from above loop into monsterImg
        self.animationDuration = 0.8                    //  how long it takes to cycle thru animation images
        self.animationRepeatCount = 0                   //  if you put 0, it will repeat indefinately
        self.startAnimating()
    }
    
    func playDeathAnimation(anim: String){
        self.animationImages = nil                      //  clears out image cache (my words)
        self.image = UIImage(named: "\(anim).png")        //  sets default image so char doesn't reset to alive after dying
        
        var imgArray = [UIImage]()
        for var x = 1; x <= 5; x++ {
            let img = UIImage(named: "\(anim)\(x).png")
            imgArray.append(img!)
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()
        self.image = UIImage(named: "\(anim)5.png")
    }

}

