//
//  CustomizableButton.swift
//  CustomizableButton
//
//  Created by Endoral on 07.07.17.
//  Copyright © 2017 Endoral. All rights reserved.
//

import UIKit

@IBDesignable
public class CustomizableButton: UIButton {
    /// Gradient direction type. horizontal = 0, vertical = 1, diagonal = 2
    public enum GradientDirection: Int {
        case horizontal = 0
        case vertical = 1
        case diagonal = 2
    }

    /// Layer corner radius. default = 0.0
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    /// Layer border width. default = 0.0
    @IBInspectable public var borderWidth: CGFloat = 0.0 {
        didSet {
            setBackgroundFromColor()
        }
    }

    /// Layer border color. default = nil
    @IBInspectable public var borderColor: UIColor? {
        didSet {
            setBackgroundFromColor()
        }
    }

    /// Color for drawing background image. default = nil
    @IBInspectable public var backgroundFromColor: UIColor? {
        didSet {
            setBackgroundFromColor()
        }
    }

    /// Color for drawing background image with gradient. default = nil
    @IBInspectable public var backgroundToColor: UIColor? {
        didSet {
            setBackgroundFromColor()
        }
    }

    /// Gradient direction. default = 0. horizontal = 0, vertical = 1, diagonal = 2
    @IBInspectable public var gradientDirection: Int {
        get {
            return gradientDir.rawValue
        }

        set {
            gradientDir = GradientDirection(rawValue: newValue) ?? .horizontal
        }
    }

    /// Layer shadow color. default = .darkGray
    @IBInspectable public var shadowColor: UIColor? = .darkGray {
        didSet {
            layer.shadowColor = shadowColor?.cgColor
        }
    }

    /// Layer shadow opacity. default = 0.2
    @IBInspectable public var shadowOpacity: Float = 0.2 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }

    /// Layer shadow radius. default = 1.0
    @IBInspectable public var shadowRadius: CGFloat = 1.0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }

    /// Layer shadow offset. default = (1.0, 1.0)
    @IBInspectable public var shadowOffset: CGSize = CGSize(width: 1.0, height: 1.0) {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }

    /// Gradient direction. default = .horizontal
    public var gradientDir: GradientDirection = .horizontal {
        didSet {
            setBackgroundFromColor()
        }
    }

    private var _backgroundFromColor: UIImage?

    override public var bounds: CGRect {
        didSet {
            setBackgroundFromColor()
        }
    }

    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        configureLayer()
        configureShadow()
        setBackgroundFromColor()
    }

    #if !TARGET_INTERFACE_BUILDER
    override public func awakeFromNib() {
        super.awakeFromNib()

        configureLayer()
        configureShadow()
        setBackgroundFromColor()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    #endif

    private func configureLayer() {
        layer.cornerRadius = cornerRadius
    }

    private func configureShadow() {
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
    }

    private func makeOutMaskLayer() -> CAShapeLayer {
        let outMaskPath = makeOutMaskPath()
        let layer = CAShapeLayer()

        layer.fillColor = borderColor?.cgColor
        layer.frame = bounds
        layer.path = outMaskPath.cgPath
        layer.fillRule = .evenOdd

        return layer
    }

    private func makeInMaskLayer() -> CAShapeLayer {
        let inMaskPath = makeInMaskPath()
        let layer = CAShapeLayer()

        layer.frame = bounds
        layer.path = inMaskPath.cgPath
        layer.fillRule = .evenOdd

        return layer
    }

    private func makeOutMaskPath() -> UIBezierPath {
        let outMaskRect = CGRect(
            origin: bounds.origin,
            size: bounds.size
        )

        let inMaskPath = makeInMaskPath()
        let path = UIBezierPath(roundedRect: outMaskRect, cornerRadius: cornerRadius)

        path.append(inMaskPath)
        path.usesEvenOddFillRule = true

        return path
    }

    private func makeInMaskPath() -> UIBezierPath {
        let inMaskRect = CGRect(
            origin: bounds.origin + borderWidth,
            size: bounds.size - borderWidth * 2
        )

        let path = UIBezierPath(roundedRect: inMaskRect, cornerRadius: cornerRadius - borderWidth)

        return path
    }

    private func makeBackground(from color: UIColor) -> UIImage? {
        let outMaskLayer = makeOutMaskLayer()
        let inMaskLayer = makeInMaskLayer()
        inMaskLayer.fillColor = color.cgColor

        let layer = CALayer()

        layer.frame = bounds
        layer.addSublayer(outMaskLayer)
        layer.addSublayer(inMaskLayer)

        let image = UIImage(layer: layer)

        return image
    }

    private func makeGradientBackground(from fromColor: UIColor, to toColor: UIColor) -> UIImage? {
        let startPoint: CGPoint
        let endPoint: CGPoint

        switch gradientDir {
        case .horizontal:
            startPoint = CGPoint(x: 0.0, y: 0.5)
            endPoint = CGPoint(x: 1.0, y: 0.5)

        case .vertical:
            startPoint = CGPoint(x: 0.5, y: 0.0)
            endPoint = CGPoint(x: 0.5, y: 1.0)

        case .diagonal:
            startPoint = CGPoint(x: 0.0, y: 0.0)
            endPoint = CGPoint(x: 1.0, y: 1.0)
        }

        let outMaskLayer = makeOutMaskLayer()
        let inMaskLayer = makeInMaskLayer()
        let gradientLayer = CAGradientLayer()

        gradientLayer.frame = bounds
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = [fromColor.cgColor, toColor.cgColor]
        gradientLayer.mask = inMaskLayer

        let layer = CALayer()

        layer.frame = bounds
        layer.addSublayer(outMaskLayer)
        layer.addSublayer(gradientLayer)

        let gradientImage = UIImage(layer: layer)

        return gradientImage
    }

    private func setBackgroundFromColor() {
        guard let from = backgroundFromColor else {
            return
        }

        if let to = backgroundToColor {
            _backgroundFromColor = makeGradientBackground(from: from, to: to)
        } else {
            _backgroundFromColor = makeBackground(from: from)
        }

        setBackgroundImage(_backgroundFromColor, for: .normal)
    }
}
