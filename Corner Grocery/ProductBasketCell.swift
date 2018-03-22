//
//  ProductBasketCell.swift
//  Corner Grocery
//
//  Created by YUAN ZHIWEN on 19/4/17.
//  Copyright © 2017 YUAN ZHIWEN. All rights reserved.
//

import UIKit

class ProductBasketCell: UITableViewCell {
    
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var minusButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
