//
//  StatisticsViewController.swift
//  Final Project
//
//  Created by Ken Zhang on 7/26/16.
//  Copyright © 2016 Ken Zhang. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController
{
    
    var livingCellCounter = 0
    var diedCellCounter = 0
    var bornCellCounter = 0
    var emptyCellCounter = 0
    var grid: GridProtocol!
    var cols = 0
    var rows = 0
    
    @IBOutlet weak var generation: UITextField!
    @IBOutlet weak var diedCells: UITextField!
    @IBOutlet weak var livingCells: UITextField!
    @IBOutlet weak var bornCells: UITextField!
    @IBOutlet weak var emptyCells: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //clear the counters before the calculation
        diedCellCounter = 0
        livingCellCounter = 0
        emptyCellCounter = 0
        bornCellCounter = 0
        
        //call the calculation to show the data
        statisticsDataCalculation()
        
        let s = #selector(StatisticsViewController.watchForNotifications(_:))
        let c = NSNotificationCenter.defaultCenter()
        c.addObserver(self, selector: s, name: "setEngineStatisticsNotification", object: nil)
        
        diedCells.text = String(diedCellCounter)
        livingCells.text = String(livingCellCounter)
        bornCells.text = String(bornCellCounter)
        emptyCells.text = String(emptyCellCounter)
        generation.text = String(StandardEngine.sharedInstance.generation)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func watchForNotifications(notification:NSNotification){
        
        //clear date after one round
        diedCellCounter = 0
        livingCellCounter = 0
        emptyCellCounter = 0
        bornCellCounter = 0
        
        statisticsDataCalculation()
        
        //change the texts to the modified numbers
        diedCells.text = String(diedCellCounter)
        livingCells.text = String(livingCellCounter)
        bornCells.text = String(bornCellCounter)
        emptyCells.text = String(emptyCellCounter)
        generation.text = String(StandardEngine.sharedInstance.generation)
        
        
    }
    
    func statisticsDataCalculation(){
        grid = StandardEngine.sharedInstance.grid
        rows = grid.rows
        cols = grid.cols
        for x in 0..<rows{
            for y in 0..<cols{
                switch grid[(x,y)]{
                case .Alive: livingCellCounter += 1
                case .Died: diedCellCounter += 1
                case .Born: bornCellCounter += 1
                case .Empty: emptyCellCounter += 1
                }
            }
        }
        
        //change the texts to the modified numbers
        diedCells.text = String(diedCellCounter)
        livingCells.text = String(livingCellCounter)
        bornCells.text = String(bornCellCounter)
        emptyCells.text = String(emptyCellCounter)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
}
