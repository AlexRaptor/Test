//
//  UIPageViewControllerWithOverlayIndicator.swift
//  Test
//
//  Created by Alexander Selivanov on 28/01/2019.
//  Copyright © 2019 Alexander Selivanov. All rights reserved.
//

import UIKit

class PageViewControllerWithStaticPageControl: UIPageViewController {

    var pageControl = UIPageControl()

    private lazy var orderedViewControllers: [UIViewController?] = {
        return [newColoredViewController(withIdentifier: "PageView", color: .red),
                newColoredViewController(withIdentifier: "PageView", color: .green),
                newColoredViewController(withIdentifier: "PageView", color: .blue)]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self

        configurePageControl()

        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController!],
                               direction: .forward,
                               animated: true, completion: nil)
        }
    }

    func configurePageControl() {

        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50,
                                                   width: UIScreen.main.bounds.width, height: 50))
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }

    private func newColoredViewController(withIdentifier storyboardId: String,
                                          color: UIColor) -> StaticPageControlViewController? {

        guard let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: storyboardId) as? StaticPageControlViewController
            else { return nil }

        viewController.color = color

        return viewController
    }

}

extension PageViewControllerWithStaticPageControl: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard var currentIndex = orderedViewControllers.firstIndex(of: viewController) else { return nil }

        if currentIndex == 0 {
            currentIndex = orderedViewControllers.count
        }

        currentIndex -= 1

        return orderedViewControllers[currentIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard var currentIndex = orderedViewControllers.firstIndex(of: viewController) else { return nil }

        currentIndex += 1

        if currentIndex == orderedViewControllers.count {
            currentIndex = 0
        }

        return orderedViewControllers[currentIndex]
    }
}

// MARK: - UIPageViewControllerDelegate Methods
extension PageViewControllerWithStaticPageControl: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {

        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.firstIndex(of: pageContentViewController)!
    }
}
