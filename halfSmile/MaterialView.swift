//
//  MaterialView.swift
//  halfSmile
//
//  Created by Chris Hovey on 7/11/16.
//  Copyright © 2016 Chris Hovey. All rights reserved.
//

import UIKit

class MaterialView: UIView {

    override func awakeFromNib() {
        layer.cornerRadius = 3.0

        clipsToBounds = true
        

    }
    
}
