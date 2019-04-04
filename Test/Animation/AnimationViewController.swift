//
//  AnimationViewController.swift
//  Test
//
//  Created by Alexander Selivanov on 05/03/2019.
//  Copyright © 2019 Alexander Selivanov. All rights reserved.
//

import UIKit

class AnimationViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    private let imageWidth = CGFloat(100)
    private let imageHeight = CGFloat(100)

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = UIImage(named: "monalisa")
        imageView.contentMode = .scaleAspectFit
        imageView.frame.size = CGSize(width: imageWidth, height: imageHeight)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        imageView.center = view.center
    }
    
    @IBAction func startTapped(_ sender: UIButton) {

        UIView.animate(withDuration: 2.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.imageView.frame = CGRect(origin: CGPoint(x: 0, y: 0),
                                          size: CGSize(width:self.imageWidth * 2.0, height: self.imageHeight * 2.0))
        })
    }
}
