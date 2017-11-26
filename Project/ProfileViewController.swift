//
//  ProfileViewController.swift
//  Project
//
//  Created by Kevin Lin on 2017/10/13.
//  Copyright © 2017年 Kevin Lin. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //var user: User = User(name: "kl1701141", UID: "403410068", loginTime: "2017-10-13 00:37:35", devices: "A1")
    var user: User!
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProfileTableViewCell
        cell.backgroundColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
        
        switch indexPath.row {
        case 0:
            cell.typeLabel.text = "UID"
            cell.valueLabel.text = user.UID
        case 1:
            cell.typeLabel.text = "用戶名"
            cell.valueLabel.text = user.token
        case 2:
            cell.typeLabel.text = "管理裝置"
            cell.valueLabel.text = user.devices
        case 3:
            cell.typeLabel.text = "登錄時間"
            cell.valueLabel.text = user.loginTime
        default:
            cell.typeLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        cell.backgroundColor = UIColor.clear
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
        title = "用戶資料"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
