//
//  Category.swift
//  Notes
//
//  Created by LongLH on 12/17/17.
//  Copyright © 2017 LongLH. All rights reserved.
//

import UIKit

extension Category {
    var color: UIColor? {
        get {
            guard let hex = colorAsHex else { return nil }
            return UIColor(hex: hex)
        }
        set(newColor) {
            if let newColor = newColor {
                colorAsHex = newColor.toHex
            }
        }
    }
}
