//
//  Message.swift
//  Project
//
//  Created by Kevin Lin on 2017/9/21.
//  Copyright © 2017年 Kevin Lin. All rights reserved.
//

import Foundation

class Message {
    var device = ""
    var line = ""
    var displayTime = ""
    var funcIn = ""
    var funcOut = ""
    var text = ""
    var color = ""
    
    init(device: String, line: String, displayTime: String, funcIn: String, funcOut: String, text: String, color: String){
        self.device = device
        self.line = line
        self.displayTime = displayTime
        self.funcIn = funcIn
        self.funcOut = funcOut
        self.text = text
        self.color = color
    }
}
