//
//  Problem3ViewController.swift
//  Assignment2
//
//  Created by Ken Zhang on 6/29/16.
//  Copyright © 2016 Ken Zhang. All rights reserved.
//

import UIKit

class Problem3ViewController: UIViewController {
    @IBAction func buttonClick(sender: AnyObject) {
        print("Button in Probleme3ViewController was clicked")
        var beforeLivingCellsCounter = 0
        var afterLivingCellsCounter = 0
        var before  = [[Bool]](count: size, repeatedValue: [Bool](count: size, repeatedValue: false))
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
        
        let after = step(before)
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
        self.title = "Problem 3"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
