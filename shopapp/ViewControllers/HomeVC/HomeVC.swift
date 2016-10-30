//
//  HomeVC.swift
//  shopapp
//
//  Created by Flamur on 6/6/16.
//  Copyright © 2016 Codeators. All rights reserved.
//

import UIKit
import Alamofire
import MagicalRecord

class HomeVC: UIViewController {
    @IBOutlet weak var collectionView:UICollectionView!
    var productArr = [Product]()
    var categoryId:NSNumber!
    var get_all_product = true;
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        
        let logo = UIImage(named: "shopapp.jpg")
        let imageView = UIImageView(image:logo)
       
        imageView.frame.size = CGSize(width: 90, height: 40)
        //self.navigationItem.titleView = imageView
        self.navigationItem.title = "Shop app"
        // Do any additional setup after loading the view.
        
        if let catID = categoryId{
            self.productArr = []
            if catID.intValue == -1{
                
                self.getAllProducts()
            }
            else{
                
                self.getProductsById(catID)
                
            }
        }
        if get_all_product{
            self.productArr = []
            getAllProducts()
        }
        
        

    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        dispatch_async(dispatch_get_main_queue(), {
            self.collectionView.reloadData()
        })
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone:
            if UIDevice.currentDevice().orientation.isLandscape.boolValue {
                collectionView.adaptBeautifulGrid(3,gridLineSpace: CGFloat(5))
            } else {
                collectionView.adaptBeautifulGrid(2,gridLineSpace: CGFloat(5))
            }
            
        case .Pad:
            if UIDevice.currentDevice().orientation.isLandscape.boolValue {
                collectionView.adaptBeautifulGrid(4,gridLineSpace: CGFloat(5))
            } else {
                collectionView.adaptBeautifulGrid(3,gridLineSpace: CGFloat(5))
            }
            
            
        case .Unspecified:
            collectionView.adaptBeautifulGrid(2,gridLineSpace: CGFloat(5))
            
        default:
            collectionView.adaptBeautifulGrid(2,gridLineSpace: CGFloat(5))
        }
        
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
            collectionView.adaptBeautifulGrid(3,gridLineSpace: CGFloat(5))
        } else {
            print("Portrait")
        }
    }
    
    //MARK: API Call Method
    func getAllProducts(){
        let path = NSString(format: "%@/%@", baseURLString,"get-all-products.php")
        let url = NSURL(string: path as String)
        Alamofire.request(.GET, url!, parameters: ["accesskey":12345]).responseJSON { (request, response, result) in
            
           
            
            let data = result.value as! [String:AnyObject]
            
            let mm = data["data"] as! [AnyObject]
            
            for i in 0 ..< mm.count {
                
                let obj = Product()
                
                let json = mm[i]["Menu"] as! NSDictionary
                
                
                if let image = json["Menu_image"]{
                    let  imgPath = String(format: "%@/%@",imageURLString,image as! String)
                    
                    obj.img = imgPath
                }
                
                if let price = json["Price"]?.intValue{
                    obj.price = Int32(price)
                }
                if let name = json["Menu_name"]{
                    obj.name = name as? String
                }
                
                self.productArr.append(obj)
            }
            
            
        }
        
    }
    
    
    
    
    func getProductsById(id:NSNumber){
        
        let parammeters = ["accesskey":12345,"category_id":id];
        
        let path = NSString(format: "%@/%@", baseURLString,"get-menu-data-by-category-id.php")
        let url = NSURL(string: path as String)
        Alamofire.request(.GET, url!, parameters: parammeters).responseJSON { (request, response, result) in
            
            
            
            let data = result.value as! [String:AnyObject]
            
            let mm = data["data"] as! [AnyObject]
            
            for i in 0 ..< mm.count {
                
                let json = mm[i]["Menu"] as! NSDictionary
                
                let obj = Product()
                
                if let image = json["Menu_image"]{
                    let  imgPath = String(format: "%@/%@",imageURLString,image as! String)
                    obj.img = imgPath
                }
                
                if let price = json["Price"]?.intValue{
                    obj.price = Int32(price)
                }
                if let name = json["Menu_name"]{
                    obj.name = name as? String
                }
                
                self.productArr.append(obj)
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.collectionView.reloadData()
            })
            
        }
        
    }

    
    //MARK: Storyboard methods
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetails"{
            
            let obj = sender as! Product
            let vc = segue.destinationViewController as! ProductViewController
            vc.productObj = obj   
        }
    }
    
    
    
}

//MARK: Collection View Methods
extension HomeVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  productArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! HomeCell
        
        let obj = productArr[indexPath.row]
        cell.configureCell(obj)
        
        
        
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let obj = self.productArr[indexPath.row]
        print(obj.price)
        self.performSegueWithIdentifier("showDetails", sender: obj)
    }
    @IBAction func openLeftMenu(sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    @IBAction func openRightMenu(sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
    }
}
