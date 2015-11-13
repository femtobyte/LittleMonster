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
    //outlets for gameboard
    @IBOutlet weak var foodImg: DragImage!
    @IBOutlet weak var heartImg: DragImage!
    @IBOutlet weak var obeyImg: DragImage!
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!
    @IBOutlet weak var penalty3Img: UIImageView!
    @IBOutlet weak var restartBtn: UIButton!
    @IBOutlet weak var livesPanel: UIImageView!
    @IBOutlet weak var ground: UIImageView!
    @IBOutlet weak var skullStack: UIStackView!
    
    //outlets for char specific images
    @IBOutlet weak var bgImg: UIImageView!
    @IBOutlet weak var bigGuyGround: UIImageView!
    @IBOutlet weak var grassybgImg: UIImageView!
    @IBOutlet weak var lilMonsterImg: MonsterImg!
    @IBOutlet weak var monsterImg: MonsterImg!

    //outlets for initial char pick screen
    @IBOutlet weak var lilGuyBtn: UIButton!
    @IBOutlet weak var bigGuyBtn: UIButton!
    @IBOutlet weak var charPickLbl: UILabel!
    @IBOutlet weak var gameTitleLbl: UILabel!
    @IBOutlet weak var splashbg: UIImageView!
    @IBOutlet weak var bigGuyPickImg: UIImageView!
    @IBOutlet weak var lilGuyPickImg: UIImageView!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTY = 3
    
    var penalties = 0
    var timer: NSTimer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    var monsterDead = false
    var currentIdleAnim = ""
    var currentDeathAnim = ""
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    var sfxObey: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        //when calling music files, use a do/try, and catch for catching errors
        do{
            // could call this with 3 lines, setting up a variable for the resourcePath and for the NSURL, but this calls it all in one line.  Basically telling the AVAudioPlayer where the music file is to play.
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            try sfxObey = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bonk", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            sfxObey.prepareToPlay()
            
        }catch let err as NSError{
            print(err.debugDescription)
        }
        
    }
    
    
    @IBAction func onLilGuyBtnPressed(sender: AnyObject) {
        closeCharPickScreen()
        gamePlaySetUp()
        grassybgImg.hidden = false
        lilMonsterImg.hidden = false
        foodImg.dropTarget = lilMonsterImg
        heartImg.dropTarget = lilMonsterImg
        obeyImg.dropTarget = lilMonsterImg
        currentIdleAnim = "littleidle"
        currentDeathAnim = "littledead"
        lilMonsterImg.playIdleAnimation(currentIdleAnim)
    }
    
    @IBAction func onBigGuyBtnPressed(sender: AnyObject) {
        closeCharPickScreen()
        gamePlaySetUp()
        monsterImg.hidden = false
        bgImg.hidden = false
        ground.hidden = false
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        obeyImg.dropTarget = monsterImg
        currentIdleAnim = "idle"
        currentDeathAnim = "dead"
        monsterImg.playIdleAnimation(currentIdleAnim)
    }
    
    func gamePlaySetUp(){
        foodImg.hidden = false
        heartImg.hidden = false
        obeyImg.hidden = false
        penalty1Img.hidden = false
        penalty2Img.hidden = false
        penalty3Img.hidden = false
        livesPanel.hidden = false
        skullStack.hidden = false
        restartBtn.hidden = true
        resetPenalties()
        startTimer()
    }
    
    func closeCharPickScreen(){
        lilGuyBtn.hidden = true
        bigGuyBtn.hidden = true
        charPickLbl.hidden = true
        gameTitleLbl.hidden = true
        splashbg.hidden = true
        lilGuyPickImg.hidden = true
        bigGuyPickImg.hidden = true
    }
    
    func resetPenalties(){
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        penalties = 0
    }
    
    func itemDroppedOnCharacter(notif: AnyObject){
//        print("frame \(monsterImg.frame)")
        monsterHappy = true
        startTimer()            //invalidates old timer, and restarts timer
        
        disableImg(heartImg)
        disableImg(foodImg)
        disableImg(obeyImg)
        
        if currentItem == 0{
            sfxHeart.play()
        }else if currentItem == 1{
            sfxBite.play()
        }else if currentItem == 2{
            sfxObey.play()
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
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
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
            let rand = arc4random_uniform(3)    //random number 0-2
            
            if rand == 0{
                disableImg(foodImg)
                heartImg.alpha = OPAQUE
                heartImg.userInteractionEnabled = true
            }else if rand == 1{
                disableImg(heartImg)
                foodImg.alpha = OPAQUE
                foodImg.userInteractionEnabled = true
            }else if rand == 2{
                disableImg(obeyImg)
                obeyImg.alpha = OPAQUE
                obeyImg.userInteractionEnabled = true
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
        if(currentDeathAnim == "dead"){
            monsterImg.playDeathAnimation(currentDeathAnim)
        }else if(currentDeathAnim == "littledead"){
            lilMonsterImg.playDeathAnimation(currentDeathAnim)
        }
        restartBtn.hidden = false
    }
    
    @IBAction func onRestartPressed(sender: AnyObject) {
        sfxSkull.play()
        restartBtn.hidden = true
        monsterDead = false
        resetPenalties()
        foodImg.alpha = OPAQUE
        foodImg.userInteractionEnabled = true
        obeyImg.alpha = OPAQUE
        obeyImg.userInteractionEnabled = true
        heartImg.alpha = OPAQUE
        heartImg.userInteractionEnabled = true
        startTimer()
        if(monsterImg.hidden == false){
            monsterImg.playIdleAnimation(currentIdleAnim)
        }else if(lilMonsterImg.hidden == false){
            lilMonsterImg.playIdleAnimation(currentIdleAnim)
        }
    }
  

}