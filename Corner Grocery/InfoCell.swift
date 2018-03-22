//
//  InfoCell.swift
//  Corner Grocery
//
//  Created by YUAN ZHIWEN on 30/5/17.
//  Copyright © 2017 YUAN ZHIWEN. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var myLabel: UILabel!
    @IBOutlet var arrowImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
