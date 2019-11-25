//
//  ViewController.swift
//  CALayer UIKit Animation
//
//  Created by Stephen Anthony on 23/11/2019.
//  Copyright © 2019 Darjeeling Apps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private var arrowView: ArrowView!
    
    @IBAction private func flipArrow(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.arrowView.direction.flip()
        }
    }
}
