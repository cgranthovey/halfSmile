//
//  SecondWinnerVC.swift
//  halfSmile
//
//  Created by Chris Hovey on 7/15/16.
//  Copyright © 2016 Chris Hovey. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
import Canvas

class SecondWinnerVC: UIViewController, AVAudioPlayerDelegate {
    
    var mySegueDictionary = [String: AnyObject]()
    var dict = [String: AnyObject]()
    
    @IBOutlet weak var topImage: UIImageView!
//    @IBOutlet weak var bottomImage: UIImageView!
    
    @IBOutlet weak var shadow: UIView!
    
    @IBOutlet weak var randomViewForAnimation: UIView!
    
    
    var person1: Person!
    var person2: Person!
    var sfxTick: AVAudioPlayer!
    var sfxSwing: AVAudioPlayer!
    var sfxSwing2: AVAudioPlayer!
    var sfxWind: AVAudioPlayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        parseDict()
        parseFacePointColor()
        shadow.hidden = true
        topImage.hidden = true
    }
    
    var topAlphaView1: UIView!
    var bottomAlphaView1: UIView!
    var hasCompletedOnce = false

    override func viewWillAppear(animated: Bool) {
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        initAudio()
        
        

        let firstPersonDict = ["person": person1, "img": topImage]
        let secondPersonDict = ["person": person2, "img": topImage]
        NSTimer.scheduledTimerWithTimeInterval(0.0, target: self, selector: #selector(WinnerVC.animateZoom(_:)), userInfo: firstPersonDict, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(3.95, target: self, selector: #selector(WinnerVC.animateZoom(_:)), userInfo: secondPersonDict, repeats: false)

    }
    
    var facePointColor: UIColor!
    
    func parseFacePointColor(){
        if let color = dict["color"] as? UIColor{
            facePointColor = color
        }
    }

    func initAudio(){
        do {
            print("arnold 2")
            try sfxTick = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("poolBalls", ofType: "mp3")!))
            sfxTick.prepareToPlay()
            sfxTick.volume = 0.3
            try sfxWind = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("wind", ofType: "mp3")!))
            sfxWind.prepareToPlay()
            sfxWind.volume = 0.5
            try sfxSwing = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("swish", ofType: "mp3")!))
            sfxSwing.prepareToPlay()
            sfxSwing.volume = 0.05

            if sfxSwing == nil{
                print("sfxswing nil")
            }


        } catch let err as NSError {
            print(err.debugDescription)
        }
    }

    func sfxTickFunc(){
        if sfxTick.playing{
            sfxTick.stop()
            sfxTick.currentTime = 0
        }
        sfxTick.play()
    }
    
    
    func parseDict(){
        person1 = mySegueDictionary["person1"] as! Person
        person2 = mySegueDictionary["person2"] as! Person
    }
    
    func radians (degrees: Double) -> CGFloat{
        return CGFloat(degrees * M_PI / 180)
    }
    

    func findFace(person: Person, personImageView: UIImageView){
        var cgImageObject: CGImage!
        let rectFace = CGRectMake(CGFloat(person.faceLeft), CGFloat(person.faceTop), CGFloat(person.faceWidth), CGFloat(person.faceHeight))
        
        print("face left\(person.faceLeft)")
        print("face top\(person.faceTop)")
        print("face width \(person.faceWidth)")
        print("face height \(person.faceHeight)")
        
        
     
        cgImageObject = CGImageCreateWithImageInRect(person.selfieImage.CGImage!, rectFace)


        var hey = person.selfieImage
        var yo  = hey.fixOrientation()
        var yoToCG = yo.CGImage
        
        var ai = CGImageCreateWithImageInRect(yoToCG, rectFace)
        var aiToUI = UIImage(CGImage: ai!)
        personImageView.image = aiToUI
        

        personImageView.roundCornersForAspectFit(5)
    }
    
    func swoosh(number: Int){
        if number == 1{
            sfxSwing.play()
        } else if number == 2{
            sfxSwing2.play()
        }
    }
    
    @objc func animateZoom(timer: NSTimer){
        
        var dict = timer.userInfo as? Dictionary<String, AnyObject>
        let person = dict!["person"] as! Person
        let personImageView = dict!["img"] as! UIImageView
//        let view = dict!["alpha"] as! UIView
        
        findFace(person, personImageView: personImageView)
        
        if topAlphaView1 == nil{
            topAlphaView1 = makeAlphaView(topImage)
        }
        let view = topAlphaView1
        view.alpha = 0.45

        let original = shadow.center.x
        shadow.center.x = -shadow.frame.width
        topImage.hidden = false
        shadow.hidden = false
        personImageView.hidden = false
        for faceDotView in faceDotViews{
            faceDotView.removeFromSuperview()
        }
        
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.5, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.shadow.center.x  = original
            self.sfxWind.play()

        }){ (true) in
//            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
//                }, completion: { (true) in
                    UIView.animateWithDuration(0.2, animations: {
                        self.randomViewForAnimation.center.x = self.randomViewForAnimation.center.x + 50
                        }, completion: { (true) in
                            UIView.animateWithDuration(0.2, animations: {
                                self.makeFrameForFacePoints(person.mouthLeftX, yPoint: person.mouthLeftY, person: person, personImageView: personImageView)
                                }, completion: { (true) in
                                    UIView.animateWithDuration(0.2, animations: {
                                        self.makeFrameForFacePoints(person.underLipBottomX, yPoint: person.underLipBottomY, person: person, personImageView: personImageView)
                                        }, completion: { (true) in
                                            UIView.animateWithDuration(0.2, animations: {
                                                self.makeFrameForFacePoints(person.mouthRightX, yPoint: person.mouthRightY, person: person, personImageView: personImageView)
                                                }, completion: { (true) in
                                                    UIView.animateWithDuration(0.2, animations: {
                                                        self.makeFrameForFacePoints(person.upperLipTopX, yPoint: person.upperLipTopY, person: person, personImageView: personImageView)
                                                        }, completion: { (true) in
                                                            UIView.animateWithDuration(0.2, animations: {
                                                                self.makeFrameForFacePoints(person.noseTipX, yPoint: person.noseTipY, person: person, personImageView: personImageView)
                                                                }, completion: { (true) in
                                                                    UIView.animateWithDuration(0.2, animations: {
                                                                        self.makeFrameForFacePoints(person.pupilLeftX, yPoint: person.pupilLeftY, person: person, personImageView: personImageView)
                                                                        }, completion: { (true) in
                                                                            UIView.animateWithDuration(0.2, animations: {
                                                                                self.makeFrameForFacePoints(person.pupileRightX, yPoint: person.pupilRightY, person: person, personImageView: personImageView)
                                                                                }, completion: { (true) in
                                                                                    
                                                                                    UIView.animateWithDuration(0.20, animations: {
                                                                                        self.randomViewForAnimation.center.x = self.randomViewForAnimation.center.x - 65
                                                                                        }, completion: { (true) in
                                                                                            UIView.animateWithDuration(0.35, animations: {
                                                                                                self.randomViewForAnimation.center.x = self.randomViewForAnimation.center.x + 15
                                                                                                }, completion: {(true) in
                                                                                                    UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseIn
                                                                                                        , animations: {
                                                                                                            self.shadow.center.x = self.view.frame.width + 300
                                                                                                            self.sfxSwing.play()
                                                                                                        }, completion: {(true) in
                                                                                                            personImageView.hidden = true
                                                                                                            personImageView.image = UIImage(named: "giraffe")
//                                                                                                            view.alpha = 0
                                                                                                            if self.hasCompletedOnce == true{
                                                                                                                self.performSegueWithIdentifier("ResultVC", sender: nil)
                                                                                                            }
                                                                                                            self.hasCompletedOnce = true
                                                                                                    })
                                                                                            })
                                                                                    })
                                                                            })
                                                                    })
                                                            })
                                                    })
                                            })
  //                                  })
                            })
                    })

        })
            

            
        }
    }

    
    var faceDotViews = [UIView]()
    
    func makeFrameForFacePoints(xPoint: Int, yPoint: Int, person: Person, personImageView: UIImageView){
        
        self.sfxTickFunc()
        
        var rect = AVMakeRectWithAspectRatioInsideRect((personImageView.image?.size)!, personImageView.bounds)
        let imageStartPointX = ((personImageView.frame.size.width) - rect.width) / 2
        let imageStartPointY = ((personImageView.frame.size.height) - rect.height) / 2
        
        let frame1 = CGRectMake(CGFloat(xPoint - person.faceLeft) * rect.width / (personImageView.image?.size.width)! - 3 + imageStartPointX, CGFloat(yPoint - person.faceTop) * rect.height / (personImageView.image?.size.height)! - 3 + imageStartPointY, 6, 6)
        let view = UIView(frame: frame1)
        view.backgroundColor = facePointColor
        faceDotViews.append(view)
        personImageView.addSubview(view)
    }
    
    
    
    func makeAlphaView(personImageView: UIImageView) -> UIView {
        var rect = AVMakeRectWithAspectRatioInsideRect((personImageView.image?.size)!, personImageView.bounds)
        let imageStartPointX = ((personImageView.frame.size.width) - rect.width) / 2
        let imageStartPointY = ((personImageView.frame.size.height) - rect.height) / 2
        let frame1 = CGRectMake(imageStartPointX, imageStartPointY, rect.width, rect.height)
        let view = UIView(frame: frame1)
        view.backgroundColor = UIColor.blackColor()
        view.alpha = 0.0
        personImageView.addSubview(view)
        return view
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ResultVC"{
            if let vc = segue.destinationViewController as? ResultVC{
                if let segueDict = mySegueDictionary as? [String: AnyObject]{
                    vc.dict = self.dict
                    vc.segueDict = segueDict
                }
            }
        }
    }

}








