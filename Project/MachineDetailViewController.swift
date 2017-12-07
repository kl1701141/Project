//
//  MachineDetailViewController.swift
//  Project
//
//  Created by Kevin Lin on 2017/9/5.
//  Copyright © 2017年 Kevin Lin. All rights reserved.
//

import UIKit

class MachineDetailViewController: UIViewController, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate {
    
    var user: User!
    var device:Device!
    var lineNum:[String] = []
    
    
    @IBOutlet var machineImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    
    
    @IBOutlet weak var displayLinesView: UIView!
    
    // PickerViews
    @IBOutlet weak var fromPicker: UIPickerView!
    @IBOutlet weak var toPicker: UIPickerView!
    
    // TextFields
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    
    // Buttons
    @IBOutlet weak var interludeButton: UIButton!
    @IBOutlet weak var publishMessageButton: UIButton!
    @IBOutlet weak var enableLinesButton: UIButton!
    @IBOutlet weak var disableLinesButton: UIButton!
    @IBOutlet weak var displayLinesButton: UIButton!
    @IBOutlet weak var getPermissionButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        machineImageView.image = UIImage(named: device.imageName)
        
        title = device.name + ": 裝置編輯"
        tableView.backgroundColor = UIColor.darkGray
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        displayLinesView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        
        // initial lineNum array from 1 to 255 for from/toPickerView
        for i in 1...255 {
            self.lineNum.append("\(i)")
        }
        
        // check permissions to enable/disable buttons
        let permission = checkPermission()
        if permission == 0 {
            interludeButton.isEnabled = false
            publishMessageButton.isEnabled = false
            enableLinesButton.isEnabled = false
            disableLinesButton.isEnabled = false
            displayLinesButton.isEnabled = false
            interludeButton.setTitleColor(.lightGray, for: .normal)
            publishMessageButton.setTitleColor(.lightGray, for: .normal)
            enableLinesButton.setTitleColor(.lightGray, for: .normal)
            disableLinesButton.setTitleColor(.lightGray, for: .normal)
            displayLinesButton.setTitleColor(.lightGray, for: .normal)
        } else if permission == 1 {
            getPermissionButton.setTitleColor(.lightGray, for: .normal)
            getPermissionButton.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // when view ever appears, do these
        reloadDeviceData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // reload device data after write back to DB
    func reloadDeviceData() {
        // API format
        let urlString: String = "http://\(host):\(port)/api/Marquees/\(device.Did)"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        // use GET method
        request.httpMethod = "GET"
        
        // set Headers
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("bearer " + user.token, forHTTPHeaderField: "Authorization")
        
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error as Any)
            } else {
                guard let data = data else {return}
                
                // parse response json to an Array with Dictionary<String, Any> elements
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                self.device = Device(name: json!["Station"] as! String, location: json!["Location"] as! String, imageName: "marquee01.png", status: json!["Status"] as! String, Did: "\(json!["Id"] as! Int)")
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    // test if this user have permission to set this marquee
    func checkPermission() -> Int {
        var permission: Int = 0;
        
        // API format
        let urlString: String = "http://\(host):\(port)/api/Owners"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        // use GET method
        request.httpMethod = "GET"
        
        // set Headers
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("bearer " + user.token, forHTTPHeaderField: "Authorization")
        
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error as Any)
            } else {
                guard let data = data else {return}
                
                // parse response json to an Array with Dictionary<String, Any> elements
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [Dictionary<String, Any>]
                
                for object in json! {
                    if (object["Station"] as! String == self.device.name) && (object["Uid"] as? Int == Int(self.user.UID)) {
                        permission = 1
                        break
                    }
                }
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        
        return permission
    }
    
    // Action & initial something for Function: 調整顯示行數
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

        displayLinesView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.displayLinesView.transform = CGAffineTransform.identity
        })
    }
    
    // publish for adjust displaying lines
    @IBAction func publishMessage(_ sender: AnyObject) {
        // API format
        let urlString: String = "http://\(host):\(port)/api/Mqtt"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let from = fromTextField.text!
        let to = toTextField.text!
        let type = "B8"
        
        // POST body data
        let body = "Topic=\(device.name)&Type=\(type)&Data=\(from),\(to)&Date=\(dateFormatter.string(from: now))"
        let postData = body.data(using: String.Encoding.utf8)
        
        // use POST method
        request.httpMethod = "POST"
        request.httpBody = postData
        
        // set Headers
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("bearer " + user.token, forHTTPHeaderField: "Authorization")
        
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

        UIView.animate(withDuration: 10, animations: {
            self.displayLinesView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        })
        displayLinesView.isHidden = true
    }
    
    // Action for cancel adjusting displaying lines and go back
    @IBAction func cancelDisplayLineFunc(_ sender: AnyObject) {
        displayLinesView.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            self.displayLinesView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
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
//        case 2:
//            cell.typeLabel.text = "管理者"
//            cell.valueLabel.text = device.controller
        default:
            cell.typeLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    // this user ask for a permission to set this marquee
    @IBAction func askForPermission(_ sender: AnyObject) {
        // API format
        let urlString: String = "http://\(host):\(port)/api/Owners"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        // POST body data
        let body = "Station=\(device.name)&Uid=\(user.UID)"
        let postData = body.data(using: String.Encoding.utf8)
        
        // use POST method
        request.httpMethod = "POST"
        request.httpBody = postData
        
        // set Headers
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("bearer " + user.token, forHTTPHeaderField: "Authorization")
        
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
        
        
        let alertMessage = UIAlertController(title: "申請成功！", message: "您的申請已成功送出，請耐心等待批准！", preferredStyle: .alert)
        alertMessage.addAction(UIAlertAction(title: "確認", style: .default, handler: nil))
        self.present(alertMessage, animated: true, completion: nil)

    }

    // MARK: - Picker view data source
    
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
                // from must less than to
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
                // from must less than to
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showDisplayingLines" {
            let destinationController = segue.destination as! DisplayingTableViewController
            destinationController.device = device.name
            destinationController.user = user
        } else if segue.identifier == "enableLines" {
            let destinationController = segue.destination as! PickUpLinesTableViewController
            destinationController.device = device
            destinationController.user = user
            destinationController.type = "B6"
        } else if segue.identifier == "disableLines" {
            let destinationController = segue.destination as! PickUpLinesTableViewController
            destinationController.device = device
            destinationController.user = user
            destinationController.type = "B7"
        } else if segue.identifier == "interludePublish" {
            let destinationController = segue.destination as! MessagePublishController
            destinationController.user = user
            destinationController.type = "B2"
            destinationController.device = device.name
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
