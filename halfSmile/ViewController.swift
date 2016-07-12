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

//icons 
//panda  Creative Stall, Lucid Formation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var topImg: UIImageView!
    @IBOutlet weak var bottomImg: UIImageView!
    
    var hasChoosenTop: Bool!
    var hasChoosenBottom: Bool!
    var imgSelected: String!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hasChoosenTop = false
        hasChoosenBottom = false
        
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
        
    }
    

    
    @IBAction func battleBtn(sender: UIButton){
        if !hasChoosenTop || !hasChoosenBottom{
            showErrorAlert()
        } else{
            if let firstImg = topImg.image, let firstImgData = UIImageJPEGRepresentation(firstImg, 0.8), let secondImg = bottomImg.image, let secondImgData = UIImageJPEGRepresentation(secondImg, 0.8){
                
                FaceService.instance.client.detectWithData(firstImgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: [], completionBlock: { (face: [MPOFace]!, err: NSError!) in
                    if err == nil {
                        var topFace: String?
                        topFace = face[0].faceId
                        var top = face[0].attributes.age
                        print("my faceId: \(topFace)")
                        print("my faceId: \(top)")

                    }
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
    
}

