//
//  CGSize_extenders.swift
//  Test
//
//  Created by Alexander Selivanov on 27/02/2019.
//  Copyright © 2019 Alexander Selivanov. All rights reserved.
//

import UIKit

extension CGSize {

    init(dimension: CGFloat) {
        self.init(width: dimension, height: dimension)
    }
}

extension CGSize {

    static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    static func += (lhs: inout CGSize, rhs: CGSize) {
        lhs = lhs + rhs
    }

    static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }

    static func -= (lhs: inout CGSize, rhs: CGSize) {
        lhs = lhs - rhs
    }

    static func + (lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width + rhs, height: lhs.height + rhs)
    }

    static func += (lhs: inout CGSize, rhs: CGFloat) {
        lhs = lhs + rhs
    }

    static func - (lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width - rhs, height: lhs.height - rhs)
    }

    static func -= (lhs: inout CGSize, rhs: CGFloat) {
        lhs = lhs - rhs
    }
}
