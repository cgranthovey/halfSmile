//
//  IntroVC.swift
//  halfSmile
//
//  Created by Chris Hovey on 7/26/16.
//  Copyright © 2016 Chris Hovey. All rights reserved.
//

import UIKit


class IntroVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func fullSmileBtn(sender: AnyObject){
        
        let dict = ["button": "full", "gameType": "Full-Smile", "gameExplanation": "Closer to 100%", "imageTop": "monkeyBlue", "imageBottom": "frogGreen", "color": ORANGE_COLOR, "background": "bgBlue"]
        performSegueWithIdentifier("toViewController", sender: dict)
    }
    
    @IBAction func halfSmileBtn(sender: AnyObject){
        let dict = ["button": "half", "gameType": "Half-Smile", "gameExplanation": "Closer to 50%", "imageTop": "penguinOrange", "imageBottom": "pandaGreen", "color": BLUE_COLOR, "background": "bgOrange"]
        performSegueWithIdentifier("toViewController", sender: dict)
    }
    
    @IBAction func zeroSmileBtm(sender: AnyObject){
        let dict = ["button": "zero", "gameType": "Zero-Smile", "gameExplanation": "Closer to 0%", "imageTop": "pandaOrange", "imageBottom": "frogZeroBlue", "color": GREEN_COLOR, "background": "bgPerfect"]
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
