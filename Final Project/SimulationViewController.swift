//
//  SimulationViewController.swift
//  Final Project
//
//  Created by Ken Zhang on 7/26/16.
//  Copyright © 2016 Ken Zhang. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, EngineDelegateProtocol {
    private var inputTextField: UITextField?
    weak var AddAlertSaveAction: UIAlertAction?
    
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
    
    override func viewDidAppear(animated: Bool) {
        if StandardEngine.sharedInstance.isPaused{
            pauseAndContinueButoon.setImage(UIImage(named: "Play.png"), forState: UIControlState.Normal)
        }else{
            pauseAndContinueButoon.setImage(UIImage(named: "Pause.png"), forState: UIControlState.Normal)
        }
        
        switch StandardEngine.sharedInstance.colorSelected{
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
        let rows = StandardEngine.sharedInstance.grid.rows
        let cols = StandardEngine.sharedInstance.grid.cols
        StandardEngine.sharedInstance.grid = Grid(rows,cols, cellInitializer: {_ in .Empty})
        if let delegate = StandardEngine.sharedInstance.delegate {
            delegate.engineDidUpdate(StandardEngine.sharedInstance.grid)
        }
        NSNotificationCenter.defaultCenter().postNotificationName("setEngineStaticsNotification", object: nil, userInfo: nil)
    }
    @IBOutlet weak var grid: GridView!
    
    @IBAction func run(sender: AnyObject) {
        StandardEngine.sharedInstance.grid = StandardEngine.sharedInstance.step()
        NSNotificationCenter.defaultCenter().postNotificationName("setEngineStaticsNotification", object: nil, userInfo: nil)
  
    }
    
    
    func engineDidUpdate(withGrid: GridProtocol) {
        grid.setNeedsDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        StandardEngine.sharedInstance.delegate = self
        xGreen.hidden = false
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


