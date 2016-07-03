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
        var beforeLivingCellsCounter = 0
        var afterLivingCellsCounter = 0
        var livingNeighbors = 0
        var before  = [[Bool]](count: size, repeatedValue: [Bool](count: size, repeatedValue: false))
        var after  = [[Bool]](count: size, repeatedValue: [Bool](count: size, repeatedValue: false))
        
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
                
                //check how many of the neighbors are alive
                
                //left top
                if before[(x+size-1)%size][(y+size-1)%size] == true{
                    livingNeighbors += 1
                }
                //top
                if before[(x+size-1)%size][y] == true{
                    livingNeighbors += 1
                }
                //right top
                if before[(x+size-1)%size][(y+1)%size] == true{
                    livingNeighbors += 1
                }
                //left
                if before[x][(y+size-1)%size] == true{
                    livingNeighbors += 1
                }
                //right
                if before[x][(y+1)%size] == true{
                    livingNeighbors += 1
                }
                //left bottom
                if before[(x+1)%size][(y+size-1)%size] == true{
                    livingNeighbors += 1
                }
                if before[(x+1)%size][y] == true{
                    livingNeighbors += 1
                }
                if before[(x+1)%size][(y+1)%size] == true{
                    livingNeighbors += 1
                }
                
                //determine the statue of the cell
                
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
        
        //get the number of livings in the next round
        for x in 0 ..< after.count {
            for y in 0 ..< after[x].count{
                if after[x][y] == true{
                    afterLivingCellsCounter += 1
                }
            }
        }

        textView.text = "The number of living cells in before is \(beforeLivingCellsCounter) and the number of living cells in after is \(afterLivingCellsCounter)"


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
