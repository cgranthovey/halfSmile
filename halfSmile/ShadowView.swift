//
//  ShadowView.swift
//  halfSmile
//
//  Created by Chris Hovey on 7/13/16.
//  Copyright © 2016 Chris Hovey. All rights reserved.
//

import UIKit

class ShadowView: UIView {

    override func awakeFromNib() {
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 1.0).CGColor
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.6
        layer.shadowOffset = CGSizeMake(0.0, 0.0)
        layer.backgroundColor = UIColor.clearColor().CGColor
    }
}
