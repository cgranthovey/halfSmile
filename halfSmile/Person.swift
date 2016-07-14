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
    private var _smile: String!
    private var _selfieImage: UIImage!
    
    private var _faceWidth: Int!
    private var _faceHeight: Int!
    private var _faceLeft: Int!
    private var _faceTop: Int!
    
    private var _pupilLeftX: Int!
    private var _pupilLeftY: Int!
    private var _pupilRightX: Int!
    private var _pupilRightY: Int!
    
    private var _noseTipX: Int!
    private var _noseTipY: Int!
    
    private var _mouthLeftX: Int!
    private var _mouthLeftY: Int!
    private var _mouthRightX: Int!
    private var _mouthRightY: Int!
    
    private var _upperLipTopX: Int!
    private var _upperLipTopY: Int!
    private var _underLipBottomX: Int!
    private var _underLipBottomY: Int!
    
    
    var smile: String{
        if _smile == nil{
            _smile = "no smile"
        }
        return self._smile
    }
    var selfieImage: UIImage{
        if _selfieImage == nil{
            _selfieImage = UIImage(named: "giraffe")
        }
        return self._selfieImage
    }
    var faceWidth: Int{
        return _faceWidth
    }
    var faceHeight: Int{
        return _faceHeight
    }
    var faceLeft: Int{
        return _faceLeft
    }
    var faceTop: Int{
        return _faceTop
    }
    var pupilLeftX: Int{
        return _pupilLeftX
    }
    var pupilLeftY: Int{
        return _pupilLeftY
    }
    var pupileRightX: Int{
        return _pupilRightX
    }
    var pupilRightY: Int{
        return _pupilRightY
    }
    var noseTipX: Int{
        return _noseTipX
    }
    var noseTipY: Int{
        return _noseTipY
    }
    var mouthLeftX: Int{
        return _mouthLeftX
    }
    var mouthLeftY: Int{
        return _mouthLeftY
    }
    var mouthRightX: Int{
        return _mouthRightX
    }
    var mouthRightY: Int{
        return _mouthRightY
    }
    var upperLipTopX: Int{
        return _upperLipTopX
    }
    var upperLipTopY: Int{
        return _upperLipTopY
    }
    var underLipBottomX: Int{
        return _underLipBottomX
    }
    var underLipBottomY: Int{
        return _underLipBottomY
    }
    
    init(face: MPOFace, image: UIImage){
        self._smile = face.attributes.smile.stringValue
        
        self._selfieImage = image
        
        self._faceWidth = Int(face.faceRectangle.width)
        self._faceHeight = Int(face.faceRectangle.height)
        self._faceLeft = Int(face.faceRectangle.left)
        self._faceTop = Int(face.faceRectangle.top)
        
        self._pupilLeftX = Int(face.faceLandmarks.pupilLeft.x)
        self._pupilLeftY = Int(face.faceLandmarks.pupilLeft.y)
        self._pupilRightX = Int(face.faceLandmarks.pupilRight.x)
        self._pupilRightX = Int(face.faceLandmarks.pupilRight.y)
        
        self._noseTipX = Int(face.faceLandmarks.noseTip.x)
        self._noseTipY = Int(face.faceLandmarks.noseTip.y)
        
        self._mouthLeftX = Int(face.faceLandmarks.mouthLeft.x)
        self._mouthLeftY = Int(face.faceLandmarks.mouthLeft.y)
        self._mouthRightX = Int(face.faceLandmarks.mouthRight.x)
        self._mouthRightY = Int(face.faceLandmarks.mouthRight.y)
        
        self._upperLipTopX = Int(face.faceLandmarks.upperLipTop.x)
        self._upperLipTopY = Int(face.faceLandmarks.upperLipTop.y)
        self._underLipBottomX = Int(face.faceLandmarks.underLipBottom.x)
        self._underLipBottomY = Int(face.faceLandmarks.underLipBottom.y)
    }
    
    func downloadFaceAttributes(face: MPOFace){

    }
     
}