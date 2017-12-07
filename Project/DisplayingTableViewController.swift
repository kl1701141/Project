//
//  DisplayingTableViewController.swift
//  Project
//
//  Created by Kevin Lin on 2017/9/21.
//  Copyright © 2017年 Kevin Lin. All rights reserved.
//

import UIKit

class DisplayingTableViewController: UITableViewController {

    var user: User!
    var device: String!
    var lineNotEmpty: [String] = []
    
    var messages:[Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // initial the max line message set, because DB only stores th modified lines
        for i in 1...255 {
            self.messages.append(Message(device: device, line: "\(i)", funcIn: "", funcOut: "", text: "", id: "0"))
        }
        
        title = device + ": 編輯內容"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView.backgroundColor = UIColor.darkGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // when view ever appears, do these
        loadContentsFromServer()
        tableView.reloadData()
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
                    if object["Station"] as! String == self.device {
                        self.messages[(object["Line"] as! Int) - 1] = Message(device: object["Station"] as! String, line: "\(object["Line"] as! Int)", funcIn: object["PreFunc"] as! String, funcOut: object["PostFunc"] as! String, text: object["Text"] as! String, id: "\(object["Id"] as! Int)")
                        self.lineNotEmpty.append("\(object["Line"] as! Int)")
                    }
                }
            }
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
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
        
        var funcIn: String = ""
        switch message.funcIn {
        case "A":
            funcIn = "向左移入"
        case "B":
            funcIn = "向內捲入"
        case "C":
            funcIn = "向外捲入"
        case "D":
            funcIn = "覆蓋向左"
        case "E":
            funcIn = "覆蓋向右"
        case "F":
            funcIn = "覆蓋向上"
        case "G":
            funcIn = "覆蓋向下"
        case "H":
            funcIn = "覆蓋向內"
        case "I":
            funcIn = "覆蓋向外"
        case "J":
            funcIn = "覆蓋 ↑↓"
        case "K":
            funcIn = "覆蓋 ↓↑"
        case "L":
            funcIn = "向上捲入"
        case "M":
            funcIn = "向下捲入"
        case "N":
            funcIn = "立即顯現"
        case "O":
            funcIn = "同時出現"
        case "P":
            funcIn = "跳入"
        case "Q":
            funcIn = "射入"
        case "R":
            funcIn = "動畫"
        case "S":
            funcIn = "續幕"
        default:
            funcIn = " "
        }
        
        var funcOut: String = ""
        switch message.funcOut {
        case "A":
            funcOut = "向左移出"
        case "B":
            funcOut = "向內捲出"
        case "C":
            funcOut = "向外捲出"
        case "D":
            funcOut = "覆蓋向左"
        case "E":
            funcOut = "覆蓋向右"
        case "F":
            funcOut = "覆蓋向上"
        case "G":
            funcOut = "覆蓋向下"
        case "H":
            funcOut = "覆蓋向內"
        case "I":
            funcOut = "覆蓋向外"
        case "J":
            funcOut = "覆蓋 ↑↓"
        case "K":
            funcOut = "覆蓋 ↓↑"
        case "L":
            funcOut = "向上捲出"
        case "M":
            funcOut = "向下捲出"
        case "N":
            funcOut = "立即顯現"
        case "O":
            funcOut = "同時出現"
        case "P":
            funcOut = "跳出"
        case "Q":
            funcOut = "射出"
        case "R":
            funcOut = "動畫"
        case "S":
            funcOut = "續幕"
        default:
            funcOut = " "
        }
        
        cell.funcLabel.text = funcIn + ", " + funcOut
        
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
                destinationController.user = user
                destinationController.type = "B1"
                destinationController.lineNotEmpty = lineNotEmpty
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
