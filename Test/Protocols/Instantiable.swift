//
//  Instantiable.swift
//  Reader
//
//  Created by Endoral on 26/11/2018.
//  Copyright © 2018 Endoral. All rights reserved.
//

import UIKit

protocol Instantiable: class {
    /// Creating an instance of the object from the UINib.
    /// - Parameters:
    ///     - nibName: The name of the file containing the required UINib in the specified bundle. Default value is '"\(Self.self)"'.
    ///     - bundle: Bundle to search for the requested UINib. If the bundle parameter is nil, the main bundle is used. Default value is 'nil'.
    ///     - owner: If the owner parameter is nil, connections to File's Owner are not permitted. Default value is 'nil'.
    ///     - options: Options are identical to the options specified with -[NSBundle loadNibNamed:owner:options:]. Default value is 'nil'.
    /// - Returns: Instance of the object from the specified UINib.
    static func instantiate(nibName: String, bundle: Bundle?, owner: Any?, options: [UINib.OptionsKey: Any]?) -> Self

    /// Load Interface Builder nib file by name and bundle.
    /// - Parameters:
    ///     - nibName: The name of the file containing the required UINib in the specified bundle. Default value is '"\(Self.self)"'.
    ///     - bundle: Bundle to search for the requested UINib. If the bundle parameter is nil, the main bundle is used. Default value is 'nil'.
    /// - Returns: An object that wraps, or contains, Interface Builder nib files.
    static func loadNib(nibName: String, bundle: Bundle?) -> UINib
}

extension Instantiable {

    static func instantiate(nibName: String = "\(Self.self)", bundle: Bundle? = nil, owner: Any? = nil, options: [UINib.OptionsKey: Any]? = nil) -> Self {
        let nib = loadNib(nibName: nibName, bundle: bundle)
        let result = nib.instantiate(withOwner: owner, options: options)[0] as! Self

        return result
    }

    static func loadNib(nibName: String = "\(Self.self)", bundle: Bundle? = nil) -> UINib {
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib
    }
}










