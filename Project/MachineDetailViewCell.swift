//
//  MachineDetailViewCell.swift
//  Project
//
//  Created by Kevin Lin on 2017/9/5.
//  Copyright © 2017年 Kevin Lin. All rights reserved.
//

import UIKit

class MachineDetailViewCell: UITableViewCell {

    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
