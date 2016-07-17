//
//  Engine.swift
//  Assignment4
//
//  Created by Ken Zhang on 7/16/16.
//  Copyright © 2016 Ken Zhang. All rights reserved.
//

import Foundation

protocol EngineDelegate {
    func engineDidUpdate(withGrid: GridProtocol)
}

protocol EngineProtocol{
    var delegate: EngineDelegate? { get set }
    var grid: GridProtocol { get }
    var refreshRate: Double { get set }
    var refreshTimer: NSTimer? { get set }
    var rows: Int { get set }
    var cols: Int { get set }
    init(rows: Int, cols: Int)
    func step() -> GridProtocol
}

extension EngineProtocol{
    var refreshRate: Double{
        return 0.0
    }
}

class StandardEngine: EngineProtocol {
    
    private static var _sharedInstance = StandardEngine(rows:10, cols: 10)
    static var sharedInstance: StandardEngine {
        get {
            return _sharedInstance
        }
    }
    
    var delegate: EngineDelegate?
    var grid: GridProtocol
    
    var rows: Int {
        didSet {
            if let delegate = delegate {
                delegate.engineDidUpdate(grid)
                NSNotificationCenter.defaultCenter().postNotificationName("setEngineStaticsNotification", object: self)
            }
        }
    }
    var cols: Int {
        didSet {
            if let delegate = delegate {
                delegate.engineDidUpdate(grid)
                NSNotificationCenter.defaultCenter().postNotificationName("setEngineStaticsNotification", object: self)
            }
        }
    }
    
    var refreshRate: Double = 0.0
    var refreshTimer: NSTimer?
    
    required init(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        grid = Grid(rows: rows, cols: cols)
    }
    
    func step() -> GridProtocol {
        var livingNeighbors = 0
        
        for x in 0 ..< grid.rows {
            for y in 0 ..< grid.cols{
                let arrOfTuplesOfCo = grid.neighbors(x, column: y)
                for items in arrOfTuplesOfCo{
                    if grid[items.0, items.1] == .Living || grid[items.0, items.1] == .Born{
                        livingNeighbors += 1
                    }
                }
                
                switch livingNeighbors{
                case 2:
                    switch grid[x, y]!{
                    case .Born, .Living: grid[x,y] = .Living
                    case .Died, .Empty: grid[x,y] = .Empty
                    }
                case 3:
                    switch grid[x, y]!{
                    case .Died, .Empty: grid[x,y] = .Born
                    case.Living, .Born: grid[x,y] = .Living
                    }
                default:
                    switch grid[x, y]!{
                    case .Born, .Living: grid[x,y] = .Died
                    case .Empty, .Died: grid[x,y] = .Empty
                    }
                }
                livingNeighbors = 0
            }
        }
        return grid
    }
}






