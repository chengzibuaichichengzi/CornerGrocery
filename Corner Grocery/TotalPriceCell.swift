//
//  TotalPriceCell.swift
//  Corner Grocery
//
//  Created by YUAN ZHIWEN on 19/4/17.
//  Copyright © 2017 YUAN ZHIWEN. All rights reserved.
//

import UIKit

class TotalPriceCell: UITableViewCell {

    
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var checkOutButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
