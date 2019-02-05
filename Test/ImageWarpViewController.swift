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

//    lazy var sourceSizeX: CGFloat =
//        (sourcePinPositions[PinTypes.bottomRight.rawValue].x - sourcePinPositions[PinTypes.bottomLeft.rawValue].x)
//    lazy var sourceSizeY: CGFloat =
//        (sourcePinPositions[PinTypes.topLeft.rawValue].y - sourcePinPositions[PinTypes.bottomLeft.rawValue].y)

    enum PinTypes: Int {
        case bottomLeft, bottomRight, topLeft, topRight
    }

    var pins: [UIImageView] = []
//    var sourcePinPositions: [CGPoint] = []
//    let sourcePositions: [float2] = [float2(0, 0), float2(1, 0), float2(0, 1), float2(1, 1)]
//    var destinationPositions: [float2] = [float2(0, 0), float2(1, 0), float2(0, 1), float2(1, 1)]

    var touchedPin: UIImageView?
    var indexOfTouchedPin: Int?

    var ciImage: CIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)

        configureImage(named: "monalisa.jpg")

        configurePins()
    }

    private func configureGestures() {

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }

    @objc func handlePan(recognizer: UIPanGestureRecognizer) {

        print("pan")

        switch recognizer.state {

        case .began:
            print("began")
            let touchLocation = recognizer.location(in: recognizer.view)
//            let skTouchLocation = CGPoint(x: touchLocation.x, y: recognizer.view!.bounds.height - touchLocation.y)

//            guard let touchedPin = view.subviews(at:)
            nodes(at: skTouchLocation).filter({ self.pins.contains($0) }).first
                else {

                    print("touchLocation: \(touchLocation)")
                    print("skTouchLocation: \(skTouchLocation)")

                    for pin in pins {
                        print("\(pin.name): \(pin.position)")
                    }

                    break

            }

            self.touchedPin = touchedPin
            indexOfTouchedPin = pins.firstIndex(of: touchedPin)

            if indexOfTouchedPin == nil {
                print("NIL")
            } else {
                print("indexOfTouchedPin: \(indexOfTouchedPin)")
            }

        case .ended:
            print("ended")
            guard let touchedPin = self.touchedPin else { break }

            let translation = recognizer.translation(in: self.view)

            touchedPin.position = CGPoint(x: touchedPin.position.x + translation.x,
                                          y: touchedPin.position.y - translation.y)
            self.touchedPin = nil
            self.indexOfTouchedPin = nil
            print("\n\n\n")
        case .changed:
            //print("changed")
            guard let touchedPin = self.touchedPin,
                let indexOfTouchedPin = self.indexOfTouchedPin
                else { break }

            let translation = recognizer.translation(in: self.view)

            touchedPin.position = CGPoint(x: touchedPin.position.x + translation.x,
                                          y: touchedPin.position.y - translation.y)

            recalculateDestinationPositions(indexOfTouchedPin, touchedPin)

            warpImage()

        default:
            print("default")
            break
        }

        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }

    private func configureImage(named: String) {

        guard let monaLisa = UIImage(named: named) else { fatalError("File \"\(named)\" not found") }

        ciImage = CIImage(cgImage: monaLisa.cgImage!)

        imageView.frame = CGRect(x: 0, y: 0, width: SPRITE_SIZE.width, height: SPRITE_SIZE.height)
        imageView.center = imageView.superview?.center
            ?? CGPoint(x: UIScreen.main.bounds.maxX / 2, y: UIScreen.main.bounds.maxY / 2)

        imageView.contentMode = .scaleAspectFill

        imageView.backgroundColor = .gray
        imageView.image = monaLisa
    }

    @IBAction func testButtonTapped(_ sender: UIButton) {

        guard let perspectiveTransform = CIFilter(name: "CIPerspectiveTransform")
            else { print("Filter not found"); return }

        let bottomLeft = CGPoint(x: 0, y: 0)
        let bottomRight = CGPoint(x: 200, y: 0)
        let topLeft = CGPoint(x: 0, y: 200)
        let topRight = CGPoint(x: 250, y: 250)

        guard let minMax = getMinAndMaxPoints(points: bottomLeft, bottomRight, topLeft, topRight) else { return }

//        let origin = imageView.frame.origin

        let newWidth = minMax.max.x - minMax.min.x
        let newHeight = minMax.max.y - minMax.min.y

        let newSize = CGSize(width: newWidth, height: newHeight)

//        print("newSize: \(newWidth), \(newHeight)")

//        print("old origin: \(imageView.frame.origin)")

        imageView.frame.size = newSize
//        imageView.frame = CGRect(origin: origin, size: newSize)
//        imageView.center = center

//        print("new origin: \(imageView.frame.origin)")

        perspectiveTransform.setValue(CIVector(cgPoint: bottomLeft), forKey: "inputBottomLeft")
        perspectiveTransform.setValue(CIVector(cgPoint: bottomRight), forKey: "inputBottomRight")
        perspectiveTransform.setValue(CIVector(cgPoint: topLeft), forKey: "inputTopLeft")
        perspectiveTransform.setValue(CIVector(cgPoint: topRight), forKey: "inputTopRight")

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

//        let pinImage = UIImage(named: "scale")

        let frame = CGRect(x: 0, y: 0, width: 20, height: 20)

        var pin = UIImageView(frame: frame)
        pin.layer.cornerRadius = pin.frame.height / 2
        pin.layer.masksToBounds = true
        pin.contentMode = .scaleAspectFit
        pin.backgroundColor = .yellow
        pin.center = CGPoint(x: imageView.frame.minX - PIN_OFFSET, y: imageView.frame.maxY + PIN_OFFSET)
        pins.insert(pin, at: PinTypes.bottomLeft.rawValue)
        view.addSubview(pin)

        pin = UIImageView(frame: frame)
        pin.layer.cornerRadius = pin.frame.height / 2
        pin.layer.masksToBounds = true
        pin.contentMode = .scaleAspectFit
        pin.backgroundColor = .blue
        pin.center = CGPoint(x: imageView.frame.maxX + PIN_OFFSET, y: imageView.frame.maxY + PIN_OFFSET)
        pins.insert(pin, at: PinTypes.bottomRight.rawValue)
        view.addSubview(pin)

        pin = UIImageView(frame: frame)
        pin.layer.cornerRadius = pin.frame.height / 2
        pin.layer.masksToBounds = true
        pin.contentMode = .scaleAspectFit
        pin.backgroundColor = .red
        pin.center = CGPoint(x: imageView.frame.minX - PIN_OFFSET, y: imageView.frame.minY - PIN_OFFSET)
        pins.insert(pin, at: PinTypes.topLeft.rawValue)
        view.addSubview(pin)

        pin = UIImageView(frame: frame)
        pin.layer.cornerRadius = pin.frame.height / 2
        pin.layer.masksToBounds = true
        pin.contentMode = .scaleAspectFit
        pin.backgroundColor = .green
        pin.center = CGPoint(x: imageView.frame.maxX + PIN_OFFSET, y: imageView.frame.minY - PIN_OFFSET)
        pins.insert(pin, at: PinTypes.topRight.rawValue)
        view.addSubview(pin)
    }
}
