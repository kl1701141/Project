//
//  MessagePublishController.swift
//  Project
//
//  Created by Kevin Lin on 2017/9/8.
//  Copyright © 2017年 Kevin Lin. All rights reserved.
//

import UIKit

class MessagePublishController: UIViewController {

    var device:Device!
    var host = "192.168.8.37"
    var port = "51700"
    
    
    @IBOutlet var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit " + device.name
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pulishMessage(_ sender: AnyObject) {
        let urlString: String = "http://\(host):\(port)/api/Default"
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        let body = "Topic=\(device.name)&Text=\(textField.text!)"
        
        let postData = body.data(using: String.Encoding.utf8)
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error as Any)
            } else {
                guard let data = data else {return}
                print(data)
            }
        
        }
        task.resume()
        
        //var response: URLResponse?
        
        //print(urlString, body)
        
        textField.text = nil
        //self.dismiss(animated: true, completion: nil)
        _ = navigationController?.popViewController(animated: true)
        
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
