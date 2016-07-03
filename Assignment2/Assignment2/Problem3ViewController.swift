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
        textView.text = "Button in Problem3ViewController was clicked"
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
