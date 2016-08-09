//
//  placementStaningsView.swift
//  halfSmile
//
//  Created by Chris Hovey on 8/4/16.
//  Copyright © 2016 Chris Hovey. All rights reserved.
//

import UIKit

class placementStaningsView: UIView {

    override func awakeFromNib() {
        layer.cornerRadius = 3.0
        layer.borderWidth = 1
        layer.borderColor = UIColor.blackColor().CGColor
        clipsToBounds = true
    }
}
