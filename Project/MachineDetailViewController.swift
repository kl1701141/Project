//
//  MachineDetailViewController.swift
//  Project
//
//  Created by Kevin Lin on 2017/9/5.
//  Copyright © 2017年 Kevin Lin. All rights reserved.
//

import UIKit

class MachineDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var machineImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    
    var device:Device!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        machineImageView.image = UIImage(named: device.imageName)
        tableView.backgroundColor = UIColor.darkGray
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        title = device.name
        
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MachineDetailViewCell
        cell.backgroundColor = UIColor.darkGray
        
        switch indexPath.row {
        case 0:
            cell.typeLabel.text = "裝置位置"
            cell.valueLabel.text = device.location
        case 1:
            cell.typeLabel.text = "裝置名稱"
            cell.valueLabel.text = device.name
        case 2:
            cell.typeLabel.text = "管理者"
            cell.valueLabel.text = device.controller
        default:
            cell.typeLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showDisplayingLines" {
            let destinationController = segue.destination as! DisplayingTableViewController
            destinationController.device = device.name
        } else if segue.identifier == "enableLines" {
            let destinationController = segue.destination as! PickUpLinesTableViewController
            destinationController.device = device.name
            destinationController.type = "B6"
        } else if segue.identifier == "disableLines" {
            let destinationController = segue.destination as! PickUpLinesTableViewController
            destinationController.device = device.name
            destinationController.type = "B7"
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
