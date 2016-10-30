//
//  CartVC.swift
//  shopapp
//
//  Created by Flamur on 6/13/16.
//  Copyright © 2016 Codeators. All rights reserved.
//

import UIKit
import MagicalRecord

class CartVC: UIViewController, UITableViewDelegate, UITableViewDataSource, DeleteItemDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var productList:[CartProducts]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Your Cart"
        getDataFromDB()
        // Do any additional setup after loading the view.
    }
    
    
    
    func getDataFromDB(){
        productList = CartProducts.MR_findAll() as? [CartProducts]
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cartCell", forIndexPath: indexPath) as! CartCell
        
        cell.deleteProductDelegate = self
        
        let obj = productList[indexPath.row]
        
        if let name = obj.name{
            cell.productName.text = name
        }
        if let price = obj.price{
            cell.productPrice.text = "\(Double(price)) €";
        }
        if let img = obj.img{
            if let reposURL = NSURL(string: img){
                cell.imgProduct.kf_setImageWithURL(reposURL)
            }
        }
        if let quantity = obj.quantity{
            cell.productQuantity.text = "Quantity: \(quantity)"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func deleteItem(cell: CartCell) {
        
        let alertToDelete: UIAlertController = UIAlertController(title: "Delete", message: "Are you sure to delete this product from Cart", preferredStyle: .Alert)
        let indexPath = self.tableView.indexPathForCell(cell)! as NSIndexPath
        
        let alertAction = UIAlertAction(title: "Yes", style: .Default) { (UIAlertAction) -> Void in
            
            let index = indexPath.row
            let obj = self.productList[index] as CartProducts
            
            
            obj.MR_deleteEntity()
            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
            
            
            self.productList.removeAtIndex((indexPath.row))
            self.tableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertToDelete.addAction(cancelAction)
        alertToDelete.addAction(alertAction)
        
        self.navigationController?.presentViewController(alertToDelete, animated: true, completion: nil)
        self.tableView.reloadData()
        
    }
    
    @IBAction func onClickPlaceOrder(sender: UIButton) {
        
        if(productList.count > 0){
            let checkout = UIStoryboard(name: "Main", bundle: nil)
            let checkouotVC = checkout.instantiateViewControllerWithIdentifier("CheckoutVC") as! CheckoutVC
            
            self.navigationController?.pushViewController(checkouotVC, animated: true)
        }
        else{
            showAlert("Cart is empty, nothing to order!")
        }
        
    }
    
    //MARK: Alert
    func showAlert(message: String){
        let alert = UIAlertController(title: "Failed", message: message, preferredStyle: .Alert)
        
        let doneAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        
        alert.addAction(doneAction)
        
        navigationController?.presentViewController(alert, animated: true, completion: nil)
    }
    
}
