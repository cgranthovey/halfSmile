//
//  ResultVC.swift
//  halfSmile
//
//  Created by Chris Hovey on 7/18/16.
//  Copyright © 2016 Chris Hovey. All rights reserved.
//

import UIKit
import Canvas
import AVFoundation

class ResultVC: UIViewController {

    var segueDict = [String: AnyObject]()
    var dict = [String: AnyObject]()
    
    var person1: Person!
    var person2: Person!
    
    var sfxBoing: AVAudioPlayer!
    var sfxSlide: AVAudioPlayer!
    var sfxKnife: AVAudioPlayer!
    
    var swipeRight: UISwipeGestureRecognizer!
    
    @IBOutlet weak var winnerSelfieImg: UIImageView!
    @IBOutlet weak var secondPlaceSelfieImg: UIImageView!
    
    @IBOutlet weak var winnerPercentageLbl: UILabel!
    @IBOutlet weak var secondPlacePercentageLbl: UILabel!
    
    @IBOutlet weak var winnerLbl: UILabel!
    @IBOutlet weak var secondPlaceLbl: UILabel!
    
    @IBOutlet weak var topShadow: UIView!
    
    @IBOutlet weak var playAgainButtonOutlet: UIButton!
    
    @IBOutlet weak var underLineView: UIView!
    
    @IBOutlet weak var gameTypeLbl: UILabel!
    @IBOutlet weak var gameTypeExplanationLbl: UILabel!
    
    @IBOutlet weak var slimButtonView: UIView!
    
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewSlim: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewSlim: UIView!
    
    @IBOutlet weak var bottomMaterialView: MaterialView!
    
    @IBOutlet weak var viewForWinnerLbl: CSAnimationView!
    @IBOutlet weak var smallView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        topShadow.hidden = true
//        winnerSelfieImg.hidden = true
        initAudio()
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ResultVC.popBack))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        
        parseSegueDict()
        parseOverallDict()
        
        print("person1: \(person1.smile)")
        print("person2: \(person2.smile)")
//        determineWinnerHalf
        whichWinnerFunction()
        animateBeginning()
        
        viewForWinnerLbl.delay = 0.0
        viewForWinnerLbl.duration = 0.5
        viewForWinnerLbl.type = CSAnimationTypeShake
        
        
        
        
    }
    
    
    
    func initAudio(){
        do{
            try sfxBoing = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("boing", ofType: "mp3")!))
            sfxBoing.prepareToPlay()
            sfxBoing.volume = 1.0
            try sfxKnife = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("knife", ofType: "mp3")!))
            sfxKnife.prepareToPlay()
            sfxKnife.volume = 0.3
            try sfxSlide = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("slide", ofType: "mp3")!))
            sfxSlide.prepareToPlay()
            sfxSlide.volume = 0.3
        } catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    var mainColor: UIColor!
    
    
    func animateBeginning(){
        var originalTopX = topView.center.x
        var originalBottomX = bottomView.center.x
        
        topView.center.x = -view.frame.width/2
        bottomView.center.x = -view.frame.width/2
        
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.topView.center.x = originalTopX
            self.bottomView.center.x = originalBottomX
            self.sfxKnife.play()
            }) { (true) in
                self.coverView.hidden = true
                
                UIView.animateWithDuration(0.2, animations: {
                    self.smallView.center.x = self.smallView.center.x + 2
                    }, completion: { (true) in
                        
                        UIView.animateWithDuration(1.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                            self.sfxSlide.play()
                            self.topView.center.y = -self.view.frame.height
                            self.bottomView.center.y = self.view.frame.height * 2
                        }) { (true) in
                            if self.winnerLbl.text != "Tie"{
                                self.viewForWinnerLbl.startCanvasAnimation()
                                self.sfxBoing.play()
                            }
                        }
                })
                

        }
    }
    
    
    
    func parseOverallDict(){
        if let color = dict["color"] as? UIColor{
            mainColor = color
            playAgainButtonOutlet.backgroundColor = mainColor
            underLineView.backgroundColor = mainColor
            topViewSlim.backgroundColor = mainColor
            bottomViewSlim.backgroundColor = mainColor
            slimButtonView.backgroundColor = mainColor
        }
        
        if let topLabel = dict["gameType"] as? String{
            gameTypeLbl.text = topLabel
        }
        
        if let gameExplanation = dict["gameExplanation"] as? String{
            gameTypeExplanationLbl.text = gameExplanation
        }
        
    }

    func whichWinnerFunction(){
        
        if let holdButtonType = dict["button"] as? String{
            if holdButtonType == "half"{
                determineWinnerHalf()
            } else if holdButtonType == "full"{
                determineWinnerFull()
            } else{
                determineWinnerZero()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
//        topShadow.hidden = false
//        winnerSelfieImg.hidden = false
        winnerSelfieImg.roundCornersForAspectFit(5.0)
        secondPlaceSelfieImg.roundCornersForAspectFit(5.0)
    }
    
    func parseSegueDict() {
        person1 = segueDict["person1"] as! Person
        person2 = segueDict["person2"] as! Person
    }
    
    func determineWinnerFull(){
        if person1.smile > person2.smile{
            setLabels(person1, secondPlace: person2)
        } else if person2.smile > person1.smile{
            setLabels(person2, secondPlace: person1)
        } else{
            setLabels(person1, secondPlace: person2)
            tieGame()
        }
    }
    
    func determineWinnerZero(){
        if person1.smile < person2.smile{
            setLabels(person1, secondPlace: person2)
        } else if person2.smile < person1.smile{
            setLabels(person2, secondPlace: person1)
        } else {
            setLabels(person1, secondPlace: person2)
            tieGame()

        }
    }
    
    func determineWinnerHalf(){
        let personOneSubtracted = abs(person1.smile - 0.5)
        let personTwoSubtracted = abs(person2.smile - 0.5)
        if personOneSubtracted < personTwoSubtracted{
            setLabels(person1, secondPlace: person2)
        } else if personTwoSubtracted < personOneSubtracted {
            setLabels(person2, secondPlace: person1)
        } else{
            setLabels(person1, secondPlace: person2)
            tieGame()
        }
    }
    
    func tieGame(){
        winnerLbl.text = "Tie"
        secondPlaceLbl.text = "Tie"
        winnerLbl.textColor = UIColor.blackColor()
        bottomMaterialView.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1.0)
    }

    func setLabels(winner: Person, secondPlace: Person){

        winnerSelfieImg.image = winner.selfieImage
        secondPlaceSelfieImg.image = secondPlace.selfieImage
        print("winnerNumber \(winner.smile)")
        var winnerNumber = round(10 * winner.smile * 100) / 10
        var secondPlaceNumber = round(10 * secondPlace.smile * 100) / 10
        print(winnerNumber)
        if winnerNumber == 100{
            winnerPercentageLbl.text = "100%"
        } else{
            winnerPercentageLbl.text = "\(winnerNumber)%"
        }
        if secondPlaceNumber == 100{
            secondPlacePercentageLbl.text = "100%"
        } else{
            secondPlacePercentageLbl.text = "\(secondPlaceNumber)%"
        }
    }
    
    func determinePercentage(person: Person, percentLabel: UILabel){
        if person.smile > 0.50{
            percentLabel.text = "\(round(10 * (0.50 - (person.smile - 0.50)) * 2 * 100) / 10)%"
        } else{
            percentLabel.text = "\(round(10 * person.smile * 2 * 100) / 10)%"
        }
    }
    
    
    
    @IBAction func playAgainBtn(sender: AnyObject){
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
    
    func popBack(){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    
}
