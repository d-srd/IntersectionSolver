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
    
    // MARK: - types
    
    enum Direction {
        case left, right, forwards
    }
    
    // MARK: - outlets
    
    // cars are buttons, attached to particular road segments in the view
    // meaning that they only show if their superview is showing
    // which is hacky, but also quick
    // once they are tapped, their titles change to a predefined emoji giving the appearance of a car
    // after which the user is asked for a direction. that direction is then stored in
    // {directionName}carDirection, and that direction is then used to calculate the car's cost
    // of passing through the intersection
    @IBOutlet weak var topCarButton: UIButton!
    @IBOutlet weak var rightCarButton: UIButton!
    @IBOutlet weak var bottomCarButton: UIButton!
    @IBOutlet weak var leftCarButton: UIButton!

    // these are used to modify the edge weight of the graph
    @IBOutlet weak var bottomLeftRoadSign: UIView!
    @IBOutlet weak var topLeftRoadSign: UIView!
    @IBOutlet weak var topRightRoadSign: UIView!
    @IBOutlet weak var bottomRightRoadSign: UIView!
    
    // we need to get references to the nodes in the graph somehow.
    // this seemed reasonable when I started working on it. in retrospect, it does suck.
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
    
    @IBOutlet weak var roadSegmentTopLeftToBottomLeft: RoadView!
    @IBOutlet weak var roadSegmentBottomRightToTopRight: RoadView!
    @IBOutlet weak var roadSegmentRightTopToLeftTop: RoadView!
    @IBOutlet weak var roadSegmentLeftBottomToRightBottom: RoadView!
    
    @IBOutlet weak var roadSegmentMiddleBottomLeftToBottomLeft: RoadView!
    @IBOutlet weak var roadSegmentMiddleTopRightToTopRight: RoadView!
    
    // the way the intersection is created is to tap on a source view and then tap on a destination view
    // to create a road segment between them. the paths are all predefined which makes it easy
    // to modify the graph. a better solution would be to allow the user to "draw" roads, allow them to choose
    // the number of directions (one way or two way road) and make the graph based on that.
    // however, this was a quick, dirty, and easy solution.
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
    
    // MARK: - members
    
    // internal representation of the intersection.
    //
    //            0      1
    //            |      ^
    //            |      |
    //            ˇ      |
    //  2<--------3<-----4<-----5
    //            |      ^
    //            |      |
    //            ˇ      |
    //  6-------->7----->8---->9
    //            |      ^
    //            |      |
    //            ˇ      |
    //            10     11
    //
    // the default edge weight for any edge is 1
    // if the user selects a stop sign or a yield sign on any of the predefined edges, i.e. 6 -> 7, 11 -> 8, 5 -> 4, 0 -> 3,
    // then that edge's weight is set to 5
    // why 5? quick maffs. it's the lowest number which allows the other cars in the intersection
    // to "have the right of way", or in other words, have a lower cost to go from their source to their destination
    private lazy var graphVertices = Array((0..<12))
    private lazy var graph = WeightedGraph<Int, Int>(vertices: graphVertices)

    // displayed when the user taps on a road sign container view, allowing them to choose the sign, which then modifies the internal graph structure
    private lazy var roadSignAlertController: UIAlertController = {
        // "Choose the desired traffic sign"
        let alert = UIAlertController(title: "Odaberite prometni znak", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Stop", style: .default, handler: { _ in
            self.activeRoadSignView?.addSubview(StopSignView(frame: self.activeRoadSignView!.bounds))
            
            let verts = self.vertices(for: self.activeRoadSignView)
            self.setEdgeWeight(in: self.graph, from: verts.0, to: verts.1, weight: 5)
            
            self.activeRoadSignView = nil
        }))
        // Yield sign
        alert.addAction(UIAlertAction(title: "Obrnuti trokut", style: .default, handler: { _ in
            self.activeRoadSignView?.addSubview(YieldSignView(frame: self.activeRoadSignView!.bounds))
            
            let verts = self.vertices(for: self.activeRoadSignView)
            self.setEdgeWeight(in: self.graph, from: verts.0, to: verts.1, weight: 5)
            
            self.activeRoadSignView = nil
        }))
        // Right of way
        alert.addAction(UIAlertAction(title: "Prednost prolaska", style: .default, handler: { _ in
            self.activeRoadSignView?.addSubview(RightOfWaySignView(frame: self.activeRoadSignView!.bounds))
            
            let verts = self.vertices(for: self.activeRoadSignView)
            self.setEdgeWeight(in: self.graph, from: verts.0, to: verts.1, weight: 1)
            
            self.activeRoadSignView = nil
        }))
        
        return alert
    }()
    // displayed when the user taps on a car, allowing them to choose the car's movement direction
    private lazy var carDirectionAlertController: UIAlertController = {
        // car's desired direction of movement
        let alert = UIAlertController(title: "Smjer kretanja", message: nil, preferredStyle: .actionSheet)
        // forwards
        alert.addAction(UIAlertAction(title: "Naprijed", style: .default, handler: { _ in
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
        // left
        alert.addAction(UIAlertAction(title: "Lijevo", style: .default, handler: { _ in
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
        // right
        alert.addAction(UIAlertAction(title: "Desno", style: .default, handler: { _ in
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
        
        return alert
    }()
    
    // useful when it comes to modifying any particular car's state
    private var activeCarButton: UIButton?
    
    // since all the vertices in the graph are predefined, we can just pass through all of the edges
    // between the car's starting vertex and its destination vertex
    private var topCarDirection: Direction?
    private var topCarCost: Int? {
        switch topCarDirection {
        case .left?: return getCost(in: graph, from: 0, to: 9)
        case .right?: return getCost(in: graph, from: 0, to: 2)
        case .forwards?: return getCost(in: graph, from: 0, to: 10)
        default: return nil
        }
    }
    private var rightCarDirection: Direction?
    private var rightCarCost: Int? {
        switch rightCarDirection {
        case .left?: return getCost(in: graph, from: 5, to: 10)
        case .right?: return getCost(in: graph, from: 5, to: 1)
        case .forwards?: return getCost(in: graph, from: 5, to: 2)
        default: return nil
        }
    }
    private var bottomCarDirection: Direction?
    private var bottomCarCost: Int? {
        switch bottomCarDirection {
        case .left?: return getCost(in: graph, from: 11, to: 2)
        case .right?: return getCost(in: graph, from: 11, to: 9)
        case .forwards?: return getCost(in: graph, from: 11, to: 1)
        default: return nil
        }
    }
    private var leftCarDirection: Direction?
    private var leftCarCost: Int? {
        switch leftCarDirection {
        case .left?: return getCost(in: graph, from: 6, to: 1)
        case .right?: return getCost(in: graph, from: 6, to: 10)
        case .forwards?: return getCost(in: graph, from: 6, to: 9)
        default: return nil
        }
    }
    
    private var carCosts: [UIButton : Int?] {
        return [
            topCarButton : topCarCost,
            rightCarButton : rightCarCost,
            bottomCarButton : bottomCarCost,
            leftCarButton : leftCarCost
        ]
    }
    
    // titles for buttons
    private lazy var vehicleForButton = [
        topCarButton : "🚗",
        rightCarButton : "🚙",
        bottomCarButton : "🚕",
        leftCarButton : "🦊" // ran out of distinguishable cars
    ]
    
    // useful when we need to hide some views but show others
    private lazy var allContainers = [rightTopGestureContainer, rightBottomGestureContainer, leftTopGestureContainer, leftBottomGestureContainer, bottomLeftGestureContainer, bottomRightGestureContainer, topLeftGestureContainer, topRightGestureContainer, middleBottomLeftGestureContainer, middleBottomRightGestureContainer, middleTopLeftGestureContainer, middleTopRightGestureContainer]
    
    // used when making a new road segment
    private var sourceVertex: Int?
    private var sourceView: UIView?
    private var destinationVertex: Int?
    private var destinationView: UIView?
    private var isSelectingDestinationVertex = false
    
    // useful for configuring the chosen sign
    private var activeRoadSignView: UIView?
    
    // map views to vertices in the graph
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
    
    // which vertices can be chosen from any other vertex? i.e. all possible road segment configurations
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
    
    // MARK: - IB functions
    
    // sent by the road sign tap gesture recognizers.
    // creates a directed edge between the source and destination vertex
    @IBAction func didTapRoadConstruct(_ sender: UITapGestureRecognizer) {
        guard let container = sender.view,
              let vertex = graphVertexForContainerView[container]
        else { return }
        
        if !isSelectingDestinationVertex {
            sourceVertex = vertex
            sourceView = container
            
            // highlight possible destinations
            for view in allowedVertexContainersForVertex[container]! {
                view?.backgroundColor = UIColor.red
            }
            
            isSelectingDestinationVertex = true
        } else {
            defer {
                isSelectingDestinationVertex = false
                sourceVertex = nil
                destinationVertex = nil
                sourceView = nil
                destinationView = nil
            }
            // is a connection between the source and destination allowed? yes, I know this line sucks
            if allowedVertexContainersForVertex[sourceView!]?.contains(container) ?? false {
                destinationVertex = vertex
                destinationView = container

                // don't add an edge directly linking the source and destination.
                // rather, go through the vertices between them and add edges there
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
                
                // the road segments are hidden by default, so let's show them if such a segment exists
                if let roadView = roadSegment(for: (sourceVertex!, destinationVertex!)) {
                    adjustRoadSegmentDimensions(segment: roadView, from: sourceView!, to: destinationView!)
                    roadView.isHidden = false
                }
                // reset colors
                for view in allContainers {
                    view?.backgroundColor = UIColor.lightGray
                }
                
                // we don't want to make duplicate edges, so disable the source/destination views.
                sourceView?.isUserInteractionEnabled = false
                sourceView?.isHidden = true
                destinationView?.isUserInteractionEnabled = false
                destinationView?.isHidden = true
            } else {
                // user didn't tap on an allowed destination vertex, so just reset
                for view in allContainers {
                    view?.backgroundColor = UIColor.lightGray
                }
            }
        }
        
    }

    @IBAction func solveIntersection(_ sender: UITapGestureRecognizer) {
        let cars = orderOfCarsThroughIntersection()
        let message = cars
            .enumerated()
            .map { "\($0.offset + 1). : \(vehicleForButton[$0.element]!)" }
            .joined(separator: "\n")
        let alert = UIAlertController(title: "Redoslijed automobila", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.dismiss(animated: true, completion: nil) }))
        
        present(alert, animated: true)
    }
    
    
    @IBAction func didTapRoadSign(_ sender: UITapGestureRecognizer) {
        activeRoadSignView = sender.view
        
        present(roadSignAlertController, animated: true, completion: nil)
    }
    
    @IBAction func didTapCarButton(_ sender: UIButton) {
        sender.setTitle(vehicleForButton[sender], for: .normal)
        activeCarButton = sender
        
        present(carDirectionAlertController, animated: true)
    }
    
    // MARK: - functions
    
    // sort cars by cost
    private func orderOfCarsThroughIntersection() -> [UIButton] {
        return carCosts.sorted {
            if let costFirst = $0.value, let costSecond = $1.value { return costFirst < costSecond }
            return false
        }.compactMap { $0.key }
    }
    
    
    private func roadSegment(for vertices: (Int, Int)) -> RoadView? {
        //
        //            0      1
        //            |      ^
        //            |      |
        //            ˇ      |
        //  2<--------3<-----4<-----5
        //            |      ^
        //            |      |
        //            ˇ      |
        //  6-------->7----->8---->9
        //            |      ^
        //            |      |
        //            ˇ      |
        //            10     11
        //
        switch vertices {
        case (0, 3), (0, 7), (0, 10):
            return roadSegmentTopLeftToBottomLeft
        case (11, 8), (11, 4), (11, 1):
            return roadSegmentBottomRightToTopRight
        case (5, 4), (5, 3), (5, 2):
            return roadSegmentRightTopToLeftTop
        case (6, 7), (6, 8), (6, 9):
            return roadSegmentLeftBottomToRightBottom
        case (7, 10):
            return roadSegmentMiddleBottomLeftToBottomLeft
        case (4, 1):
            return roadSegmentMiddleTopRightToTopRight
        default:
            return nil
        }
    }
    
    // resize the road to fit the desired dimensions between vertices
    private func adjustRoadSegmentDimensions(segment: RoadView, from source: UIView, to destination: UIView) {
        switch segment {
        case roadSegmentLeftBottomToRightBottom:
            let scale = destination.frame.maxX / segment.bounds.width
            segment.bounds = segment.bounds.applying(CGAffineTransform(scaleX: scale, y: 1))
            segment.frame.origin = CGPoint(x: 0, y: segment.frame.origin.y)
            segment.arrowOffset = CGSize(width: -100, height: 0)
        case roadSegmentRightTopToLeftTop:
            let scale = (view.frame.width - destination.frame.minX) / segment.bounds.width
            segment.bounds = segment.bounds.applying(CGAffineTransform(scaleX: scale, y: 1))
            segment.frame.origin = CGPoint(x: view.frame.width - segment.frame.width, y: segment.frame.origin.y)
            // move the car button if neccessary
            segment.subviews[0].frame.origin = view.convert(CGPoint(x: segment.frame.maxX - 80, y: segment.frame.midY), to: segment)
            segment.arrowOffset = CGSize(width: 80, height: 0)
        case roadSegmentBottomRightToTopRight:
            let scale = (view.frame.height - destination.frame.minY) / segment.bounds.height
            segment.bounds = segment.bounds.applying(CGAffineTransform(scaleX: 1, y: scale))
            segment.frame.origin = CGPoint(x: segment.frame.origin.x, y: view.frame.height - segment.frame.height)
            segment.subviews[0].frame.origin = view.convert(CGPoint(x: segment.frame.minX, y: segment.frame.maxY - 200), to: segment)
            segment.arrowOffset = CGSize(width: 0, height: 100)
        case roadSegmentTopLeftToBottomLeft:
            let scale = destination.frame.maxY / segment.bounds.height
            segment.bounds = segment.bounds.applying(CGAffineTransform(scaleX: 1, y: scale))
            segment.frame.origin = CGPoint(x: segment.frame.origin.x, y: 0)
            segment.subviews[0].frame.origin = view.convert(CGPoint(x: segment.frame.minX, y: segment.frame.minY + 80), to: segment)
            segment.arrowOffset = CGSize(width: 0, height: -100)
        default:
            break
        }
    }
    
    // which edge should the road sign modify
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
            // stupid default value to avoid having to use Optionals
            return (2000, 2000)
        }
    }
    
    // sum of the weights of edges between the source and destination
    func getCost<T>(in graph: WeightedGraph<T, Int>, from source: T, to destination: T) -> Int {
        return ((graph as Graph).bfs(from: source, to: destination) as! [WeightedEdge<Int>]).reduce(0) { $0 + $1.weight }
    }
    
    func setEdgeWeight<T>(in graph: WeightedGraph<T, Int>, from source: T, to destination: T, weight: Int) {
        (graph.edgesForVertex(source) as! [WeightedEdge<Int>]).filter { $0.v == graph.indexOfVertex(destination) }.first?.weight = weight
    }
    
    func getEdgeWeight<T>(in graph: WeightedGraph<T, Int>, from source: T, to destination: T) -> Int? {
        return (graph.edgesForVertex(source) as! [WeightedEdge<Int>]).filter { $0.v == graph.indexOfVertex(destination) }.first?.weight
    }
    
    // this is the worst thing I've ever done
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
        case (0, 7), (7, 0), (2, 4), (4, 2):
            return [3]
        case (6, 8), (8, 6), (3, 10), (10, 3):
            return [7]
        case (3, 5), (5, 3), (8, 1), (1, 8):
            return [4]
        case (7, 9), (9, 7), (4, 11), (11, 4):
            return [8]
        default:
            return []
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //            0      1
        //            |      ^
        //            |      |
        //            ˇ      |
        //  2<--------3<-----4<-----5
        //            |      ^
        //            |      |
        //            ˇ      |
        //  6-------->7----->8---->9
        //            |      ^
        //            |      |
        //            ˇ      |
        //            10     11
        //
        // useful to add the center edges now, as we don't know which roads the user will add
        
        let edge0 = WeightedEdge<Int>(u: graph.indexOfVertex(4)!,
                                     v: graph.indexOfVertex(3)!,
                                     directed: true,
                                     weight: 1)
        let edge1 = WeightedEdge<Int>(u: graph.indexOfVertex(3)!,
                                      v: graph.indexOfVertex(7)!,
                                      directed: true,
                                      weight: 1)
        let edge2 = WeightedEdge<Int>(u: graph.indexOfVertex(7)!,
                                      v: graph.indexOfVertex(8)!,
                                      directed: true,
                                      weight: 1)
        let edge3 = WeightedEdge<Int>(u: graph.indexOfVertex(8)!,
                                      v: graph.indexOfVertex(4)!,
                                      directed: true,
                                      weight: 1)
        
        for edge in [edge0, edge1, edge2, edge3] {
            graph.addEdge(edge)
        }
        
    }
}
