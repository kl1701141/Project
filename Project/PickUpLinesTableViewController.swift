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
    var device: Device!
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
            title = device.name + ": 啟用行號"
            // button for enable selected lines in this marquee
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add,  target: self, action: #selector(PickUpLinesTableViewController.editAction))
            
            // initial display enable or disable line
            for i in 0...254 {
                let index = device.status.index(device.status.startIndex, offsetBy: i)
                if device.status[index] == "0" {
                    self.messages.append(Message(device: device.name, line: "\(i+1)", funcIn: "", funcOut: "", text: "", id: "0"))
                } else {
                    continue
                }
            }
        } else if type == "B7" {
            title = device.name + ": 停用行號"
            // button for disable selected lines in this marquee
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.trash,  target: self, action: #selector(PickUpLinesTableViewController.editAction))
            
            // initial display enable or disable line
            for i in 0...254 {
                let index = device.status.index(device.status.startIndex, offsetBy: i)
                if device.status[index] == "1" {
                    self.messages.append(Message(device: device.name, line: "\(i+1)", funcIn: "", funcOut: "", text: "", id: "0"))
                } else {
                    continue
                }
                
            }
        }
        loadContentsFromServer()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tableView.backgroundColor = UIColor.darkGray

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // To load all contents in this marquee from server
    func loadContentsFromServer () {
        // API format
        let urlString: String = "http://\(host):\(port)/api/Contents"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        // use GET method
        request.httpMethod = "GET"
        
        // set Headers
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("bearer " + user.token, forHTTPHeaderField: "Authorization")
        
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error as Any)
            } else {
                guard let data = data else {return}
                // parse response json to an Array with Dictionary<String, Any> elements
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [Dictionary<String, Any>]
                for object in json! {
                    if object["Station"] as! String == self.device.name {
                        if self.type == "B6" {
                            let index = self.device.status.index(self.device.status.startIndex, offsetBy: (object["Line"] as! Int - 1))
                            if self.device.status[index] == "0" {
                                for i in 0...self.messages.count {
                                    if self.messages[i].line == "\(object["Line"] as! Int)" {
                                        self.messages[i] = Message(device: object["Station"] as! String, line: "\(object["Line"] as! Int)", funcIn: object["PreFunc"] as! String, funcOut: object["PostFunc"] as! String, text: object["Text"] as! String, id: "\(object["Id"] as! Int)")
                                        break
                                    }
                                }
                            } else {
                                continue
                            }
                        } else if self.type == "B7" {
                            let index = self.device.status.index(self.device.status.startIndex, offsetBy: (object["Line"] as! Int - 1))
                            if self.device.status[index] == "1" {
                                for i in 0...self.messages.count {
                                    if self.messages[i].line == "\(object["Line"] as! Int)" {
                                        self.messages[i] = Message(device: object["Station"] as! String, line: "\(object["Line"] as! Int)", funcIn: object["PreFunc"] as! String, funcOut: object["PostFunc"] as! String, text: object["Text"] as! String, id: "\(object["Id"] as! Int)")
                                        break
                                    }
                                }
                            } else {
                                continue
                            }
                        }
                    }
                }
            }
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
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
        
        
        
        setOfLines.insert(Int(messages[indexPath.row].line)!)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PickUpLinesTableViewCell
        cell.tintColor = .white
        cell.ifChecked.image = UIImage(named: "icons8-unchecked-checkbox-white-50.png")
        cell.ifChecked.tintColor = .white
        
        self.lineSelected[indexPath.row] = false
        
        setOfLines.insert(Int(messages[indexPath.row].line)!)
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
            var lineNumbers = "\(linesToEdit[0])"
            
            for line in linesToEdit {
                if line == linesToEdit[0] {
                    continue
                }
                lineNumbers += ",\(line)"
            }
            
            // POST body data
            let body = "Topic=\(device.name)&Type=\(type!)&Data=\(count)," + lineNumbers + "&Date=\(dateFormatter.string(from: now))"
            let postData = body.data(using: String.Encoding.utf8)
            // use POST method
            request.httpMethod = "POST"
            request.httpBody = postData
            
            // set Headers
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
            setStatusBackToDB()
            
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    // write back the new Status for this Line to DB
    func setStatusBackToDB() {
        // API format
        let urlString: String = "http://\(host):\(port)/api/Marquees/\(device.Did)"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        var lineStatus:[String] = []
        
        for i in 1...device.status.count {
            let index = device.status.index(device.status.startIndex, offsetBy: (i-1))
            lineStatus.append("\(device.status[index])")
        }
        // modify a string for selected lines
        let linesToEdit = setOfLines.sorted()
        for line in linesToEdit {
            if type == "B6" {
                lineStatus[line-1] = "1"
            } else if type == "B7" {
                lineStatus[line-1] = "0"
            }
        }
        
        var newStatus: String = ""
        for i in lineStatus {
            newStatus.append(i)
        }
        
        // POST body data
        let body = "Id=\(device.Did)&Station=\(device.name)&Location=\(device.location)&Status=\(newStatus)"
        let putData = body.data(using: String.Encoding.utf8)
        // use PUT method
        request.httpMethod = "PUT"
        request.httpBody = putData
        
        // set Headers
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
