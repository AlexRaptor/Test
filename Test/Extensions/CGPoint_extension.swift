//
//  CGPoint_extenders.swift
//  Test
//
//  Created by Alexander Selivanov on 04/02/2019.
//  Copyright © 2019 Alexander Selivanov. All rights reserved.
//

//import Foundation
import UIKit

extension CGPoint {

    init(scalar: CGFloat) {
        self.init(x: scalar, y: scalar)
    }
}

extension CGPoint {

    var magnitude: CGFloat {
        return sqrt(pow(self.x, 2) + pow(self.y, 2))
    }

    var normalized: CGPoint {
        return CGPoint(x: self.x / abs(magnitude), y: self.y / abs(magnitude))
    }

    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func += (lhs: inout CGPoint, rhs: CGPoint) {
        lhs = lhs + rhs // swiftlint:disable:this shorthand_operator
    }

    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    static func -= (lhs: inout CGPoint, rhs: CGPoint) {
        lhs = lhs - rhs // swiftlint:disable:this shorthand_operator
    }

    static func + (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x + rhs, y: lhs.y + rhs)
    }

    static func += (lhs: inout CGPoint, rhs: CGFloat) {
        lhs = lhs + rhs
    }

    static func - (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x - rhs, y: lhs.y - rhs)
    }

    static func -= (lhs: inout CGPoint, rhs: CGFloat) {
        lhs = lhs - rhs
    }
}
