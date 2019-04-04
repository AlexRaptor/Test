//
//  TutorialBottomView.swift
//  Test
//
//  Created by Alexander Selivanov on 25/02/2019.
//  Copyright © 2019 Alexander Selivanov. All rights reserved.
//

import UIKit

final class TutorialBottomView: UIView, Instantiable {

    var buttonHandler: (() -> Void)?

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var view: UIView!

    @IBAction func buttonTapped(_ sender: UIButton) {

        buttonHandler?()
    }
}
