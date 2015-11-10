//
//  ViewController.swift
//  LittleMonster
//
//  Created by C Sinclair on 11/6/15.
//  Copyright © 2015 femtobyte. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var foodImg: DragImage!
    @IBOutlet weak var heartImg: DragImage!
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!
    @IBOutlet weak var penalty3Img: UIImageView!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTY = 3
    
    var penalties = 0
    var timer: NSTimer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    var monsterDead = false
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("monsterImg is \(monsterImg.frame)")
        print("heartImg is \(heartImg.frame)")
        print("foodImg is \(foodImg.frame)")

        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        //when calling music files, use a do/try, and catch for catching errors
        do{
            // could call this with 3 lines, setting up a variable for the resourcePath and for the NSURL, but this calls it all in one line.  Basically telling the AVAudioPlayer where the music file is to play.
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            
        }catch let err as NSError{
            print(err.debugDescription)
        }

        startTimer()
    }
    
    func itemDroppedOnCharacter(notif: AnyObject){
        print("you are in the right spot")
        print("frame \(monsterImg.frame)")
        monsterHappy = true
        startTimer()            //invalidates old timer, and restarts timer
        
        disableImg(heartImg)
        disableImg(foodImg)
        
        if currentItem == 0{
            sfxHeart.play()
        }else{
            sfxBite.play()
        }
    }
    func disableImg(image: DragImage){
        image.alpha = DIM_ALPHA
        image.userInteractionEnabled = false
    }
    
    func startTimer(){
        if timer != nil{
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState(){
        
        if !monsterHappy{
            penalties++
            sfxSkull.play()
            
            if penalties == 1{
                penalty1Img.alpha = OPAQUE
                penalty2Img.alpha = DIM_ALPHA           //clean up, in case 2 isn't dimmed
            }else if penalties == 2{
                penalty2Img.alpha = OPAQUE
                penalty3Img.alpha = DIM_ALPHA
            }else if penalties >= 3{
                penalty3Img.alpha = OPAQUE
            }else {
                penalty1Img.alpha = DIM_ALPHA
                penalty2Img.alpha = DIM_ALPHA
                penalty3Img.alpha = DIM_ALPHA
            }
            
            if penalties >= MAX_PENALTY{
                gameOver()
            }
        }
        if (!monsterDead) {
            let rand = arc4random_uniform(2)    //random number 0 or 1
            
            if rand == 0{
                disableImg(foodImg)
                
                heartImg.alpha = OPAQUE
                heartImg.userInteractionEnabled = true
            }else{
                disableImg(heartImg)
                
                foodImg.alpha = OPAQUE
                foodImg.userInteractionEnabled = true
            }
            
            currentItem = rand
            monsterHappy = false
        }
    }
    
    func gameOver(){
        monsterDead = true
        timer.invalidate()
        sfxDeath.play()
        disableImg(heartImg)
        disableImg(foodImg)
        monsterImg.playDeathAnimation()
    }

}