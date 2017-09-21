//
//  MachinesTableViewController.swift
//  Project
//
//  Created by Kevin Lin on 2017/9/4.
//  Copyright © 2017年 Kevin Lin. All rights reserved.
//

import UIKit
import CoreData

class MachinesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    
    var devices:[Device] = [
        Device(name: "A0", location: "EA-101", imageName: "doge.jpg", displaying: "Hello World!", controller: "Andy Wang"),
        Device(name: "B4", location: "CS-104", imageName: "doge1.png", displaying: "Wow, Such Doge!", controller: "Peter Chen, Vava Yu, PG One, GAI Wang"),
        Device(name: "H8", location: "資工系館前", imageName: "doge2.png", displaying: "I am trying to add structs to an array. I know it's possible. I have seen it in another post on the site. But I am wondering if there is any way to add structs to an array without creating variables.", controller: "Kevin Lin, Kiki Liu"),
        Device(name: "C5", location: "活動中心", imageName: "doge3.jpg", displaying: "Is there any way to add structs to an array without creating variables?", controller: "Kinny Fang, Sarah Lin, Michael Lin"),
        Device(name: "D7", location: "資工系辦", imageName: "hibiki.jpg", displaying: "Not the answer you're looking for? Browse other questions tagged", controller: "Cathy Lin, Jeremy Huang"),
        Device(name: "A2", location: "EA-206", imageName: "hibiki2.jpg", displaying: "Join the Stack Overflow Community", controller: "Doge Chen")
    ]
    
    var searchController: UISearchController!
    var searchResults:[Device] = []
    
    func updateSearchResults(for searchController: UISearchController) {
        if let keyword = searchController.searchBar.text {
            filterContent(for: keyword)
            tableView.reloadData()
        }
    }
    
    func filterContent(for keyword: String) {
        searchResults = devices.filter({ (device) -> Bool in
            let isMatch = device.location.localizedCaseInsensitiveContains(keyword)
            return isMatch
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search device..."
        searchController.searchBar.barTintColor = UIColor(red: 110.0/255.0, green: 66.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        searchController.searchBar.tintColor = UIColor.white
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
        if searchController.isActive {
            return searchResults.count
        } else {
            return devices.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MachinesTableViewCell

        // Configure the cell...
        
        let device = (searchController.isActive) ? searchResults[indexPath.row] : devices[indexPath.row]
        
        cell.nameLabel.text = device.name
        cell.locationLabel.text = device.location
        cell.thumbnailImageView.image = UIImage(named: device.imageName)
        cell.accessoryType = .disclosureIndicator
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit edittingStyle:UITableViewCellEditingStyle, forRowAt indexPath: IndexPath ) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showMachineDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! MachineDetailViewController
                destinationController.device = devices[indexPath.row]
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

}
