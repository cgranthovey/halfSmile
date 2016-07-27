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
        
        let dict = ["button": "full", "imageTop": "frogClear", "imageBottom": "monkeyClear", "color": ORANGE_COLOR]
        performSegueWithIdentifier("toViewController", sender: dict)
    }
    
    @IBAction func halfSmileBtn(sender: AnyObject){
        let dict = ["button": "half", "imageTop": "penguin", "imageBottom": "panda", "color": BLUE_COLOR]
        performSegueWithIdentifier("toViewController", sender: dict)
    }
    
    @IBAction func zeroSmileBtm(sender: AnyObject){
        let dict = ["button": "zero", "imageTop": "pandaClear", "imageBottom": "frogZeroClear", "color": GREEN_COLOR]
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
