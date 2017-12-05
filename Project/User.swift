//
//  User.swift
//  Project
//
//  Created by Kevin Lin on 2017/10/13.
//  Copyright © 2017年 Kevin Lin. All rights reserved.
//

import Foundation

class User {
    var account = ""
    var UID = ""
    var loginTime = ""
    var devices = ""
    var token = ""
    
    init(account: String, UID: String, loginTime: String, devices: String, token: String) {
        self.account = account
        self.UID = UID
        self.loginTime = loginTime
        self.devices = devices
        self.token = token
    }
}
