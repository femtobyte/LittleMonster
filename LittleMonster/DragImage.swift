//
//  DragImage.swift
//  LittleMonster
//
//  Created by C Sinclair on 11/8/15.
//  Copyright © 2015 femtobyte. All rights reserved.
//

import Foundation
import UIKit

class DragImage: UIImageView{
    
    var originalPosition: CGPoint!      // coordinate with x,y
    var dropTarget: UIView?             // target for image being dragged
    
    //  required inits when inheriting from UIImageView class
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        originalPosition = self.center
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //  gets first touch, using if let because first is an optional.
        //  grab location of touch in superview
        //  move our center to the location of touch
        //  moves object to whereever touch happens.
        if let touch = touches.first{
            let position = touch.locationInView(self.superview)
            self.center = CGPointMake(position.x, position.y)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // if both if let's are true, go into code block
        if let touch = touches.first, let target = dropTarget{              //  checks that a value is in both initial touch and target
            let position = touch.locationInView(self.superview)             //  sets position to current touch
            if CGRectContainsPoint(target.frame, position){                 //  checks if current touch is in target rect, if so, sends notification.   ViewController will be listening for this notification and do something when it gets it
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "onTargetDropped", object: nil))
            }
        }
        
        self.center = originalPosition
    }
}