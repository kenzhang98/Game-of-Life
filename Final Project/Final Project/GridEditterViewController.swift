//
//  EditViewController.swift
//  Final Project
//
//  Created by Ken Zhang on 7/27/16.
//  Copyright © 2016 Ken Zhang. All rights reserved.
//

import UIKit

class GridEditterViewController: UIViewController{
    var name:String?
    var commit: (String -> Void)?
    var anotherCommit: ([[Int]] -> Void)?
    var savedCells: [[Int]] = []
    
    @IBAction func cancelButton(sender: AnyObject) {
        navigationController!.popViewControllerAnimated(true)
    }
    @IBOutlet weak var editterGrid: GridView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func save(sender: AnyObject) {
        
        let filteredArray = StandardEngine.sharedInstance.grid.cells.filter{$0.state.isLiving()}.map{return $0.position}
        
        for i in filteredArray{
            savedCells.append([i.row, i.col])
        }
        
        guard let newText = nameTextField.text, commit = commit
            else { return }
        commit(newText)
        guard let anothercommit = anotherCommit else { return }
        anothercommit(savedCells)
        
        navigationController!.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = name
        
        //set up the observer which updates the grid in the embed view when gets called
        let s = #selector(GridEditterViewController.watchForNotifications(_:))
        let c = NSNotificationCenter.defaultCenter()
        c.addObserver(self, selector: s, name: "updateGridInEmbedView", object: nil)
    }
    
    func watchForNotifications(notification:NSNotification){
        editterGrid.setNeedsDisplay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
