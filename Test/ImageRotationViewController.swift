//
//  ImageRotationViewController.swift
//  Test
//
//  Created by Alexander on 12/04/2019.
//  Copyright © 2019 Alexander Selivanov. All rights reserved.
//

import UIKit

class ImageRotationViewController: UIViewController {
    
    @IBOutlet private weak var frontImageView: UIImageView!
    @IBOutlet private weak var leftImageView: UIImageView!
    @IBOutlet private weak var rightImageView: UIImageView!
    
    private var imagesArray: [(color: UIImage?, bw: UIImage?)] = [(nil, nil), (nil, nil), (nil, nil)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Image Rotation"
        
        initializeData()
        initializeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 0.5), view: frontImageView)
//        setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 0.5), view: leftImageView)
//        setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 0.5), view: rightImageView)
        
        leftImageView.transform = CGAffineTransform(translationX: -leftImageView.bounds.size.width / 1.55, y: 0)//-leftImageView.bounds.size.height / 12)
            .concatenating(CGAffineTransform(scaleX: 0.7, y: 0.7)).concatenating(CGAffineTransform(rotationAngle: -0.12))
       
        rightImageView.transform = CGAffineTransform(translationX: rightImageView.bounds.size.width / 1.55, y: 0)//-rightImageView.bounds.size.height / 12)
            .concatenating(CGAffineTransform(scaleX: 0.7, y: 0.7)).concatenating(CGAffineTransform(rotationAngle: 0.12))
    }
    
    func initializeData() {
        imagesArray = [
            (color: UIImage(named: "Color_0"), bw: UIImage(named: "BW_0")),
            (color: UIImage(named: "Color_1"), bw: UIImage(named: "BW_1")),
            (color: UIImage(named: "Color_2"), bw: UIImage(named: "BW_2"))
        ]
    }
    
    func initializeUI() {
        
        frontImageView.image = imagesArray[0].color
        leftImageView.image = imagesArray[1].bw
        rightImageView.image = imagesArray[2].bw
    }
    
//    func setAnchorPoint(anchorPoint: CGPoint, view: UIView) {
//        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
//        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
//
//        newPoint = newPoint.applying(view.transform)
//        oldPoint = oldPoint.applying(view.transform)
//
//        var position : CGPoint = view.layer.position
//
//        position.x -= oldPoint.x
//        position.x += newPoint.x;
//
//        position.y -= oldPoint.y;
//        position.y += newPoint.y;
//
//        view.layer.position = position;
//        view.layer.anchorPoint = anchorPoint;
//    }
    
    @IBAction private func onStartTap(_ sender: UIButton) {
        
        let duration = 1.0
        
        sender.isEnabled = false
        
        view.bringSubviewToFront(rightImageView)
        view.bringSubviewToFront(frontImageView)
        
        UIView.transition(with: self.frontImageView,
                          duration: duration,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.frontImageView.image = self?.imagesArray[0].bw
        })
        
        UIView.transition(with: self.rightImageView,
                              duration: duration,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                self?.rightImageView.image = self?.imagesArray[2].color
        }) { [weak self] (_) in
            let lastImage = self?.imagesArray.removeLast() ?? (nil, nil)
            self?.imagesArray.insert(lastImage, at: 0)
        }
        
//        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: { [weak self] in

        DispatchQueue.main.asyncAfter(deadline: .now() + duration / 2) { [weak self] in
            guard let this = self else { return }
            this.view.bringSubviewToFront(this.frontImageView)
            this.view.bringSubviewToFront(this.rightImageView)
        }
            
        UIView.animate(withDuration: duration, animations: { [weak self] in
            guard let this = self else { return }
       
            // Front image to left
            this.frontImageView.transform = this.leftImageView.transform
            
            // Left image to right
            this.leftImageView.transform = this.rightImageView.transform
            
            // Right image to front
            this.rightImageView.transform = .identity
            
//            this.view.bringSubviewToFront(this.rightImageView)
            
        }) { [weak self] (_) in

            guard let this = self else { return }
            
            
            
            let leftImageViewTmp = this.leftImageView
            this.leftImageView = this.frontImageView
            this.frontImageView = this.rightImageView
            this.rightImageView = leftImageViewTmp
            
            sender.isEnabled = true
//            let firstImage = self?.imagesArray.removeFirst() ?? (nil, nil)
//            self?.imagesArray.append(firstImage)

//            let lastImage = self?.imagesArray.removeLast() ?? (nil, nil)
//            self?.imagesArray.insert(lastImage, at: 0)
        }
    }
}
