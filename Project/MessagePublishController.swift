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
    var type = "B1"
    
    // for publish host and port information
    var host = "192.168.15.110"
    var port = "51320"
    
    //dFormatter.dateFormat = "yyyy年ＭＭ月dd日 HH:mm:ss"
    
    // for function picker options
    var infunction = ["向左移入","向內捲入","向外捲入","覆蓋向左","覆蓋向右","覆蓋向上","覆蓋向下","覆蓋向內","附蓋向外","覆蓋 ↑↓","覆蓋 ↓↑","向上捲入","向下捲入","立即顯現","同時出現","跳入","射入","動畫","續幕"]
    var outfunction = ["向左移入","向內捲出","向外捲出","覆蓋向左","覆蓋向右","覆蓋向上","覆蓋向下","覆蓋向內","附蓋向外","覆蓋 ↑↓","覆蓋 ↓↑","向上捲出","向下捲出","立即顯現","同時出現","跳入","射入","動畫","續幕"]
    var colors = ["紅色", "黃色", "綠色"]
    var fullHalf = ["一行半形中英數字 (上限10字)", "兩行半形英數字 (上限20字)", "全形中英數字 (上限5字)"]
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
        
        colorTextField.text = "紅色"
        fullHalfTextField.text = "一行半形英數字 (上限10字)"
        funcInTextField.text = "向左移入"
        funcOutTextField.text = "向左移入"
        timeTextField.text = "0"
        messageTextField.maxLength = 10;
        
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
        } else if textField == self.messageTextField {
            if fullHalfTextField.text == "一行半形英數字 (上限10字)" {
                messageTextField.maxLength = 10
            } else if fullHalfTextField.text == "兩行半形英數字 (上限20字)" {
                messageTextField.maxLength = 20
            } else if fullHalfTextField.text == "全形中英數字 (上限5字)" {
                messageTextField.maxLength = 5
            }
            //print(messageTextField.maxLength)
        }
        
    }
    
    @IBAction func clearAllTextField(_ sender: AnyObject) {
        colorTextField.text = "紅色"
        fullHalfTextField.text = "一行半形英數字 (上限10字)"
        funcInTextField.text = "向左移入"
        funcOutTextField.text = "向左移入"
        timeTextField.text = "0"
        messageTextField.text = nil
        messageTextField.maxLength = 10;
    }
    
    @IBAction func publishMessage(_ sender: AnyObject) {
        let urlString: String = "http://\(host):\(port)/api/Mqtt"
        let url = URL(string: urlString)!
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var request = URLRequest(url: url)
        
        let line = message.line
        let time = timeTextField.text
        var funcIn = funcInTextField.text!
        switch funcIn {
        case "向左移入":
            funcIn = "A"
        case "向內捲入":
            funcIn = "B"
        case "向外捲入":
            funcIn = "C"
        case "覆蓋向左":
            funcIn = "D"
        case "覆蓋向右":
            funcIn = "E"
        case "覆蓋向上":
            funcIn = "F"
        case "覆蓋向下":
            funcIn = "G"
        case "覆蓋向內":
            funcIn = "H"
        case "覆蓋向外":
            funcIn = "I"
        case "覆蓋 ↑↓":
            funcIn = "J"
        case "覆蓋 ↓↑":
            funcIn = "K"
        case "向上捲入":
            funcIn = "L"
        case "向下捲入":
            funcIn = "M"
        case "立即顯現":
            funcIn = "N"
        case "同時出現":
            funcIn = "O"
        case "跳入":
            funcIn = "P"
        case "射入":
            funcIn = "Q"
        case "動畫":
            funcIn = "R"
        case "續幕":
            funcIn = "S"
        default:
            funcIn = "A"
        }
        
        var mode = "C0"
        if fullHalfTextField.text == "兩行半形英數字 (上限20字)" {
            mode = "C1"
        }
        
        var colorMode = ""
        if colorTextField.text == "紅色" {
            colorMode = "01"
            if fullHalfTextField.text == "全形中英數字 (上限5字)" {
                colorMode = "21"
            }
        } else if colorTextField.text == "綠色" {
            colorMode = "04"
            if fullHalfTextField.text == "全形中英數字 (上限5字)" {
                colorMode = "24"
            }
        } else if colorTextField.text == "黃色" {
            colorMode = "05"
            if fullHalfTextField.text == "全形中英數字 (上限5字)" {
                colorMode = "25"
            }
        }
        
        while (messageTextField.text?.count)! < messageTextField.maxLength {
            messageTextField.text?.append(" ")
        }
        let text = messageTextField.text
        
        var funcOut = funcOutTextField.text!
        switch funcOut {
        case "向左移入":
            funcOut = "A"
        case "向內捲出":
            funcOut = "B"
        case "向外捲出":
            funcOut = "C"
        case "覆蓋向左":
            funcOut = "D"
        case "覆蓋向右":
            funcOut = "E"
        case "覆蓋向上":
            funcOut = "F"
        case "覆蓋向下":
            funcOut = "G"
        case "覆蓋向內":
            funcOut = "H"
        case "覆蓋向外":
            funcOut = "I"
        case "覆蓋 ↑↓":
            funcOut = "J"
        case "覆蓋 ↓↑":
            funcOut = "K"
        case "向上捲出":
            funcOut = "L"
        case "向下捲出":
            funcOut = "M"
        case "立即顯現":
            funcOut = "N"
        case "同時出現":
            funcOut = "O"
        case "跳入":
            funcOut = "P"
        case "射入":
            funcOut = "Q"
        case "動畫":
            funcOut = "R"
        case "續幕":
            funcOut = "S"
        default:
            funcOut = "A"
        }
        
        
        
        
        let body = "Topic=\(message.device)&Type=\(type)&Data=\(line),\(time!),\(funcIn),\(mode),\(colorMode),\(text!),\(funcOut)&Date=\(dateFormatter.string(from: now))"
        
        
        print (body)
        
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
