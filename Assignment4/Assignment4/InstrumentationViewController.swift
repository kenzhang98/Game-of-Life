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
//        StandardEngine.refreshInterval
    }
    @IBOutlet weak var rowsTextField: UITextField!
    @IBOutlet weak var rowsStepper: UIStepper!
    @IBOutlet weak var colsTextField: UITextField!
    @IBOutlet weak var colsStepper: UIStepper!
    @IBOutlet weak var refreshRateSlider: UISlider!
    @IBOutlet weak var timedRefreshSwitch: UISwitch!
    @IBAction func rowsCalculation(sender: AnyObject) {
        rowsTextField.text = String(Int(rowsStepper.value))
    }
    @IBAction func colsCalculation(sender: AnyObject) {
        colsTextField.text = String(Int(colsStepper.value))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //take care of the steppers and textfields
        rowsStepper.stepValue = 10
        rowsStepper.minimumValue = 0
        colsStepper.stepValue = 10
        colsStepper.minimumValue = 0
        colsTextField.text = String(Int(colsStepper.value))
        rowsTextField.text = String(Int(rowsStepper.value))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

