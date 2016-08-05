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
import AVFoundation
import NVActivityIndicatorView


//icons 
//panda  Creative Stall, Lucid Formation, sachan, Pranav Grover, Elena Rimeikaite,  Arthur Shlain, Creative Stall, Nick Bluth 


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var dict1: Dictionary<String, AnyObject>!
    
    @IBOutlet weak var topImg: UIImageView!
    @IBOutlet weak var bottomImg: UIImageView!
    
    @IBOutlet weak var viewForButton: CSAnimationView!
    
    @IBOutlet weak var rightSmall: UIView!
    @IBOutlet weak var containerView: MaterialView!
    
    @IBOutlet weak var battleBtnOutlet: UIButton!
    @IBOutlet weak var slimView: UIView!
    
    @IBOutlet weak var backgroundImg: UIImageView!
    
    var hasChoosenTop: Bool!
    var hasChoosenBottom: Bool!
    var imgSelected: String!
    
    var timerDone: Bool!
    var firstDownloaded: Bool = false
    var secondDownloaded: Bool = false
    
    
    let imagePicker = UIImagePickerController()
    
    var activityIndicatorView: NVActivityIndicatorView!
    var person1: Person!
    var person2: Person!
    var battleBtnPressedBoolean: Bool!
    
    var swipeRight: UISwipeGestureRecognizer!
    var errorCalledOnceAlready: Bool!
    
    var anErrorTop: Bool!
    var anErrorBottom: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hasChoosenTop = false
        hasChoosenBottom = false
        
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.popBack))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        
        let myWaitingFrame = CGRectMake(0, 0, 40, 40)
        
        activityIndicatorView = NVActivityIndicatorView(frame: myWaitingFrame, type: .LineScalePulseOut, color: UIColor.whiteColor(), padding: 0)
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.center = self.view.center
        
        imagePicker.delegate = self
        let topTap = UITapGestureRecognizer(target: self, action: #selector(loadPicker(_:)))
        topTap.numberOfTapsRequired = 1
        
        let bottomTap = UITapGestureRecognizer(target: self, action: #selector(loadPicker(_:)))
        bottomTap.numberOfTapsRequired = 1
        print("viewDidLoad")
        errorCalledOnceAlready = false
        
        topImg.addGestureRecognizer(topTap)
        topImg.tag = 0
        bottomImg.addGestureRecognizer(bottomTap)
        bottomImg.tag = 1
        imgSelected = "none"
        
        viewForButton.duration = 0.5
        viewForButton.delay = 0
        viewForButton.type = CSAnimationTypePop
        
        findImagesAndColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        battleBtnPressedBoolean = false
        timerDone = false
        firstDownloaded = false
        secondDownloaded = false
        anErrorTop = false
        anErrorBottom = false
        activityIndicatorView.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        errorCalledOnceAlready = false
    }
    
    var topAnimal: String!
    var bottomAnimal: String!
    var color: UIColor!
    
    
    
    func findImagesAndColor(){
        
        if let backGround = dict1["background"] as? String{
            backgroundImg.image = UIImage(named: backGround)
        }
        
        if let topAnimal = dict1["imageTop"] as? String{
            self.topAnimal = topAnimal
            topImg.image = UIImage(named: topAnimal)
            
        }
        if let bottomAnimal = dict1["imageBottom"] as? String{
            self.bottomAnimal = bottomAnimal
            bottomImg.image = UIImage(named: bottomAnimal)
        }
        if let color1 = dict1["color"] as? UIColor{
            self.color = color1
            rightSmall.backgroundColor = color1
            slimView.backgroundColor = color1
            battleBtnOutlet.backgroundColor = color1
        }
        
        if let battleType = dict1["gameType"] as? String{
            battleBtnOutlet.setTitle(battleType.uppercaseString + " BATTLE", forState: .Normal)
        }
    }
    
    
    
 
    
    
    override func viewDidDisappear(animated: Bool) {
        if battleBtnPressedBoolean == true && hasChoosenTop == true && hasChoosenBottom == true{
            self.rightSmall.transform = CGAffineTransformMakeScale(1, 2/self.containerView.frame.height)
            hasChoosenTop = false
            hasChoosenBottom = false
        }
    }
    
    var holdString: String!

    @IBAction func battleBtn(sender: UIButton){
        if !hasChoosenTop || !hasChoosenBottom{
            showErrorAlert()
        } else{
            viewForButton.startCanvasAnimation()
            battleBtnPressedBoolean = true
            growLines()
            if let firstImg = topImg.image, let firstImgData = UIImageJPEGRepresentation(firstImg, 0.8), let secondImg = bottomImg.image, let secondImgData = UIImageJPEGRepresentation(secondImg, 0.8){
                FaceService.instance.client.detectWithData(firstImgData, returnFaceId: false, returnFaceLandmarks: true, returnFaceAttributes: [4], completionBlock: { (face: [MPOFace]!, err: NSError!) in
                    if err == nil {
                        
                        if face.count != 0{
                            if let faceA: MPOFace = face[0]{
                                let img = self.topImg.image!
                                self.person1 = Person(face: faceA, image: img)
                                
                                self.firstDownloaded = true
                                self.prepForEditVC()
                                self.secondAnimation()
                            }
                        } else {
                            self.holdString = "Could not detect a face in at least one of the images"
                            self.anErrorTop = true
                            self.prepForEditVC()
                        }
                    } else{
                        if let holdError = err.localizedFailureReason{
                            self.holdString = holdError
                            self.anErrorTop = true
                            self.prepForEditVC()
                        } else{
                            self.holdString = "The images could not be processed"
                            self.anErrorTop = true
                            self.prepForEditVC()
                        }
                        print (err.debugDescription)
                    }
                })
                FaceService.instance.client.detectWithData(secondImgData, returnFaceId: false, returnFaceLandmarks: true, returnFaceAttributes: [4], completionBlock: { (face: [MPOFace]!, err: NSError!) in
                    if err == nil{
                        
                        if face.count != 0{
                            if let faceA: MPOFace = face[0]{
                                let img = self.bottomImg.image!
                                self.person2 = Person(face: faceA, image: img)
                                
                                self.secondDownloaded = true
                                self.prepForEditVC()
                                self.secondAnimation()
                            }
                        } else {
                            self.holdString = "Could not detect a face in at least one of the images"
                            self.anErrorBottom = true
                            self.prepForEditVC()
                        }
                        

                    } else{
                        if let holdError = err.localizedFailureReason{
                            self.holdString = holdError
                            self.anErrorBottom = true
                            self.prepForEditVC()
                        } else{
                            self.holdString =  "The images could not be processed"
                            self.anErrorBottom = true
                            self.prepForEditVC()
                        }
                        print(err.debugDescription)
                    }

                })
            }
        }
    }
    
    
    func showErrorAlert(){
        let alert =  UIAlertController(title: "Choose images", message: "Tap animal images to take selfie.", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func loadPicker(gesture: UITapGestureRecognizer){
      //  imagePicker.allowsEditing = true
        imagePicker.sourceType = .Camera
        imagePicker.cameraDevice = .Front
        imagePicker.cameraCaptureMode = .Photo
        imagePicker.cameraOverlayView = .None
        imagePicker.allowsEditing = false
        if gesture.view?.tag == 0{
            imgSelected = "top"
        } else {
            imgSelected = "bottom"
        }
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage?{
            
            if imgSelected == "top"{
                topImg.image = pickedImage
                hasChoosenTop = true
                topImg.roundCornersForAspectFit(5.0)
            } else{
                bottomImg.image = pickedImage
                hasChoosenBottom = true
                bottomImg.roundCornersForAspectFit(5.0)
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    

    func growLines(){

        UIView.animateWithDuration(0.8, animations: {
            self.rightSmall.transform = CGAffineTransformMakeScale(1, self.containerView.frame.height/2)

            }) { (true) in
                UIView.animateWithDuration(0.8, animations: {
                    self.rightSmall.transform = CGAffineTransformMakeScale(self.containerView.frame.width/2, self.containerView.frame.height/2)
                }) {(true) in
                        UIView.animateWithDuration(0.6, animations: {
                            self.activityIndicatorView.startAnimation()
                            self.activityIndicatorView.alpha = 1
                        }){(true) in
                            var timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(self.callSecondAnimation), userInfo: nil, repeats: false)
                    } 
                }
        }
    }

    
    var myWhiteView: UIView!
    
    func callSecondAnimation(){
        self.timerDone = true
        prepForEditVC()
        secondAnimation()
    }
    
    func secondAnimation(){
        
        if firstDownloaded == true && secondDownloaded == true && timerDone == true{
            let aFrame = CGRectMake(0, 0, 2, 2)
            myWhiteView = UIView(frame: aFrame)
            myWhiteView.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(myWhiteView)
            myWhiteView.center.x = self.view.center.x
            myWhiteView.center.y = self.view.center.y
            print("secondAnim called")
            
            UIView.animateWithDuration(0.7, animations: {
                self.myWhiteView.transform = CGAffineTransformMakeScale(self.view.frame.width/2, 1)
            }) { (true) in
                UIView.animateWithDuration(0.7, animations: {
                    self.myWhiteView.transform = CGAffineTransformMakeScale(self.view.frame.width/2, self.view.frame.height/2)
                }){ (true) in
                    self.resetVC()
                    let myDictionary: [String: AnyObject] = ["person1": self.person1, "person2": self.person2]
                    self.performSegueWithIdentifier("SecondWinnerVC", sender: myDictionary)
                }
            }
        }
    }
    
    func resetVC(){
        activityIndicatorView.stopAnimation()

        topImg.image = UIImage(named: topAnimal)
        bottomImg.image = UIImage(named: bottomAnimal)
        self.topImg.roundCornersForAspectFit(0)
        self.bottomImg.roundCornersForAspectFit(0)
        if myWhiteView != nil{
            myWhiteView.removeFromSuperview()
        }
        print("reset called")
        timerDone = false
        firstDownloaded = false
        secondDownloaded = false
    }
    
    func prepForEditVC(){
        print(errorCalledOnceAlready)
        print("first downloaded \(firstDownloaded)")
        print("second downloaded \(secondDownloaded)")
        print("an error\(anErrorTop)")
        print("bottom error \(anErrorBottom)")
        if timerDone == true && errorCalledOnceAlready == false && (((firstDownloaded == true || secondDownloaded == true) && (anErrorTop == true || anErrorBottom == true)) || (anErrorTop == true && anErrorBottom == true)){
            errorCalledOnceAlready = true
            
            print("prepForEditVC function")
            UIView.animateWithDuration(0.5, delay: 0.6, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.activityIndicatorView.alpha = 0
                }) { (true) in
                    print("inside animate")
                    self.activityIndicatorView.stopAnimation()
                    self.resetVC()
                    self.performSegueWithIdentifier("ErrorVC", sender: self.holdString)
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SecondWinnerVC"{
            if let myWinnerVC = segue.destinationViewController as? SecondWinnerVC{
                if let dict = sender as? [String: AnyObject]{
                    myWinnerVC.dict = self.dict1
                    myWinnerVC.mySegueDictionary = dict
                }
            }
        }
        if segue.identifier == "ErrorVC"{
            print("inside segue")
            if let myErrorVC = segue.destinationViewController as? ErrorVC{
                if let errorString = sender as? String{
                    myErrorVC.error = errorString
                    myErrorVC.dict = dict1
                }
            }
        }
    }
    
    func popBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    
    
    
    
    
    
    
}












