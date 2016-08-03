//
//  SimulationViewController.swift
//  Final Project
//
//  Created by Ken Zhang on 7/26/16.
//  Copyright © 2016 Ken Zhang. All rights reserved.
//

import UIKit
//import GameplayKit to use its shuffle function
import GameplayKit


class SimulationViewController: UIViewController, EngineDelegateProtocol {
    private var inputTextField: UITextField?
    weak var AddAlertSaveAction: UIAlertAction?
    weak var AddAlertOkAction: UIAlertAction?
    @IBOutlet weak var warning: UILabel!
    //set up the labels to show which style is selected
    @IBOutlet weak var xRed: UILabel!
    @IBOutlet weak var xOrange: UILabel!
    @IBOutlet weak var xGreen: UILabel!
    @IBOutlet weak var xCyan: UILabel!
    @IBOutlet weak var xBlue: UILabel!
    
    //set up button to change the style of the cells
    @IBAction func red(sender: AnyObject)
    {
        grid.livingColor = UIColor(red: 231/255, green: 0, blue:0, alpha: 1)
        if let delegate = StandardEngine.sharedInstance.delegate {
            delegate.engineDidUpdate(StandardEngine.sharedInstance.grid)
        }
        
        //post notification to update the grid in the embed view
        NSNotificationCenter.defaultCenter().postNotificationName("red", object: nil, userInfo: nil)
        xRed.hidden = false
        xOrange.hidden = true
        xGreen.hidden = true
        xCyan.hidden = true
        xBlue.hidden = true
        
        StandardEngine.sharedInstance.color = "red"
        StandardEngine.sharedInstance.changesDetect = true
        
    }
    @IBAction func orange(sender: AnyObject)
    {
        grid.livingColor = UIColor(red: 255/255, green: 150/255, blue:0, alpha: 1)
        grid.diedColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.3)
        if let delegate = StandardEngine.sharedInstance.delegate {
            delegate.engineDidUpdate(StandardEngine.sharedInstance.grid)
        }
        
        //post notification to update the grid in the embed view
        NSNotificationCenter.defaultCenter().postNotificationName("orange", object: nil, userInfo: nil)
        
        xRed.hidden = true
        xOrange.hidden = false
        xGreen.hidden = true
        xCyan.hidden = true
        xBlue.hidden = true
        
        StandardEngine.sharedInstance.color = "orange"
        StandardEngine.sharedInstance.changesDetect = true
    }
    @IBAction func green(sender: AnyObject)
    {
        grid.livingColor = UIColor(red: 0/255, green: 239/255, blue:22/255, alpha: 1)
        grid.diedColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.4)
        grid.bornColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        if let delegate = StandardEngine.sharedInstance.delegate {
            delegate.engineDidUpdate(StandardEngine.sharedInstance.grid)
        }
        
        //post notification to update the grid in the embed view
        NSNotificationCenter.defaultCenter().postNotificationName("green", object: nil, userInfo: nil)
        
        xRed.hidden = true
        xOrange.hidden = true
        xGreen.hidden = false
        xCyan.hidden = true
        xBlue.hidden = true
        
        StandardEngine.sharedInstance.color = "green"
        StandardEngine.sharedInstance.changesDetect = true
    }
    @IBAction func cyan(sender: AnyObject)
    {
        grid.livingColor = UIColor(red: 0/255, green: 222/255, blue:255/255, alpha: 1)
        grid.diedColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.5)
        grid.bornColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        if let delegate = StandardEngine.sharedInstance.delegate {
            delegate.engineDidUpdate(StandardEngine.sharedInstance.grid)
        }
        
        //post notification to update the grid in the embed view
        NSNotificationCenter.defaultCenter().postNotificationName("cyan", object: nil, userInfo: nil)
        
        xRed.hidden = true
        xOrange.hidden = true
        xGreen.hidden = true
        xCyan.hidden = false
        xBlue.hidden = true
        
        StandardEngine.sharedInstance.color = "cyan"
        StandardEngine.sharedInstance.changesDetect = true
    }
    @IBAction func blue(sender: AnyObject)
    {
        grid.livingColor = UIColor(red: 0/255, green: 125/255, blue:222.255, alpha: 1)
        grid.diedColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.6)
        if let delegate = StandardEngine.sharedInstance.delegate {
            delegate.engineDidUpdate(StandardEngine.sharedInstance.grid)
        }
        
        //post notification to update the grid in the embed view
        NSNotificationCenter.defaultCenter().postNotificationName("blue", object: nil, userInfo: nil)
        
        xRed.hidden = true
        xOrange.hidden = true
        xGreen.hidden = true
        xCyan.hidden = true
        xBlue.hidden = false
        
        StandardEngine.sharedInstance.color = "blue"
        StandardEngine.sharedInstance.changesDetect = true
    }
    
    @IBOutlet weak var pauseAndContinueButoon: UIButton!
    @IBAction func pauseAndContinue(sender: AnyObject) {
        StandardEngine.sharedInstance.isPaused = !StandardEngine.sharedInstance.isPaused
        if StandardEngine.sharedInstance.isPaused{
            StandardEngine.sharedInstance.refreshTimer?.invalidate()
            pauseAndContinueButoon.setImage(UIImage(named: "Play.png"), forState: UIControlState.Normal)
            NSNotificationCenter.defaultCenter().postNotificationName("switchTimedRefresh", object: nil, userInfo: nil)
        }else{
            StandardEngine.sharedInstance.refreshInterval = NSTimeInterval(StandardEngine.sharedInstance.refreshRate)
            if let delegate = StandardEngine.sharedInstance.delegate {
                delegate.engineDidUpdate(StandardEngine.sharedInstance.grid)
            }
            pauseAndContinueButoon.setImage(UIImage(named: "Pause.png"), forState: UIControlState.Normal)
            NSNotificationCenter.defaultCenter().postNotificationName("switchTimedRefresh", object: nil, userInfo: nil)
            
            if StandardEngine.sharedInstance.refreshInterval == 0{
                NSNotificationCenter.defaultCenter().postNotificationName("changeRefreshRateSliderValue", object: nil, userInfo: nil)
            }
        }
    }
    
    @IBAction func randomizeAction(sender: AnyObject) {
        //stop the grid from changing while still in the randomize view
        StandardEngine.sharedInstance.refreshTimer?.invalidate()
        
        let rows = StandardEngine.sharedInstance.grid.rows
        let cols = StandardEngine.sharedInstance.grid.cols
        NSNotificationCenter.defaultCenter().postNotificationName("setEngineStatisticsNotification", object: nil, userInfo: nil)
        
        //pop up an uialertview
        let alert = UIAlertController(title: "Randomization", message: "Please enter the numer of living cells to randomize the grid", preferredStyle: UIAlertControllerStyle.Alert)
        
        //set up the function to remove the observer
        func removeTextFieldObserver() {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidChangeNotification, object: alert.textFields![0])
        }
        
        //add cancel button action
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {(action) -> Void in
            
            if !StandardEngine.sharedInstance.isPaused{
                StandardEngine.sharedInstance.refreshInterval = NSTimeInterval(StandardEngine.sharedInstance.refreshRate)
            }
            if let delegate = StandardEngine.sharedInstance.delegate {
                delegate.engineDidUpdate(StandardEngine.sharedInstance.grid)
            }
            
        }))
        
        //set up save button actino to use later
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(action) -> Void in
            
            StandardEngine.sharedInstance.generation = 0
            NSNotificationCenter.defaultCenter().postNotificationName("setEngineStatisticsNotification", object: nil, userInfo: nil)
            
            //clear the grid
            StandardEngine.sharedInstance.grid = Grid(StandardEngine.sharedInstance.grid.rows,StandardEngine.sharedInstance.grid.cols, cellInitializer: {_ in .Empty})
            if let delegate = StandardEngine.sharedInstance.delegate {
                delegate.engineDidUpdate(StandardEngine.sharedInstance.grid)
            }
            
            if let text = self.inputTextField!.text{
                if let number = Int(text){
                    let row = StandardEngine.sharedInstance.rows
                    let col = StandardEngine.sharedInstance.cols
                    //create a shuffled array
                    var shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray([Int](0...row*col-1))
                    
                    for _ in 1...number{
                        let random = shuffled[0] as! Int
                        let xCo = random / row
                        let yCo = random % col
                        StandardEngine.sharedInstance.grid[xCo, yCo] = CellState.toggle(StandardEngine.sharedInstance.grid[xCo, yCo])
                        shuffled.removeFirst()
                    }
                }
            }
            NSNotificationCenter.defaultCenter().postNotificationName("setEngineStatisticsNotification", object: nil, userInfo: nil)
            if !StandardEngine.sharedInstance.isPaused{
                StandardEngine.sharedInstance.refreshInterval = NSTimeInterval(StandardEngine.sharedInstance.refreshRate)
            }
            if let delegate = StandardEngine.sharedInstance.delegate {
                delegate.engineDidUpdate(StandardEngine.sharedInstance.grid)
            }
            
        })
        
        //disable the save button initially unless the user enters any text
        okAction.enabled = false
        
        AddAlertOkAction = okAction
        
        //add save button
        alert.addAction(okAction)
        
        //add a text field for user to enter name for the row
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "(From 1 to \(rows*cols))"
            self.inputTextField = textField
            //add observer
            let sel = #selector(self.handleLivingCellsTextFieldNotification(_:))
            NSNotificationCenter.defaultCenter().addObserver(self, selector: sel, name: UITextFieldTextDidChangeNotification, object: textField)
        })
        
        //pop up the alert view
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleLivingCellsTextFieldNotification(notification: NSNotification) {
        let textField = notification.object as! UITextField
        
        if let text = textField.text{
            if let number = Int(text){
                if number <= StandardEngine.sharedInstance.rows * StandardEngine.sharedInstance.cols && number != 0{
                    AddAlertOkAction!.enabled = true
                }else{
                    AddAlertOkAction!.enabled = false
                }
            }else{
                AddAlertOkAction!.enabled = false
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if StandardEngine.sharedInstance.isPaused{
            pauseAndContinueButoon.setImage(UIImage(named: "Play.png"), forState: UIControlState.Normal)
        }else{
            pauseAndContinueButoon.setImage(UIImage(named: "Pause.png"), forState: UIControlState.Normal)
        }
        
        switch StandardEngine.sharedInstance.colorSelected{
        case "red":
            redChangeColor()
            xRed.hidden = false
            xOrange.hidden = true
            xGreen.hidden = true
            xCyan.hidden = true
            xBlue.hidden = true
        case "orange":
            orangeChangeColor()
            xRed.hidden = true
            xOrange.hidden = false
            xGreen.hidden = true
            xCyan.hidden = true
            xBlue.hidden = true
        case "green":
            greenChangeColor()
            xRed.hidden = true
            xOrange.hidden = true
            xGreen.hidden = false
            xCyan.hidden = true
            xBlue.hidden = true
        case "cyan":
            cyanChangeColor()
            xRed.hidden = true
            xOrange.hidden = true
            xGreen.hidden = true
            xCyan.hidden = false
            xBlue.hidden = true
        case "blue":
            blueChangeColor()
            xRed.hidden = true
            xOrange.hidden = true
            xGreen.hidden = true
            xCyan.hidden = true
            xBlue.hidden = false
        default:
            greenChangeColor()
            xRed.hidden = true
            xOrange.hidden = true
            xGreen.hidden = false
            xCyan.hidden = true
            xBlue.hidden = true
        }
        
        switch(StandardEngine.sharedInstance.shape){
            case "Triangle":
                shapeLabel.text = "Triangle"
                shapeValue.value = 0.5
        case "Square":
            shapeLabel.text = "Square"
            shapeValue.value = 1.5
        case "Pentagon":
            shapeLabel.text = "Pentagon"
            shapeValue.value = 2.5
        case "Hexagon":
            shapeLabel.text = "Hexagon"
            shapeValue.value = 3.5
        case "Heptagon":
            shapeLabel.text = "Heptagon"
            shapeValue.value = 4.5
        case "Octagon":
            shapeLabel.text = "Octagon"
            shapeValue.value = 5.5
        case "Nanogon":
            shapeLabel.text = "Nanogon"
            shapeValue.value = 6.5
        case "Decagon":
            shapeLabel.text = "Decagon"
            shapeValue.value = 7.5
        case "Circle":
            shapeLabel.text = "Circle"
            shapeValue.value = 8.5
        default:
            shapeLabel.text = "Circle"
            shapeValue.value = 8.5
        }
    }
    
    @IBAction func Save(sender: AnyObject) {
        
        //stop the grid from changing while still in the save view
        StandardEngine.sharedInstance.refreshTimer?.invalidate()
        
        
        let alert = UIAlertController(title: "Save", message: "Please enter a name to save the current grid", preferredStyle: UIAlertControllerStyle.Alert)
        
        //set up the function to remove the observer
        func removeTextFieldObserver() {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidChangeNotification, object: alert.textFields![0])
        }
        
        //add cancel button action
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {(action) -> Void in
            removeTextFieldObserver()
            
            if !StandardEngine.sharedInstance.isPaused{
                StandardEngine.sharedInstance.refreshInterval = NSTimeInterval(StandardEngine.sharedInstance.refreshRate)
            }
            if let delegate = StandardEngine.sharedInstance.delegate {
                delegate.engineDidUpdate(StandardEngine.sharedInstance.grid)
            }
            
        }))
        
        //set up save button actino to use later
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: {(action) -> Void in
            if let text = self.inputTextField!.text{
                TableViewController.sharedTable.names.append(text)
                TableViewController.sharedTable.comments.append("")
                TableViewController.sharedTable.color.append(StandardEngine.sharedInstance.color)
                TableViewController.sharedTable.shape.append(StandardEngine.sharedInstance.shape)
                
                
                if let point = GridView().points{
                    var medium:[[Int]] = []
                    _ = point.map{ medium.append([$0.0, $0.1]) }
                    TableViewController.sharedTable.gridContent.append(medium)
                }
                
                let itemRow = TableViewController.sharedTable.names.count - 1
                let itemPath = NSIndexPath(forRow:itemRow, inSection: 0)
                TableViewController().tableView.insertRowsAtIndexPaths([itemPath], withRowAnimation: .Automatic)
                NSNotificationCenter.defaultCenter().postNotificationName("TableViewReloadData", object: nil, userInfo: nil)
            }
            removeTextFieldObserver()
            
            if !StandardEngine.sharedInstance.isPaused{
                StandardEngine.sharedInstance.refreshInterval = NSTimeInterval(StandardEngine.sharedInstance.refreshRate)
            }
            if let delegate = StandardEngine.sharedInstance.delegate {
                delegate.engineDidUpdate(StandardEngine.sharedInstance.grid)
            }
            
        })
        
        //disable the save button initially unless the user enters any text
        saveAction.enabled = false
        
        AddAlertSaveAction = saveAction
        
        //add save button
        alert.addAction(saveAction)
        
        //add a text field for user to enter name for the row
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Enter name:"
            self.inputTextField = textField
            //add observer
            let sel = #selector(self.handleTextFieldTextDidChangeNotification(_:))
            NSNotificationCenter.defaultCenter().addObserver(self, selector: sel, name: UITextFieldTextDidChangeNotification, object: textField)
        })
        
        //pop up the alert view
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //set up the handler to enable the save button when the user enters any text for the name
    func handleTextFieldTextDidChangeNotification(notification: NSNotification) {
        let textField = notification.object as! UITextField
        
        // Enforce a minimum length of >= 1 for secure text alerts.
        if let text = textField.text{
            AddAlertSaveAction!.enabled = text.characters.count >= 1
        }
    }
    
    @IBAction func Reset(sender: AnyObject) {
        StandardEngine.sharedInstance.undoCells = []
        StandardEngine.sharedInstance.redoCells = []
        let rows = StandardEngine.sharedInstance.grid.rows
        let cols = StandardEngine.sharedInstance.grid.cols
        StandardEngine.sharedInstance.grid = Grid(rows,cols, cellInitializer: {_ in .Empty})
        if let delegate = StandardEngine.sharedInstance.delegate {
            delegate.engineDidUpdate(StandardEngine.sharedInstance.grid)
        }
        
        StandardEngine.sharedInstance.generation = 0
        NSNotificationCenter.defaultCenter().postNotificationName("setEngineStatisticsNotification", object: nil, userInfo: nil)
    }
    @IBOutlet weak var grid: GridView!
    
    @IBAction func run(sender: AnyObject) {
        StandardEngine.sharedInstance.grid = StandardEngine.sharedInstance.step()
        NSNotificationCenter.defaultCenter().postNotificationName("setEngineStatisticsNotification", object: nil, userInfo: nil)
  
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
            grid.setNeedsDisplay()
            
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
            grid.setNeedsDisplay()
            
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
    
    @IBOutlet weak var shapeLabel: UILabel!
    @IBOutlet weak var shapeValue: UISlider!
    @IBAction func shapeAction(sender: AnyObject) {
        StandardEngine.sharedInstance.changesDetect = true
        switch (Int(floor(shapeValue.value))){
        case 0:
            shapeLabel.text = "Triangle"
            StandardEngine.sharedInstance.shape = "Triangle"
            if let delegate = StandardEngine.sharedInstance.delegate {
                delegate.engineDidUpdate(StandardEngine.sharedInstance.grid)
            }
            grid.setNeedsDisplay()
            
            let op = NSBlockOperation {
                
            }
            NSOperationQueue.mainQueue().addOperation(op)
        case 1:
            shapeLabel.text = "Square"
            StandardEngine.sharedInstance.shape = "Square"
            grid.setNeedsDisplay()
        case 2:
            shapeLabel.text = "Pentagon"
            StandardEngine.sharedInstance.shape = "Pentagon"
            grid.setNeedsDisplay()
        case 3:
            shapeLabel.text = "Hexagon"
            StandardEngine.sharedInstance.shape = "Hexagon"
            grid.setNeedsDisplay()
        case 4:
            shapeLabel.text = "Heptagon"
            StandardEngine.sharedInstance.shape = "Heptagon"
            grid.setNeedsDisplay()
        case 5:
            shapeLabel.text = "Octagon"
            StandardEngine.sharedInstance.shape = "Octagon"
            grid.setNeedsDisplay()
        case 6:
            shapeLabel.text = "Nanogon"
            StandardEngine.sharedInstance.shape = "Nanogon"
            grid.setNeedsDisplay()
        case 7:
            shapeLabel.text = "Decagon"
            StandardEngine.sharedInstance.shape = "Decagon"
            grid.setNeedsDisplay()
        case 8:
            shapeLabel.text = "Circle"
            StandardEngine.sharedInstance.shape = "Circle"
            grid.setNeedsDisplay()
        default:
            shapeLabel.text = "Circle"
            StandardEngine.sharedInstance.shape = "Circle"
            grid.setNeedsDisplay()
        }
    }
    
    func engineDidUpdate(withGrid: GridProtocol) {
        grid.setNeedsDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        StandardEngine.sharedInstance.delegate = self
    }
    

    func redChangeColor(){
        grid.livingColor = UIColor(red: 231/255, green: 0, blue:0, alpha: 1)
        grid.setNeedsDisplay()
    }
    

    func orangeChangeColor(){
        grid.livingColor = UIColor(red: 255/255, green: 150/255, blue:0, alpha: 1)
        grid.diedColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.3)
        grid.setNeedsDisplay()
    }
    

    func greenChangeColor(){
        grid.livingColor = UIColor(red: 0/255, green: 239/255, blue:22/255, alpha: 1)
        grid.diedColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.4)
        grid.bornColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        grid.setNeedsDisplay()
    }
    

    func cyanChangeColor(){
        grid.livingColor = UIColor(red: 0/255, green: 222/255, blue:255/255, alpha: 1)
        grid.diedColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.5)
        grid.bornColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        grid.setNeedsDisplay()
    }
    

    func blueChangeColor(){
        grid.livingColor = UIColor(red: 0/255, green: 125/255, blue:222.255, alpha: 1)
        grid.diedColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.6)
        grid.setNeedsDisplay()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


