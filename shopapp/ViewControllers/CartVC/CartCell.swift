//
//  CartCell.swift
//  shopapp
//
//  Created by Flamur on 6/13/16.
//  Copyright © 2016 Codeators. All rights reserved.
//

import UIKit

protocol DeleteItemDelegate:NSObjectProtocol{
    func deleteItem(cell:CartCell)
}

class CartCell: UITableViewCell {

    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    weak var deleteProductDelegate:DeleteItemDelegate? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func deleteProduct(sender: AnyObject) {
        deleteProductDelegate?.deleteItem(self)
    }
}
