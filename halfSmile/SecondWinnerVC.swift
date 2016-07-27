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

class SecondWinnerVC: UIViewController {
    
    var mySegueDictionary = [String: AnyObject]()
    var dict = [String: AnyObject]()
    
    @IBOutlet weak var topImage: UIImageView!
//    @IBOutlet weak var bottomImage: UIImageView!
    
    @IBOutlet weak var shadow: UIView!
    
    @IBOutlet weak var randomViewForAnimation: UIView!
    
    var person1: Person!
    var person2: Person!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseDict()
//        findFace(person1, personImageView: topImage)
        
        shadow.hidden = true
        topImage.hidden = true

//        findFace(person2, personImageView: bottomImage)
    }
    
    var topAlphaView1: UIView!
    var bottomAlphaView1: UIView!
    var hasCompletedOnce = false

    override func viewWillAppear(animated: Bool) {
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let firstPersonDict = ["person": person1, "img": topImage]
        let secondPersonDict = ["person": person2, "img": topImage]
        NSTimer.scheduledTimerWithTimeInterval(0.0, target: self, selector: #selector(WinnerVC.animateZoom(_:)), userInfo: firstPersonDict, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(3.5, target: self, selector: #selector(WinnerVC.animateZoom(_:)), userInfo: secondPersonDict, repeats: false)

    }

    
    
    
    func parseDict(){
        person1 = mySegueDictionary["person1"] as! Person
        person2 = mySegueDictionary["person2"] as! Person
    }
    
    func findFace(person: Person, personImageView: UIImageView){
        var cgImageObject: CGImage!
        let rectFace = CGRectMake(CGFloat(person.faceLeft), CGFloat(person.faceTop), CGFloat(person.faceWidth), CGFloat(person.faceHeight))
        cgImageObject = CGImageCreateWithImageInRect(person.selfieImage.CGImage, rectFace)
        personImageView.image = UIImage(CGImage: cgImageObject!)
        personImageView.roundCornersForAspectFit(5)
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

        let original = shadow.center.x
        shadow.center.x = -shadow.frame.width
        topImage.hidden = false
        shadow.hidden = false
        personImageView.hidden = false
        for faceDotView in faceDotViews{
            faceDotView.removeFromSuperview()
        }
        
        UIView.animateWithDuration(0.5, delay: 0.1, usingSpringWithDamping: 1.5, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.shadow.center.x  = original

        }){ (true) in
//            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
//                view.alpha = 0.0
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
                                                                                    
                                                                                    UIView.animateWithDuration(0.25, animations: {
                                                                                        self.randomViewForAnimation.center.x = self.randomViewForAnimation.center.x - 50
                                                                                        }, completion: { (true) in
                                                                                            UIView.animateWithDuration(0.2, animations: {
                                                                                                view.alpha = 0.35
                                                                                                }, completion: {(true) in
                                                                                                    UIView.animateWithDuration(0.5, delay: 0.3, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseIn
                                                                                                        , animations: {
                                                                                                            self.shadow.center.x = self.view.frame.width + 300
                                                                                                        }, completion: {(true) in
                                                                                                            personImageView.hidden = true
                                                                                                            personImageView.image = UIImage(named: "giraffe")
                                                                                                            view.alpha = 0
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
  //                                          })
                                    })
                            })
                    })

        })
            

            
        }
    }
    
    var faceDotViews = [UIView]()
    
    func makeFrameForFacePoints(xPoint: Int, yPoint: Int, person: Person, personImageView: UIImageView){
        var rect = AVMakeRectWithAspectRatioInsideRect((personImageView.image?.size)!, personImageView.bounds)
        let imageStartPointX = ((personImageView.frame.size.width) - rect.width) / 2
        let imageStartPointY = ((personImageView.frame.size.height) - rect.height) / 2
        
        let frame1 = CGRectMake(CGFloat(xPoint - person.faceLeft) * rect.width / (personImageView.image?.size.width)! - 3 + imageStartPointX, CGFloat(yPoint - person.faceTop) * rect.height / (personImageView.image?.size.height)! - 3 + imageStartPointY, 6, 6)
        let view = UIView(frame: frame1)
        view.backgroundColor = UIColor(red: 255.0/255.0, green: 87.0/255.0, blue: 34.0/255.0, alpha: 1.0)
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
