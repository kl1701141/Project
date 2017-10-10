//
//  MessagePublishController.swift
//  Project
//
//  Created by Kevin Lin on 2017/9/8.
//  Copyright © 2017年 Kevin Lin. All rights reserved.
//

import UIKit

class MessagePublishController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{

    //var device:Device!
    var message:Message!
    var host = "192.168.15.122"
    var port = "51700"
    var IOfunction = ["向左移入","向內捲入","向外捲入","覆蓋向左","覆蓋向右","覆蓋向上","覆蓋向下","覆蓋向內","附蓋向外","覆蓋 ↑↓","覆蓋 ↓↑","向上捲入","向下捲入","立即顯現","同時出現","跳入","射入","動畫","續幕"]
    
    @IBOutlet weak var functionPicker: UIPickerView!
    
    @IBOutlet var textField: UITextField!
    @IBOutlet weak var funcInTextField: UITextField!
    @IBOutlet weak var funcOutTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        
        title = "Edit line: " + message.line
        // Do any additional setup after loading the view.
        
        
        functionPicker.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return IOfunction.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return IOfunction[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.funcInTextField.text = self.IOfunction[row]
        self.functionPicker.isHidden = true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.funcInTextField {
            self.functionPicker.isHidden = false
            //if you dont want the users to se the keyboard type:
            
            textField.endEditing(true)
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func pulishMessage(_ sender: AnyObject) {
        let urlString: String = "http://\(host):\(port)/api/Default"
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        let body = "Topic=\(message.device)&Text=\(textField.text!)"
        //print message.device
        
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
