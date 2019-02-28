//
//  TutorialPageViewController.swift
//  Test
//
//  Created by Alexander Selivanov on 25/02/2019.
//  Copyright © 2019 Alexander Selivanov. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController {

    private var bottomView: TutorialBottomView!

    fileprivate(set) lazy var tutorialViewControllers = {
        return [
            self.getNewTutorialViewController(text: "Грудь", imageName: "tutorial_1"),
            self.getNewTutorialViewController(text: "Пресс", imageName: "tutorial_2"),
            self.getNewTutorialViewController(text: "Прическа", imageName: "tutorial_3"),
            self.getNewTutorialViewController(text: "Борода", imageName: "tutorial_4")
        ]
    }()

    private var currentPageIndex = 0

    private func getNewTutorialViewController(text: String?, imageName: String?) -> TutorialViewController? {

        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiate(TutorialViewController.self)
            else { return nil }

        viewController.descriptionText = text
        viewController.previewImageName = imageName

        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self

        configureBottom()

        setViewControllerForCurrentPage()

        updateUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        bottomView?.view.roundCorners([.topLeft, .topRight], radius: 10)

        let bottomViewPath = UIBezierPath(roundedRect: bottomView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(
            width: 10,
            height: 10
        ))

        bottomView.applyShadow(shadowPath: bottomViewPath.cgPath, shadowColor: .darkGray, shadowOpacity: 0.5, shadowRadius: 10, shadowOffset: CGSize(width: 0, height: -5))
    }

    func configureBottom() {

        bottomView = TutorialBottomView.instantiate()

        bottomView.buttonHandler = { [weak self, weak bottomView] in

            self?.currentPageIndex += 1

            if (self?.currentPageIndex)! >= (bottomView?.pageControl.numberOfPages)! {
                print("EXIT")
                self?.currentPageIndex = (bottomView?.pageControl.numberOfPages)! - 1
                return
            }

            bottomView?.pageControl.currentPage = (self?.currentPageIndex)!
            self?.setViewControllerForCurrentPage()
            self?.updateUI()
        }

        bottomView.pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.8196078431, green: 0.8196078431, blue: 0.8196078431, alpha: 1)
        bottomView.pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.1921568627, green: 0.5647058824, blue: 1, alpha: 1)
        bottomView.pageControl.numberOfPages = tutorialViewControllers.count
        bottomView.pageControl.currentPage = currentPageIndex
        bottomView.pageControl.addTarget(self, action: #selector(pageControlTapHandler(sender:)), for: .valueChanged)

        view.addSubview(bottomView)

        bottomView.translatesAutoresizingMaskIntoConstraints = false

        let views: [String: Any] = ["bottomView": bottomView]

        let heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[bottomView(122)]", options: .alignAllLastBaseline, metrics: nil, views: views)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[bottomView]-0-|", options: .alignAllLastBaseline, metrics: nil, views: views)
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[bottomView]-0-|", options: .alignAllLastBaseline, metrics: nil, views: views)

        NSLayoutConstraint.activate(heightConstraints + verticalConstraints + horizontalConstraints)
    }

    private func setViewControllerForCurrentPage() {

        guard let firstMainViewController = tutorialViewControllers[currentPageIndex] else { return }

        setViewControllers([firstMainViewController], direction: .forward, animated: true, completion: nil)
    }

    @objc func pageControlTapHandler(sender: UIPageControl) {

        currentPageIndex = sender.currentPage
        bottomView.pageControl.currentPage = currentPageIndex
        setViewControllerForCurrentPage()
    }

    func updateUI() {

        bottomView.button.setTitle(currentPageIndex < (bottomView.pageControl.numberOfPages - 1) ? "Next" : "Close", for: .normal)
    }
}

extension TutorialPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let currentIndex = tutorialViewControllers.index(of: viewController as! TutorialViewController),
        currentIndex > 0
            else { return nil }

        return tutorialViewControllers[currentIndex - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let currentIndex = tutorialViewControllers.index(of: viewController as! TutorialViewController),
            currentIndex < (tutorialViewControllers.count - 1)
            else { return nil }

        return tutorialViewControllers[currentIndex + 1]
    }
}

extension TutorialPageViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        guard let tutorialViewController = pageViewController.viewControllers![0] as? TutorialViewController else { return }

        currentPageIndex = tutorialViewControllers.index(of: tutorialViewController)!

        bottomView.pageControl.currentPage = currentPageIndex
        updateUI()
    }
}
