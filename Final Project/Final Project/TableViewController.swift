//
//  TableViewController.swift
//  Final Project
//
//  Created by Ken Zhang on 7/27/16.
//  Copyright © 2016 Ken Zhang. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var names:[String] = ["test1", "test2", "test3"]
    var gridContent: [[[Int]]] = [[],[],[]]
    
    static var _sharedTable = TableViewController()
    static var sharedTable: TableViewController { get { return _sharedTable } }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
//        let requestURL: NSURL = NSURL(string: "https://dl.dropboxusercontent.com/u/7544475/S65g.json")!
//        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithRequest(urlRequest) {
//            (data, response, error) -> Void in
//            
//            let httpResponse = response as! NSHTTPURLResponse
//            let statusCode = httpResponse.statusCode
//            
//            if (statusCode == 200) {
//                do{
//                    
//                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments) as? [AnyObject]
//                    for i in 0...json!.count-1 {
//                        let pattern = json![i]
//                        let collection = pattern as! Dictionary<String, AnyObject>
//                        self.names.append(collection["title"]! as! String)
//                        let arr = collection["contents"].map{return $0 as! [[Int]]}
//                        self.gridContent.append(arr!)
//                    }
//                }catch {
//                    print("Error with Json: \(error)")
//                }
//            }
//        }
//        task.resume()
        
        
        // set up observer to reload the data of the table view
        let s = #selector(TableViewController.dataReload(_:))
        let c = NSNotificationCenter.defaultCenter()
        c.addObserver(self, selector: s, name: "TableViewReloadData", object: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dataReload(notification:NSNotification) {
        self.tableView.reloadData()
        self.tableView.setNeedsDisplay()
    }
    
    @IBAction func addName(sender: AnyObject) {
        TableViewController.sharedTable.names.append("Add new name...")
        TableViewController.sharedTable.gridContent.append([])
        
        let itemRow = TableViewController.sharedTable.names.count - 1
        let itemPath = NSIndexPath(forRow:itemRow, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([itemPath], withRowAnimation: .Automatic)
        
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableViewController.sharedTable.names.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("Default")
            else {
                preconditionFailure("missing Default reuse identifier")
        }
        let row = indexPath.row
        guard let nameLabel = cell.textLabel else {
            preconditionFailure("Something is wrong.")
        }
        nameLabel.text = TableViewController.sharedTable.names[row]
        cell.tag = row
        return cell
    }
    
    override func tableView(tableView: UITableView,
                            commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                                               forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            TableViewController.sharedTable.names.removeAtIndex(indexPath.row)
             TableViewController.sharedTable.gridContent.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath],
                                             withRowAnimation: .Automatic)
        }
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let editingRow = (sender as! UITableViewCell).tag
        print(TableViewController.sharedTable.gridContent[editingRow])
        let editingString = TableViewController.sharedTable.names[editingRow]
        guard let editingVC = segue.destinationViewController as? GridEditterViewController
            else {
                preconditionFailure("Something went wrong")
        }
        editingVC.name = editingString
        editingVC.commit = {
            TableViewController.sharedTable.names[editingRow] = $0
            let indexPath = NSIndexPath(forRow: editingRow, inSection: 0)
            self.tableView.reloadRowsAtIndexPaths([indexPath],
                                                  withRowAnimation: .Automatic)
        }
    }

}
