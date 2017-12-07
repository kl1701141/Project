//
//  MachinesTableViewController.swift
//  Project
//
//  Created by Kevin Lin on 2017/9/4.
//  Copyright © 2017年 Kevin Lin. All rights reserved.
//

import UIKit

class MachinesTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var user: User!
    var devices:[Device] = []
    
    var searchController: UISearchController!
    var searchResults:[Device] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        title = "所有裝置"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search,  target: self, action: #selector(MachinesTableViewController.searchBarActivate))
        
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.darkGray
        
        
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "搜尋裝置..."
        searchController.searchBar.barTintColor = UIColor.darkGray
        searchController.searchBar.tintColor = UIColor.white
        searchController.hidesNavigationBarDuringPresentation = false
        
        if searchController.isActive {
            searchController.searchBar.isHidden = false
        }
        //view.backgroundColor = UIColor.darkGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // when view ever appears, do these
        initialMarqueesTableFromServer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // get all the marquees from server
    func initialMarqueesTableFromServer () {
        // API format
        let urlString: String = "http://\(host):\(port)/api/Marquees"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        // use GET method
        request.httpMethod = "GET"
        
        // set headers
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
                    self.devices.append(Device(name: object["Station"] as! String, location: object["Location"] as! String, imageName: "marquee01.png", status: object["Status"] as! String, Did: "\(object["Id"] as! Int)"))
                }
            }
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
    
    // activate searchBar with button in NavigationBar
    func searchBarActivate() {
        present(searchController, animated: true, completion: nil)
        searchController.isActive = true
    }
    
    // update table data when keyword changes
    func updateSearchResults(for searchController: UISearchController) {
        if let keyword = searchController.searchBar.text {
            if keyword != "" {
                filterContent(for: keyword)
                tableView.reloadData()
            }
        }
    }
    
    // action to do when searchBar's Cancel button clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        self.tableView.reloadData()
    }
    
    // check and get the data if match the keyword
    func filterContent(for keyword: String) {
        searchResults = devices.filter({ (device) -> Bool in
            let isMatch = device.location.localizedCaseInsensitiveContains(keyword)
            if keyword == "" {
                return true
            }
            return isMatch
        })
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive {
            if searchController.searchBar.text == "" {
                return devices.count
            } else {
                return searchResults.count
            }
        } else {
            return devices.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MachinesTableViewCell
        
        cell.backgroundColor = UIColor(red: 75.0/255.0, green: 75.0/255.0, blue: 75.0/255.0, alpha: 1.0)

        // Configure the cell...
        
        let device = (searchController.isActive) ? ((searchController.searchBar.text == "") ? devices[indexPath.row] : searchResults[indexPath.row]) : devices[indexPath.row]
        
        cell.nameLabel.text = device.name
        cell.locationLabel.text = device.location
        cell.thumbnailImageView.image = UIImage(named: device.imageName)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showMachineDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! MachineDetailViewController
                destinationController.device = (searchController.isActive) ? ((searchController.searchBar.text == "") ? devices[indexPath.row] : searchResults[indexPath.row]) :  devices[indexPath.row]
                destinationController.user = user
                searchController.searchBar.text = ""
                tableView.reloadData()
                searchController.isActive = false
            }
        }
    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
    

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
