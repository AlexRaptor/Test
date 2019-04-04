//
//  PageViewController.swift
//  Test
//
//  Created by Alexander Selivanov on 28/01/2019.
//  Copyright © 2019 Alexander Selivanov. All rights reserved.
//

import UIKit

class StaticPageControlViewController: UIViewController {

    var color: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = color
    }
}
