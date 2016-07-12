//
//  Button.swift
//  Assignment3
//
//  Created by Ken Zhang on 7/10/16.
//  Copyright © 2016 Ken Zhang. All rights reserved.
//

import UIKit

class Button: UIButton {
    
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    var hor: Int = 0
    var ver: Int = 0
    
    func neighbors(row: Int, column: Int) -> [(row:Int, column:Int)]{
        return [((row+hor-1)%hor,(column+ver-1)%ver), ((row+hor-1)%hor, column), ((row+hor-1)%hor, (column+1)%ver), (row, (column+ver-1)%ver), (row, (column+1)%ver), ((row+1)%hor, (column+ver-1)%ver), ((row+1)%hor, column), ((row+1)%hor, (column+1)%ver)]
    }
    
    func step2(horizontal: Int, vertical: Int, middle: [[CellState]]) -> [[CellState]] {
        var livingNeighbors = 0
        var after  = [[CellState]](count: middle.count, repeatedValue: [CellState](count: middle[0].count, repeatedValue: .Empty))
        hor = horizontal
        ver = vertical
        for x in 0 ..< middle.count {
            for y in 0 ..< middle[x].count{
                let arrOfTuplesOfCo = neighbors(x, column: y)
                for items in arrOfTuplesOfCo{
                    if middle[items.0][items.1] == .Living || middle[items.0][items.1] == .Born{
                        livingNeighbors += 1
                    }
                }
                
                switch livingNeighbors{
                case 2:
                    switch middle[x][y]{
                    case .Born, .Living: after[x][y] = .Living
                    case .Died, .Empty: after[x][y] = .Empty
                    }
                case 3:
                    switch middle[x][y]{
                    case .Born, .Died, .Empty: after[x][y] = .Born
                    case.Living: after[x][y] = .Living
                    }
                default:
                    switch middle[x][y]{
                    case .Born, .Living: after[x][y] = .Died
                    case .Empty, .Died: after[x][y] = .Empty
                    }
                }
                
                
                livingNeighbors = 0
            }
            
        }
        return after
    }
}
