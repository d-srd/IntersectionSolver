//
//  ViewController.swift
//  Intersections
//
//  Created by Dino Srdoč on 30/04/2018.
//  Copyright © 2018 Dino Srdoč. All rights reserved.
//

import UIKit
import SwiftGraph

extension CGRect {
    var midPoint: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}

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
    var arrowOffset: CGSize = CGSize(width: 0, height: 20)
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let rect = UIBezierPath(rect: bounds)
        let arrow = UIBezierPath()
        
        var referencePointArrow = bounds.midPoint
        referencePointArrow.x += arrowOffset.width
        referencePointArrow.y += arrowOffset.height
        
        arrow.move(to: CGPoint(x: referencePointArrow.x - 3, y: referencePointArrow.y + 10))
        arrow.addLine(to: CGPoint(x: referencePointArrow.x - 3, y: referencePointArrow.y))
        arrow.addLine(to: CGPoint(x: referencePointArrow.x - 7, y: referencePointArrow.y))
        arrow.addLine(to: CGPoint(x: referencePointArrow.x, y: referencePointArrow.y - 5))
        arrow.addLine(to: CGPoint(x: referencePointArrow.x + 7, y: referencePointArrow.y))
        arrow.addLine(to: CGPoint(x: referencePointArrow.x + 3, y: referencePointArrow.y))
        arrow.addLine(to: CGPoint(x: referencePointArrow.x + 3, y: referencePointArrow.y + 10))
        arrow.close()
        
        color.setFill()
        rect.fill()
        UIColor.white.setFill()
        arrow.fill()
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var grassView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // A -> D, E -> H => glavna cesta
        // K -> I, J -> L => sporedna cesta
        // J -> C, K -> G => weight = 3
        // svi ostali imaju weight = 1
        //
        //
        //            A     H
        //            |     ^
        //            |     |
        //            ˇ     |
        //  I<--------B<----G<-----K
        //            |     ^
        //            |     |
        //            ˇ     |
        //  J-------->C---->F---->L
        //            |     ^
        //            |     |
        //            ˇ     |
        //            D     E
        //
        // auti su na A -> D, J -> D, E -> I, K -> I
        //
        
        let intersection = WeightedGraph<String, Int>(vertices: ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L"])
        
        let edgePairs = [
            ("A", "B"), ("B", "C"), ("C", "D"),
            ("E", "F"), ("F", "G"), ("G", "H"),
            ("K", "G"), ("G", "B"), ("B", "I"),
            ("J", "C"), ("C", "F"), ("F", "L")
        ]
        let edges = makeEdges(in: intersection, with: edgePairs)
        edges[6].weight = 3
        edges[9].weight = 3
        for edge in edges { intersection.addEdge(edge) }
        
        let car0 = getCost(in: intersection, from: "A", to: "D")
        let car1 = getCost(in: intersection, from: "J", to: "D")
        let car2 = getCost(in: intersection, from: "E", to: "I")
        let car3 = getCost(in: intersection, from: "K", to: "I")
        print("car costs: ", [car0, car1, car2, car3])
        
        print(intersection)
        
        print("hi there")
    }
    
    func getCost<T>(in graph: WeightedGraph<T, Int>, from source: T, to destination: T) -> Int {
        return ((graph as Graph).bfs(from: source, to: destination) as! [WeightedEdge<Int>]).reduce(0) { $0 + $1.weight }
    }
    
    func makeEdges(in graph: WeightedGraph<String, Int>, with indices: [(String, String)]) -> [WeightedEdge<Int>] {
        return indices.map {
            WeightedEdge<Int>(u: graph.indexOfVertex($0)!,
                              v: graph.indexOfVertex($1)!,
                              directed: true,
                              weight: 1)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
