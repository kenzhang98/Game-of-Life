//
//  ViewController.swift
//  Assignment3
//
//  Created by Ken Zhang on 7/6/16.
//  Copyright © 2016 Ken Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Grid: GridView!
    @IBAction func buttonClick(sender: AnyObject) {
        let process = Button()
        Grid.grid = process.step2(Grid.rows, vertical: Grid.cols, middle: Grid.grid)
        Grid.setNeedsDisplay()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



