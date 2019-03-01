//
//  CustomPageControl.swift
//  Belle
//
//  Created by Endoral on 21/01/2019.
//  Copyright © 2019 Endoral. All rights reserved.
//

import UIKit

class CustomPageControl: UIPageControl {

    override var currentPage: Int {
        didSet {
            updatePageIndicators()
        }
    }

    private lazy var currentPageIndicator: UIView = {
        let view = UIView()

        view.backgroundColor = currentPageIndicatorTintColor

        view.clipsToBounds = true

        return view
    }()

    func updatePageIndicators() {

        subviews.enumerated().forEach { index, subview in

            guard index == currentPage else { return }

            let frame = CGRect(origin: CGPoint(scalar: -2), size: CGSize(dimension: subview.bounds.height + 4))

            currentPageIndicator.removeFromSuperview()
            currentPageIndicator.frame = frame
            currentPageIndicator.layer.cornerRadius = frame.width / 2

            subview.backgroundColor = .clear
            subview.addSubview(currentPageIndicator)
        }
    }
}
