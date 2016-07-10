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
    var grid = [[CellState]](count: 20, repeatedValue: [CellState](count: 20, repeatedValue: CellState.Empty))
    
    //set up variables and funcs for toggle method
    
    override func awakeFromNib() {
        self.multipleTouchEnabled = true
    }
    
    //override drawRect function
    override func drawRect(rect: CGRect){
        
        //set up the width and length variables for the horizontal strokes
        
        let verHeight = gridWidth
        let verLength = bounds.width
        let space = bounds.width / CGFloat(rows)
        
        //create the path
        let verPath = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        verPath.lineWidth = verHeight
        
        //move the point of the path to the start of the vertical strokes with a for loop
        for x in 0...rows{
            verPath.moveToPoint(CGPoint(x: CGFloat(x) * space, y: 0))
            //add a point to the path at the end of vertical each stroke
            verPath.addLineToPoint(CGPoint(x: CGFloat(x) * space, y: verLength))
        }
        
        //set up the width and length variables for the vertical strokes
        let horHeight = gridWidth
        let horLength = bounds.width
        let spaceHeight = bounds.height / CGFloat(cols)
        
        //create the path
        let horPath = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        horPath.lineWidth = horHeight
        
        //move the point of the path to the start of the horizontal strokes with a for loop
        for y in 0...cols{
            horPath.moveToPoint(CGPoint(x: 0, y: CGFloat(y) * spaceHeight))
            //add a point to the path at the end of each horizontal stroke
            horPath.addLineToPoint(CGPoint(x: horLength, y: CGFloat(y) * spaceHeight))
        }
        
        //set the stroke color
        gridColor.setStroke()
        //draw the stroke
        verPath.stroke()
        horPath.stroke()
        
        //set up the tiny rectangles and then draw the circles
        for x in 0..<rows{
            for y in 0..<cols{
                
                let rectangle = CGRect(x: CGFloat(x) * bounds.width / CGFloat(rows), y: CGFloat(y) * bounds.height / CGFloat(cols), width: bounds.width / CGFloat(rows), height: bounds.height / CGFloat(cols))
                
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
        
        print("boundsWidth: \(bounds.width)")
    }
    //drawRec function finishes here
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            self.processTouch(touch)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            self.processTouch(touch)
        }
    }
    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        for touch in touches {
//            self.processTouch(touch)
//        }
//    }
    
    func processTouch(touch: UITouch) {
        let point = touch.locationInView(self)
        let cellWidth = 600 / rows
        let cellHeight = 600 / cols
        let xCo = Int(point.x) / cellWidth
        let yCo = Int(point.y) / cellHeight
        
        grid[xCo][yCo] = CellState.toggle(grid[xCo][yCo])
        
        print("xCo: \(xCo) yCo: \(yCo) cellWidth: \(cellWidth) cellHeight: \(cellHeight) state: \(grid[xCo][yCo]) pointX: \(point.x) pointY: \(point.y)" )
        self.setNeedsDisplay()
    }
}






