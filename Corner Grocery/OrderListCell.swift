//
//  OrderListCell.swift
//  Corner Grocery
//
//  Created by YUAN ZHIWEN on 5/5/17.
//  Copyright © 2017 YUAN ZHIWEN. All rights reserved.
//

import UIKit

class OrderListCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
