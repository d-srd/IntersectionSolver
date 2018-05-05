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

class ViewController: UIViewController {

    @IBAction func solveIntersection(_ sender: UITapGestureRecognizer) {
        print("top left cost: ", topCarCost)
        print("top right cost: ", rightCarCost)
        print("bottom left cost: ", leftCarCost)
        print("bottom right cost: ", bottomCarCost)
    }
    
    private var roadSignAlertController: UIAlertController!
    private var carDirectionAlertController: UIAlertController!
    private var activeCarButton: UIButton?
    private var carCosts = [UIButton : Int]()
    
    enum Direction {
        case left, right, forwards
    }
    
    @IBOutlet weak var topCarButton: UIButton!
    private var topCarDirection: Direction?
    private var topCarCost: Int? {
        switch topCarDirection {
        case .left?: return getCost(in: graph, from: 0, to: 9)
        case .right?: return getCost(in: graph, from: 0, to: 2)
        case .forwards?: return getCost(in: graph, from: 0, to: 10)
        default: return nil
        }
    }
    @IBOutlet weak var rightCarButton: UIButton!
    private var rightCarDirection: Direction?
    private var rightCarCost: Int? {
        switch rightCarDirection {
        case .left?: return getCost(in: graph, from: 5, to: 10)
        case .right?: return getCost(in: graph, from: 5, to: 1)
        case .forwards?: return getCost(in: graph, from: 5, to: 2)
        default: return nil
        }
    }
    @IBOutlet weak var bottomCarButton: UIButton!
    private var bottomCarDirection: Direction?
    private var bottomCarCost: Int? {
        switch bottomCarDirection {
        case .left?: return getCost(in: graph, from: 11, to: 2)
        case .right?: return getCost(in: graph, from: 11, to: 9)
        case .forwards?: return getCost(in: graph, from: 11, to: 1)
        default: return nil
        }
    }
    @IBOutlet weak var leftCarButton: UIButton!
    private var leftCarDirection: Direction?
    private var leftCarCost: Int? {
        switch leftCarDirection {
        case .left?: return getCost(in: graph, from: 6, to: 1)
        case .right?: return getCost(in: graph, from: 6, to: 10)
        case .forwards?: return getCost(in: graph, from: 6, to: 9)
        default: return nil
        }
    }
    
    private lazy var vehicleForButton = [
        topCarButton : "🚗",
        rightCarButton : "🚙",
        bottomCarButton : "🚕",
        leftCarButton : "🦊"
    ]
    
    
    @IBAction func pressedCarButton(_ sender: UIButton) {
        sender.setTitle(vehicleForButton[sender], for: .normal)
        activeCarButton = sender
        
        present(carDirectionAlertController, animated: true)
    }
    
    @IBOutlet weak var bottomLeftRoadSign: UIView!
    @IBOutlet weak var topLeftRoadSign: UIView!
    @IBOutlet weak var topRightRoadSign: UIView!
    @IBOutlet weak var bottomRightRoadSign: UIView!
    
    @IBOutlet weak var grassView: UIView!
    
    // asti ga moruzgve
    @IBOutlet weak var rightTopGestureContainer: UIView!
    @IBOutlet weak var rightBottomGestureContainer: UIView!
    @IBOutlet weak var leftTopGestureContainer: UIView!
    @IBOutlet weak var leftBottomGestureContainer: UIView!
    @IBOutlet weak var bottomLeftGestureContainer: UIView!
    @IBOutlet weak var bottomRightGestureContainer: UIView!
    @IBOutlet weak var topLeftGestureContainer: UIView!
    @IBOutlet weak var topRightGestureContainer: UIView!
    @IBOutlet weak var middleBottomLeftGestureContainer: UIView!
    @IBOutlet weak var middleBottomRightGestureContainer: UIView!
    @IBOutlet weak var middleTopLeftGestureContainer: UIView!
    @IBOutlet weak var middleTopRightGestureContainer: UIView!
    
    @IBOutlet weak var roadSegmentTopLeftToMiddleTopLeft: RoadView!
    @IBOutlet weak var roadSegmentTopLeftToMiddleBottomLeft: RoadView!
    @IBOutlet weak var roadSegmentTopLeftToBottomLeft: RoadView!
    
    @IBOutlet weak var roadSegmentBottomRightToMiddleBottomRight: RoadView!
    @IBOutlet weak var roadSegmentBottomRightToMiddleTopRight: RoadView!
    @IBOutlet weak var roadSegmentBottomRightToTopRight: RoadView!
    
    @IBOutlet weak var roadSegmentRightTopToMiddleTopRight: RoadView!
    @IBOutlet weak var roadSegmentRightTopToMiddleTopLeft: RoadView!
    @IBOutlet weak var roadSegmentRightTopToLeftTop: RoadView!
    
    @IBOutlet weak var roadSegmentLeftBottomToMiddleBottomLeft: RoadView!
    @IBOutlet weak var roadSegmentLeftBottomToMiddleBottomRight: RoadView!
    @IBOutlet weak var roadSegmentLeftBottomToRightBottom: RoadView!
    
    @IBOutlet weak var roadSegmentMiddleBottomLeftToBottomLeft: RoadView!
    @IBOutlet weak var roadSegmentMiddleTopRightToTopRight: RoadView!
    
    
    private lazy var allContainers = [rightTopGestureContainer, rightBottomGestureContainer, leftTopGestureContainer, leftBottomGestureContainer, bottomLeftGestureContainer, bottomRightGestureContainer, topLeftGestureContainer, topRightGestureContainer, middleBottomLeftGestureContainer, middleBottomRightGestureContainer, middleTopLeftGestureContainer, middleTopRightGestureContainer]
    
    @IBOutlet var rightTopTap: UITapGestureRecognizer!
    @IBOutlet var rightBottomTap: UITapGestureRecognizer!
    @IBOutlet var bottomRightTap: UITapGestureRecognizer!
    @IBOutlet var bottomLeftTap: UITapGestureRecognizer!
    @IBOutlet var leftBottomTap: UITapGestureRecognizer!
    @IBOutlet var leftTopTap: UITapGestureRecognizer!
    @IBOutlet var topLeftTap: UITapGestureRecognizer!
    @IBOutlet var topRightTap: UITapGestureRecognizer!
    @IBOutlet var middleTopLeftTap: UITapGestureRecognizer!
    @IBOutlet var middleTopRightTap: UITapGestureRecognizer!
    @IBOutlet var middleBottomLeftTap: UITapGestureRecognizer!
    @IBOutlet var middleBottomRightTap: UITapGestureRecognizer!
    
    private var sourceVertex: Int? {
        didSet { print("source: ", sourceVertex) }
    }
    private var sourceView: UIView?
    private var destinationVertex: Int? {
        didSet { print("destination: ", destinationVertex) }
    }
    private var destinationView: UIView?
    private var isSelecting = false
    
    private var activeRoadSignView: UIView?
    
    private lazy var graphVertices = Array((0..<12))
    
    private lazy var graphVertexForContainerView = [
        topLeftGestureContainer : 0,
        topRightGestureContainer : 1,
        leftTopGestureContainer : 2,
        middleTopLeftGestureContainer : 3,
        middleTopRightGestureContainer : 4,
        rightTopGestureContainer : 5,
        leftBottomGestureContainer : 6,
        middleBottomLeftGestureContainer : 7,
        middleBottomRightGestureContainer : 8,
        rightBottomGestureContainer : 9,
        bottomLeftGestureContainer : 10,
        bottomRightGestureContainer : 11
    ]
    
    private lazy var allowedVertexContainersForVertex = [
        topLeftGestureContainer : [middleTopLeftGestureContainer, middleBottomLeftGestureContainer, bottomLeftGestureContainer],
        topRightGestureContainer : [],
        leftTopGestureContainer : [],
        middleTopLeftGestureContainer : [],
        middleTopRightGestureContainer : [topRightGestureContainer],
        rightTopGestureContainer : [middleTopRightGestureContainer, middleTopLeftGestureContainer, leftTopGestureContainer],
        leftBottomGestureContainer : [middleBottomLeftGestureContainer, middleBottomRightGestureContainer, rightBottomGestureContainer],
        middleBottomLeftGestureContainer : [bottomLeftGestureContainer],
        middleBottomRightGestureContainer : [],
        rightBottomGestureContainer : [],
        bottomLeftGestureContainer : [],
        bottomRightGestureContainer : [middleBottomRightGestureContainer, middleTopRightGestureContainer, topRightGestureContainer]
    ]
    
    private var graph = WeightedGraph<Int, Int>(vertices: Array((0..<12))) {
        didSet {
            print(graph)
        }
    }
    
    private func roadSegment(for vertices: (Int, Int)) -> RoadView? {
        switch vertices {
        case (0, 3):
            return roadSegmentTopLeftToMiddleTopLeft
        case (0, 7):
            return roadSegmentTopLeftToMiddleBottomLeft
        case (0, 10):
            return roadSegmentTopLeftToBottomLeft
        case (11, 8):
            return roadSegmentBottomRightToMiddleBottomRight
        case (11, 4):
            return roadSegmentBottomRightToMiddleTopRight
        case (11, 1):
            return roadSegmentBottomRightToTopRight
        case (5, 4):
            return roadSegmentRightTopToMiddleTopRight
        case (5, 3):
            return roadSegmentRightTopToMiddleTopLeft
        case (5, 2):
            return roadSegmentRightTopToLeftTop
        case (6, 7):
            return roadSegmentLeftBottomToMiddleBottomLeft
        case (6, 8):
            return roadSegmentLeftBottomToMiddleBottomRight
        case (6, 9):
            return roadSegmentLeftBottomToRightBottom
        case (7, 10):
            return roadSegmentMiddleBottomLeftToBottomLeft
        case (4, 1):
            return roadSegmentMiddleTopRightToTopRight
        default:
            return nil
        }
    }
    
    private func vertices(for roadSign: UIView?) -> (Int, Int) {
        if roadSign == bottomLeftRoadSign {
            return (6, 7)
        } else if roadSign == topLeftRoadSign {
            return (0, 3)
        } else if roadSign == topRightRoadSign {
            return (5, 4)
        } else if roadSign == bottomRightRoadSign {
            return (11, 8)
        } else {
            return (2000, 2000)
        }
    }
    
    
    // this is the worst thing ive ever done
    private func verticesBetween(source src: Int, destination dest: Int) -> [Int] {
        switch (src, dest) {
        case (0, 10):
            return [3, 7]
        case (10, 0):
            return [7, 3]
        case (1, 11):
            return [4, 8]
        case (11, 1):
            return [8, 4]
        case (2, 5):
            return [3, 4]
        case (5, 2):
            return [4, 3]
        case (6, 9):
            return [7, 8]
        case (9, 6):
            return [8, 7]
        case (0, 7): fallthrough
        case (7, 0): fallthrough
        case (2, 4): fallthrough
        case (4, 2):
            return [3]
        case (6, 8): fallthrough
        case (8, 6): fallthrough
        case (3, 10): fallthrough
        case (10, 3):
            return [7]
        case (3, 5): fallthrough
        case (5, 3): fallthrough
        case (8, 1): fallthrough
        case (1, 8):
            return [4]
        case (7, 9): fallthrough
        case (9, 7): fallthrough
        case (4, 11): fallthrough
        case (11, 4):
            return [8]
        default:
            return []
        }
    }
    
    @IBAction func didTapRoadConstruct(_ sender: UITapGestureRecognizer) {
        guard let container = sender.view,
              let vertex = graphVertexForContainerView[container]
        else { return }
        
        print("tapped vertex: ", vertex)
        
        
        if !isSelecting {
            sourceVertex = vertex
            sourceView = container
            
            for view in allowedVertexContainersForVertex[container]! {
                view?.backgroundColor = UIColor.red
            }
            
            isSelecting = true
        } else {
            if allowedVertexContainersForVertex[sourceView!]?.contains(container) ?? false {
                destinationVertex = vertex
                destinationView = container
                destinationView?.backgroundColor = UIColor.green
                
                let vertices = verticesBetween(source: sourceVertex!, destination: destinationVertex!)
                if let vert0 = vertices.first {
                    let edge = WeightedEdge<Int>(u: graph.indexOfVertex(sourceVertex!)!,
                                                 v: graph.indexOfVertex(vert0)!,
                                                 directed: true,
                                                 weight: 1)
                    graph.addEdge(edge)
                }
                if let vert1 = vertices.last {
                    let edge = WeightedEdge<Int>(u: graph.indexOfVertex(vert1)!,
                                                 v: graph.indexOfVertex(destinationVertex!)!,
                                                 directed: true,
                                                 weight: 1)
                    graph.addEdge(edge)
                }
                
                if let roadView = roadSegment(for: (sourceVertex!, destinationVertex!)) {
                    roadView.isHidden = false
                }
                for view in self.allContainers {
                    view?.backgroundColor = UIColor.lightGray
                }
                
                sourceView?.isUserInteractionEnabled = false
                sourceView?.isHidden = true
                destinationView?.isUserInteractionEnabled = false
                destinationView?.isHidden = true
                
//                for view in allowedVertexContainersForVertex[sourceView!]! {
//                    view?.isUserInteractionEnabled = false
//                    view?.isHidden = true
//                }

            } else {
                for view in allContainers {
                    view?.backgroundColor = UIColor.lightGray
                }
            }
            isSelecting = false
            sourceVertex = nil
            destinationVertex = nil
            sourceView = nil
            destinationView = nil
        }
        
    }
    
    @IBAction func didTapRoadSign(_ sender: UITapGestureRecognizer) {
        activeRoadSignView = sender.view
        
        present(roadSignAlertController, animated: true, completion: nil)
    }
    
    
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
        
        let edge0 = WeightedEdge<Int>(u: graph.indexOfVertex(3)!,
                                     v: graph.indexOfVertex(4)!,
                                     directed: true,
                                     weight: 1)
        let edge1 = WeightedEdge<Int>(u: graph.indexOfVertex(4)!,
                                      v: graph.indexOfVertex(8)!,
                                      directed: true,
                                      weight: 1)
        let edge2 = WeightedEdge<Int>(u: graph.indexOfVertex(8)!,
                                      v: graph.indexOfVertex(7)!,
                                      directed: true,
                                      weight: 1)
        let edge3 = WeightedEdge<Int>(u: graph.indexOfVertex(7)!,
                                      v: graph.indexOfVertex(3)!,
                                      directed: true,
                                      weight: 1)
        
        for edge in [edge0, edge1, edge2, edge3] {
            graph.addEdge(edge)
        }
        
        roadSignAlertController = UIAlertController(title: "Odaberite prometni znak", message: nil, preferredStyle: .actionSheet)
        roadSignAlertController.addAction(UIAlertAction(title: "Stop", style: .default, handler: { _ in
            self.activeRoadSignView?.addSubview(StopSignView(frame: self.activeRoadSignView!.bounds))
            
            let verts = self.vertices(for: self.activeRoadSignView)
            self.setEdgeWeight(in: self.graph, from: verts.0, to: verts.1, weight: 3)
            
            self.activeRoadSignView = nil
        }))
        roadSignAlertController.addAction(UIAlertAction(title: "Obrnuti trokut", style: .default, handler: { _ in
            self.activeRoadSignView?.addSubview(YieldSignView(frame: self.activeRoadSignView!.bounds))
            
            let verts = self.vertices(for: self.activeRoadSignView)
            self.setEdgeWeight(in: self.graph, from: verts.0, to: verts.1, weight: 3)
            
            self.activeRoadSignView = nil
        }))
        roadSignAlertController.addAction(UIAlertAction(title: "Prednost prolaska", style: .default, handler: { _ in
            self.activeRoadSignView?.addSubview(RightOfWaySignView(frame: self.activeRoadSignView!.bounds))
            
            let verts = self.vertices(for: self.activeRoadSignView)
            self.setEdgeWeight(in: self.graph, from: verts.0, to: verts.1, weight: 1)
            
            self.activeRoadSignView = nil
        }))
        
        carDirectionAlertController = UIAlertController(title: "Smjer kretanja", message: nil, preferredStyle: .actionSheet)
        carDirectionAlertController.addAction(UIAlertAction(title: "Naprijed", style: .default, handler: { _ in
            if self.activeCarButton == self.leftCarButton {
                self.leftCarDirection = .forwards
            } else if self.activeCarButton == self.bottomCarButton {
                self.bottomCarDirection = .forwards
            } else if self.activeCarButton == self.topCarButton {
                self.topCarDirection = .forwards
            } else if self.activeCarButton == self.rightCarButton {
                self.rightCarDirection = .forwards
            }
        }))
        carDirectionAlertController.addAction(UIAlertAction(title: "Lijevo", style: .default, handler: { _ in
            if self.activeCarButton == self.leftCarButton {
                self.leftCarDirection = .left
            } else if self.activeCarButton == self.bottomCarButton {
                self.bottomCarDirection = .left
            } else if self.activeCarButton == self.topCarButton {
                self.topCarDirection = .left
            } else if self.activeCarButton == self.rightCarButton {
                self.rightCarDirection = .left
            }
        }))
        carDirectionAlertController.addAction(UIAlertAction(title: "Desno", style: .default, handler: { _ in
            if self.activeCarButton == self.leftCarButton {
                self.leftCarDirection = .right
            } else if self.activeCarButton == self.bottomCarButton {
                self.bottomCarDirection = .right
            } else if self.activeCarButton == self.topCarButton {
                self.topCarDirection = .right
            } else if self.activeCarButton == self.rightCarButton {
                self.rightCarDirection = .right
            }
        }))
    }
    
    func getCost<T>(in graph: WeightedGraph<T, Int>, from source: T, to destination: T) -> Int {
        return ((graph as Graph).bfs(from: source, to: destination) as! [WeightedEdge<Int>]).reduce(0) { $0 + $1.weight }
    }
    
    func setEdgeWeight<T>(in graph: WeightedGraph<T, Int>, from source: T, to destination: T, weight: Int) {
        (graph.edgesForVertex(source) as! [WeightedEdge<Int>]).filter { $0.v == graph.indexOfVertex(destination) }.first?.weight = weight
    }
    
    func getEdgeWeight<T>(in graph: WeightedGraph<T, Int>, from source: T, to destination: T) -> Int? {
        return (graph.edgesForVertex(source) as! [WeightedEdge<Int>]).filter { $0.v == graph.indexOfVertex(destination) }.first?.weight
    }
    
    func makeEdges(in graph: WeightedGraph<String, Int>, with indices: [(String, String)]) -> [WeightedEdge<Int>] {
        return indices.map {
            WeightedEdge<Int>(u: graph.indexOfVertex($0)!,
                              v: graph.indexOfVertex($1)!,
                              directed: true,
                              weight: 1)
        }
    }


}
