//
//  DisplayingTableViewController.swift
//  Project
//
//  Created by Kevin Lin on 2017/9/21.
//  Copyright © 2017年 Kevin Lin. All rights reserved.
//

import UIKit

class DisplayingTableViewController: UITableViewController {

    var device: String!
    
    var messages:[Message] = [
        Message(device: "A1", line: "1", displayTime: "2", funcIn: "A", funcOut: "A", text: "WOW", color: "01"),
        Message(device: "A1", line: "2", displayTime: "2", funcIn: "A", funcOut: "A", text: "YOO", color: "01"),
        Message(device: "A1", line: "3", displayTime: "2", funcIn: "A", funcOut: "A", text: "Such", color: "01"),
        Message(device: "A1", line: "4", displayTime: "2", funcIn: "A", funcOut: "A", text: "Display", color: "01"),
        Message(device: "A1", line: "10", displayTime: "2", funcIn: "A", funcOut: "A", text: "Doge", color: "01")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView.backgroundColor = UIColor.darkGray

        title = "Displaying on " + device
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DisplayingTableViewCell
        
        cell.backgroundColor = UIColor.darkGray
        // Configure the cell...
        
        let message = messages[indexPath.row]
        cell.lineNumberLabel.text = "Line: " + message.line
        cell.displayingLabel.text = "正在顯示: " + message.text
        
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "messagePublish" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! MessagePublishController
                destinationController.message = messages[indexPath.row]
                destinationController.type = "B1"
            }
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
