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
        TableViewController.sharedTable.names = []
        TableViewController.sharedTable.gridContent = []
        
        if let url = urlTextField.text{
            let requestURL: NSURL = NSURL(string: url)!
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
                        }catch {
                            print("Error with Json: \(error)")
                        }
                        NSNotificationCenter.defaultCenter().postNotificationName("TableViewReloadData", object: nil, userInfo: nil)
                        
                    }
                    else{
                        let op = NSBlockOperation {
                            let alertController = UIAlertController(title: "Error", message:
                                "HTTP Error \(safeStatusCode): \(NSHTTPURLResponse.localizedStringForStatusCode(safeStatusCode))", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                            
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                        NSOperationQueue.mainQueue().addOperation(op)
                    }
                }else{
                    //put the pop up window in the main thread and then pop it up
                    let op = NSBlockOperation {
                        let alertController = UIAlertController(title: "Error", message:
                            "Please put in a correct url", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                    NSOperationQueue.mainQueue().addOperation(op)
                }
            }
            task.resume()
            
        }
        
    }
    
    @IBAction func refreshTimer(sender: AnyObject) {
        StandardEngine.sharedInstance.refreshInterval = NSTimeInterval(refreshRateSlider.value)
        hzLabel.text = String(format: "%.2f", refreshRateSlider.value) + "Hz"
        timedRefreshSwitch.setOn(true, animated: true)
    }
    

    @IBOutlet weak var hzLabel: UILabel!
    @IBOutlet weak var rowsTextField: UITextField!
    @IBOutlet weak var rowsStepper: UIStepper!
    @IBOutlet weak var colsTextField: UITextField!
    @IBOutlet weak var colsStepper: UIStepper!
    @IBOutlet weak var refreshRateSlider: UISlider!
    @IBOutlet weak var timedRefreshSwitch: UISwitch!
    
    @IBAction func rowsCalculation(sender: AnyObject) {
        
        StandardEngine.sharedInstance.rows = Int(rowsStepper.value)
        rowsTextField.text = String(Int(StandardEngine.sharedInstance.rows))
        
        //create a new grid when row changes
        StandardEngine.sharedInstance.grid = Grid(StandardEngine.sharedInstance.rows, StandardEngine.sharedInstance.cols)
        
        //post notification to update the grid in the embed view
        NSNotificationCenter.defaultCenter().postNotificationName("updateGridInEmbedView", object: nil, userInfo: nil)
    }
    @IBAction func colsCalculation(sender: AnyObject) {
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
        
        
        //set up hzLabel as the view loads
        hzLabel.text = String(format: "%.2f", refreshRateSlider.value) + "Hz"
        
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
            StandardEngine.sharedInstance.refreshInterval = NSTimeInterval(refreshRateSlider.value)
        }
        else{
            StandardEngine.sharedInstance.refreshTimer?.invalidate()
        }

    }
    
}
