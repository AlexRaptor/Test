//
//  TutorialPageViewController.swift
//  Test
//
//  Created by Alexander Selivanov on 25/02/2019.
//  Copyright © 2019 Alexander Selivanov. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController {

    var bottomView: TutorialBottomView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureBottom()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        bottomView?.roundCorners([.topLeft, .topRight], radius: 10)
    }

    func configureBottom() {

        bottomView = TutorialBottomView.instantiate()


        view.addSubview(bottomView)

        bottomView.translatesAutoresizingMaskIntoConstraints = false

        let views = ["bottomView": bottomView]

        let heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[bottomView(122)]", options: .alignAllLastBaseline, metrics: nil, views: views)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[bottomView]-0-|", options: .alignAllLastBaseline, metrics: nil, views: views)
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[bottomView]-16-|", options: .alignAllLastBaseline, metrics: nil, views: views)

        NSLayoutConstraint.activate(heightConstraints + verticalConstraints + horizontalConstraints)
    }
}

//extension TutorialPageViewController: UIPageViewControllerDataSource {
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        <#code#>
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        <#code#>
//    }
//
//
//
//}
//
//extension TutorialPageViewController: UIPageViewControllerDelegate {
//
//}
