//
//  PickUpLinesTableViewController.swift
//  Project
//
//  Created by Kevin Lin on 2017/10/21.
//  Copyright © 2017年 Kevin Lin. All rights reserved.
//

import UIKit

class PickUpLinesTableViewController: UITableViewController {

    var type: String!
    var device: String!
    
    // for publish host and port information
    var host = "192.168.15.110"
    var port = "51320"
    
    var messages:[Message] = [
        Message(device: "A1", line: "1", displayTime: "2", funcIn: "A", funcOut: "A", text: "WOW", color: "01"),
        Message(device: "A1", line: "2", displayTime: "2", funcIn: "A", funcOut: "A", text: "YOO", color: "01"),
        Message(device: "A1", line: "3", displayTime: "2", funcIn: "A", funcOut: "A", text: "Such", color: "01"),
        Message(device: "A1", line: "4", displayTime: "2", funcIn: "A", funcOut: "A", text: "Display", color: "01"),
        Message(device: "A1", line: "5", displayTime: "2", funcIn: "A", funcOut: "A", text: "WOW", color: "01"),
        Message(device: "A1", line: "6", displayTime: "2", funcIn: "A", funcOut: "A", text: "YOO", color: "01"),
        Message(device: "A1", line: "7", displayTime: "2", funcIn: "A", funcOut: "A", text: "Such", color: "01"),
        Message(device: "A1", line: "8", displayTime: "2", funcIn: "A", funcOut: "A", text: "Display", color: "01"),
        Message(device: "A1", line: "9", displayTime: "2", funcIn: "A", funcOut: "A", text: "WOW", color: "01"),
        Message(device: "A1", line: "10", displayTime: "2", funcIn: "A", funcOut: "A", text: "YOO", color: "01"),
        Message(device: "A1", line: "11", displayTime: "2", funcIn: "A", funcOut: "A", text: "Such", color: "01"),
        Message(device: "A1", line: "12", displayTime: "2", funcIn: "A", funcOut: "A", text: "Display", color: "01"),
        Message(device: "A1", line: "1", displayTime: "2", funcIn: "A", funcOut: "A", text: "WOW", color: "01"),
        Message(device: "A1", line: "2", displayTime: "2", funcIn: "A", funcOut: "A", text: "YOO", color: "01"),
        Message(device: "A1", line: "3", displayTime: "2", funcIn: "A", funcOut: "A", text: "Such", color: "01"),
        Message(device: "A1", line: "4", displayTime: "2", funcIn: "A", funcOut: "A", text: "Display", color: "01"),
        Message(device: "A1", line: "5", displayTime: "2", funcIn: "A", funcOut: "A", text: "WOW", color: "01"),
        Message(device: "A1", line: "6", displayTime: "2", funcIn: "A", funcOut: "A", text: "YOO", color: "01"),
        Message(device: "A1", line: "7", displayTime: "2", funcIn: "A", funcOut: "A", text: "Such", color: "01"),
        Message(device: "A1", line: "8", displayTime: "2", funcIn: "A", funcOut: "A", text: "Display", color: "01"),
        Message(device: "A1", line: "9", displayTime: "2", funcIn: "A", funcOut: "A", text: "WOW", color: "01"),
        Message(device: "A1", line: "10", displayTime: "2", funcIn: "A", funcOut: "A", text: "YOO", color: "01"),
        Message(device: "A1", line: "11", displayTime: "2", funcIn: "A", funcOut: "A", text: "Such", color: "01"),
        Message(device: "A1", line: "12", displayTime: "2", funcIn: "A", funcOut: "A", text: "Display", color: "01")
    ]
    
    var lineSelected = Array(repeatElement(false, count: 254))
    
    var setOfLines = Set<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        tableView.backgroundColor = UIColor.darkGray
        
        
        
        if type == "B6" {
            title = "Enable Lines On " + device
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add,  target: self, action: #selector(PickUpLinesTableViewController.editAction))
        } else if type == "B7" {
            title = "Disable Lines On " + device
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.trash,  target: self, action: #selector(PickUpLinesTableViewController.editAction))
        }
        
        //cell?.tintColor = .white
        
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PickUpLinesTableViewCell
        
        cell.backgroundColor = UIColor.darkGray
        // Configure the cell...
        
        let message = messages[indexPath.row]
        cell.typeLabel.text = "Line: " + message.line
        cell.valueLabel.text = ": " + message.text
        
        //cell.accessoryType = .disclosureIndicator
        if lineSelected[indexPath.row] {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        cell.tintColor = .white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.tintColor = .white
        cell?.accessoryType = .checkmark
        self.lineSelected[indexPath.row] = true
        
        setOfLines.insert(indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.tintColor = .white
        cell?.accessoryType = .none
        self.lineSelected[indexPath.row] = false
        
        setOfLines.remove(indexPath.row)
    }
    
    func editAction() {
        if setOfLines.count != 0 {
            let urlString: String = "http://\(host):\(port)/api/Mqtt"
            let url = URL(string: urlString)!
            
            let now = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            var request = URLRequest(url: url)
            
            let count = setOfLines.count
            
            let linesToEdit = setOfLines.sorted()
            var lineNumbers = "\(linesToEdit[0]+1)"
            
            for line in linesToEdit {
                if line == linesToEdit[0] {
                    continue
                }
                
                lineNumbers += ",\(line+1)"
            }
            
            
            let body = "Topic=\(device!)&Type=\(type!)&Data=\(count)," + lineNumbers + "&Date=\(dateFormatter.string(from: now))"
            
            
            print (body)
            
            let postData = body.data(using: String.Encoding.utf8)
            
            request.httpMethod = "POST"
            request.httpBody = postData
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error as Any)
                } else {
                    guard let data = data else {return}
                    print(data)
                }
                
            }
            task.resume()
        }
        
        _ = navigationController?.popViewController(animated: true)
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
