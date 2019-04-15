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
    
    private var imagesArray = [(color: UIImage?, bw: UIImage?)]()
    
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
        
        if let firstImage = imagesArray.first {
            frontImageView.image = firstImage.color
        }
        
        if imagesArray.count > 1 {
            leftImageView.image = imagesArray[1].color
            
            if imagesArray.count > 2 {
                rightImageView.image = imagesArray[2].color
            }
        }
        
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
        
        sender.isEnabled = false
        
//        UIView.transition(with: self.frontImageView,
//                          duration:1,
//                          options: .transitionCrossDissolve,
//                          animations: { [weak self] in
//                            self?.frontImageView.image = lastImage
//
//        }) { (_) in
//            UIView.transition(with: self.frontImageView,
//                              duration:1,
//                              options: .transitionCrossDissolve,
//                              animations: { [weak self] in
//                                self?.frontImageView.image = firstImage
//
//            }) { (_) in
//                sender.isEnabled = true
//            }
//        }
        
//        let frontImageFrame = frontImageView.frame
//        let leftImageFrame = leftImageView.frame
//        let rightImageFrame = rightImageView.frame
//
//        let frontImageCenter = frontImageView.center
//        let leftImageCenter = leftImageView.center
//        let rightImageCenter = rightImageView.center
        
//        let
        
        UIView.animate(withDuration: 1, animations: { [weak self] in
//        let this = self
            guard let this = self else { return }
            
            
//            let leftImagePosition = this.leftImageView.center
        
            // Front image to left
//            this.frontImageView.frame = leftImageFrame
            this.frontImageView.transform = this.leftImageView.transform
            
            // Left image to right
//            this.leftImageView.frame = rightImageFrame
            this.leftImageView.transform = this.rightImageView.transform
            
            // Right image to fromt
//            this.rightImageView.frame = frontImageFrame
            
            this.rightImageView.transform = .identity
            
            this.view.bringSubviewToFront(this.rightImageView)
            
        }) { [weak self] (_) in
    
            sender.isEnabled = true
            
            guard let this = self else { return }
        
            let leftImageViewTmp = this.leftImageView
            this.leftImageView = this.frontImageView
            this.frontImageView = this.rightImageView
            this.rightImageView = leftImageViewTmp
            
        }
    }
}
