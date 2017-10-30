//
//  DisplayLinesView.swift
//  Project
//
//  Created by Kevin Lin on 2017/10/30.
//  Copyright © 2017年 Kevin Lin. All rights reserved.
//

import UIKit

class DisplayLinesView: UIView, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var lines: [String] = []
    
    
    
    
    // pickers
    @IBOutlet weak var fromPicker: UIPickerView!
    @IBOutlet weak var toPicker: UIPickerView!
    
    // text fields
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 254
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        
        pickerLabel.text = lines[row]
        self.endEditing(true)
        
        pickerLabel.textColor = .darkGray
        pickerLabel.textAlignment = .center
        pickerLabel.font = UIFont(name:"Helvetica", size: 17)
        
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == fromPicker {
            self.fromTextField.text = self.lines[row]
        } else if pickerView == toPicker {
            self.toTextField.text = self.lines[row]
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
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
