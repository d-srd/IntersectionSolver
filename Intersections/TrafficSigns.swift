//
//  TrafficSigns.swift
//  Intersections
//
//  Created by Dino Srdoč on 03/05/2018.
//  Copyright © 2018 Dino Srdoč. All rights reserved.
//

import UIKit

@IBDesignable
class TrafficLightView: UIView {
    @IBInspectable
    var isRedLightOn: Bool = false {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable
    var isYellowLightOn: Bool = false {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable
    var isGreenLightOn: Bool = false {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable
    var circleRadius: CGFloat = 10
    
    private let lightRedColor = UIColor.darkRed
    private let lightYellowColor = UIColor.darkYellow
    private let lightGreenColor = UIColor.darkGreen
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let multiplier = bounds.maxY / 3
        let offset: CGFloat = 5
        
        let redRect = CGRect(x: bounds.midX - circleRadius / 2, y: offset, width: circleRadius, height: circleRadius)
        let redCircle = UIBezierPath(ovalIn: redRect)
        
        let yellowRect = CGRect(x: bounds.midX - circleRadius / 2, y: multiplier + offset, width: circleRadius, height: circleRadius)
        let yellowCircle = UIBezierPath(ovalIn: yellowRect)
        
        let greenRect = CGRect(x: bounds.midX - circleRadius / 2, y: 2 * multiplier + offset, width: circleRadius, height: circleRadius)
        let greenCircle = UIBezierPath(ovalIn: greenRect)
        
        //        layer.backgroundColor = UIColor.black.cgColor
        
        if isRedLightOn {
            UIColor.red.setFill()
            redCircle.fill()
        } else {
            lightRedColor.setFill()
            redCircle.fill()
        }
        
        if isYellowLightOn {
            UIColor.yellow.setFill()
            yellowCircle.fill()
        } else {
            lightYellowColor.setFill()
            yellowCircle.fill()
        }
        
        if isGreenLightOn {
            UIColor.green.setFill()
            greenCircle.fill()
        } else {
            lightGreenColor.setFill()
            greenCircle.fill()
        }
    }
}

@IBDesignable
class StopSignView: UIView {
    @IBInspectable
    var radius: CGFloat = 15
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let octagon = UIBezierPath()
        let sideLength = radius * 0.85
        octagon.move(to: bounds.midPoint)
        octagon.move(to: CGPoint(x: bounds.midX - sideLength / 2, y: bounds.midY + radius))
        octagon.addLine(to: CGPoint(x: bounds.midX - radius, y: bounds.midY + sideLength / 2))
        octagon.addLine(to: CGPoint(x: bounds.midX - radius, y: bounds.midY - sideLength / 2))
        octagon.addLine(to: CGPoint(x: bounds.midX - sideLength / 2, y: bounds.midY - radius))
        octagon.addLine(to: CGPoint(x: bounds.midX + sideLength / 2, y: bounds.midY - radius))
        octagon.addLine(to: CGPoint(x: bounds.midX + radius, y: bounds.midY - sideLength / 2))
        octagon.addLine(to: CGPoint(x: bounds.midX + radius, y: bounds.midY + sideLength / 2))
        octagon.addLine(to: CGPoint(x: bounds.midX + sideLength / 2, y: bounds.midY + radius))
        octagon.close()
        
        UIColor.red.setFill()
        UIColor.black.setStroke()
        octagon.fill()
        octagon.stroke()
    }
}

class YieldSignView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let triangle = UIBezierPath()
        triangle.move(to: CGPoint(x: bounds.midX, y: bounds.maxY - 5))
        triangle.addLine(to: CGPoint(x: bounds.minX + 2 , y: bounds.minY + 10))
        triangle.addLine(to: CGPoint(x: bounds.maxX - 2, y: bounds.minY + 10))
        //        triangle.addLine(to: CGPoint(x: bounds.midX, y: bounds.maxY - 10))
        triangle.close()
        
        UIColor.red.setFill()
        UIColor.black.setStroke()
        triangle.fill()
        triangle.stroke()
        triangle.apply(CGAffineTransform(scaleX: 0.8, y: 0.8))
        triangle.apply(CGAffineTransform(translationX: 5, y: 4))
        UIColor.white.setFill()
        triangle.fill()
    }
}

@IBDesignable
class RightOfWaySign: UIView {
    @IBInspectable
    var size: CGSize = CGSize(width: 30, height: 30)
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let containerRectOrigin = CGPoint(x: bounds.midX - size.width / 2, y: bounds.midY - size.height / 2)
        let containerRect = UIBezierPath(rect: CGRect(origin: containerRectOrigin, size: size))
        let innerRectScale: CGFloat = 0.7
        let innerRectOrigin = CGPoint(x: bounds.midX - size.width * innerRectScale / 2, y: bounds.midY - size.height * innerRectScale / 2)
        let innerYellowRect = UIBezierPath(rect: CGRect(origin: innerRectOrigin, size: size.applying(CGAffineTransform(scaleX: innerRectScale, y: innerRectScale))))
        
        layer.transform = CATransform3DMakeRotation(.pi / 4, 0, 0, 1)
        layer.contentsScale = UIScreen.main.scale
        layer.rasterizationScale = UIScreen.main.scale
        layer.shouldRasterize = true
        
        UIColor.white.setFill()
        UIColor.black.setStroke()
        containerRect.fill()
        containerRect.stroke()
        UIColor.yellow.setFill()
        innerYellowRect.fill()
        innerYellowRect.stroke()
        
    }
}
