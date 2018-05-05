//
//  Intersection.swift
//  Intersections
//
//  Created by Dino Srdoč on 30/04/2018.
//  Copyright © 2018 Dino Srdoč. All rights reserved.
//

import Foundation
import SwiftGraph

enum Orientation { case horizontal, vertical }

indirect enum RoadConnectionPoint: Equatable {
    case top(RoadConnectionPoint)
    case right(RoadConnectionPoint)
    case bottom(RoadConnectionPoint)
    case left(RoadConnectionPoint)
    case middle
    case none
    
    var orientation: Orientation? {
        switch self {
        case .left(.right): fallthrough
        case .right(.left):
            return Orientation.horizontal
        case .top(.bottom): fallthrough
        case .bottom(.top):
            return Orientation.vertical
        default: return nil
        }
    }
}

struct Road: Equatable {
    var origin: RoadConnectionPoint
    var destination: RoadConnectionPoint
//    var isOneWay: Bool
    
//    func intersects(other road: Road) -> Bool {
//        switch (orientation, road.orientation) {
//        case (.horizontal?, .vertical?): fallthrough
//        case (.vertical?, .horizontal?):
//            return true
//        default:
//            return false
//        }
//    }
}

enum RoadSign { case stop, invertedTriangle, rightOfWay }

protocol IntersectionRepresentable {
    var graph: WeightedGraph<String, Int> { get }
    var roads: [Road] { get set }
    
    func add(sign: RoadSign, to road: Road)
    func convert(roads: [Road]) -> WeightedGraph<String, Int>
}

func getCost<T>(in graph: WeightedGraph<T, Int>, from source: T, to destination: T) -> Int {
    return ((graph as Graph).bfs(from: source, to: destination) as! [WeightedEdge<Int>]).reduce(0) { $0 + $1.weight }
}

func makeEdges<T>(in graph: WeightedGraph<T, Int>, with indices: [(T, T)]) -> [WeightedEdge<Int>] {
    return indices.map {
        WeightedEdge<Int>(u: graph.indexOfVertex($0)!,
                          v: graph.indexOfVertex($1)!,
                          directed: true,
                          weight: 1)
    }
}

struct PlusIntersection: IntersectionRepresentable {
    let graph: WeightedGraph<String, Int>
    private var edges: [WeightedEdge<Int>]
    private var vertices: [String]
    var roads: [Road]
    
    private let leftToRightRoad = Road(origin: .left(.left(.none)),
                                       destination: .right(.right(.none)))
    private let rightToLeftRoad = Road(origin: .right(.right(.none)),
                                       destination: .left(.left(.none)))
    private let bottomToTopRoad = Road(origin: .bottom(.bottom(.none)),
                                       destination: .top(.top(.none)))
    private let topToBottomRoad = Road(origin: .top(.top(.none)),
                                       destination: .bottom(.bottom(.none)))
    
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
    //
    
    init(havingOneWayRoad road: Orientation?) {
        // this shit is ugly
        roads = [leftToRightRoad, rightToLeftRoad, bottomToTopRoad, topToBottomRoad]
        let pairs = [
            ("A", "B"), ("B", "C"), ("C", "D"),
            ("E", "F"), ("F", "G"), ("G", "H"),
            ("K", "G"), ("G", "B"), ("B", "I"),
            ("J", "C"), ("C", "F"), ("F", "L")
        ]
        vertices = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L"]
        graph = WeightedGraph<String, Int>(vertices: vertices)
        edges = makeEdges(in: graph, with: pairs)
        
        for edge in edges { graph.addEdge(edge) }
//        graph = convert(roads: roads)
    }
    
    func add(sign: RoadSign, to road: Road) {
        if road == rightToLeftRoad && (sign == .stop || sign == .invertedTriangle) {
            edges[6].weight = 3
        } else if road == leftToRightRoad && (sign == .stop || sign == .invertedTriangle) {
            edges[9].weight = 3
        } else if road == topToBottomRoad && (sign == .stop || sign == .invertedTriangle) {
            edges[0].weight = 3
        } else if road == bottomToTopRoad && (sign == .stop || sign == .invertedTriangle) {
            edges[3].weight = 3
        }
    }
    
    func convert(roads: [Road]) -> WeightedGraph<String, Int> {
        return WeightedGraph<String, Int>()
    }
    
//    func convert(roads: [Road]) -> [String] {
//        var vertexCount = 0
//
//        for road in roads {
//
//        }
//    }
    
}
