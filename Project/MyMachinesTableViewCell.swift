//
//  MyMachinesTableViewCell.swift
//  Project
//
//  Created by Kevin Lin on 2017/12/7.
//  Copyright © 2017年 Kevin Lin. All rights reserved.
//

import UIKit

class MyMachinesTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
