//
//  UserInfoTableViewCell.swift
//  Corner Grocery
//
//  Created by YUAN ZHIWEN on 8/5/17.
//  Copyright © 2017 YUAN ZHIWEN. All rights reserved.
//

import UIKit


class UserInfoTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
