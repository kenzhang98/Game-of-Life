//
//  GridView.swift
//  Final Project
//
//  Created by Ken Zhang on 7/26/16.
//  Copyright © 2016 Ken Zhang. All rights reserved.
//

import Foundation
import UIKit



class GridView: UIView{
    
    //@IBinspectable is not mandatory in this assignment
    
    //set up variables
    
    var points:[(Int,Int)]? {
        get{
            var newValue: [(Int,Int)] = []
            _ = StandardEngine.sharedInstance.grid.cells.map{
                switch $0.state{
                case .Alive: newValue.append($0.position)
                case .Born: newValue.append($0.position)
                default: break
                }
            }
            return newValue
        }
        set(newValue){
            let rows = StandardEngine.sharedInstance.grid.rows
            let cols = StandardEngine.sharedInstance.grid.cols
            StandardEngine.sharedInstance.grid = Grid(rows,cols, cellInitializer: {_ in .Empty})
            if let points = newValue {
                _ = points.map{
                    StandardEngine.sharedInstance.grid[$0.0, $0.1] = .Alive
                }
            }
        }
        
    }
    
    var livingColor: UIColor = UIColor.greenColor()
    var emptyColor: UIColor = UIColor.grayColor()
    var bornColor: UIColor = UIColor.greenColor().colorWithAlphaComponent(0.3)
    var diedColor: UIColor = UIColor.grayColor().colorWithAlphaComponent(0.3)
    var gridColor: UIColor = UIColor.blackColor()
    var gridWidth: CGFloat = 2.0
    //instead of taking rows and cols as variables, replace them with StandardEngine.sharedInstance.rows and StandardEngine.sharedInstance.cols
    
    //override drawRect function
    override func drawRect(rect: CGRect){
        
        //set up the width and length variables for the vertical strokes
        let verHeight = gridWidth
        let verLength = bounds.height
        
        //create the path
        let verPath = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        verPath.lineWidth = verHeight
        
        //move the point of the path to the start of the vertical strokes with a for loop
        for x in 0...StandardEngine.sharedInstance.rows{
            verPath.moveToPoint(CGPoint(x: CGFloat(x) * (bounds.width - gridWidth) / CGFloat(StandardEngine.sharedInstance.rows) + CGFloat(gridWidth/2), y: 0))
            //add a point to the path at the end of vertical each stroke
            verPath.addLineToPoint(CGPoint(x: CGFloat(x) * (bounds.width - gridWidth) / CGFloat(StandardEngine.sharedInstance.rows) + CGFloat(gridWidth/2), y: verLength))
        }
        
        //set up the width and length variables for the horizontal strokes
        let horHeight = gridWidth
        let horLength = bounds.width
        
        //create the path
        let horPath = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        horPath.lineWidth = horHeight
        
        //move the point of the path to the start of the horizontal strokes with a for loop
        for y in 0...StandardEngine.sharedInstance.cols{
            horPath.moveToPoint(CGPoint(x: 0, y: CGFloat(y) * (bounds.height - gridWidth) / CGFloat(StandardEngine.sharedInstance.cols) + CGFloat(gridWidth/2)))
            //add a point to the path at the end of each horizontal stroke
            horPath.addLineToPoint(CGPoint(x: horLength, y: CGFloat(y) * (bounds.height - gridWidth) / CGFloat(StandardEngine.sharedInstance.cols) + CGFloat(gridWidth/2)))
        }
        
        //set the stroke color
        gridColor.setStroke()
        //draw the stroke
        verPath.stroke()
        horPath.stroke()
        
        //set up the tiny rectangles and then draw the circles
        for x in 0..<StandardEngine.sharedInstance.rows{
            for y in 0..<StandardEngine.sharedInstance.cols{
                
                let rectangle = CGRect(x: CGFloat(x) * (bounds.width - gridWidth) / CGFloat(StandardEngine.sharedInstance.rows) + CGFloat(gridWidth), y: CGFloat(y) * (bounds.height - gridWidth) / CGFloat(StandardEngine.sharedInstance.cols) + CGFloat(gridWidth), width: bounds.width / CGFloat(StandardEngine.sharedInstance.rows) - CGFloat(gridWidth), height: bounds.height / CGFloat(StandardEngine.sharedInstance.cols) - CGFloat(gridWidth))
                
                let path = UIBezierPath(ovalInRect: rectangle)
                
                switch StandardEngine.sharedInstance.grid[(x,y)]{
                case .Alive: livingColor.setFill()
                case .Born: bornColor.setFill()
                case .Died: diedColor.setFill()
                case .Empty: emptyColor.setFill()
                }
                
                path.fill()
            }
        }
        
    }
    //drawRec function finishes here
    
    
    
    //implement touch handling function of Problem 5
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            self.processTouch(touch)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            self.processTouch(touch)
            
        }
    }
    
    
    func processTouch(touch: UITouch) {
        let point = touch.locationInView(self)
        let cellWidth = Double(bounds.width) / Double(StandardEngine.sharedInstance.rows)
        let cellHeight = Double(bounds.height) / Double(StandardEngine.sharedInstance.cols)
        let xCo = Int(floor(Double(point.x) / cellWidth))
        let yCo = Int(floor(Double(point.y) / cellHeight))
        
        // if the point is not out of boundaries, then toggle the cell that user picks
        if xCo <= StandardEngine.sharedInstance.rows-1 && yCo <= StandardEngine.sharedInstance.cols-1 && xCo >= 0 && yCo >= 0 {
            StandardEngine.sharedInstance.grid[xCo, yCo] = CellState.toggle(StandardEngine.sharedInstance.grid[xCo, yCo])
        }
        let gridToBeChanged = CGRect(x: CGFloat(Double(xCo) * cellWidth), y: CGFloat(Double(yCo) * cellHeight), width: CGFloat(cellWidth), height: CGFloat(cellHeight))
        
        NSNotificationCenter.defaultCenter().postNotificationName("setEngineStaticsNotification", object: nil, userInfo: nil)
        
        self.setNeedsDisplayInRect(gridToBeChanged)
    }
}

