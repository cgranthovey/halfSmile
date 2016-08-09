//
//  HelpVC.swift
//  halfSmile
//
//  Created by Chris Hovey on 8/8/16.
//  Copyright © 2016 Chris Hovey. All rights reserved.
//

import UIKit

class HelpVC: UIViewController {

    var swipeRight: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(HelpVC.userSwipedRight))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
    }
    
    @IBAction func backBtn(sender: AnyObject){
        userSwipedRight()
    }

    func userSwipedRight(){
        self.navigationController?.popViewControllerAnimated(true)
    }

}
