//
//  RoadViews.swift
//  Intersections
//
//  Created by Dino Srdoč on 04/05/2018.
//  Copyright © 2018 Dino Srdoč. All rights reserved.
//

import UIKit

@IBDesignable
class CarView: UIView {
    @IBInspectable
    var color: UIColor = .red
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let rect = UIBezierPath(roundedRect: bounds, byRoundingCorners: UIRectCorner.topLeft, cornerRadii: bounds.size)
        color.setFill()
        rect.fill()
        
    }
}

@IBDesignable
class RoadView: UIView {
    @IBInspectable
    var color: UIColor = .black
    
    @IBInspectable
    var laneWidth: CGFloat = 10
    
    @IBInspectable
    var arrowOffset: CGSize = CGSize(width: 0, height: 20) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var arrowRotation: CGFloat = 0
    
    let arrowLayer = CAShapeLayer()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let rect = UIBezierPath(rect: bounds)
        let arrow = UIBezierPath()
        
        var referencePointArrow = bounds.midPoint
        referencePointArrow.x += arrowOffset.width
        referencePointArrow.y += arrowOffset.height
        
        //        let arrowLayer = CAShapeLayer()
        
        arrow.move(to: CGPoint(x: referencePointArrow.x - 3, y: referencePointArrow.y + 10))
        arrow.addLine(to: CGPoint(x: referencePointArrow.x - 3, y: referencePointArrow.y))
        arrow.addLine(to: CGPoint(x: referencePointArrow.x - 7, y: referencePointArrow.y))
        arrow.addLine(to: CGPoint(x: referencePointArrow.x, y: referencePointArrow.y - 5))
        arrow.addLine(to: CGPoint(x: referencePointArrow.x + 7, y: referencePointArrow.y))
        arrow.addLine(to: CGPoint(x: referencePointArrow.x + 3, y: referencePointArrow.y))
        arrow.addLine(to: CGPoint(x: referencePointArrow.x + 3, y: referencePointArrow.y + 10))
        arrow.close()
        
        arrowLayer.path = arrow.cgPath
        arrowLayer.position = arrow.bounds.midPoint
        arrowLayer.bounds = arrow.bounds
        arrowLayer.fillColor = UIColor.white.cgColor
        arrowLayer.transform = CATransform3DMakeRotation(arrowRotation, 0, 0, 1)
        
        color.setFill()
        rect.fill()
        layer.addSublayer(arrowLayer)
    }
}
