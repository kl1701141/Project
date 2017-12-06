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
    var funcIn = ""
    var funcOut = ""
    var text = ""
    var id = ""
    
    init(device: String, line: String, funcIn: String, funcOut: String, text: String, id: String){
        self.device = device
        self.line = line
        self.funcIn = funcIn
        self.funcOut = funcOut
        self.text = text
        self.id = id
    }
}
