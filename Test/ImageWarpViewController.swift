//
//  ImageWarpViewController.swift
//  Test
//
//  Created by Alexander Selivanov on 01/02/2019.
//  Copyright © 2019 Alexander Selivanov. All rights reserved.
//

import UIKit

class ImageWarpViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    let SPRITE_SIZE = CGSize(width: 200, height: 200) // swiftlint:disable:this identifier_name
    let PIN_OFFSET: CGFloat = 10 // swiftlint:disable:this identifier_name

    enum PinTypes: Int {
        case bottomLeft, bottomRight, topLeft, topRight
    }

    var pins: [UIImageView] = []

    var touchedPin: UIImageView?
    var indexOfTouchedPin: Int?

    var ciImage: CIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .gray

        configureImage(named: "monalisa.jpg")

        configurePins()
    }

    @objc func handlePan(recognizer: UIPanGestureRecognizer) {

        guard let touchedView = recognizer.view else { return }

        let translation = recognizer.translation(in: recognizer.view)

        touchedView.center += translation

        recognizer.setTranslation(CGPoint.zero, in: touchedView)

        warpImage()
    }

    private func configureImage(named: String) {

        guard let monaLisa = UIImage(named: named) else { fatalError("File \"\(named)\" not found") }

        ciImage = CIImage(cgImage: monaLisa.cgImage!)

        imageView.frame = CGRect(x: 0, y: 0, width: SPRITE_SIZE.width, height: SPRITE_SIZE.height)
        imageView.center = imageView.superview?.center
            ?? CGPoint(x: UIScreen.main.bounds.maxX / 2, y: UIScreen.main.bounds.maxY / 2)

        imageView.contentMode = .scaleAspectFill

        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.green.cgColor

        imageView.image = monaLisa
    }

    private func warpImage() {

        guard let perspectiveTransform = CIFilter(name: "CIPerspectiveTransform")
            else { print("Filter not found"); return }

        let imageBottom = imageView.frame.maxX

        let bottomLeft = pins[PinTypes.bottomLeft.rawValue].center + CGPoint(x: PIN_OFFSET, y: -PIN_OFFSET)
        let bottomRight = pins[PinTypes.bottomRight.rawValue].center + CGPoint(x: -PIN_OFFSET, y: -PIN_OFFSET)
        let topLeft = pins[PinTypes.topLeft.rawValue].center + CGPoint(x: PIN_OFFSET, y: PIN_OFFSET)
        let topRight = pins[PinTypes.topRight.rawValue].center + CGPoint(x: -PIN_OFFSET, y: +PIN_OFFSET)

        guard let minMax = getMinAndMaxPoints(points: bottomLeft, bottomRight, topLeft, topRight) else { return }

        let newWidth = minMax.max.x - minMax.min.x
        let newHeight = minMax.max.y - minMax.min.y

        let newSize = CGSize(width: newWidth, height: newHeight)

        imageView.frame = CGRect(origin: minMax.min, size: newSize)

        var filterBottomLeft = CGPoint(x: bottomLeft.x, y: imageBottom - bottomLeft.y)
        var filterBottomRight = CGPoint(x: bottomRight.x, y: imageBottom - bottomRight.y)
        var filterTopLeft = CGPoint(x: topLeft.x, y: imageBottom - topLeft.y)
        var filterTopRight = CGPoint(x: topRight.x, y: imageBottom - topRight.y)

        // swiftlint:disable:next line_length
        guard let filterMinMax = getMinAndMaxPoints(points: filterBottomLeft, filterBottomRight, filterTopLeft, filterTopRight)
            else { return }

        filterBottomLeft -= filterMinMax.min
        filterBottomRight -= filterMinMax.min
        filterTopLeft -= filterMinMax.min
        filterTopRight -= filterMinMax.min

        perspectiveTransform.setValue(CIVector(cgPoint: filterBottomLeft), forKey: "inputBottomLeft")
        perspectiveTransform.setValue(CIVector(cgPoint: filterBottomRight), forKey: "inputBottomRight")
        perspectiveTransform.setValue(CIVector(cgPoint: filterTopLeft), forKey: "inputTopLeft")
        perspectiveTransform.setValue(CIVector(cgPoint: filterTopRight), forKey: "inputTopRight")

        perspectiveTransform.setValue(ciImage, forKey: kCIInputImageKey)

        guard let newImage = perspectiveTransform.outputImage else { return }

        imageView.image = UIImage(ciImage: newImage)
    }
    private func getMinAndMaxPoints(points: CGPoint...) -> (min: CGPoint, max: CGPoint)? {

        guard let firstPoint = points.first else { return nil }

        var min = firstPoint
        var max = firstPoint

        for point in points {

            if point.x < min.x { min.x = point.x }
            if point.x > max.x { max.x = point.x }
            if point.y < min.y { min.y = point.y }
            if point.y > max.y { max.y = point.y }
        }

        return (min: min, max: max)
    }

    private func configurePins() {

        func createPin(pinType: PinTypes, color: UIColor, center: CGPoint) {

            // let pinImage = UIImage(named: "scale")

            let frame = CGRect(x: 0, y: 0, width: 20, height: 20)

            let pin = UIImageView(frame: frame)
            pin.isUserInteractionEnabled = true
            pin.layer.cornerRadius = pin.frame.height / 2
            pin.layer.masksToBounds = true
            pin.contentMode = .scaleAspectFit
            pin.backgroundColor = color
            pin.center = center
            pins.insert(pin, at: pinType.rawValue)

            view.addSubview(pin)

            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
            pin.addGestureRecognizer(panGestureRecognizer)
        }

        createPin(pinType: .bottomLeft,
                  color: .yellow,
                  center: CGPoint(x: imageView.frame.minX - PIN_OFFSET, y: imageView.frame.maxY + PIN_OFFSET))

        createPin(pinType: .bottomRight,
                  color: .blue,
                  center: CGPoint(x: imageView.frame.maxX + PIN_OFFSET, y: imageView.frame.maxY + PIN_OFFSET))

        createPin(pinType: .topLeft,
                  color: .red,
                  center: CGPoint(x: imageView.frame.minX - PIN_OFFSET, y: imageView.frame.minY - PIN_OFFSET))

        createPin(pinType: .topRight,
                  color: .green,
                  center: CGPoint(x: imageView.frame.maxX + PIN_OFFSET, y: imageView.frame.minY - PIN_OFFSET))
    }
}
