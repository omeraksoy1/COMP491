//
//  UIView+Ext.swift
//  BirdsOfIstanbul
//
//  Created by Can Koz on 2.03.2022.
//

import UIKit

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight],
                      radius: CGFloat = 10, color: UIColor? = nil, width: CGFloat? = nil) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        if let color = color {
            layer.borderColor = color.cgColor
        }
        if let width = width {
            layer.borderWidth = width
        }
    }
}
