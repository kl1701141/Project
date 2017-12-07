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
    
    @IBOutlet weak var logInButton: UIButton!
    
    
    // temp var for user Authorization token
    var userToken: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/M/dd HH:mm:ss"
        
        if segue.identifier == "loginToProfile" {
            // triggered log in action to get marquees controlled by this user
            let userDevices: String = getMarquees ()

            let user: User = User(account: "\(accountTextField.text!)", UID: "1", loginTime: "\(dateFormatter.string(from: now))", devices: userDevices, token: userToken)
            
            // segue to profile view and machine view for passing user data
            let barViewControllers = segue.destination as! UITabBarController
            
            let navToMyMachine = barViewControllers.viewControllers![1] as! UINavigationController
            let navToProfile = barViewControllers.viewControllers![2] as! UINavigationController
            let navToMachines = barViewControllers.viewControllers![0] as! UINavigationController
            
            
            let myMachineViewController = navToMyMachine.viewControllers[0] as! MyMachinesTableViewController
            let profileViewController = navToProfile.viewControllers[0] as! ProfileViewController
            let machineViewController = navToMachines.viewControllers[0] as! MachinesTableViewController
            
            
            myMachineViewController.user = user
            profileViewController.user = user
            machineViewController.user = user
        }
    }
    
    // return marquees under this users controll as a String
    func getMarquees () -> String{
        // API format
        let urlString: String = "http://\(host):\(port)/api/Owners"
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        
        // use GET method
        request.httpMethod = "GET"
        
        // set Headers
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("bearer " + userToken, forHTTPHeaderField: "Authorization")
        
        var userDevices: String = ""
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error as Any)
            } else {
                
                guard let data = data else {return}
                
                // parse response json to an Array with Dictionary<String, Any> elements
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [Dictionary<String, Any>]
                var cnt = 0
                for object in json! {
                    if object["Uid"] as! Int == 1 {
                        cnt += 1
                        if cnt == 1 {
                            userDevices.append(object["Station"]! as! String)
                        } else {
                            userDevices.append(", ")
                            userDevices.append(object["Station"]! as! String)
                        }
                    }
                }
            }
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        
        return userDevices
    }
    
    // Action to log in
    @IBAction func logInAction(_ sender: AnyObject) {
        if accountTextField.text == "" {
            // alert for empty account text field
            let alertMessage = UIAlertController(title: nil, message: "您尚未輸入帳號", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "我知道了", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
        } else if passwordTextField.text == "" {
            // alert for empty password text field
            let alertMessage = UIAlertController(title: nil, message: "您尚未輸入密碼", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "我知道了", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
        } else {
            // API CALLED, returns a token store into userToken
            logInAndGetToken ()
            if userToken == "帳號或密碼錯誤" {
                let alertMessage = UIAlertController(title: nil, message: "帳號或密碼錯誤", preferredStyle: .alert)
                alertMessage.addAction(UIAlertAction(title: "我知道了", style: .default, handler: nil))
                self.present(alertMessage, animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "loginToProfile", sender: self)
            }
        }
    }
    
    // Triggered log in API and get a token
    func logInAndGetToken () {
        // API format
        let urlString: String = "http://\(host):\(port)/api/Account/Token"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        // POST body data
        let body = "Email=\(accountTextField.text!)&Password=\(passwordTextField.text!)"
        let postData = body.data(using: String.Encoding.utf8)
        
        // use POST method
        request.httpMethod = "POST"
        request.httpBody = postData
        
        // set Header
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error as Any)
            } else {
                guard let data = data else {return}
                
                // parse the response token to String, drop response String's first and last character to get real token
                let outputStr = String(data: data, encoding: String.Encoding.utf8) as String!
                self.userToken = String(describing: outputStr!.dropLast())
                self.userToken = String(describing: self.userToken.dropFirst())
                
            }
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }

}
