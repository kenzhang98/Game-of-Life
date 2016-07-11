//
//  Button.swift
//  Assignment3
//
//  Created by Ken Zhang on 7/10/16.
//  Copyright © 2016 Ken Zhang. All rights reserved.
//

import UIKit

class Button: UIButton {

    @IBAction func whatever(sender: AnyObject) {
        print("test")
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    let size = 20
 
    func neighbors(row: Int, column: Int) -> [(row:Int, column:Int)]{
        return [((row+size-1)%size,(column+size-1)%size), ((row+size-1)%size, column), ((row+size-1)%size, (column+1)%size), (row, (column+size-1)%size), (row, (column+1)%size), ((row+1)%size, (column+size-1)%size), ((row+1)%size, column), ((row+1)%size, (column+1)%size)]
    }
    
    func step2(middle: [[CellState]]) -> [[CellState]] {
        var livingNeighbors = 0
        var after  = [[CellState]](count: size, repeatedValue: [CellState](count: size, repeatedValue: .Empty))
        
        for x in 0 ..< middle.count {
            for y in 0 ..< middle[x].count{
                let arrOfTuplesOfCo = neighbors(x, column: y)
                for items in arrOfTuplesOfCo{
                    
                    if middle[items.0][items.1] == .Living || middle[items.0][items.1] == .Born{
                        livingNeighbors += 1
                    }
                    
                    if livingNeighbors < 2 && middle[x][y] == .Living{
                        after[x][y] = .Died
                    }else if livingNeighbors < 2 && middle[x][y] == .Died{
                        after[x][y] = .Empty
                    }
                    
                    if middle[x][y] == .Living && livingNeighbors == 2 || middle[x][y] == .Living && livingNeighbors == 3{
                        after[x][y] = .Living
                    }
                    if livingNeighbors == 3{
                        after[x][y] = .Born
                    }
                    
                    if livingNeighbors > 3 && middle[x][y] == .Living{
                        after[x][y] = .Died
                    }else if livingNeighbors > 3 && middle[x][y] == .Died{
                        after[x][y] = .Empty
                    }
                    
                    if middle[x][y] == .Died && livingNeighbors == 3{
                        after[x][y] = .Born
                    }
                    
                }
                livingNeighbors = 0
            }
            
        }
        return after
    }
}
