//
//  ErrorVC.swift
//  halfSmile
//
//  Created by Chris Hovey on 7/28/16.
//  Copyright © 2016 Chris Hovey. All rights reserved.
//

import UIKit

class ErrorVC: UIViewController {

    var dict: Dictionary<String, AnyObject>!
    var error: String!
    
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var popVCOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLbl.alpha = 0
        popVCOutlet.alpha = 0
        parseDict()
        appear()
    }
    
    func parseDict(){
        if let color = dict["color"] as? UIColor{
            colorView.backgroundColor = color
        }
        if error != nil{
            errorLbl.text = error
        }
    }
    
    func appear(){
        UIView.animateWithDuration(0.5, delay: 0.3, options: .CurveEaseIn, animations: { 
            self.errorLbl.alpha = 1.0
            self.popVCOutlet.alpha = 1.0
            }, completion: nil)
    }
    
    @IBAction func popVC(){
        self.navigationController?.popViewControllerAnimated(true)
    }
}
