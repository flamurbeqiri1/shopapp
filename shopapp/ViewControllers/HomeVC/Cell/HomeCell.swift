//
//  HomeCell.swift
//  shopapp
//
//  Created by Flamur on 6/6/16.
//  Copyright © 2016 Codeators. All rights reserved.
//

import UIKit
import Kingfisher

class HomeCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage:UIImageView!
    @IBOutlet weak var productPrice:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(obj:Product){
        
        
        if let urlStrung = obj.img{
            if let reposURL = NSURL(string: urlStrung){
                productImage.kf_setImageWithURL(reposURL)
            }
        }
        
        if let price = obj.price{
            self.productPrice.text = "\(Double(price)) €"
        }
        
        
        
    }
}
