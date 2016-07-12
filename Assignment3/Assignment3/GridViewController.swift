//
//  GridViewController.swift
//  Assignment3
//
//  Created by Ken Zhang on 7/7/16.
//  Copyright © 2016 Ken Zhang. All rights reserved.
//

import Foundation
import UIKit

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


@IBDesignable class GridView: UIView{
    
    //set up variables
    @IBInspectable var livingColor: UIColor = UIColor.greenColor()
    @IBInspectable var emptyColor: UIColor = UIColor.grayColor()
    @IBInspectable var bornColor: UIColor = UIColor.greenColor()
    @IBInspectable var diedColor: UIColor = UIColor.grayColor()
    @IBInspectable var gridColor: UIColor = UIColor.blackColor()
    @IBInspectable var gridWidth: CGFloat = 2.0
    @IBInspectable var rows: Int = 20{
        didSet {
            grid = [[CellState]](count: rows, repeatedValue: [CellState](count: cols, repeatedValue: CellState.Empty))
        }
    }
    @IBInspectable var cols: Int = 20{
        didSet{
            grid = [[CellState]](count: rows, repeatedValue: [CellState](count: cols, repeatedValue: CellState.Empty))
        }
    }
    var grid = [[CellState]](count: 1, repeatedValue: [CellState](count: 1, repeatedValue: CellState.Empty))
    
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
        for x in 0...rows{
            verPath.moveToPoint(CGPoint(x: CGFloat(x) * (bounds.width - gridWidth) / CGFloat(rows) + CGFloat(gridWidth/2), y: 0))
            //add a point to the path at the end of vertical each stroke
            verPath.addLineToPoint(CGPoint(x: CGFloat(x) * (bounds.width - gridWidth) / CGFloat(rows) + CGFloat(gridWidth/2), y: verLength))
        }
        
        //set up the width and length variables for the horizontal strokes
        let horHeight = gridWidth
        let horLength = bounds.width
        
        //create the path
        let horPath = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        horPath.lineWidth = horHeight
        
        //move the point of the path to the start of the horizontal strokes with a for loop
        for y in 0...cols{
            horPath.moveToPoint(CGPoint(x: 0, y: CGFloat(y) * (bounds.height - gridWidth) / CGFloat(cols) + CGFloat(gridWidth/2)))
            //add a point to the path at the end of each horizontal stroke
            horPath.addLineToPoint(CGPoint(x: horLength, y: CGFloat(y) * (bounds.height - gridWidth) / CGFloat(cols) + CGFloat(gridWidth/2)))
        }
        
        //set the stroke color
        gridColor.setStroke()
        //draw the stroke
        verPath.stroke()
        horPath.stroke()
        
        //set up the tiny rectangles and then draw the circles
        for x in 0..<rows{
            for y in 0..<cols{
                
                let rectangle = CGRect(x: CGFloat(x) * (bounds.width - gridWidth) / CGFloat(rows) + CGFloat(gridWidth), y: CGFloat(y) * (bounds.height - gridWidth) / CGFloat(cols) + CGFloat(gridWidth), width: bounds.width / CGFloat(rows) - CGFloat(gridWidth), height: bounds.height / CGFloat(cols) - CGFloat(gridWidth))
                
                let path = UIBezierPath(ovalInRect: rectangle)
                
                switch grid[x][y]{
                case .Living: livingColor.setFill()
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
    
    //    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    //        if let touch = touches.first {
    //            self.processTouch(touch)
    //
    //        }
    //    }
    
    func processTouch(touch: UITouch) {
        let point = touch.locationInView(self)
        let cellWidth = Double(bounds.width) / Double(rows)
        let cellHeight = Double(bounds.height) / Double(cols)
        let xCo = Int(floor(Double(point.x) / cellWidth))
        let yCo = Int(floor(Double(point.y) / cellHeight))
        
        if xCo <= rows-1 && yCo <= cols-1 && xCo >= 0 && yCo >= 0 {
            grid[xCo][yCo] = CellState.toggle(grid[xCo][yCo])
        }
        let gridToBeChanged = CGRect(x: CGFloat(Double(xCo) * cellWidth), y: CGFloat(Double(yCo) * cellHeight), width: CGFloat(cellWidth), height: CGFloat(cellHeight))
        self.setNeedsDisplayInRect(gridToBeChanged)
    }
}




