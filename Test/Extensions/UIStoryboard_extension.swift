//
//  UIStoryboard_extension.swift
//  Pobjects
//
//  Created by Mac Developer on 17.11.17.
//  Copyright © 2017 iDSi Apps. All rights reserved.
//

import UIKit

extension UIStoryboard {
    func instantiate<T>(_ viewControllerFromClass: T.Type, withIdentifier indentifier: String? = nil) -> T? where T: UIViewController {

        let controller = instantiateViewController(withIdentifier: "\(indentifier ?? "\(viewControllerFromClass)")") as? T

        return controller
    }
}

extension UIStoryboard {
    
    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
}
