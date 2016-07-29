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
    var comment:String?
    var commit: (String -> Void)?
    var anotherCommit: ([[Int]] -> Void)?
    var commitForComment: (String -> Void)?
    var savedCells: [[Int]] = []
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var saveComment: UIButton!
    
    @IBAction func saveComment(sender: AnyObject) {
        guard let comment = commentTextField.text, commitForComment = commitForComment
            else { return }
        commitForComment(comment)
        if commentTextField.text == ""{
            saveComment.setTitle("Empty", forState: .Normal)
        }else{
            saveComment.setTitle("Saved", forState: .Normal)
        }
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        //if the user changes the grid and hits cancel button, an alert will pop up to confirm the action
        if StandardEngine.sharedInstance.changesDetect{
            
            let alert = UIAlertController(title: "Quit Without Saving", message: "Are you sure you want to quit without saving?", preferredStyle: UIAlertControllerStyle.Alert)
            //add cancel button action
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            alert.addAction(UIAlertAction(title: "Quit", style: UIAlertActionStyle.Default, handler: {(action) -> Void in self.navigationController!.popViewControllerAnimated(true)}))
            
            let op = NSBlockOperation {
                self.presentViewController(alert, animated: true, completion: nil)
            }
            NSOperationQueue.mainQueue().addOperation(op)
        }else{
            navigationController!.popViewControllerAnimated(true)
        }
        //clear the changes detecter
        StandardEngine.sharedInstance.changesDetect = false
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
        commentTextField.text = comment
        
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
