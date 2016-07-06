//
//  Problem2ViewController.swift
//  Assignment2
//
//  Created by Ken Zhang on 6/29/16.
//  Copyright © 2016 Ken Zhang. All rights reserved.
//

import UIKit

class Problem2ViewController: UIViewController {
    @IBAction func buttonClick(sender: AnyObject) {
        print("Button in Problem2ViewController was clicked")
        
        let size = 10
        let counter = [-1,0,1]
        var beforeLivingCellsCounter = 0
        var afterLivingCellsCounter = 0
        var livingNeighbors = 0
        var before  = [[Bool]](count: size, repeatedValue: [Bool](count: size, repeatedValue: false))
        var after  = [[Bool]](count: size, repeatedValue: [Bool](count: size, repeatedValue: false))
        
        var xCo = 0
        var yCo = 0
        
        //create a random array
        for x in 0 ..< before.count {
            for y in 0 ..< before[x].count{
                if arc4random_uniform(3) == 1 {
                    // set current cell to alive
                    before[x][y] = true
                    beforeLivingCellsCounter += 1
                }
            }
        }
        
        for x in 0 ..< before.count {
            for y in 0 ..< before[x].count{
                
                for items in counter{
                    
                    switch x+items{
                    case -1: xCo = size - 1
                    for items in counter{
                        switch y+items{
                        case -1: yCo = size - 1
                        case size: yCo = 0
                        default: yCo = y+items
                        }
                        if xCo != x || yCo != y{
                            switch before[xCo][yCo]{
                            case true: livingNeighbors += 1
                            default: livingNeighbors += 0
                            }
                        }
                        
                        
                        }
                    case size: xCo = 0
                    for items in counter{
                        switch y+items{
                        case -1: yCo = size - 1
                        case size: yCo = 0
                        default: yCo = y+items
                        }
                        if xCo != x || yCo != y{
                            switch before[xCo][yCo]{
                            case true: livingNeighbors += 1
                            default: livingNeighbors += 0
                            }
                        }
                        }
                    default: xCo = x+items
                    for items in counter{
                        switch y+items{
                        case -1: yCo = size - 1
                        case size: yCo = 0
                        default: yCo = y+items
                        }
                        if xCo != x || yCo != y{
                            switch before[xCo][yCo]{
                            case true: livingNeighbors += 1
                            default: livingNeighbors += 0
                            }
                        }
                        }
                    }
                }
                
                if livingNeighbors < 2{
                    after[x][y] = false
                }
                if before[x][y] == true && livingNeighbors == 2 || livingNeighbors == 3{
                    after[x][y] = true
                }
                if livingNeighbors > 3{
                    after[x][y] = false
                }
                if before[x][y] == false && livingNeighbors == 3{
                    after[x][y] = true
                }
                
                //clear the counter for the next cell
                livingNeighbors = 0
            }
        }
        
        //get the number of living cells in the next round
        for x in 0 ..< after.count {
            for y in 0 ..< after[x].count{
                if after[x][y] == true{
                    afterLivingCellsCounter += 1
                }
            }
        }

        textView.text = "Before living cells: \(beforeLivingCellsCounter) \nAfter living cells: \(afterLivingCellsCounter)"


    }
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Problem 2"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
