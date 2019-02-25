//
//  UIView_extension.swift
//  FaceMorphing
//
//  Created by Endoral on 25.07.2018.
//  Copyright © 2018 Endoral. All rights reserved.
//

import UIKit

extension UIView {
    func snapshot(afterScreenUpdates: Bool = true) -> UIImage? {
        UIGraphicsBeginImageContext(bounds.size)

        defer {
            UIGraphicsEndImageContext()
        }

        drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)

        let image = UIGraphicsGetImageFromCurrentImageContext()

        return image
    }
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(
                width: radius,
                height: radius
            )
        )

        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath

        layer.mask = maskLayer
    }
}

extension UIView {
    /// Applying shadow on view.
    /// - Parameters:
    ///     - shadowPath:
    ///     - shadowColor: by default '.darkGray'
    ///     - shadowOpacity: by default '0.2'
    ///     - shadowRadius: by default '1.0'
    ///     - shadowOffset: by default 'CGSize(width: 1.0, height: 1.0)'
    func applyShadow(
        shadowPath: CGPath,
        shadowColor: UIColor? = .darkGray,
        shadowOpacity: Float = 0.2,
        shadowRadius: CGFloat = 1.0,
        shadowOffset: CGSize = CGSize(width: 1.0, height: 1.0)
        ) {
        layer.shadowPath = shadowPath
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
    }

    /// Applying shadow on view.
    /// - Parameters:
    ///     - shadowColor: by default '.darkGray'
    ///     - shadowOpacity: by default '0.2'
    ///     - shadowRadius: by default '1.0'
    ///     - shadowOffset: by default 'CGSize(width: 1.0, height: 1.0)'
    func applyShadow(
        shadowColor: UIColor? = .darkGray,
        shadowOpacity: Float = 0.2,
        shadowRadius: CGFloat = 1.0,
        shadowOffset: CGSize = CGSize(width: 1.0, height: 1.0)
        ) {
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath

        applyShadow(
            shadowPath: shadowPath,
            shadowColor: shadowColor,
            shadowOpacity: shadowOpacity,
            shadowRadius: shadowRadius,
            shadowOffset: shadowOffset
        )
    }
}
