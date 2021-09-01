//
//  Pointer.swift
//  Clock
//
//  Created by Kyle Lei on 2021/9/1.
//

import Foundation
import UIKit

class Pointer {
    var angle: CGFloat = 0
    var pointerLeadingLength: CGFloat = 75
    var pointerTailingLength: CGFloat = 10
    let path = UIBezierPath()
    let shape = CAShapeLayer()
    let view = UIView()
    
    func lineShape(lineWidth: CGFloat, color: UIColor) {
        shape.lineWidth = lineWidth
        shape.lineCap = .round
        shape.strokeColor = color.cgColor
        shape.fillColor = UIColor.clear.cgColor
    }

    func shadow(_ shadowOn: Bool) {
        if shadowOn {
            shape.shadowOffset = CGSize(width: 0, height: 5)
            shape.shadowColor = UIColor.black.cgColor
            shape.shadowRadius = 5
            shape.shadowOpacity = 0.5
        }
    }
}
