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
    var user: User!
    
    var messages:[Message] = []
    var lineSelected = Array(repeatElement(false, count: 254))
    var setOfLines = Set<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if type == "B6" {
            title = device + ": 啟用行號"
            // button for enable selected lines in this marquee
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add,  target: self, action: #selector(PickUpLinesTableViewController.editAction))
        } else if type == "B7" {
            title = device + ": 停用行號"
            // button for disable selected lines in this marquee
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.trash,  target: self, action: #selector(PickUpLinesTableViewController.editAction))
        }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tableView.backgroundColor = UIColor.darkGray

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
        
        if lineSelected[indexPath.row] {
            cell.ifChecked.image = UIImage(named: "icons8-checked-checkbox-white-50.png")
        } else {
            cell.ifChecked.image = UIImage(named: "icons8-unchecked-checkbox-white-50.png")
        }
        cell.tintColor = .white
        cell.ifChecked.tintColor = .white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PickUpLinesTableViewCell
        cell.tintColor = .white
        cell.ifChecked.image = UIImage(named: "icons8-checked-checkbox-white-50.png")
        cell.ifChecked.tintColor = .white
        
        self.lineSelected[indexPath.row] = true
        
        setOfLines.insert(indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PickUpLinesTableViewCell
        cell.tintColor = .white
        cell.ifChecked.image = UIImage(named: "icons8-unchecked-checkbox-white-50.png")
        cell.ifChecked.tintColor = .white
        
        self.lineSelected[indexPath.row] = false
        
        setOfLines.remove(indexPath.row)
    }
    
    // function for enable/disable lines in this marquee
    func editAction() {
        if setOfLines.count != 0 {
            // API format
            let urlString: String = "http://\(host):\(port)/api/Mqtt"
            let url = URL(string: urlString)!
            var request = URLRequest(url: url)
            
            // Date format
            let now = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            
            // modify a string for selected lines
            let count = setOfLines.count
            
            let linesToEdit = setOfLines.sorted()
            var lineNumbers = "\(linesToEdit[0]+1)"
            
            for line in linesToEdit {
                if line == linesToEdit[0] {
                    continue
                }
                lineNumbers += ",\(line+1)"
            }
            
            // POST body data
            let body = "Topic=\(device!)&Type=\(type!)&Data=\(count)," + lineNumbers + "&Date=\(dateFormatter.string(from: now))"
            let postData = body.data(using: String.Encoding.utf8)
            
            // use POST method
            request.httpMethod = "POST"
            request.httpBody = postData
            
            // set headers
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("bearer " + user.token, forHTTPHeaderField: "Authorization")
            
            let semaphore = DispatchSemaphore(value: 0)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error as Any)
                } else {
                    guard data != nil else {return}
                }
                semaphore.signal()
            }
            task.resume()
            semaphore.wait()
            
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
