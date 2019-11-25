//
//  ArrowView.swift
//  CALayer UIKit Animation
//
//  Created by Stephen Anthony on 23/11/2019.
//  Copyright © 2019 Darjeeling Apps. All rights reserved.
//

import UIKit

/// The view used to show an arrow pointing upwards or downwards.
@IBDesignable class ArrowView: UIView {
    private static let preferredSize = CGSize(width: 52, height: 52)
    private static let arrowLineWidth: CGFloat = 6
    private static let arrowHeight: CGFloat = 13
    private static let arrowHorizontalInset: CGFloat = 12
    
    /// The direction of the arrow the receiver displays. Animatable.
    var direction: Direction = .up {
        didSet {
            guard oldValue != direction else { return }
            if let backgroundColourAnimation = action(for: layer, forKey: "backgroundColor") as? CABasicAnimation {
                let pathAnimation = backgroundColourAnimation.copy(forKeyPath: "path")
                pathAnimation.fromValue = arrowShapeLayer.presentation()?.path
                pathAnimation.duration = backgroundColourAnimation.duration
                arrowShapeLayer.add(pathAnimation, forKey: "pathAnimation")
                
                let strokeColourAnimation = backgroundColourAnimation.copy(forKeyPath: "strokeColor")
                strokeColourAnimation.fromValue = arrowShapeLayer.presentation()?.strokeColor
                strokeColourAnimation.duration = backgroundColourAnimation.duration
                arrowShapeLayer.add(strokeColourAnimation, forKey: "strokeColourAnimation")
            }
            arrowShapeLayer.path = direction.arrowPath(in: bounds).cgPath
            arrowShapeLayer.strokeColor = direction.arrowColour.cgColor
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return ArrowView.preferredSize
    }
    
    private lazy var arrowShapeLayer: CAShapeLayer = {
        let arrowShapeLayer = CAShapeLayer()
        arrowShapeLayer.strokeColor = direction.arrowColour.cgColor
        arrowShapeLayer.lineWidth = ArrowView.arrowLineWidth
        arrowShapeLayer.lineCap = .round
        arrowShapeLayer.fillColor = UIColor.clear.cgColor
        return arrowShapeLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonSetup()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        /// Remove the default implicit animation from the `strokeColor`
        /// property.
        arrowShapeLayer.actions = ["strokeColor": NSNull()]
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return ArrowView.preferredSize
    }
    
    override public func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        arrowShapeLayer.frame = bounds
        arrowShapeLayer.path = direction.arrowPath(in: bounds).cgPath
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            arrowShapeLayer.strokeColor = direction.arrowColour.cgColor
        }
    }
    
    private func commonSetup() {
        backgroundColor = .secondarySystemGroupedBackground
        clipsToBounds = true
        layer.cornerRadius = ArrowView.preferredSize.width / 2
        layer.addSublayer(arrowShapeLayer)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .vertical)
        setContentHuggingPriority(.required, for: .horizontal)
        setContentHuggingPriority(.required, for: .vertical)
    }
}

extension ArrowView {
    
    /// The different directions that the arrow can point.
    enum Direction {
        case up
        case down
        
        mutating func flip() {
            switch self {
            case .up:
                self = .down
            case .down:
                self = .up
            }
        }
        
        fileprivate func arrowPath(in rect: CGRect) -> UIBezierPath {
            let path = UIBezierPath()
            let insetRect = rect.insetBy(dx: ArrowView.arrowHorizontalInset, dy: 0)
            let leftAndRightArrowPointCentreY = self.leftAndRightArrowPointCentreY(in: insetRect)
            switch self {
            case .up:
                path.move(to: CGPoint(x: insetRect.minX, y: leftAndRightArrowPointCentreY))
                path.addLine(to: CGPoint(x: insetRect.midX, y: leftAndRightArrowPointCentreY - ArrowView.arrowHeight))
                path.addLine(to: CGPoint(x: insetRect.maxX, y: leftAndRightArrowPointCentreY))
            case .down:
                path.move(to: CGPoint(x: insetRect.minX, y: leftAndRightArrowPointCentreY))
                path.addLine(to: CGPoint(x: insetRect.midX, y: leftAndRightArrowPointCentreY + ArrowView.arrowHeight))
                path.addLine(to: CGPoint(x: insetRect.maxX, y: leftAndRightArrowPointCentreY))
            }
            return path
        }
        
        private func leftAndRightArrowPointCentreY(in rect: CGRect) -> CGFloat {
            let arrowLineWidthOffset = round(ArrowView.arrowLineWidth * 0.8)
            switch self {
            case .up:
                return rect.midY + arrowLineWidthOffset
            case .down:
                return rect.midY - arrowLineWidthOffset
            }
        }
        
        fileprivate var arrowColour: UIColor {
            switch self {
            case .up:
                return UIColor.systemGreen
            case .down:
                return UIColor.systemRed
            }
        }
    }
}
