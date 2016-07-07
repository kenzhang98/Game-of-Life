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
    
    func toggle(value: CellState) -> CellState{
        switch value {
        case .Empty, .Died:
            return(.Living)
        case .Living, .Born:
            return(.Empty)
        }
    }
}

@IBDesignable class GridView: UIView{
    @IBInspectable var rows: Int = 20{
        didSet {
            arrOfCellState = [[CellState]]()
        }
    }
    @IBInspectable var cols: Int = 20{
        didSet{
            arrOfCellState = [[CellState]]()
        }
    }
    @IBInspectable var livingColor: UIColor = UIColor.blackColor()
    @IBInspectable var emptyColor: UIColor = UIColor.blackColor()
    @IBInspectable var bornColor: UIColor = UIColor.blackColor()
    @IBInspectable var diedColor: UIColor = UIColor.blackColor()
    @IBInspectable var gridColor: UIColor = UIColor.blackColor()
    @IBInspectable var gridWidth: CGFloat = 2.0
    
    var arrOfCellState = [[CellState]]()
    
    override func drawRect(rect: CGRect){
        
        //set up the width and length variables for the horizontal strokes
        let verHeight = gridWidth
        let verLength = bounds.width
        var space = bounds.width / CGFloat(rows)
        
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
        space = bounds.height / CGFloat(cols)
        
        //create the path
        let horPath = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        horPath.lineWidth = horHeight
        
        //move the point of the path to the start of the horizontal strokes with a for loop
        for y in 0...cols{
            horPath.moveToPoint(CGPoint(x: 0, y: CGFloat(y) * space))
            //add a point to the path at the end of each horizontal stroke
            horPath.addLineToPoint(CGPoint(x: horLength, y: CGFloat(y) * space))
        }
        
        //set the stroke color
        gridColor.setStroke()
        //draw the stroke
        verPath.stroke()
        horPath.stroke()
    }
}

