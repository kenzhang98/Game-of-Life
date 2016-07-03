//
//  Engine.swift
//  Assignment2
//
//  Created by Ken Zhang on 7/3/16.
//  Copyright © 2016 Ken Zhang. All rights reserved.
//

import Foundation

let size = 4

func step(middle: [[Bool]]) -> [[Bool]]{
    var livingNeighbors = 0
    var after  = [[Bool]](count: size, repeatedValue: [Bool](count: size, repeatedValue: false))
    
    
    
    for x in 0 ..< middle.count {
        for y in 0 ..< middle[x].count{
            
            //check how many of the neighbors are alive
            
            //left top
            if middle[(x+size-1)%size][(y+size-1)%size] == true{
                livingNeighbors += 1
            }
            //top
            if middle[(x+size-1)%size][y] == true{
                livingNeighbors += 1
            }
            //right top
            if middle[(x+size-1)%size][(y+1)%size] == true{
                livingNeighbors += 1
            }
            //left
            if middle[x][(y+size-1)%size] == true{
                livingNeighbors += 1
            }
            //right
            if middle[x][(y+1)%size] == true{
                livingNeighbors += 1
            }
            //left bottom
            if middle[(x+1)%size][(y+size-1)%size] == true{
                livingNeighbors += 1
            }
            if middle[(x+1)%size][y] == true{
                livingNeighbors += 1
            }
            if middle[(x+1)%size][(y+1)%size] == true{
                livingNeighbors += 1
            }
            
            //determine the statue of the cell
            
            if middle[x][y] == true && livingNeighbors < 2{
                after[x][y] = false
            }
            if middle[x][y] == true && livingNeighbors == 2 || livingNeighbors == 3{
                after[x][y] = true
            }
            if middle[x][y] == true && livingNeighbors > 3{
                after[x][y] = false
            }
            if middle[x][y] == false && livingNeighbors == 3{
                after[x][y] = true
            }
            
            //clear the counter for the next cell
            livingNeighbors = 0
            
        }
    }
    
    return after
}

func neighbors(row: Int, column: Int) -> [(row:Int, column:Int)]{
    return [((row+size-1)%size,(column+size-1)%size), ((row+size-1)%size, column), ((row+size-1)%size, (column+1)%size), (row, (column+size-1)%size), (row, (column+1)%size), ((row+1)%size, (column+size-1)%size), ((row+1)%size, column), ((row+1)%size, (column+1)%size)]
}

func step2(middle: [[Bool]]) -> [[Bool]] {
    var livingNeighbors = 0
    var after  = [[Bool]](count: size, repeatedValue: [Bool](count: size, repeatedValue: false))
    
    for x in 0 ..< middle.count {
        for y in 0 ..< middle[x].count{
            let arrOfTuplesOfCo = neighbors(x, column: y)
            print(arrOfTuplesOfCo)
            print(x,y)
            for items in arrOfTuplesOfCo{
                
                print(items)
                print(middle[items.0][items.1])
                if middle[items.0][items.1] == true{
                    livingNeighbors += 1
                }
                
                print(livingNeighbors)
                
                if livingNeighbors < 2{
                    after[x][y] = false
                }
                if middle[x][y] == true && livingNeighbors == 2 || livingNeighbors == 3{
                    after[x][y] = true
                }
                if livingNeighbors > 3{
                    after[x][y] = false
                }
                if middle[x][y] == false && livingNeighbors == 3{
                    after[x][y] = true
                }
                
                print("this is middle \(middle[x][y])")
                print("this is after \(after[x][y])")
            }
            livingNeighbors = 0
        }
        
    }
    
    return after
}




