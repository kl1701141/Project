//
//  MachineDetailViewController.swift
//  Project
//
//  Created by Kevin Lin on 2017/9/5.
//  Copyright © 2017年 Kevin Lin. All rights reserved.
//

import UIKit

class MachineDetailViewController: UIViewController, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate {
    
    // for publish host and port information
    var host = "192.168.15.110"
    var port = "51320"
    
    var user: User!

    
    @IBOutlet weak var displayLinesView: UIView!
    
    
    @IBOutlet var machineImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var fromPicker: UIPickerView!
    @IBOutlet weak var toPicker: UIPickerView!
    
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    
    var device:Device!
    
    var lineNum:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        
        machineImageView.image = UIImage(named: device.imageName)
        tableView.backgroundColor = UIColor.darkGray
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        title = device.name + ": 裝置編輯"
        
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        displayLinesView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        
        for i in 1...255 {
            self.lineNum.append("\(i)")
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lineNum.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        
        pickerLabel.text = lineNum[row]
        
        self.view.endEditing(true)
        
        pickerLabel.textColor = .darkGray
        pickerLabel.textAlignment = .center
        pickerLabel.font = UIFont(name:"Helvetica", size: 17)
        
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == fromPicker {
            let numInFromTextField = 0 + Int(self.lineNum[row])!
            let numInToTextField = 0 + Int(self.toTextField.text!)!
            if numInFromTextField > numInToTextField {
                let alertMessage = UIAlertController(title: "溫馨提醒", message: "起始行號必須小於結束行號!\n將調整結束行號", preferredStyle: .alert)
                alertMessage.addAction(UIAlertAction(title: "我知道了", style: .default, handler: nil))
                self.present(alertMessage, animated: true, completion: nil)
                self.toTextField.text = self.lineNum[row]
            }
            self.fromTextField.text = self.lineNum[row]
            fromTextField.textAlignment = .center
        } else if pickerView == toPicker {
            let numInFromTextField = 0 + Int(self.fromTextField.text!)!
            let numInToTextField = 0 + Int(self.lineNum[row])!
            if numInToTextField < numInFromTextField {
                let alertMessage = UIAlertController(title: "溫馨提醒", message: "結束行號必須大於起始行號!\n將調整起始行號", preferredStyle: .alert)
                alertMessage.addAction(UIAlertAction(title: "我知道了", style: .default, handler: nil))
                self.present(alertMessage, animated: true, completion: nil)
                self.fromTextField.text = self.lineNum[row]
            }
            self.toTextField.text = self.lineNum[row]
            toTextField.textAlignment = .center
        }
        
        pickerView.isHidden = true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.fromTextField {
            self.fromPicker.isHidden = false
            textField.endEditing(true)
        } else if textField == self.toTextField {
            self.toPicker.isHidden = false
            textField.endEditing(true)
        }
        
    }
    
    @IBAction func displayLineFunc(_ sender: AnyObject) {
        // set default value
        fromTextField.text = "1"
        toTextField.text = "255"
        
        // set text into center
        fromTextField.textAlignment = .center
        toTextField.textAlignment = .center
        
        // set picker's color
        fromPicker.backgroundColor = .white
        toPicker.backgroundColor = .white
        
        //setDisplayingLineView.layer.borderWidth = 10
        //setDisplayingLineView.layer.borderColor = CGColor.typeID.
        // launch
        displayLinesView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.displayLinesView.transform = CGAffineTransform.identity
        })
    }
    
    @IBAction func publishMessage(_ sender: AnyObject) {
        let urlString: String = "http://\(host):\(port)/api/Mqtt"
        let url = URL(string: urlString)!
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var request = URLRequest(url: url)
        
        let from = fromTextField.text!
        let to = toTextField.text!
        let type = "B8"

        let body = "Topic=\(device.name)&Type=\(type)&Data=\(from),\(to)&Date=\(dateFormatter.string(from: now))"
        
        
        print (body)
        
        let postData = body.data(using: String.Encoding.utf8)
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("bearer " + user.token, forHTTPHeaderField: "Authorization")
        
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
        
        //messageTextField.text = nil
        //self.dismiss(animated: true, completion: nil)
        //_ = navigationController?.popViewController(animated: true)
        UIView.animate(withDuration: 10, animations: {
            self.displayLinesView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        })
        displayLinesView.isHidden = true
    }
    
    @IBAction func cancelDisplayLineFunc(_ sender: AnyObject) {
        displayLinesView.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            self.displayLinesView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MachineDetailViewCell
        cell.backgroundColor = UIColor.darkGray
        
        switch indexPath.row {
        case 0:
            cell.typeLabel.text = "裝置位置"
            cell.valueLabel.text = device.location
        case 1:
            cell.typeLabel.text = "裝置站號"
            cell.valueLabel.text = device.name
        case 2:
            cell.typeLabel.text = "管理者"
            cell.valueLabel.text = device.controller
        default:
            cell.typeLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showDisplayingLines" {
            let destinationController = segue.destination as! DisplayingTableViewController
            destinationController.device = device.name
            destinationController.user = user
        } else if segue.identifier == "enableLines" {
            let destinationController = segue.destination as! PickUpLinesTableViewController
            destinationController.device = device.name
            destinationController.user = user
            destinationController.type = "B6"
        } else if segue.identifier == "disableLines" {
            let destinationController = segue.destination as! PickUpLinesTableViewController
            destinationController.device = device.name
            destinationController.user = user
            destinationController.type = "B7"
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
