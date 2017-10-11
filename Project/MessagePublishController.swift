//
//  MessagePublishController.swift
//  Project
//
//  Created by Kevin Lin on 2017/9/8.
//  Copyright © 2017年 Kevin Lin. All rights reserved.
//

import UIKit

class MessagePublishController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{

    var message:Message!
    
    // for publish host and port information
    var host = "192.168.15.122"
    var port = "51700"
    
    
    // for function picker options
    var infunction = ["向左移入","向內捲入","向外捲入","覆蓋向左","覆蓋向右","覆蓋向上","覆蓋向下","覆蓋向內","附蓋向外","覆蓋 ↑↓","覆蓋 ↓↑","向上捲入","向下捲入","立即顯現","同時出現","跳入","射入","動畫","續幕"]
    var outfunction = ["向左移入","向內捲出","向外捲出","覆蓋向左","覆蓋向右","覆蓋向上","覆蓋向下","覆蓋向內","附蓋向外","覆蓋 ↑↓","覆蓋 ↓↑","向上捲出","向下捲出","立即顯現","同時出現","跳入","射入","動畫","續幕"]
    var colors = ["紅色", "黃色", "綠色"]
    var fullHalf = ["全形中英數字 (上限5字)", "半形中英數字 (上限10字)", "上下兩行之半形英數字 (上限20字)"]
    var times: [String] = []
    
    
    // pickers
    @IBOutlet weak var colorPicker: UIPickerView!
    @IBOutlet weak var fullHalfPicker: UIPickerView!
    @IBOutlet weak var funcInPicker: UIPickerView!
    @IBOutlet weak var funcOutPicker: UIPickerView!
    @IBOutlet weak var timePicker: UIPickerView!
    
    
    // text fields
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var fullHalfTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var funcInTextField: UITextField!
    @IBOutlet weak var funcOutTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        title = "Edit line: " + message.line
        // Do any additional setup after loading the view.
        
        colorPicker.backgroundColor = UIColor.white
        fullHalfPicker.backgroundColor = UIColor.white
        funcInPicker.backgroundColor = UIColor.white
        funcOutPicker.backgroundColor = UIColor.white
        timePicker.backgroundColor = UIColor.white
        
        for i in 0...255 {
            self.times.append("\(i)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        var rows: Int = times.count
        if pickerView == funcInPicker {
            rows = self.infunction.count
        } else if pickerView == funcOutPicker {
            rows = self.outfunction.count
        } else if pickerView == colorPicker {
            rows = self.colors.count
        } else if pickerView == fullHalfPicker {
            rows = self.fullHalf.count
        } else if pickerView == timePicker {
            rows = self.times.count
        }
        
        return rows
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        
        if pickerView == funcInPicker {
            pickerLabel.text = infunction[row]
        } else if pickerView == funcOutPicker {
            pickerLabel.text = outfunction[row]
        } else if pickerView == colorPicker {
            pickerLabel.text = colors[row]
        } else if pickerView == fullHalfPicker {
            pickerLabel.text = fullHalf[row]
        } else if pickerView == timePicker {
            pickerLabel.text = times[row]
        }
        self.view.endEditing(true)
        
        pickerLabel.textColor = .darkGray
        pickerLabel.textAlignment = .center
        pickerLabel.font = UIFont(name:"Helvetica", size: 17)
        
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == funcInPicker {
            self.funcInTextField.text = self.infunction[row]
        } else if pickerView == funcOutPicker {
            self.funcOutTextField.text = self.outfunction[row]
        } else if pickerView == colorPicker {
            self.colorTextField.text = self.colors[row]
        } else if pickerView == fullHalfPicker {
            self.fullHalfTextField.text = self.fullHalf[row]
        } else if pickerView == timePicker {
            self.timeTextField.text = self.times[row]
        }
        
        pickerView.isHidden = true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.funcInTextField {
            self.funcInPicker.isHidden = false
            textField.endEditing(true)
        } else if textField == self.funcOutTextField {
            self.funcOutPicker.isHidden = false
            textField.endEditing(true)
        } else if textField == self.colorTextField {
            self.colorPicker.isHidden = false
            textField.endEditing(true)
        } else if textField == self.fullHalfTextField {
            self.fullHalfPicker.isHidden = false
            textField.endEditing(true)
        } else if textField == self.timeTextField {
            self.timePicker.isHidden = false
            textField.endEditing(true)
        }
        
    }
    
    @IBAction func pulishMessage(_ sender: AnyObject) {
        let urlString: String = "http://\(host):\(port)/api/Default"
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        let body = "Topic=\(message.device)&Text=\(messageTextField.text!)"
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
        
        messageTextField.text = nil
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
