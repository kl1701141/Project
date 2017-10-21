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
    //var user: User!
    
    
    
    //dFormatter.dateFormat = "yyyy年ＭＭ月dd日 HH:mm:ss"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/M/dd HH:mm:ss"
        
        if segue.identifier == "loginToProfile" {
            let user: User = User(name: "\(accountTextField.text!)", UID: "403410068", loginTime: "\(dateFormatter.string(from: now))", devices: "A1")
            let barViewControllers = segue.destination as! UITabBarController
            let nav = barViewControllers.viewControllers![1] as! UINavigationController
            let destinationViewController = nav.viewControllers[0] as! ProfileViewController
            destinationViewController.user = user
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
