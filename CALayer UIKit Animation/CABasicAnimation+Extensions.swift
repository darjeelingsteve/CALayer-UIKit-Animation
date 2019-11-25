//
//  CABasicAnimation+Extensions.swift
//  CALayer UIKit Animation
//
//  Created by Stephen Anthony on 23/11/2019.
//  Copyright © 2019 Darjeeling Apps. All rights reserved.
//

import UIKit

extension CABasicAnimation {
    
    /// Creates a copy of the receiver with the `keyPath` set to the given
    /// value.
    /// - Parameter keyPath: The value of the returned animation's `keyPath`.
    /// - Returns An animation identical to the receiver with the given
    /// `keyPath`.
    func copy(forKeyPath keyPath: String) -> CABasicAnimation {
        let copy = self.copy() as! CABasicAnimation
        copy.keyPath = keyPath
        return copy
    }
}
