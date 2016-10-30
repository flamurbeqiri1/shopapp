//
//  Category.swift
//  shopapp
//
//  Created by Flamur on 6/11/16.
//  Copyright © 2016 Codeators. All rights reserved.
//

import UIKit

class Product{

    var productID:Int?
    var name:String?
    var img:String?
    var price:Int32?
    
    
    init(id:Int,name:String,img_url:String,price:Int32){
        self.productID = id
        self.name = name
        self.img = img_url
        self.price = price
    }
    init(){
        
    }
}
