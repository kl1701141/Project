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
            alertMessage.addAction(UIAlertAction(title: "我知道了", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
            
        } else if passwordTextField.text == "" {
            // alert for empty password text field
            let alertMessage = UIAlertController(title: nil, message: "您尚未輸入密碼", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "我知道了", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
            
        } else if confirmPasswordTextField.text == "" {
            // alert for empty confirmPassword text field
            let alertMessage = UIAlertController(title: nil, message: "您尚未輸入確認密碼", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "我知道了", style: .default, handler: nil))
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
            
            let semaphore = DispatchSemaphore(value: 0)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error as Any)
                } else {
                    guard data != nil else {return}
                }
                semaphore.signal()
            }
            
            task.resume()
            semaphore.wait()

            self.performSegue(withIdentifier: "backToLoginPage", sender: self)
            
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
