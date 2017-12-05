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
    
    var userToken: String = ""

    
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
            let urlString: String = "http://\(host):\(port)/api/Owners"
            let url = URL(string: urlString)!
            
            var request = URLRequest(url: url)
            
            request.httpMethod = "GET"
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("bearer " + userToken, forHTTPHeaderField: "Authorization")
            
            var userDevices: String = ""
            let semaphore = DispatchSemaphore(value: 0)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error as Any)
                } else {
                    guard let data = data else {return}
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [Dictionary<String, Any>]
                    //print(json!)
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
                    //print(userDevices)
                }
                semaphore.signal()
            }
            
            task.resume()
            semaphore.wait()

            let user: User = User(account: "\(accountTextField.text!)", UID: "1", loginTime: "\(dateFormatter.string(from: now))", devices: userDevices, token: userToken)
            let barViewControllers = segue.destination as! UITabBarController
            
            let navToProfile = barViewControllers.viewControllers![1] as! UINavigationController
            let navToMachines = barViewControllers.viewControllers![0] as! UINavigationController
            
            let profileViewController = navToProfile.viewControllers[0] as! ProfileViewController
            let machineViewController = navToMachines.viewControllers[0] as! MachinesTableViewController

            profileViewController.user = user
            machineViewController.user = user
        }
    }
    
    @IBAction func logInAction(_ sender: AnyObject) {
        
        if accountTextField.text == "" {
            let alertMessage = UIAlertController(title: nil, message: "您尚未輸入帳號", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "我知道了", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
        } else if passwordTextField.text == "" {
            let alertMessage = UIAlertController(title: nil, message: "您尚未輸入密碼", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "我知道了", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
        } else {
            // API CALLED, returns a token store into userToken
            let urlString: String = "http://\(host):\(port)/api/Account/Token"
            let url = URL(string: urlString)!

            var request = URLRequest(url: url)
            let body = "Email=\(accountTextField.text!)&Password=\(passwordTextField.text!)"
            
            let postData = body.data(using: String.Encoding.utf8)
            
            request.httpMethod = "POST"
            request.httpBody = postData
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            let semaphore = DispatchSemaphore(value: 0)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error as Any)
                } else {
                    guard let data = data else {return}
                    let outputStr = String(data: data, encoding: String.Encoding.utf8) as String!
                    
                    self.userToken = String(describing: outputStr!.dropLast())
                    self.userToken = String(describing: self.userToken.dropFirst())
                    
                }
                semaphore.signal()
            }
            
            task.resume()
            semaphore.wait()
            
            self.performSegue(withIdentifier: "loginToProfile", sender: self)
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
