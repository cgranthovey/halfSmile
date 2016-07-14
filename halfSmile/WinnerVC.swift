//
//  WinnerVC.swift
//  halfSmile
//
//  Created by Chris Hovey on 7/14/16.
//  Copyright © 2016 Chris Hovey. All rights reserved.
//

import UIKit
import SpriteKit



class WinnerVC: UIViewController {

    
    var mySegueDictionary = [String: AnyObject]()
    
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var bottomImage: UIImageView!
    
    var person1: Person!
    var person2: Person!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseDict()
        
        topImage.image = person1.selfieImage
        bottomImage.image = person2.selfieImage
        
        animateZoom()
        
//        var hi = CGRectMake(17, 55, 200, 120)
//        
//        
//        var capInset = UIEdgeInsets(top: 40.0, left: 30.0, bottom: 20.0, right: 10.0)
//        image.resizableImageWithCapInsets(<#T##capInsets: UIEdgeInsets##UIEdgeInsets#>)
//        
//        CGImageCreateWithImageInRect(<#T##image: CGImage?##CGImage?#>, <#T##rect: CGRect##CGRect#>)
    }
    
    func parseDict(){
        person1 = mySegueDictionary["person1"] as! Person
        person2 = mySegueDictionary["person2"] as! Person
    }
    
    
    func animateZoom(){
        
        let cgI = topImage.image?.CGImage

        UIView.animateWithDuration(1.0, animations: {
            let rect = CGRectMake(CGFloat(self.person1.faceTop), CGFloat(self.person1.faceLeft), CGFloat(self.person1.faceWidth), CGFloat(self.person1.faceHeight))
            let cgImageObject = CGImageCreateWithImageInRect(cgI, rect)
            self.topImage.image = UIImage(CGImage: cgImageObject!)
            }, completion: nil)
    }

    func drawFaceRect(){
        
        var aFrame = CGRectMake(CGFloat(self.person2.faceLeft), CGFloat(self.person2.faceTop), CGFloat(self.person2.faceWidth), CGFloat(self.person2.faceHeight))
        var headFrameView = UIView(frame: aFrame)
        headFrameView.backgroundColor = UIColor.blueColor()
        headFrameView.alpha = 0.5
        bottomImage.addSubview(headFrameView)
        
    }

}













