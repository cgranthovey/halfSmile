//
//  MaterialLabel.swift
//  halfSmile
//
//  Created by Chris Hovey on 8/8/16.
//  Copyright © 2016 Chris Hovey. All rights reserved.
//

import UIKit

class MaterialLabel: UILabel {

    override func awakeFromNib() {
        self.layer.cornerRadius = 3.0
        clipsToBounds = true
    }
}