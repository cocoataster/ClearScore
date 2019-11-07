//
//  Utils.swift
//  ClearScore
//
//  Created by Eric Sans Alvarez on 03/11/2019.
//  Copyright © 2019 Eric Sans Alvarez. All rights reserved.
//

import UIKit

class Utils {
    
    // Prompt user with informative alert
    
    open class func showError(_ type: ErrorType, message: String? = nil, in controller: UIViewController) {
        var title = ""
        
        switch type {
        case .network:
            title = "Network Error"
        case .parsing:
            title = "Parsing Error"
        case .unknown:
            title = "Unexpected Error"
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        
        controller.present(alertController, animated: true)
    }
}
