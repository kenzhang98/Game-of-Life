//
//  InstrumentationViewController.swift
//  Final Project
//
//  Created by Ken Zhang on 7/26/16.
//  Copyright © 2016 Ken Zhang. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController {
    
    //declare the UI elements and actions
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBAction func reloadButton(sender: AnyObject) {
        
        //download and parse the JSON file and then update the table view
        //clear date
        TableViewController.sharedTable.names = []
        TableViewController.sharedTable.gridContent = []
        TableViewController.sharedTable.comments = []
        TableViewController.sharedTable.color = []
        
        //if the user enters an invalid url, pop up an alert view
        if let url = urlTextField.text{
            guard let requestURL: NSURL = NSURL(string: url) else {
                let alertController = UIAlertController(title: "URL Error", message:
                    "Please enter a valid url!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
                //clear date
                TableViewController.sharedTable.names = []
                TableViewController.sharedTable.gridContent = []
                TableViewController.sharedTable.comments = []
                TableViewController.sharedTable.color = []
                NSNotificationCenter.defaultCenter().postNotificationName("TableViewReloadData", object: nil, userInfo: nil)
                
                return
            }
            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest) {
                (data, response, error) -> Void in
                
                let httpResponse = response as?NSHTTPURLResponse
                let statusCode = httpResponse?.statusCode
                if let safeStatusCode = statusCode{
                    if (safeStatusCode == 200) {
                        do{
                            
                            let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments) as? [AnyObject]
                            for i in 0...json!.count-1 {
                                let pattern = json![i]
                                let collection = pattern as! Dictionary<String, AnyObject>
                                TableViewController.sharedTable.names.append(collection["title"]! as! String)
                                let arr = collection["contents"].map{return $0 as! [[Int]]}
                                TableViewController.sharedTable.gridContent.append(arr!)
                            }
                            TableViewController.sharedTable.comments = TableViewController.sharedTable.names.map{_ in return ""}
                            TableViewController.sharedTable.color = TableViewController.sharedTable.names.map{_ in return "green"}
                        }catch {
                            print("Error with Json: \(error)")
                            //clear date
                            TableViewController.sharedTable.names = []
                            TableViewController.sharedTable.gridContent = []
                            TableViewController.sharedTable.comments = []
                            TableViewController.sharedTable.color = []
                            NSNotificationCenter.defaultCenter().postNotificationName("TableViewReloadData", object: nil, userInfo: nil)
                        }
                        
                        //put the table reload process into the main thread to reload it right away
                        let op = NSBlockOperation {
                            NSNotificationCenter.defaultCenter().postNotificationName("TableViewReloadData", object: nil, userInfo: nil)
                        }
                        NSOperationQueue.mainQueue().addOperation(op)
                        
                    }
                    else{
                        //put the pop up window in the main thread for HTTP errors and then pop it up
                        let op = NSBlockOperation {
                            let alertController = UIAlertController(title: "Error", message:
                                "HTTP Error \(safeStatusCode): \(NSHTTPURLResponse.localizedStringForStatusCode(safeStatusCode))           Please enter a valid url", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .Default,handler: nil))
                            
                            self.presentViewController(alertController, animated: true, completion: nil)
                            //clear date
                            TableViewController.sharedTable.names = []
                            TableViewController.sharedTable.gridContent = []
                            TableViewController.sharedTable.comments = []
                            TableViewController.sharedTable.color = []
                            NSNotificationCenter.defaultCenter().postNotificationName("TableViewReloadData", object: nil, userInfo: nil)
                        }
                        NSOperationQueue.mainQueue().addOperation(op)
                    }
                }else{
                    //put the pop up window in the main thread for url errors and then pop it up
                    let op = NSBlockOperation {
                        let alertController = UIAlertController(title: "Error", message:
                            "Please check your url or your Internet connection", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .Default,handler: nil))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                        //clear date
                        TableViewController.sharedTable.names = []
                        TableViewController.sharedTable.gridContent = []
                        TableViewController.sharedTable.comments = []
                        TableViewController.sharedTable.color = []
                        NSNotificationCenter.defaultCenter().postNotificationName("TableViewReloadData", object: nil, userInfo: nil)
                    }
                    NSOperationQueue.mainQueue().addOperation(op)
                }
            }
            task.resume()
        }
    }
    
    @IBAction func refreshTimer(sender: AnyObject) {
        StandardEngine.sharedInstance.refreshInterval = NSTimeInterval(refreshRateSlider.value)
        if refreshRateSlider.value == 0{
            timedRefreshSwitch.setOn(false, animated: true)
            StandardEngine.sharedInstance.isPaused = true
            hzLabel.text = "0 Hz"
        }else {
            timedRefreshSwitch.setOn(true, animated: true)
            StandardEngine.sharedInstance.refreshRate = refreshRateSlider.value
            StandardEngine.sharedInstance.isPaused = false
            hzLabel.text = String(format: "%.2f", refreshRateSlider.value) + "Hz"
        }
    }
    

    @IBOutlet weak var hzLabel: UILabel!
    @IBOutlet weak var rowsTextField: UITextField!
    @IBOutlet weak var rowsStepper: UIStepper!
    @IBOutlet weak var colsTextField: UITextField!
    @IBOutlet weak var colsStepper: UIStepper!
    @IBOutlet weak var refreshRateSlider: UISlider!
    @IBOutlet weak var timedRefreshSwitch: UISwitch!
    
    @IBAction func rowsTextFieldAction(sender: AnyObject) {
        StandardEngine.sharedInstance.changesDetect = true
        if let changeToRow = Int(rowsTextField.text!){
            if changeToRow > 0{
                StandardEngine.sharedInstance.rows = changeToRow
                rowsStepper.value = Double(changeToRow)
            }
            else {
                //if user enters a number smaller than 0, pop up an alert
                let alertControllerRow = UIAlertController(title: "Row Error", message:
                    "Please enter a number greater than 0 !", preferredStyle: UIAlertControllerStyle.Alert)
                alertControllerRow.addAction(UIAlertAction(title: "OK", style: .Default,handler: {(alert: UIAlertAction!) in
                    //let the row text field show the current number of row
                    self.rowsTextField.text = String(StandardEngine.sharedInstance.rows)
                }))
                
                self.presentViewController(alertControllerRow, animated: true, completion: nil)
            }
        }else {
            //if user enters a double, pop up an alert
            let alertControllerRow = UIAlertController(title: "Row Error", message:
                "Please enter an interger !", preferredStyle: UIAlertControllerStyle.Alert)
            alertControllerRow.addAction(UIAlertAction(title: "OK", style: .Default,handler: {(alert: UIAlertAction!) in
                //let the row text field show the current number of row
                self.rowsTextField.text = String(StandardEngine.sharedInstance.rows)
            }))
            
            self.presentViewController(alertControllerRow, animated: true, completion: nil)
        }
        //post notification to update the grid in the embed view
        NSNotificationCenter.defaultCenter().postNotificationName("updateGridInEmbedView", object: nil, userInfo: nil)
    }

    @IBAction func colsTextFieldAction(sender: AnyObject) {
        StandardEngine.sharedInstance.changesDetect = true
        if let changeToCol = Int(colsTextField.text!){
            if changeToCol > 0{
                StandardEngine.sharedInstance.cols = changeToCol
                colsStepper.value = Double(changeToCol)
            }
            else {
                //if user enters a number smaller than 0, pop up an alert
                let alertControllerCol = UIAlertController(title: "Column Error", message:
                    "Please enter a number greater than 0 !", preferredStyle: UIAlertControllerStyle.Alert)
                alertControllerCol.addAction(UIAlertAction(title: "OK", style: .Default,handler: {(alert: UIAlertAction!) in
                    //let the col text field show the current number of col
                    self.colsTextField.text = String(StandardEngine.sharedInstance.cols)
                }))
                
                self.presentViewController(alertControllerCol, animated: true, completion: nil)
            }
        }else {
            //if user enters a double, pop up an alert
            let alertControllerCol = UIAlertController(title: "Column Error", message:
                "Please enter an interger !", preferredStyle: UIAlertControllerStyle.Alert)
            alertControllerCol.addAction(UIAlertAction(title: "OK", style: .Default,handler: {(alert: UIAlertAction!) in
                //let the col text field show the current number of col
                self.colsTextField.text = String(StandardEngine.sharedInstance.cols)
            }))
            
            self.presentViewController(alertControllerCol, animated: true, completion: nil)
        }
        //post notification to update the grid in the embed view
        NSNotificationCenter.defaultCenter().postNotificationName("updateGridInEmbedView", object: nil, userInfo: nil)
    }
    
    @IBAction func rowsCalculation(sender: AnyObject) {
        StandardEngine.sharedInstance.changesDetect = true
        StandardEngine.sharedInstance.rows = Int(rowsStepper.value)
        rowsTextField.text = String(Int(StandardEngine.sharedInstance.rows))
        
        //create a new grid when row changes
        StandardEngine.sharedInstance.grid = Grid(StandardEngine.sharedInstance.rows, StandardEngine.sharedInstance.cols)
        
        //post notification to update the grid in the embed view
        NSNotificationCenter.defaultCenter().postNotificationName("updateGridInEmbedView", object: nil, userInfo: nil)
    }
    @IBAction func colsCalculation(sender: AnyObject) {
        StandardEngine.sharedInstance.changesDetect = true
        StandardEngine.sharedInstance.cols = Int(colsStepper.value)
        colsTextField.text = String(Int(StandardEngine.sharedInstance.cols))
        
        //create a new grid when col changes
        StandardEngine.sharedInstance.grid = Grid(StandardEngine.sharedInstance.rows, StandardEngine.sharedInstance.cols)
        
        //post notification to update the grid in the embed view
        NSNotificationCenter.defaultCenter().postNotificationName("updateGridInEmbedView", object: nil, userInfo: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timedRefreshSwitch.setOn(false, animated: true)
        
        //set up observer so that when the row and col get changed the numbers in the textfields will get updated
        let s = #selector(InstrumentationViewController.watchForNotifications(_:))
        let c = NSNotificationCenter.defaultCenter()
        c.addObserver(self, selector: s, name: "updateRowAndColText", object: nil)
        
        //set up observer which will switch the timed refresh
        let sel = #selector(InstrumentationViewController.switchTimedRefresh(_:))
        c.addObserver(self, selector: sel, name: "switchTimedRefresh", object: nil)
        
        //set up observer which will turn off the timed refresh when user segues out to the editter grid view
        let selc = #selector(InstrumentationViewController.turnOffTimedRefresh(_:))
        c.addObserver(self, selector: selc, name: "turnOffTimedRefresh", object: nil)
        
        let selct = #selector(InstrumentationViewController.changeRreshRateSliderValue(_:))
        c.addObserver(self, selector: selct, name: "changeRefreshRateSliderValue", object: nil)
        
        //set up hzLabel as the view loads
        hzLabel.text = "0 Hz"
        
        //take care of the steppers and textfields
        rowsStepper.value = Double(StandardEngine.sharedInstance.rows)
        colsStepper.value = Double(StandardEngine.sharedInstance.cols)
        rowsStepper.stepValue = 10
        colsStepper.stepValue = 10
        //set the rows and cols' minimum values to 10 to avoid the problem of not showing the grid and presenting error message
        rowsStepper.minimumValue = 10
        colsStepper.minimumValue = 10
        colsTextField.text = String(Int(StandardEngine.sharedInstance.cols))
        rowsTextField.text = String(Int(StandardEngine.sharedInstance.rows))
        
        if let delegate = StandardEngine.sharedInstance.delegate {
            delegate.engineDidUpdate(StandardEngine.sharedInstance.grid)
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("setEngineStaticsNotification", object: nil, userInfo: nil)
        
    }
    
    func watchForNotifications(notification:NSNotification){
        rowsStepper.value = Double(StandardEngine.sharedInstance.rows)
        colsStepper.value = Double(StandardEngine.sharedInstance.cols)
        colsTextField.text = String(Int(StandardEngine.sharedInstance.cols))
        rowsTextField.text = String(Int(StandardEngine.sharedInstance.rows))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func swtich(sender: UISwitch) {
        if sender.on{
            if refreshRateSlider.value == 0{
                refreshRateSlider.value = 5.0
            }
            hzLabel.text = String(format: "%.2f", refreshRateSlider.value) + "Hz"
            StandardEngine.sharedInstance.refreshInterval = NSTimeInterval(refreshRateSlider.value)
            StandardEngine.sharedInstance.refreshRate = refreshRateSlider.value
            StandardEngine.sharedInstance.isPaused = false
        }
        else{
            StandardEngine.sharedInstance.refreshTimer?.invalidate()
            StandardEngine.sharedInstance.isPaused = true
        }
    }
    
    func switchTimedRefresh(notification:NSNotification){
        if timedRefreshSwitch.on{
            StandardEngine.sharedInstance.refreshTimer?.invalidate()
            timedRefreshSwitch.setOn(false, animated: true)
            StandardEngine.sharedInstance.isPaused = true
        }
        else{
            timedRefreshSwitch.setOn(true, animated: true)
            StandardEngine.sharedInstance.isPaused = false
        }
    }
    
    func turnOffTimedRefresh(notification:NSNotification){
        if timedRefreshSwitch.on{
            StandardEngine.sharedInstance.refreshTimer?.invalidate()
            timedRefreshSwitch.setOn(false, animated: true)
            StandardEngine.sharedInstance.isPaused = true
        }
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func changeRreshRateSliderValue(notification:NSNotification) {
        refreshRateSlider.value =  5.0
        StandardEngine.sharedInstance.refreshInterval = NSTimeInterval(refreshRateSlider.value)
        StandardEngine.sharedInstance.refreshRate = 5.0
        StandardEngine.sharedInstance.isPaused = false
        hzLabel.text = String(format: "%.2f", refreshRateSlider.value) + "Hz"
        NSNotificationCenter.defaultCenter().postNotificationName("setEngineStaticsNotification", object: nil, userInfo: nil)
    }

}
