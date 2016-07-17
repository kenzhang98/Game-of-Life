//
//  Grid.swift
//  Assignment4
//
//  Created by Ken Zhang on 7/16/16.
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






