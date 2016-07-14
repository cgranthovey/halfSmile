//
//  ViewController.swift
//  halfSmile
//
//  Created by Chris Hovey on 7/8/16.
//  Copyright © 2016 Chris Hovey. All rights reserved.
//

import UIKit
import ProjectOxfordFace
import Foundation
import Canvas
import NVActivityIndicatorView


//icons 
//panda  Creative Stall, Lucid Formation, sachan

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var topImg: UIImageView!
    @IBOutlet weak var bottomImg: UIImageView!
    
    
    @IBOutlet weak var viewForButton: CSAnimationView!
    
    @IBOutlet weak var rightSmall: UIView!
    @IBOutlet weak var containerView: MaterialView!
    
    var hasChoosenTop: Bool!
    var hasChoosenBottom: Bool!
    var imgSelected: String!
    
    var timerDone: Bool = false
    var firstDownloaded: Bool = false
    var secondDownloaded: Bool = false
    
    
    let imagePicker = UIImagePickerController()
    
    var activityIndicatorView: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        

        
        super.viewDidLoad()
        hasChoosenTop = false
        hasChoosenBottom = false
        
        let myWaitingFrame = CGRectMake(0, 0, 40, 40)
        
        activityIndicatorView = NVActivityIndicatorView(frame: myWaitingFrame, type: .LineScalePulseOut, color: UIColor.whiteColor(), padding: 0)
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.center = self.view.center
        activityIndicatorView.alpha = 0
        
        imagePicker.delegate = self
        let topTap = UITapGestureRecognizer(target: self, action: #selector(loadPicker(_:)))
        topTap.numberOfTapsRequired = 1
        
        let bottomTap = UITapGestureRecognizer(target: self, action: #selector(loadPicker(_:)))
        bottomTap.numberOfTapsRequired = 1
        
        topImg.addGestureRecognizer(topTap)
        topImg.tag = 0
        bottomImg.addGestureRecognizer(bottomTap)
        bottomImg.tag = 1
        imgSelected = "none"
        
        viewForButton.duration = 0.5
        viewForButton.delay = 0
        viewForButton.type = CSAnimationTypePop
        
    }
    
    var person1: Person!
    var person2: Person!
    
    @IBAction func battleBtn(sender: UIButton){
        viewForButton.startCanvasAnimation()
        if !hasChoosenTop || !hasChoosenBottom{
            showErrorAlert()
        } else{
            growLines()
            if let firstImg = topImg.image, let firstImgData = UIImageJPEGRepresentation(firstImg, 0.8), let secondImg = bottomImg.image, let secondImgData = UIImageJPEGRepresentation(secondImg, 0.8){
                FaceService.instance.client.detectWithData(firstImgData, returnFaceId: false, returnFaceLandmarks: true, returnFaceAttributes: [4], completionBlock: { (face: [MPOFace]!, err: NSError!) in
                    if err == nil {
                        if let faceA: MPOFace = face[0]{
                            let img = self.topImg.image!
                            self.person1 = Person(face: faceA, image: img)
                        }
                        
                    } else{
                        print (err.debugDescription)
                    }
                    self.firstDownloaded = true
                    self.secondAnimation()
                })
                FaceService.instance.client.detectWithData(secondImgData, returnFaceId: false, returnFaceLandmarks: true, returnFaceAttributes: [4], completionBlock: { (face: [MPOFace]!, err: NSError!) in
                    if err == nil{
                        if let faceA: MPOFace = face[0]{
                            let img = self.bottomImg.image!
                            self.person2 = Person(face: faceA, image: img)
                        }
                    } else{
                        print(err.debugDescription)
                    }
                    self.secondDownloaded = true
                    self.secondAnimation()
                })
            }
        }
    }
    
    
    func showErrorAlert(){
        let alert =  UIAlertController(title: "Choose images", message: "Tap panda and owl images to take selfie.", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage?{
            if imgSelected == "top"{
                topImg.image = pickedImage
                hasChoosenTop = true
            } else{
                bottomImg.image = pickedImage
                hasChoosenBottom = true
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadPicker(gesture: UITapGestureRecognizer){
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        
        if gesture.view?.tag == 0{
            imgSelected = "top"
        } else {
            imgSelected = "bottom"
        }
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    

    func growLines(){

        UIView.animateWithDuration(0.8, animations: {
            print("help")
            print(self.containerView.frame.height)
            self.rightSmall.transform = CGAffineTransformMakeScale(1, self.containerView.frame.height/2)

            }) { (true) in
                UIView.animateWithDuration(0.8, animations: {
                    self.rightSmall.transform = CGAffineTransformMakeScale(self.containerView.frame.width/2, self.containerView.frame.height/2)
                }) {(true) in
                        UIView.animateWithDuration(0.7, animations: {
                            self.activityIndicatorView.startAnimation()
                            self.activityIndicatorView.alpha = 1
                        }){(true) in
                            self.timerDone = true
                            var timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(self.secondAnimation), userInfo: nil, repeats: false)
                    }
                    
                }
        }
    }
    
    func secondAnimation(){
        
        if firstDownloaded == true && secondDownloaded == true && timerDone == true{
            let aFrame = CGRectMake(0, 0, 2, 2)
            var myWhiteView = UIView(frame: aFrame)
            myWhiteView.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(myWhiteView)
            myWhiteView.center.x = self.view.center.x
            myWhiteView.center.y = self.view.center.y

            
            UIView.animateWithDuration(0.7, animations: {
                myWhiteView.transform = CGAffineTransformMakeScale(self.view.frame.width/2, 1)
            }) { (true) in
                UIView.animateWithDuration(0.7, animations: {
                    myWhiteView.transform = CGAffineTransformMakeScale(self.view.frame.width/2, self.view.frame.height/2)
                }){ (true) in
                    
                    let myDictionary: [String: AnyObject] = ["person1": self.person1, "person2": self.person2]
                    self.performSegueWithIdentifier("WinnerVC", sender: myDictionary)
                }
            }
        }
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "WinnerVC"{
            if let myWinnerVC = segue.destinationViewController as? WinnerVC{
                if let dict = sender as? [String: AnyObject]{
                    myWinnerVC.mySegueDictionary = dict
                }
            }
        }
    }
    
}












