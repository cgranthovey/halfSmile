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
    
    @IBOutlet weak var backBtnOutlet: UIButton!
    
    var hasChoosenTop: Bool!
    var hasChoosenBottom: Bool!
    var imgSelected: String!
    
    var timerDone: Bool = false
    var firstDownloaded: Bool = false
    var secondDownloaded: Bool = false
    
    
    let imagePicker = UIImagePickerController()
    
    var activityIndicatorView: NVActivityIndicatorView!
    var person1: Person!
    var person2: Person!
    var battleBtnPressedBoolean: Bool!
    override func viewDidLoad() {
        

        
        super.viewDidLoad()
        hasChoosenTop = false
        hasChoosenBottom = false
        
        let myWaitingFrame = CGRectMake(0, 0, 40, 40)
        
        activityIndicatorView = NVActivityIndicatorView(frame: myWaitingFrame, type: .LineScalePulseOut, color: UIColor.whiteColor(), padding: 0)
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.center = self.view.center
        
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
        
        findImagesAndColor()
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        battleBtnPressedBoolean = false
        activityIndicatorView.alpha = 0
    }
    
    var topAnimal: String!
    var bottomAnimal: String!
    var color: UIColor!
    
    func findImagesAndColor(){
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
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        if battleBtnPressedBoolean == true && hasChoosenTop == true && hasChoosenBottom == true{
            self.rightSmall.transform = CGAffineTransformMakeScale(1, 2/self.containerView.frame.height)
            hasChoosenTop = false
            hasChoosenBottom = false

        }
    }
    
    

    @IBAction func battleBtn(sender: UIButton){
        viewForButton.startCanvasAnimation()
        if !hasChoosenTop || !hasChoosenBottom{
            showErrorAlert()
        } else{
            battleBtnPressedBoolean = true
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
        let alert =  UIAlertController(title: "Choose images", message: "Tap animal images to take selfie.", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
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
            self.rightSmall.transform = CGAffineTransformMakeScale(1, self.containerView.frame.height/2)

            }) { (true) in
                UIView.animateWithDuration(0.8, animations: {
                    self.rightSmall.transform = CGAffineTransformMakeScale(self.containerView.frame.width/2, self.containerView.frame.height/2)
                }) {(true) in
                        UIView.animateWithDuration(0.7, animations: {
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
        myWhiteView.removeFromSuperview()

        timerDone = false
        firstDownloaded = false
        secondDownloaded = false
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
    }
    
    @IBAction func backBtn(sender: AnyObject){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    
}












