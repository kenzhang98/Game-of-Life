//
//  Engine.swift
//  Assignment4
//
//  Created by Ken Zhang on 7/16/16.
//  Copyright © 2016 Ken Zhang. All rights reserved.
//

import Foundation

protocol EngineDelegateProtocol {
    func engineDidUpdate(withGrid: GridProtocol)
}

protocol EngineProtocol{
    var delegate: EngineDelegateProtocol? { get set }
    var grid: GridProtocol { get }
    
    //because I use the timer int
//    var refreshRate: Double { get set }
    
    var refreshTimer: NSTimer? { get set }
    var rows: Int { get set }
    var cols: Int { get set }
    init(rows: Int, cols: Int)
    func step() -> GridProtocol
}

//use the extension 
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
    
    var delegate: EngineDelegateProtocol?
    var grid: GridProtocol
    
   
    
    var rows: Int {
        didSet {

            if let delegate = delegate {
                delegate.engineDidUpdate(grid)
            }
        NSNotificationCenter.defaultCenter().postNotificationName("setEngineStaticsNotification", object: self, userInfo: ["value" : grid])
        }
    }
    var cols: Int {
        didSet {
            StandardEngine.sharedInstance.cols = cols
            if let delegate = delegate {
                delegate.engineDidUpdate(grid)
            }
        NSNotificationCenter.defaultCenter().postNotificationName("setEngineStaticsNotification", object: nil, userInfo: ["value" : grid])
        }
    }
    
    
    

    var refreshTimer:NSTimer?
    
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


    
    required init(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        grid = Grid(rows: rows, cols: cols)
    }
    
    func step() -> GridProtocol {
        var livingNeighbors = 0
        
        let after: GridProtocol = Grid(rows: rows, cols: cols)

        for x in 0 ..< rows {
            for y in 0 ..< cols{
                let arrOfTuplesOfCo = grid.neighbors(x, column: y)
                for items in arrOfTuplesOfCo{
                    if grid[items.0, items.1] == .Living || grid[items.0, items.1] == .Born{
                        livingNeighbors += 1
                    }
                }
                
                switch livingNeighbors{
                case 2:
                    switch grid[x, y]!{
                    case .Born, .Living: after[x,y] = .Living
                    case .Died, .Empty: after[x,y] = .Empty
                    }
                case 3:
                    switch grid[x, y]!{
                    case .Died, .Empty: after[x,y] = .Born
                    case.Living, .Born: after[x,y] = .Living
                    }
                default:
                    switch grid[x, y]!{
                    case .Born, .Living: after[x,y] = .Died
                    case .Empty, .Died: after[x,y] = .Empty
                    }
                }
                livingNeighbors = 0
            }
            
        }
        
        //call the delegate method to update 
        if let delegate = delegate {
            delegate.engineDidUpdate(grid)
        }
        
        return after
        
    }
    
    @objc func timerDidFire(timer:NSTimer) {
        StandardEngine.sharedInstance.grid = StandardEngine.sharedInstance.step()
    }
}






