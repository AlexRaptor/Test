//
//  GradientView.swift
//  Test
//
//  Created by Alexander Selivanov on 19/02/2019.
//  Copyright © 2019 Alexander Selivanov. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    override class var layerClass: AnyClass { return CAGradientLayer.self }

    @IBInspectable var startColor: UIColor? = UIColor.white { didSet{ updateGradientColor() } }
    @IBInspectable var endColor: UIColor? = UIColor.white { didSet{ updateGradientColor() } }

    // Degrees clockwise from 12 hour's arrow on clock.
    // angle between 0º and 179º
    @IBInspectable var angle: CGFloat = 0 { didSet { updateGradientDirection() } }

    private weak var gradientLayer: CAGradientLayer! { return (layer as! CAGradientLayer) }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateGradient()
    }

    #if !TARGET_INTERFACE_BUILDER
    override func awakeFromNib() {
        super.awakeFromNib()
        updateGradient()
    }
    #endif

    private func updateGradientColor() {
        guard
            let startColor = startColor?.cgColor,
            let endColor = endColor?.cgColor else {
                return
        }

        gradientLayer.colors = [startColor, endColor]
    }

    private func updateGradientDirection() {

        let angle = ( 180 - self.angle ) / 180 * CGFloat.pi

        let startX = CGFloat(0)
        var startY = CGFloat(0)

        var dx = frame.width
        var dy = CGFloat(0)

        var x = frame.width
        var y = frame.height

        if tan(angle) != 0 {
            x = frame.width
            y = x / tan(angle)

            dy = y - frame.height
            dx = dy * tan(angle)
        }

        x -= dx
        y = x / tan(angle)

        let endX = x / frame.width
        let endY = y / frame.height

        var normEndX = endX / max(abs(endX), abs(endY))
        var normEndY = endY / max(abs(endX), abs(endY))

        if normEndX < 0 {
            startY = 1
            normEndX = abs(normEndX)
            normEndY = 1 - normEndY
        }

        gradientLayer.startPoint = CGPoint(x: startX, y: startY)
        gradientLayer.endPoint = CGPoint(x: normEndX, y: normEndY)
    }

    private func updateGradient() {
        updateGradientColor()
        updateGradientDirection()
    }
}
