//
//  InformationVC.swift
//  halfSmile
//
//  Created by Chris Hovey on 8/1/16.
//  Copyright © 2016 Chris Hovey. All rights reserved.
//

import UIKit

class InformationVC: UIViewController {

    var swipeRight: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(InformationVC.popBack))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        // Do any additional setup after loading the view.
    }

    @IBAction func icons8(sender: AnyObject){
        openLink("https://icons8.com/")
    }
    
    @IBAction func theNounProject(sender: AnyObject){
        openLink("https://thenounproject.com/")
    }
    
    @IBAction func freeSound(sender: AnyObject){
        openLink("https://www.freesound.org/")
    }
    
    @IBAction func backButton(sender: AnyObject){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    func popBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func openLink(urlString: String){
        if let  url = NSURL(string: urlString){
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    

}
