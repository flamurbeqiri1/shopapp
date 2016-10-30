//
//  LeftNavVC.swift
//  shopapp
//
//  Created by Flamur on 6/6/16.
//  Copyright © 2016 Codeators. All rights reserved.
//

import UIKit
import Alamofire
import MagicalRecord


class LeftNavVC: UITableViewController {
    
    var productList = [Product]()
    var menuItems:[Categories]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.menuItems = Categories.MR_findAll() as! [Categories]
        
        if menuItems.count == 0{
            
            getCategories()
        }
        navigationController?.navigationBar.translucent = false
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuItems.count + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("leftCell") as! LeftNavCell
        
        if indexPath.row == 0{
            cell.categoryLabel.text = "All Products"
            
        }else{
            
            let index = indexPath.row - 1
            let obj = self.menuItems[index]
            
            if let name = obj.name{
                
                cell.categoryLabel.text = name
            }
        }
        return cell
    }
    
    override  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeVC") as! HomeVC
        if indexPath.row != 0{
            let index = indexPath.row - 1
            let obj = menuItems[index]
            
            
            
            centerViewController.categoryId = obj.id
            centerViewController.get_all_product = false
            
        }else{
            
            centerViewController.categoryId = -1
            centerViewController.get_all_product = false
            
            
        }
        
        
        let centerNavController = UINavigationController(rootViewController: centerViewController)
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.centerViewController = centerNavController
        appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
        
    }
    
    //MARK: api call
    func getCategories(){
        
        let url = String(format: "%@/%@", baseURLString,"get-all-category-data.php")
        
        
        Alamofire.request(.GET, url, parameters: ["accesskey":12345]).responseJSON { (request, response, result) in
            
            Categories.MR_truncateAll()// per me fshi shenime ne cd
            
            
            let json = result.value as! [String:AnyObject];
            
            let data = json["data"] as! [AnyObject];
            
            
            for i in 0 ..< data.count {
                
                let json = data[i]["Category"] as! NSDictionary
                
                let category = Categories.MR_createEntity()! as Categories
                
                if let id = json["Category_ID"]?.intValue{
                    category.id = Int(id)
                }
                
                print(json["Category_name"]!)
                if let name = json["Category_name"]{
                    category.name = name as? String
                }
                
                
                //self.tableView.reloadData()
                
            }
            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
            
        }
    }
    
    
    func getCategoryById(id:NSNumber){
        
        let parammeters = ["accesskey":12345,"category_id":id];
        
        let path = NSString(format: "%@/%@", baseURLString,"get-menu-data-by-category-id.php")
        let url = NSURL(string: path as String)
        Alamofire.request(.GET, url!, parameters: parammeters).responseJSON { (request, response, result) in
            
            // print(result.value)
            // Products.MR_truncateAll()
            
            let data = result.value as! [String:AnyObject]
            
            let mm = data["data"] as! [AnyObject]
            
            for i in 0 ..< mm.count {
                
                let json = mm[i]["Menu"] as! NSDictionary
                
                
                // let product:Products = Products.MR_createEntity()! as Products
                
                let obj = Product()
                
                if let image = json["Menu_image"]{
                    let  imgPath = String(format: "%@/%@",imageURLString,image as! String)
                    obj.img = imgPath
                }
                
                if let price = json["Price"]?.intValue{
                    obj.price = Int32(price)
                }
                
                
                
                self.productList.append(obj)
            }
            // NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()//
            // self.productList = Products.MR_findAll() as! [Products]
            
            
            
            
        }
    }
    
    
    
    
}