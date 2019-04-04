//
//  TutorialViewController.swift
//  Test
//
//  Created by Alexander Selivanov on 25/02/2019.
//  Copyright © 2019 Alexander Selivanov. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var previewImage: UIImageView!

    var descriptionText: String?
    var previewImageName: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionLabel.text = descriptionText

        if let previewImageName = previewImageName, let image = UIImage(named: previewImageName) {
            previewImage.image = image
        }
    }
}
