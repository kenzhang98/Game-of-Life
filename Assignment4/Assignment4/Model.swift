//
//  Protocols.swift
//  Assignment4
//
//  Created by Ken Zhang on 7/12/16.
//  Copyright © 2016 Ken Zhang. All rights reserved.
//

import Foundation

enum CellState: String{
    case Living = "living"
    case Empty = "empty"
    case Born = "born"
    case Died = "died"
    
    static func description(value: CellState) -> String{
        switch value{
        case .Living: return "living"
        case .Empty: return "empty"
        case .Born: return "born"
        case .Died: return "died"
        }
    }
    
    static func allValues() -> [CellState]{
        return([.Living, .Born, .Died, .Empty])
    }
    
    static func toggle(value: CellState) -> CellState{
        switch value {
        case .Empty, .Died:
            return(.Living)
        case .Living, .Born:
            return(.Empty)
        }
    }
}

protocol GridProtocol {
    init(rows: Int, cols: Int)
    var rows: Int {get}
    var cols: Int {get}
    func neighbors(row:Int, column:Int) -> [(Int, Int)]
    subscript(row: Int, column: Int) -> CellState? { get set }
}

protocol EngineDelegate {
    func engineDidUpdate(withGrid: GridProtocol)
}

protocol EngineProtocol{
    var delegate: EngineDelegate? { get set }
    var grid: GridProtocol { get }
    var refreshRate: Double { get set }
    //    var refreshTimer: NSTimer { get set }
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

//let example = Grid(rows: 1, cols: 1)

class StandardEngine: EngineProtocol {
    var delegate: EngineDelegate?
    var grid: GridProtocol
    
    var rows: Int {
        didSet {
            if let delegate = delegate {
                delegate.engineDidUpdate(grid)
            }
        }
    }
    var cols: Int {
        didSet {
            if let delegate = delegate {
                delegate.engineDidUpdate(grid)
            }
        }
    }
    
    var refreshRate: Double = 0
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




class Grid: GridProtocol {
    var rows: Int
    var cols: Int
    private var grid = [[CellState]]()
    
    required init(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        grid = [[CellState]](count: rows, repeatedValue: [CellState](count: cols, repeatedValue: CellState.Empty))
    }
    
    func neighbors(row: Int, column: Int) -> [(Int, Int)] {
        return [((row+rows-1)%rows,(column+cols-1)%cols), ((row+rows-1)%rows, column), ((row+rows-1)%rows, (column+1)%cols), (row, (column+cols-1)%cols), (row, (column+1)%cols), ((row+1)%rows, (column+cols-1)%cols), ((row+1)%rows, column), ((row+1)%rows, (column+1)%cols)]
    }
    
    subscript(row: Int, column: Int) -> CellState?{
        get{
            if row >= rows || column >= cols{ return nil }
            return grid[row][column]
        }
        set{
            if newValue == nil { return }
            if row < 0 || row >= rows || column < 0 || column >= cols { return }
            grid[row][column] = newValue!
        }
    }
}




