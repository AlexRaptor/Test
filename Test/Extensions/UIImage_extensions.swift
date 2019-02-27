//
//  UIImage_extension.swift
//  Colors
//
//  Created by mac on 27.02.17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

extension UIImage: DataConvertible {
    static func decompressed(from data: Data) -> Self? {
        let result = self.init(data: data)
        return result
    }

    func compressed() -> Data? {
        let data = pngData()
        return data
    }
}

extension UIImage {
    enum ResizingOption {
        /// Resize the image anyway
        case anyway

        /// Resize image if current size is larger than new size
        case ifLarger

        /// Resize image if current size is smaller than new size
        case ifSmaller
    }

    enum ResizingAspect {
        /// Apply new size to the larger side of the image.
        case fit

        /// Apply new size to the smaller side of the image.
        case fill
    }

    /// Proportional image resizing
    /// - Parameters:
    ///     - with: Value of new image size.
    ///     - aspect: The side of the image to which the specified size will be applied. Default value is '.fit'.
    ///     - option: Image resizing condition. Default value is '.anyway'.
    /// - Returns:
    ///     - Resized image if successful.
    ///     - Original image in case the original image does not meet the specified resizing conditions.
    ///     - nil in case something went wrong with the image context.
    func proportionallyResize(with newSize: CGFloat, aspect: ResizingAspect = .fit, option: ResizingOption = .anyway) -> UIImage? {
        let actualSize: CGFloat

        switch aspect {
        case .fit:
            actualSize = max(size.width, size.height)

        case .fill:
            actualSize = min(size.width, size.height)
        }

        switch option {
        case .anyway:
            break

        case .ifLarger:
            guard actualSize > newSize else {
                return self
            }

        case .ifSmaller:
            guard actualSize < newSize else {
                return self
            }
        }

        let scale = newSize / actualSize
        let newScaledSize = CGSize(width: size.width * scale, height: size.height * scale)
        let imageBounds = CGRect(origin: .zero, size: newScaledSize)

        UIGraphicsBeginImageContext(newScaledSize)

        draw(in: imageBounds)

        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return resizedImage
    }
}

extension UIImage {

    convenience init?(layer: CALayer) {
        UIGraphicsBeginImageContext(layer.frame.size)

        defer {
            UIGraphicsEndImageContext()
        }

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        context.saveGState()

        defer {
            context.restoreGState()
        }

        layer.render(in: context)

        guard let outputImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }

        guard let outputData = outputImage.pngData() else {
            return nil
        }

        self.init(data: outputData)
    }

    func pixelColor(at point: CGPoint) -> UIColor? {
        guard let pixelData = cgImage?.dataProvider?.data else {
            return nil
        }

        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let pixelInfo: Int = ((Int(size.width) * Int(point.y)) + Int(point.x)) * 4

        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo + 1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo + 2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo + 3]) / CGFloat(255.0)

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }

    func fixOrientation() -> UIImage {
        guard imageOrientation != .up else {
            return self
        }

        var transform: CGAffineTransform = .identity

        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)

        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2)

        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -CGFloat.pi / 2)

        case .up, .upMirrored:
            break
        }

        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)

        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)

        case .up, .down, .left, .right:
            break
        }

        guard
            let cgImg = self.cgImage,
            let colorSpace = cgImg.colorSpace,
            let ctx: CGContext = CGContext(
                data: nil,
                width: Int(size.width),
                height: Int(size.height),
                bitsPerComponent: cgImg.bitsPerComponent,
                bytesPerRow: 0,
                space: colorSpace,
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            ) else {
                return self
        }

        ctx.concatenate(transform)

        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImg, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))

        default:
            ctx.draw(cgImg, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }

        guard let cgImage: CGImage = ctx.makeImage() else {
            return self
        }

        return UIImage(cgImage: cgImage)
    }

    func cropping(to rect: CGRect) -> UIImage? {
        guard let image = self.cgImage?.cropping(to: rect) else {
            return nil
        }

        return UIImage(cgImage: image)
    }
}

extension UIImage {
    func writeToSavedPhotosAlbum(completionTarget: Any?, completionSelector: Selector?, contextInfo: UnsafeMutableRawPointer? = nil) {
        UIImageWriteToSavedPhotosAlbum(self, completionTarget, completionSelector, contextInfo)
    }
}








