//
//  Device.swift
//  Project
//
//  Created by Kevin Lin on 2017/9/6.
//  Copyright © 2017年 Kevin Lin. All rights reserved.
//

import Foundation

class Device {
    var name = ""
    var location = ""
    var imageName = ""
    var status = ""
    var Did = ""
    
    init(name: String, location: String, imageName: String, status: String, Did: String) {
        self.name = name
        self.location = location
        self.imageName = imageName
        self.status = status
        self.Did = Did
    }
}
