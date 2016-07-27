//
//  ResultVC.swift
//  halfSmile
//
//  Created by Chris Hovey on 7/18/16.
//  Copyright © 2016 Chris Hovey. All rights reserved.
//

import UIKit

class ResultVC: UIViewController {

    var segueDict = [String: AnyObject]()
    var dict = [String: AnyObject]()
    
    var person1: Person!
    var person2: Person!
    
    @IBOutlet weak var winnerSelfieImg: UIImageView!
    @IBOutlet weak var secondPlaceSelfieImg: UIImageView!
    
    @IBOutlet weak var winnerPercentageLbl: UILabel!
    @IBOutlet weak var secondPlacePercentageLbl: UILabel!
    
    @IBOutlet weak var winnerLbl: UILabel!
    @IBOutlet weak var secondPlaceLbl: UILabel!
    
    @IBOutlet weak var topShadow: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
//        topShadow.hidden = true
//        winnerSelfieImg.hidden = true
        parseSegueDict()
        print("person1: \(person1.smile)")
        print("person2: \(person2.smile)")
//        determineWinnerHalf
        whichWinnerFunction()
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
            winnerLbl.text = "Tie"
            secondPlaceLbl.text = "Tie"
        }
    }
    
    func determineWinnerZero(){
        if person1.smile < person2.smile{
            setLabels(person1, secondPlace: person2)
        } else if person2.smile < person1.smile{
            setLabels(person2, secondPlace: person1)
        } else {
            setLabels(person1, secondPlace: person2)
            winnerLbl.text = "Tie"
            secondPlaceLbl.text = "Tie"
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
            winnerLbl.text = "Tie"
            secondPlaceLbl.text = "Tie"
        }
    }

    func setLabels(winner: Person, secondPlace: Person){
        winnerSelfieImg.image = winner.selfieImage
        secondPlaceSelfieImg.image = secondPlace.selfieImage
        
        if let holdTemp = dict["button"] as? String{
            if holdTemp == "half"{
                determinePercentage(winner, percentLabel: winnerPercentageLbl)
                determinePercentage(secondPlace, percentLabel: secondPlacePercentageLbl)
            } else{
                winnerPercentageLbl.text = "\(round(10 * winner.smile * 100) / 10)%"
                secondPlacePercentageLbl.text = "\(round(10 * secondPlace.smile * 100) / 10)%"
            }
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
    

    
}
