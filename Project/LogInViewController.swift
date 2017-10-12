//
//  LogInViewController.swift
//  Project
//
//  Created by Kevin Lin on 2017/10/13.
//  Copyright © 2017年 Kevin Lin. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    
    //dFormatter.dateFormat = "yyyy年ＭＭ月dd日 HH:mm:ss"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年ＭＭ月dd日 HH:mm:ss"
        
        if segue.identifier == "loginToProfile" {
            user.devices = "A1"
            user.loginTime = "\(dateFormatter.string(from: now))"
            user.UID = "403410068"
            user.name = accountTextField.text!
            var user: User = User(name: "kl1701141", UID: "403410068", loginTime: "2017-10-13 00:37:35", devices: "A1")
            let destinationController = segue.destination as! ProfileViewController
            destinationController.user = user
        }
    }*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
