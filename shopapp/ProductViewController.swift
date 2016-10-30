//
//  ProductViewController.swift
//  shopapp
//
//  Created by Flamur on 6/7/16.
//  Copyright © 2016 Codeators. All rights reserved.
//

import UIKit
import Alamofire
import MagicalRecord

class ProductViewController: UIViewController {

    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var productTax2: UILabel!
    @IBOutlet weak var productimageview: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var productQuantity: UILabel!
    
    var basePrice:Double!
    var tax:Int32!
    var quantity:Int = 1;
    
    var productObj:Product!
    var totalProductPrice:Double!
    
    
    @IBAction func stpperValueChanged(sender: UIStepper) {
        productQuantity.text = "\(Int(sender.value))"
        
        self.quantity = Int(sender.value)
      
        let tax = Double(self.tax!)
        totalProductPrice = calculatePriceWithTax(basePrice!, TaxValue: tax, Quantity: sender.value)
        totalPrice.text = "\(totalProductPrice) €"
     
    }
    
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //stepper options
        stepper.wraps = true
        stepper.autorepeat = true
        getTax()
       
        
    }
    
    @IBAction func addToCart(sender: AnyObject) {
        
        let newProduct = CartProducts.MR_createEntity()
        newProduct?.id = productObj.productID
        newProduct?.name = productObj.name
        newProduct?.img = productObj.img
        newProduct?.price = totalProductPrice
        newProduct?.quantity = self.quantity
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()// save to core data
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        //to do
        let cartViewController = mainStoryboard.instantiateViewControllerWithIdentifier("CartVC") as! CartVC
        self.navigationController?.pushViewController(cartViewController, animated: true)
       
   
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let price = productObj.price{
            self.productPrice.text = "\(price) €"
            self.basePrice = Double(price)
        }
        if let urlString = productObj.img{
            if let reposURL = NSURL(string: urlString){
                productimageview.kf_setImageWithURL(reposURL)
            }
        }
    }
    
    // MARK: - API Call Method
    func getTax(){
        let path = NSString(format: "%@/%@", baseURLString, "get-tax-and-currency.php")
        let url = NSURL(string: path as String)
        
         Alamofire.request(.GET, url!, parameters: ["accesskey":12345]).responseJSON { (request, response, result) in
            let json = result.value as! [String:AnyObject]
            let data = json["data"] as! [AnyObject]

            let taxnCurrency = data[0]["tax_n_currency"] as! NSDictionary
            print(taxnCurrency)
            
            if let tax = taxnCurrency["Value"]?.intValue{
                self.productTax2.text = "\(tax) %"
                self.tax = tax
            }
            let quantity:Double = 1.0
            let tax = Double(self.tax!)
            self.totalProductPrice = self.calculatePriceWithTax(self.basePrice!, TaxValue: tax, Quantity: quantity)
            self.totalPrice.text = "\(self.totalProductPrice) €"
        }
    }
    
    // MARK: - Calculate Tax
    func calculatePriceWithTax (ProductPrice: Double, TaxValue: Double, Quantity: Double) ->Double{
        let salesTax = ProductPrice * (TaxValue / 100)
        let finalPrice = (ProductPrice + salesTax) * Quantity
        
        return finalPrice
    }


}
