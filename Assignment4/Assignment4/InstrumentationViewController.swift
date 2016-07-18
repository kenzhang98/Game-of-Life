//
//  FirstViewController.swift
//  Assignment4
//
//  Created by Ken Zhang on 7/12/16.
//  Copyright © 2016 Ken Zhang. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController {

    //declare the UI elements and actions

    @IBAction func refreshTimer(sender: AnyObject) {
        StandardEngine.sharedInstance.refreshInterval = NSTimeInterval(refreshRateSlider.value)
    }
    
    @IBOutlet weak var rowsTextField: UITextField!
    @IBOutlet weak var rowsStepper: UIStepper!
    @IBOutlet weak var colsTextField: UITextField!
    @IBOutlet weak var colsStepper: UIStepper!
    @IBOutlet weak var refreshRateSlider: UISlider!
    @IBOutlet weak var timedRefreshSwitch: UISwitch!
    
    @IBAction func rowsCalculation(sender: AnyObject) {
        StandardEngine.sharedInstance.rows = Int(rowsStepper.value)
        rowsTextField.text = String(Int(StandardEngine.sharedInstance.rows))
    }
    @IBAction func colsCalculation(sender: AnyObject) {
        StandardEngine.sharedInstance.cols = Int(colsStepper.value)
        colsTextField.text = String(Int(StandardEngine.sharedInstance.cols))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //take care of the steppers and textfields
        rowsStepper.value = Double(StandardEngine.sharedInstance.rows)
        colsStepper.value = Double(StandardEngine.sharedInstance.cols)
        rowsStepper.stepValue = 10
        rowsStepper.minimumValue = 0
        colsStepper.stepValue = 10
        colsStepper.minimumValue = 0
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

