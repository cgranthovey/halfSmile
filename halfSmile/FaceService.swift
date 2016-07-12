//
//  FaceService.swift
//  halfSmile
//
//  Created by Chris Hovey on 7/8/16.
//  Copyright © 2016 Chris Hovey. All rights reserved.
//

import Foundation
import ProjectOxfordFace

class FaceService{
    static let instance = FaceService()
    let client = MPOFaceServiceClient(subscriptionKey: "2a1123301b8e4478a1a3a42ba35be6d1")
        
}