//
//  WinnerVC.swift
//  halfSmile
//
//  Created by Chris Hovey on 7/14/16.
//  Copyright © 2016 Chris Hovey. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation



class WinnerVC: UIViewController {

    
    var mySegueDictionary = [String: AnyObject]()
    
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var bottomImage: UIImageView!
    
    var person1: Person!
    var person2: Person!
    
    @IBOutlet weak var darkenViewTop: UIView!
    @IBOutlet weak var darkenViewBottom: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseDict()
        
        topImage.image = person1.selfieImage
        bottomImage.image = person2.selfieImage
        
        findFace(person1, personImageView: topImage)
        findFace(person2, personImageView: bottomImage)
        
        
        
        let firstPersonDict = ["person": person1, "img": topImage, "view": darkenViewBottom]
        let secondPersonDict = ["person": person2, "img": bottomImage, "view": darkenViewTop]
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(WinnerVC.animateZoom(_:)), userInfo: firstPersonDict, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(WinnerVC.animateZoom(_:)), userInfo: secondPersonDict, repeats: false)

//        drawFaceRect()
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
    }
    
    @objc func animateZoom(timer: NSTimer){
        var dict = timer.userInfo as? Dictionary<String, AnyObject>
        let person = dict!["person"] as! Person
        let personImageView = dict!["img"] as! UIImageView
        let view = dict!["view"] as! UIView
        
        UIView.animateWithDuration(0.5, animations: {
            view.alpha = 0.6
        }){ (true) in
            UIView.animateWithDuration(0.15, animations: {
                self.makeFrameForFacePoints(person.mouthLeftX, yPoint: person.mouthLeftY, person: person, personImageView: personImageView)
            }){ (true) in
                UIView.animateWithDuration(0.15, animations: {
                    self.makeFrameForFacePoints(person.underLipBottomX, yPoint: person.underLipBottomY, person: person, personImageView: personImageView)
                    }, completion: { (true) in
                        UIView.animateWithDuration(0.15, animations: {
                            self.makeFrameForFacePoints(person.mouthRightX, yPoint: person.mouthRightY, person: person, personImageView: personImageView)
                            }, completion: { (true) in
                                UIView.animateWithDuration(0.15, animations: {
                                    self.makeFrameForFacePoints(person.upperLipTopX, yPoint: person.upperLipTopY, person: person, personImageView: personImageView)
                                    }, completion: { (true) in
                                        UIView.animateWithDuration(0.15, animations: {
                                            self.makeFrameForFacePoints(person.noseTipX, yPoint: person.noseTipY, person: person, personImageView: personImageView)
                                            }, completion: { (true) in
                                                UIView.animateWithDuration(0.15, animations: {
                                                    self.makeFrameForFacePoints(person.pupilLeftX, yPoint: person.pupilLeftY, person: person, personImageView: personImageView)
                                                    }, completion: { (true) in
                                                        UIView.animateWithDuration(0.5, animations: {
                                                            self.makeFrameForFacePoints(person.pupileRightX, yPoint: person.pupilRightY, person: person, personImageView: personImageView)
                                                            }, completion: { (true) in
                                                                view.alpha = 0
                                                        })
                                                })
                                        })
                                })
                        })
                })
            }
            
            }
    }
    
    
    func makeFrameForFacePoints(xPoint: Int, yPoint: Int, person: Person, personImageView: UIImageView){
        let frame1 = CGRectMake(CGFloat(xPoint - person.faceLeft) * personImageView.frame.width / (personImageView.image?.size.width)! - 2, CGFloat(yPoint - person.faceTop) * personImageView.frame.height / (personImageView.image?.size.height)! - 2, 5, 5)
        let view = UIView(frame: frame1)
        view.backgroundColor = UIColor(red: 255.0/255.0, green: 87.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        personImageView.addSubview(view)
    }

    
    
// was going to use this function to draw lines around the faces but couldn't figure out how to draw the lines.  This function can currently find the bounds of the Aspect fit picture, and then find the face in the picture which is a different aspect ratio than what we receive
//    func drawFaceRect(){
//        print(" faceHeight: \(person2.faceHeight) faceWidth: \(person2.faceWidth)")
//        
//        let rect = AVMakeRectWithAspectRatioInsideRect(person2.selfieImage.size, bottomImage.bounds)
//        let imageStartPointX = ((bottomImage.frame.size.width) - rect.width) / 2
//        let imageStartPointY = ((bottomImage.frame.size.height) - rect.height) / 2
//        
//        let rectFace = CGRectMake(CGFloat(self.person2.faceLeft), CGFloat(self.person2.faceTop), CGFloat(self.person2.faceWidth), CGFloat(self.person2.faceHeight))
//        let originFaceX = rectFace.origin.x * rect.width / (bottomImage.image?.size.width)!
//        let originFaceY = rectFace.origin.y * rect.height / (bottomImage.image?.size.height)!
//        let adjustedFaceWidth = rectFace.width * rect.width / (bottomImage.image?.size.width)!
//        let adjustedFaceHeight = rectFace.height * rect.height / (bottomImage.image?.size.height)!
//        
//        var aFrame = CGRectMake(imageStartPointX + originFaceX, imageStartPointY + originFaceY, 2, 2)
//        let headFrameView = UIView(frame: aFrame)
//        headFrameView.backgroundColor = UIColor.orangeColor()
//        headFrameView.alpha = 0.8
//        self.bottomImage.addSubview(headFrameView)
//        
//        UIView.animateWithDuration(4.0, animations: {
//            }) { (true) in
//                UIView.animateWithDuration(1.0, animations: { 
//                    
//                    }, completion: nil)
//        }
//    }
    
    func drawLinesAroundFace(){
        
    }

}













