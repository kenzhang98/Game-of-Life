//
//  EditViewController.swift
//  Final Project
//
//  Created by Ken Zhang on 7/27/16.
//  Copyright © 2016 Ken Zhang. All rights reserved.
//

import UIKit

class GridEditterViewController: UIViewController{
    @IBOutlet weak var warning: UILabel!
    var name:String?
    var comment:String?
    var color:String?
    var commit: (String -> Void)?
    var anotherCommit: ([[Int]] -> Void)?
    var commitForComment: (String -> Void)?
    var commitForColor: (String -> Void)?
    var savedCells: [[Int]] = []
    @IBOutlet weak var commentTextField: UITextField!

    @IBAction func cancelButton(sender: AnyObject) {
        //if the user changes the grid and hits cancel button, an alert will pop up to confirm the action
        if StandardEngine.sharedInstance.changesDetect{
            let alert = UIAlertController(title: "Quit Without Saving", message: "Are you sure you want to quit without saving?", preferredStyle: UIAlertControllerStyle.Alert)
            //add cancel button action
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            alert.addAction(UIAlertAction(title: "Quit", style: UIAlertActionStyle.Default, handler: {(action) -> Void in self.navigationController!.popViewControllerAnimated(true)}))
            
            let op = NSBlockOperation {
                self.presentViewController(alert, animated: true, completion: nil)
            }
            NSOperationQueue.mainQueue().addOperation(op)
        }else{
            navigationController!.popViewControllerAnimated(true)
            //clear the changes detecter
            StandardEngine.sharedInstance.changesDetect = false
        }
    }
    @IBOutlet weak var editterGrid: GridView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func commentAction(sender: AnyObject) {
        StandardEngine.sharedInstance.changesDetect = true
    }
    
    @IBAction func save(sender: AnyObject) {
        let filteredArray = StandardEngine.sharedInstance.grid.cells.filter{$0.state.isLiving()}.map{return $0.position}
        
        for i in filteredArray{
            savedCells.append([i.row, i.col])
        }
        
        guard let newText = nameTextField.text, commit = commit
            else { return }
        commit(newText)
        guard let anothercommit = anotherCommit else { return }
        anothercommit(savedCells)
        
        navigationController!.popViewControllerAnimated(true)
        
        //save the comment if there is any
        guard let comment = commentTextField.text, commitForComment = commitForComment
            else { return }
        commitForComment(comment)
        
        //save the color
        guard let commitForColor = commitForColor else { return }
        commitForColor(StandardEngine.sharedInstance.color)
    }
    
    @IBAction func undoAction(sender: AnyObject) {
        if StandardEngine.sharedInstance.undoCells.count > 0{
            //get the cell that needs to be undo in the list of undo cells, which is the last one
            let index = StandardEngine.sharedInstance.undoCells.count
            let cellToBeUndo = StandardEngine.sharedInstance.undoCells[index - 1]
            
            //set up X and Y coordinates and then toggle it
            let xCo = cellToBeUndo.row
            let yCo = cellToBeUndo.col
            StandardEngine.sharedInstance.grid[xCo, yCo] = CellState.toggle(StandardEngine.sharedInstance.grid[xCo, yCo])
            
            //update grid in Simulation tab
            if let delegate = StandardEngine.sharedInstance.delegate {
                delegate.engineDidUpdate(StandardEngine.sharedInstance.grid)
            }
            //update editter grid
            editterGrid.setNeedsDisplay()
            
            //remove the cell from the list and then put it into redo cell in case user wants to go back
            StandardEngine.sharedInstance.undoCells.removeLast()
            StandardEngine.sharedInstance.redoCells.append(cellToBeUndo)
        }else{
            UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                
                //set the text of the label to undo and fade it in
                self.warning.text = "No more steps to undo"
                
                //Fade in
                self.warning.alpha = 1.0
                }, completion: {
                    (finished: Bool) -> Void in
                    
                    // Fade out
                    UIView.animateWithDuration(2.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        self.warning.alpha = 0.0
                        }, completion: nil)
            })
        }
    }
    
    @IBAction func redoAction(sender: AnyObject) {
        if StandardEngine.sharedInstance.redoCells.count > 0{
            //get the cell that needs to be redo in the list of redo cells, which is the last one
            let index = StandardEngine.sharedInstance.redoCells.count
            let cellToBeRedo = StandardEngine.sharedInstance.redoCells[index - 1]
            
            //set up X and Y coordinates and then toggle it
            let xCo = cellToBeRedo.row
            let yCo = cellToBeRedo.col
            StandardEngine.sharedInstance.grid[xCo, yCo] = CellState.toggle(StandardEngine.sharedInstance.grid[xCo, yCo])
            
            //update grid in Simulation tab
            if let delegate = StandardEngine.sharedInstance.delegate {
                delegate.engineDidUpdate(StandardEngine.sharedInstance.grid)
            }
            //update editter grid
            editterGrid.setNeedsDisplay()
            
            //remove the cell from the list and then put it into redo cell in case user wants to go back
            StandardEngine.sharedInstance.redoCells.removeLast()
            StandardEngine.sharedInstance.undoCells.append(cellToBeRedo)
        }else{
            UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                
                //set the text of the label to redo and fade it in
                self.warning.text = "No more steps to redo"
                
                //Fade in
                self.warning.alpha = 1.0
                }, completion: {
                    (finished: Bool) -> Void in
                    
                    // Fade out
                    UIView.animateWithDuration(2.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        self.warning.alpha = 0.0
                        }, completion: nil)
            })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        editterGrid.setNeedsDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = name
        commentTextField.text = comment
        
        //set up the observer which updates the grid in the embed view when gets called
        let s = #selector(GridEditterViewController.watchForNotifications(_:))
        let c = NSNotificationCenter.defaultCenter()
        c.addObserver(self, selector: s, name: "updateGridInEmbedView", object: nil)
        
        let red = #selector(GridEditterViewController.red(_:))
        c.addObserver(self, selector: red, name: "red", object: nil)
        
        let orange = #selector(GridEditterViewController.orange(_:))
        c.addObserver(self, selector: orange, name: "orange", object: nil)
        
        let green = #selector(GridEditterViewController.green(_:))
        c.addObserver(self, selector: green, name: "green", object: nil)
        
        let cyan = #selector(GridEditterViewController.cyan(_:))
        c.addObserver(self, selector: cyan, name: "cyan", object: nil)
        
        let blue = #selector(GridEditterViewController.blue(_:))
        c.addObserver(self, selector: blue, name: "blue", object: nil)
        
        switch color!{
        case "red":
            redChangeColor()
        case "orange":
            orangeChangeColor()
        case "green":
            greenChangeColor()
        case "cyan":
            cyanChangeColor()
        case "blue":
            blueChangeColor()
        default:
            greenChangeColor()
        }
    }
    
    func watchForNotifications(notification:NSNotification){
        editterGrid.setNeedsDisplay()
    }
    
    func red(notification:NSNotification){
        redChangeColor()
        
    }
    func redChangeColor(){
        editterGrid.livingColor = UIColor(red: 231/255, green: 0, blue:0, alpha: 1)
        editterGrid.setNeedsDisplay()
    }
    
    func orange(notification:NSNotification){
        orangeChangeColor()
    }
    func orangeChangeColor(){
        editterGrid.livingColor = UIColor(red: 255/255, green: 150/255, blue:0, alpha: 1)
        editterGrid.diedColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.3)
        
        editterGrid.setNeedsDisplay()
    }
    
    func green(notification:NSNotification){
        greenChangeColor()
    }
    func greenChangeColor(){
        editterGrid.livingColor = UIColor(red: 0/255, green: 239/255, blue:22/255, alpha: 1)
        editterGrid.diedColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.4)
        editterGrid.bornColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        editterGrid.setNeedsDisplay()
    }
    
    func cyan(notification:NSNotification){
        cyanChangeColor()
    }
    func cyanChangeColor(){
        editterGrid.livingColor = UIColor(red: 0/255, green: 222/255, blue:255/255, alpha: 1)
        editterGrid.diedColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.5)
        editterGrid.bornColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        editterGrid.setNeedsDisplay()
    }
    
    func blue(notification:NSNotification){
        blueChangeColor()
    }
    func blueChangeColor(){
        editterGrid.livingColor = UIColor(red: 0/255, green: 125/255, blue:222.255, alpha: 1)
        editterGrid.diedColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.6)
        editterGrid.setNeedsDisplay()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
}
