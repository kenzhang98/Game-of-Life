//
//  Engine.swift
//  Final Project
//
//  Created by Ken Zhang on 7/26/16.
//  Copyright © 2016 Ken Zhang. All rights reserved.
//

import UIKit

typealias Position = (row:Int, col: Int)

enum CellState {
    case Living
    case Empty
    case Born
    case Died
    
    func isLiving() -> Bool {
        switch self {
        case .Living, .Born: return true
        case .Died, .Empty: return false
        }
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

typealias Cell = (position: Position, state: CellState)

protocol GridProtocol {
    var rows: Int { get }
    var cols: Int { get }
    var cells: [Cell] { get set }
    
    var living: Int { get }
    var dead:   Int { get }
    var alive:  Int { get }
    var born:   Int { get }
    var died:   Int { get }
    var empty:  Int { get }
    
    subscript (i:Int, j:Int) -> CellState { get set }
    
    func neighbors(pos: Position) -> [Position]
    func livingNeighbors(position: Position) -> Int
}

protocol  EngineDelegateProtocol: class {
    func engineDidUpdate(withGrid: GridProtocol)
}

protocol EngineProtocol {
    var rows: Int { get set }
    var cols: Int { get set }
    var grid: GridProtocol { get }
    weak var delegate: EngineDelegateProtocol? { get set }
    
    var refreshTimer: NSTimer? { get set }
    
    func step() -> GridProtocol
}

typealias CellInitializer = (Position) -> CellState

class StandardEngine: EngineProtocol {
    
    static var _sharedInstance: StandardEngine = StandardEngine(20,20)
    static var sharedInstance: StandardEngine { get { return _sharedInstance } }
    
    var grid: GridProtocol
    
    var rows: Int = 20 {
        didSet {
            grid = Grid(self.rows, self.cols) { _,_ in .Empty }
            if let delegate = delegate { delegate.engineDidUpdate(grid) }
        }
    }
    
    var cols: Int = 20 {
        didSet {
            grid = Grid(self.rows, self.cols) { _,_ in .Empty }
            if let delegate = delegate { delegate.engineDidUpdate(grid) }
        }
    }
    
    weak var delegate: EngineDelegateProtocol?
    
    //set up refreshInterval
    var refreshInterval: NSTimeInterval = 0 {
        didSet {
            if refreshInterval != 0 {
                if let timer = refreshTimer { timer.invalidate() }
                let sel = #selector(StandardEngine.timerDidFire(_:))
                refreshTimer = NSTimer.scheduledTimerWithTimeInterval(refreshInterval,
                                                                      target: self,
                                                                      selector: sel,
                                                                      userInfo: nil,
                                                                      repeats: true)
            }
            else if let timer = refreshTimer {
                timer.invalidate()
                self.refreshTimer = nil
            }
        }
    }

    
    var refreshTimer: NSTimer?
    
    @objc func timerDidFire(timer:NSTimer) {
        StandardEngine.sharedInstance.grid = StandardEngine.sharedInstance.step()
        NSNotificationCenter.defaultCenter().postNotificationName("setEngineStaticsNotification", object: nil, userInfo: nil)
    }
    
    subscript (i:Int, j:Int) -> CellState {
        get {
            return grid.cells[i*cols+j].state
        }
        set {
            grid.cells[i*cols+j].state = newValue
        }
    }
    
    
    
    init(_ rows: Int, _ cols: Int, cellInitializer: CellInitializer = {_ in .Empty }) {
        self.rows = rows
        self.cols = cols
        self.grid = Grid(rows,cols, cellInitializer: cellInitializer)
    }
    
    func step() -> GridProtocol {
        var newGrid = Grid(self.rows, self.cols)
        newGrid.cells = grid.cells.map {
            switch grid.livingNeighbors($0.position) {
            case 2 where $0.state.isLiving(),
            3 where $0.state.isLiving():  return Cell($0.position, .Living)
            case 3 where !$0.state.isLiving(): return Cell($0.position, .Born)
            case _ where $0.state.isLiving():  return Cell($0.position, .Died)
            default:                           return Cell($0.position, .Empty)
            }
        }
        grid = newGrid
        if let delegate = delegate { delegate.engineDidUpdate(grid) }
        return grid
    }
}

struct Grid: GridProtocol {
    private(set) var rows: Int
    private(set) var cols: Int
    var cells: [Cell]
    
    var living: Int { return cells.reduce(0) { return  $1.state.isLiving() ?  $0 + 1 : $0 } }
    var dead:   Int { return cells.reduce(0) { return !$1.state.isLiving() ?  $0 + 1 : $0 } }
    var alive:  Int { return cells.reduce(0) { return  $1.state == .Living  ?  $0 + 1 : $0 } }
    var born:   Int { return cells.reduce(0) { return  $1.state == .Born   ?  $0 + 1 : $0 } }
    var died:   Int { return cells.reduce(0) { return  $1.state == .Died   ?  $0 + 1 : $0 } }
    var empty:  Int { return cells.reduce(0) { return  $1.state == .Empty  ?  $0 + 1 : $0 } }
    
    init (_ rows: Int, _ cols: Int, cellInitializer: CellInitializer = {_ in .Empty }) {
        self.rows = rows
        self.cols = cols
        self.cells = (0..<rows*cols).map {
            let pos = Position($0/cols, $0%cols)
            return Cell(pos, cellInitializer(pos))
        }
    }
    
    subscript (i:Int, j:Int) -> CellState {
        get {
            return cells[i*cols+j].state
        }
        set {
            cells[i*cols+j].state = newValue
        }
    }
    
    private static let offsets:[Position] = [
        (-1, -1), (-1, 0), (-1, 1),
        ( 0, -1),          ( 0, 1),
        ( 1, -1), ( 1, 0), ( 1, 1)
    ]
    func neighbors(pos: Position) -> [Position] {
        return Grid.offsets.map { Position((pos.row + rows + $0.row) % rows,
            (pos.col + cols + $0.col) % cols) }
    }
    
    func livingNeighbors(position: Position) -> Int {
        return neighbors(position)
            .reduce(0) {
                self[$1.row,$1.col].isLiving() ? $0 + 1 : $0
        }
    }
}










