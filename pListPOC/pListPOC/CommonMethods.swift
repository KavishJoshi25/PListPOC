//
//  CommonMethods.swift
//  pListPOC
//
//  Created by Kavish joshi on 20/01/18.
//  Copyright © 2018 Kavish joshi. All rights reserved.
//

import Foundation
import UIKit

class CommonMethods:NSObject {
    
    static func showAlert(_ alertTitle: String, alertSubtitle: String, viewController:UIViewController) {
        
        
        let alert = UIAlertController(title: alertTitle, message: alertSubtitle, preferredStyle: UIAlertControllerStyle.alert);
        let dismissAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
        alert.addAction(dismissAction);
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        
        let messageText = NSMutableAttributedString(
            string: alertSubtitle,
            attributes: [
                NSAttributedStringKey.paragraphStyle: paragraphStyle
            ]
        )
        
        alert.setValue(messageText, forKey: "attributedMessage")
        viewController.present(alert, animated: true, completion: nil)
        
    }
}


