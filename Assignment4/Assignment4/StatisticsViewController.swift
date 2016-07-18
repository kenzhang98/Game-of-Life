//
//  StatisticsViewController.swift
//  Assignment4
//
//  Created by Ken Zhang on 7/12/16.
//  Copyright © 2016 Ken Zhang. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let s = #selector(StatisticsViewController.watchForNotifications(_:))
        let c = NSNotificationCenter.defaultCenter()
        c.addObserver(self, selector: s, name: "setEngineStaticsNotification", object: nil)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func watchForNotifications(notification:NSNotification){
        
        let grid = notification.userInfo!["value"] as! GridProtocol
        let cols = grid.cols
        let rows = grid.rows
        var livingCellCounter = 0
        var diedCellCounter = 0
        var bornCellCounter = 0
        var emptyCellCounter = 0
        
        
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
    }
}
