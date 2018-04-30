//
//  ViewController.swift
//  Intersections
//
//  Created by Dino Srdoč on 30/04/2018.
//  Copyright © 2018 Dino Srdoč. All rights reserved.
//

import UIKit

extension CGRect {
    var midPoint: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}

class ViewController: UIViewController {
    
    lazy var carLayer: CAShapeLayer = {
        let baseLayer = CAShapeLayer()
        let windshieldLayer = CAShapeLayer()
        let rearWindowLayer = CAShapeLayer()
        let leftRearviewMirrorLayer = CAShapeLayer()
        let leftGlassLayer = CAShapeLayer()
        
        let baseShape = UIBezierPath()
        baseShape.move(to: CGPoint(x: 0, y: 200))
        baseShape.addLine(to: CGPoint(x: 0, y: 0))
        baseShape.addLine(to: CGPoint(x: 50, y: 0))
        baseShape.addLine(to: CGPoint(x: 50, y: 200))
        baseShape.close()
        baseLayer.path = baseShape.cgPath
        baseLayer.fillColor = UIColor.gray.cgColor
        baseLayer.strokeColor = UIColor.red.cgColor
        baseLayer.lineWidth = 2
        baseLayer.bounds = baseShape.cgPath.boundingBox
        
        return baseLayer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        carLayer.position = view.bounds.midPoint
        view.layer.insertSublayer(carLayer, at: 1)
        
        print("hi there")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

