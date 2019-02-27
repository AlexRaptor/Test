//
//  DataConvertible.swift
//  Reader
//
//  Created by Endoral on 07/12/2018.
//  Copyright © 2018 Endoral. All rights reserved.
//

import Foundation

protocol DataConvertible {
    /// Get object from data representation.
    /// - Parameters:
    ///     - from: Data represented object.
    /// - Returns:
    ///     - Instance of the object converted from the specified data.
    ///     - nil if something went wrong in the process of converting data to an object.
    static func decompressed(from data: Data) -> Self?

    /// Data represented object.
    /// - Returns:
    ///     - Object presented as data if successful.
    ///     - nil if something went wrong in the process of converting an object into data.
    func compressed() -> Data?
}
