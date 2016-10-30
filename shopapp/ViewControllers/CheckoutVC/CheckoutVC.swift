//
//  CheckoutVC.swift
//  shopapp
//
//  Created by Flamur on 6/13/16.
//  Copyright © 2016 Codeators. All rights reserved.
//

import UIKit
import Alamofire

class CheckoutVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var txtPhoneNr: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtCommentField: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    var productList:[CartProducts]!
    var productAndQuantity = "";
    
    var obj:UserDetails!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productList = CartProducts.MR_findAll() as? [CartProducts]
        
        for i in 0 ..< productList.count{
            productAndQuantity += "\(productList[i].name!) \(productList[i].price!)x\(productList[i].quantity!), "
        }
        setDelegatesOfTextFields()
        self.navigationController?.navigationBar.translucent = true
        obj = UserDetails()
        
    }
    //custom func :P
    func setDelegatesOfTextFields(){
        
        self.txtName.delegate = self
        self.txtCity.delegate = self
        self.txtZip.delegate = self
        self.txtPhoneNr.delegate = self
        self.txtEmail.delegate = self
        self.txtAddress.delegate = self
        self.txtCommentField.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickCheckOut(sender: AnyObject) {
        
        if(txtName.text != "" && txtName.text != nil){
            obj.name = txtName.text
        }
        else{
            self.showErrorAlert("Required Field",message: "Yor Name is required")
            return
            
        }
        if(txtAddress.text != "" && txtAddress.text != nil){
            obj.address = txtAddress.text
        }
        else{
            self.showErrorAlert("Required Field",message: "Yor Address is required")
            return
        }
        if(txtCity.text != "" && txtCity.text != nil){
            obj.city = txtCity.text
        }
        else{
            self.showErrorAlert("Required Field",message: "Your City is required")
            return
        }
        if(txtZip.text != "" && txtZip.text != nil){
            obj.zipp = txtZip.text
        }
        else{
            self.showErrorAlert("Required Field",message: "Your Zip is required")
            return
        }
        if(txtPhoneNr.text != "" && txtPhoneNr != nil ){
            obj.phoneNr = txtPhoneNr.text
        }
        else{
            self.showErrorAlert("Required Field",message: "Your Phone number is required")
            return
        }
        if(txtEmail.text != "" && txtEmail != nil){
            let email:NSString = txtEmail.text!
            
            if email.isValidEmail(){
                obj.email = email as String
            }else{
                self.showErrorAlert("Required", message: "Must be an email")
                txtEmail.becomeFirstResponder()
                return
            }
        }
        else{
            self.showErrorAlert("Required Field",message: "Your Email is required")
            return
        }
        if(txtCommentField.text != "" && txtCommentField.text != nil){
            obj.orderList = self.productAndQuantity
            obj.comment = txtCommentField.text
        }else{
            self.showErrorAlert("Required Field",message: "You must type a comment")
            return
        }
        
        saveData()
    }

    
    func saveData(){

        let url = String(format: "%@/%@", baseURLString,"add-reservation.php")
        let parameters = [
            "accesskey":"12345",
            "name":obj.name!,
            "address":obj.address!,
            "city":obj.city!,
            "zip":obj.zipp!,
            "phone":obj.phoneNr,
            "order_list":productAndQuantity,
            "comment":obj.comment!,
            "email":obj.email!];
        
        Alamofire.request(.GET, url, parameters: parameters)
            .responseJSON { _, _, result in
                print(result)
                debugPrint(result)
                self.emptyFields()
                self.showAlert("Success", message: "Your Order is received, Thank you")
                CartProducts.MR_truncateAll()
        }
    }
}
extension CheckoutVC:UITextFieldDelegate{
    func textFieldDidBeginEditing(textField: UITextField) {
        var offset:CGPoint = CGPoint(x: 0, y: 0)
        
        if textField.tag == 0{
            offset = CGPoint(x: 0, y: 0)
        }
        if textField.tag == 1{
            offset = CGPoint(x: 0, y: 0)
        }
        if textField.tag == 2{
            offset = CGPoint(x: 0, y: 0)
        }
        if textField.tag == 3{
            offset = CGPoint(x: 0, y: 0)
        }
        if textField.tag == 4{
            offset = CGPoint(x: 0, y: 20)
        }
        if textField.tag == 5{
            offset = CGPoint(x: 0, y: 0)
        }
        if textField.tag == 6{
            offset = CGPoint(x: 0, y: 0)
        }
        scrollView.setContentOffset(offset, animated: true)
        
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    //MARK: Alert
    func showAlert(title: String,message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let doneAction = UIAlertAction(title: "ok", style: .Cancel) { (alert) -> Void in
            let homeScreen = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = homeScreen.instantiateViewControllerWithIdentifier("HomeVC") as! HomeVC
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
        alert.addAction(doneAction)
        navigationController?.presentViewController(alert, animated: true, completion: nil)
    }
    func showErrorAlert(title: String,message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let doneAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(doneAction)
        navigationController?.presentViewController(alert, animated: true, completion: nil)
    }
    //MARK: empty fields
    
    func emptyFields(){
        txtName.text = ""
        txtAddress.text = ""
        txtCity.text = ""
        txtZip.text = ""
        txtEmail.text = ""
        txtPhoneNr.text = ""
        txtCommentField.text = ""
        
    }
}



















