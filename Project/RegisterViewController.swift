//
//  RegisterViewController.swift
//  Project
//
//  Created by Kevin Lin on 2017/11/26.
//  Copyright © 2017年 Kevin Lin. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var back: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // register for our system
    @IBAction func registerAction(_ sender: AnyObject) {
        if accountTextField.text == "" {
            // alert for empty account text field
            let alertMessage = UIAlertController(title: nil, message: "您尚未輸入帳號", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "確認", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
            
        } else if passwordTextField.text == "" {
            // alert for empty password text field
            let alertMessage = UIAlertController(title: nil, message: "您尚未輸入密碼", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "確認", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
            
        } else if confirmPasswordTextField.text == "" {
            // alert for empty confirmPassword text field
            let alertMessage = UIAlertController(title: nil, message: "您尚未輸入確認密碼", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "確認", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
        }else {
            // API CALLED, returns a token store into userToken
            let urlString: String = "http://\(host):\(port)/api/Account/Register"
            let url = URL(string: urlString)!
            var request = URLRequest(url: url)
            
            
            // POST body data
            let body = "Email=\(accountTextField.text!)&Password=\(passwordTextField.text!)&ConfirmPassword=\(confirmPasswordTextField.text!)"
            let postData = body.data(using: String.Encoding.utf8)
            
            
            // use POST method
            request.httpMethod = "POST"
            request.httpBody = postData
            
            // set Header
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            var errorCheck: Int = 0
            var ifOk: String = ""
            let semaphore = DispatchSemaphore(value: 0)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error as Any)
                } else {
                    guard let data = data else {return}
                    let outputStr = String(data: data, encoding: String.Encoding.utf8) as String!
                    ifOk = String(describing: outputStr!.dropLast())
                    ifOk = String(describing: ifOk.dropFirst())
                    if ifOk != "ok" {
                        errorCheck = 1
                    }
                }
                semaphore.signal()
            }
            
            task.resume()
            semaphore.wait()
            
            if errorCheck == 1 {
                // alert for format fault
                let alertMessage = UIAlertController(title: "要求無效。", message: "請確認您的電子郵件格式\n密碼是否為６個字元以上\n密碼與確認密碼欄位是否相符", preferredStyle: .alert)
                alertMessage.addAction(UIAlertAction(title: "確認", style: .default, handler: nil))
                self.present(alertMessage, animated: true, completion: nil)
            } else if errorCheck == 0 {
                self.performSegue(withIdentifier: "backToLoginPage", sender: self)
            }
        }
    }
    
    // segue back to log in page
    @IBAction func backToLoginPage(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "backToLoginPage", sender: self)
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
