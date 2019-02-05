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

    var ciImage: CIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let monaLisa = UIImage(named: "monalisa.jpg") else { fatalError("File \"monalisa.jpg\" not found") }

        ciImage = CIImage(cgImage: monaLisa.cgImage!)

        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
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

        let center = imageView.center

        let newWidth = minMax.max.x - minMax.min.x
        let newHeight = minMax.max.y - minMax.min.y

        print("newSize: \(newWidth), \(newHeight)")

        imageView.frame = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
        imageView.center = center

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
}
