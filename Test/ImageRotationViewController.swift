//
//  ImageRotationViewController.swift
//  Test
//
//  Created by Alexander on 12/04/2019.
//  Copyright © 2019 Alexander Selivanov. All rights reserved.
//

import UIKit

class ImageRotationViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    private var imagesArray1 = [UIImage?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Image Rotation"
        
        initializeData()
        initializeUI()
        
    }
    
    func initializeData() {
        imagesArray1 = [
            UIImage(named: "Color_0"), UIImage(named: "BW_0")
        ]
    }
    
    func initializeUI() {
        if let firstImage = imagesArray1.first {
            imageView.image = firstImage
        }
    }
    
    @IBAction private func onStartTap(_ sender: UIButton) {
        
        guard let firstImage = imagesArray1.first else { return }
        guard let lastImage = imagesArray1.last else { return }
        
        sender.isEnabled = false
        
        UIView.transition(with: self.imageView,
                          duration:1,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.imageView.image = lastImage
                            
        }) { (_) in
            UIView.transition(with: self.imageView,
                              duration:1,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                self?.imageView.image = firstImage
                                
            }) { (_) in
                sender.isEnabled = true
            }
        }
    }
}
