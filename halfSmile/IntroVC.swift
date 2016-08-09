//
//  IntroVC.swift
//  halfSmile
//
//  Created by Chris Hovey on 7/26/16.
//  Copyright © 2016 Chris Hovey. All rights reserved.
//

import UIKit
import GoogleMobileAds

class IntroVC: UIViewController {
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"  //testing
        //bannerView.adUnitID = "ca-app-pub-3796548583790825/4841274796"   // real

        bannerView.rootViewController = self
        bannerView.loadRequest(GADRequest())
    }
    
    @IBAction func questionBtn(sender: AnyObject){
        performSegueWithIdentifier("HelpVC", sender: nil)
    }
    
    @IBAction func fullSmileBtn(sender: AnyObject){
        
        let dict = ["button": "full", "gameType": "Full-Smile", "gameExplanation": "Closer to 100%", "imageTop": "monkey1", "imageBottom": "frogGreen", "color": ORANGE_COLOR, "background": "bgBlue"]
        performSegueWithIdentifier("toViewController", sender: dict)
    }
    
    @IBAction func halfSmileBtn(sender: AnyObject){
        let dict = ["button": "half", "gameType": "Half-Smile", "gameExplanation": "Closer to 50%", "imageTop": "penguinOrange", "imageBottom": "pandaGreen", "color": BLUE_COLOR, "background": "bgOrange"]
        performSegueWithIdentifier("toViewController", sender: dict)
    }
    
    @IBAction func zeroSmileBtm(sender: AnyObject){
        let dict = ["button": "zero", "gameType": "Zero-Smile", "gameExplanation": "Closer to 0%", "imageTop": "panda1", "imageBottom": "frogZeroBlue", "color": GREEN_COLOR, "background": "bgPerfect"]
        performSegueWithIdentifier("toViewController", sender: dict)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toViewController"{
            if let vc = segue.destinationViewController as? ViewController{
                if let dict = sender as? Dictionary<String, AnyObject>{
                    vc.dict1 = dict
                }
            }
        }
    }
}