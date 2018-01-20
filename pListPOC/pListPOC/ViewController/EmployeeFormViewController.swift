//
//  EmployeeFormViewController.swift
//  pListPOC
//
//  Created by Kavish joshi on 20/01/18.
//  Copyright © 2018 Kavish joshi. All rights reserved.
//

import Foundation
import UIKit

protocol updatePListDelegate {
    func refreshPList(data:NSMutableDictionary)
}

class EmployeeFormViewController: UIViewController {
    
    let outerView = UIView()
    internal var pListUpdatedelegate: updatePListDelegate?

    var updatePListObj = NSMutableDictionary()

    
    var fullName = ""
    var mobileNum = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initalizeUiComponents()
    }
    
    //Mark:initalizeUiComponents
    func initalizeUiComponents(){
        
        //add title to navigation bar
        self.navigationItem.title = "Employee Form"
        
        //outerView
        view.addSubview(outerView);
        outerView.translatesAutoresizingMaskIntoConstraints = false;
        outerView.backgroundColor = .clear
        NSLayoutConstraint.activate([outerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),outerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),outerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10),outerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5) ]);
        
        
        //fullName TextField
        let fullNameTf = self.returnCustomUITextFields(placeHolder: "Full Name", withtag: 1);
        outerView.addSubview(fullNameTf);
        fullNameTf.translatesAutoresizingMaskIntoConstraints = false;
        NSLayoutConstraint.activate([fullNameTf.topAnchor.constraint(equalTo: outerView.topAnchor, constant: 15),fullNameTf.leftAnchor.constraint(equalTo: outerView.leftAnchor, constant: 5),fullNameTf.widthAnchor.constraint(equalTo: outerView.widthAnchor, constant: -10),fullNameTf.heightAnchor.constraint(equalToConstant: 50) ]);
        
        //mobNumber TextField
        let mobNumberTf = self.returnCustomUITextFields(placeHolder: "Mobile Number", withtag: 2);
        outerView.addSubview(mobNumberTf);
        mobNumberTf.translatesAutoresizingMaskIntoConstraints = false;
        NSLayoutConstraint.activate([mobNumberTf.topAnchor.constraint(equalTo: fullNameTf.bottomAnchor, constant: 10),mobNumberTf.leftAnchor.constraint(equalTo: fullNameTf.leftAnchor, constant: 0),mobNumberTf.widthAnchor.constraint(equalTo: fullNameTf.widthAnchor, constant: 0),mobNumberTf.heightAnchor.constraint(equalToConstant: 50) ]);
        
        
        let submitBtn = self.returnCustomButton(title: "Submit");
        outerView.addSubview(submitBtn);
        submitBtn.addTarget(self, action: #selector(submitBtnBtnPressed), for: .touchUpInside)
        
        submitBtn.translatesAutoresizingMaskIntoConstraints = false;
        NSLayoutConstraint.activate([submitBtn.centerXAnchor.constraint(equalTo: outerView.centerXAnchor, constant: 0),submitBtn.centerYAnchor.constraint(equalTo: outerView.centerYAnchor, constant: 0),submitBtn.widthAnchor.constraint(equalToConstant: 60),submitBtn.heightAnchor.constraint(equalToConstant: 40)]);
    }
    
    //Mark:submitBtnBtnPressed
    @objc func submitBtnBtnPressed(){
        
        self.view.endEditing(true)
        let fields = validTextFields()
        if !fields.isEmpty {
            CommonMethods.showAlert("Please correct the following fields and try again:\n", alertSubtitle: fields, viewController: self)
            
            return
        }
        else{
            
            let pListData = NSMutableDictionary()
            pListData.setValue(fullName, forKey: "FullName")
            pListData.setValue(mobileNum, forKey: "MobileNum")
            pListUpdatedelegate?.refreshPList(data: pListData)
            navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    //Mark:returnCustomButton
    func returnCustomButton(title:String) -> UIButton {
        let customButton = UIButton()
        customButton.setTitle(title, for: .normal)
        customButton.setTitleColor(.black, for: .normal)
        customButton.backgroundColor  = .blue
        
        return customButton
    }
    
    
    //Mark: Custom UITextfields
    func returnCustomUITextFields(placeHolder:String,withtag:Int) -> UITextField {
        
        let customTextBox = UITextField()
        customTextBox.delegate = self
        customTextBox.autocorrectionType = .no
        customTextBox.tintColor = .white
        customTextBox.textColor = .white
        customTextBox.backgroundColor = .blue
        customTextBox.placeholder =  placeHolder
        customTextBox.tag = withtag
        
        //Name
        if withtag == 1 {
            
            if (updatePListObj.count  > 0){
                customTextBox.text = updatePListObj.value(forKey: "FullName") as? String
                fullName = (updatePListObj.value(forKey: "FullName") as? String)!
            }
            
        }//Number
        else if withtag == 2{
            customTextBox.keyboardType = UIKeyboardType.numberPad
            if (updatePListObj.count  > 0){
                customTextBox.text = updatePListObj.value(forKey: "MobileNum")  as? String
                mobileNum = (updatePListObj.value(forKey: "MobileNum")  as? String)!
            }
        }
        
        return customTextBox
        
    }
    
    func validTextFields() -> String {
        var errors = ""
        
        if fullName.isEmpty {
            errors += "Full Name" + " \n"
        }
        
        if mobileNum.isEmpty {
            errors += "Mobile" + " \n"
        }
        
        return errors
    }
    
}

//Mark:Textfield delegate methods
extension EmployeeFormViewController:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
     if (textField.tag == 2){
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
        }
        else{
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if  textField.tag == 1{
            fullName = textField.text!
        }
        else if(textField.tag == 2){
            mobileNum = textField.text!
        }
    }
    
}
    

