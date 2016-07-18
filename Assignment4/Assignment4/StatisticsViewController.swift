//
//  StatisticsViewController.swift
//  Assignment4
//
//  Created by Ken Zhang on 7/12/16.
//  Copyright © 2016 Ken Zhang. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    var livingCellCounter = 0
    var diedCellCounter = 0
    var bornCellCounter = 0
    var emptyCellCounter = 0
    
    @IBOutlet weak var diedCells: UITextField!
    @IBOutlet weak var livingCells: UITextField!
    @IBOutlet weak var bornCells: UITextField!
    @IBOutlet weak var emptyCells: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let s = #selector(StatisticsViewController.watchForNotifications(_:))
        let c = NSNotificationCenter.defaultCenter()
        c.addObserver(self, selector: s, name: "setEngineStaticsNotification", object: nil)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func watchForNotifications(notification:NSNotification){
        
        let grid = notification.userInfo!["value"] as! GridProtocol
        let cols = grid.cols
        let rows = grid.rows
        
        
        
        for x in 0..<rows{
            for y in 0..<cols{
                switch grid[x, y]{
                case .Living?: livingCellCounter += 1
                case .Died?: diedCellCounter += 1
                case .Born?: bornCellCounter += 1
                case .Empty?: emptyCellCounter += 1
                default: break
                }
            }
        }
        
        //change the texts to the modified numbers
        diedCells.text = String(diedCellCounter)
        livingCells.text = String(livingCellCounter)
        bornCells.text = String(bornCellCounter)
        emptyCells.text = String(emptyCellCounter)
        
        //clear date after one round
        diedCellCounter = 0
        livingCellCounter = 0
        emptyCellCounter = 0
        bornCellCounter = 0
    }
}
