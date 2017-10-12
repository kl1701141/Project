//
//  User.swift
//  Project
//
//  Created by Kevin Lin on 2017/10/13.
//  Copyright © 2017年 Kevin Lin. All rights reserved.
//

import Foundation

class User {
    var name = ""
    var UID = ""
    var loginTime = ""
    var devices = ""
    
    init(name: String, UID: String, loginTime: String, devices: String) {
        self.name = name
        self.UID = UID
        self.loginTime = loginTime
        self.devices = devices
    }
}
