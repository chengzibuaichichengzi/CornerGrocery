//
//  StatusCell.swift
//  Corner Grocery
//
//  Created by YUAN ZHIWEN on 5/5/17.
//  Copyright © 2017 YUAN ZHIWEN. All rights reserved.
//

import UIKit

class StatusCell: UITableViewCell {

    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
