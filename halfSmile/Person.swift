//
//  Person.swift
//  halfSmile
//
//  Created by Chris Hovey on 7/8/16.
//  Copyright © 2016 Chris Hovey. All rights reserved.
//

import Foundation
import UIKit
import ProjectOxfordFace

class Person{
    var faceId: String?
    var personImage: UIImage?
    var gender: String?
    var smile: Double?
    var age: Int?
    var glasses: String!
    init(personImg: UIImage){
        self.personImage = personImg
    }
    
    func downloadFaceAttributes(){
        if let img = personImage, let imgData = UIImageJPEGRepresentation(img, 0.8){
            FaceService.instance.client.detectWithData(imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: ["returnFaceAttributes=age,gender,smile,glasses"], completionBlock: { (face: [MPOFace]!, err: NSError!) in
                if err == nil{
                    self.gender = face[0].attributes.gender
                    self.age = Int(face[0].attributes.age)
                    self.smile = Double(face[0].attributes.smile)
                    self.glasses = face[0].attributes.description
                } else{
                    print(err.debugDescription)
                }
            })
            
        }
    }
     
}