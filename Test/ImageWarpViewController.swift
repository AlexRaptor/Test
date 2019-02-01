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

    var image: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let monaLisa = UIImage(named: "monalisa.jpg") else { fatalError("File \"monalisa.jpg\" not found") }

        image = monaLisa
        imageView.image = image
    }

    @IBAction func testButtonTapped(_ sender: UIButton) {

        guard let ciImage = CIImage(image: self.image) else { return }

//        let ciContext = CIContext()

//        let rect = CIRectangleFeature

        guard let perspectiveTransform = CIFilter(name: "CIPerspectiveTransform")
            else { print("Filter not found"); return }

        let topLeft = CGPoint(x: 0, y: 200)
        let topRight = CGPoint(x: 150, y: 150)
        let bottomRight = CGPoint(x: 200, y: 50)
        let bottomLeft = CGPoint(x: 0, y: 0)

        perspectiveTransform.setValue(CIVector(cgPoint: topLeft), forKey: "inputTopLeft")
        perspectiveTransform.setValue(CIVector(cgPoint: topRight), forKey: "inputTopRight")
        perspectiveTransform.setValue(CIVector(cgPoint: bottomRight), forKey: "inputBottomRight")
        perspectiveTransform.setValue(CIVector(cgPoint: bottomLeft), forKey: "inputBottomLeft")

        perspectiveTransform.setValue(ciImage, forKey: kCIInputImageKey)

        let newImage = perspectiveTransform.outputImage!

        imageView.image = UIImage(ciImage: newImage)

    }
}
