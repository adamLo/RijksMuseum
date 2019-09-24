//
//  AlertDialogs.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 12/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation
import UIKit

/*!
 * @brief Extension to help view controllers displaying simple dialogs
 */
extension UIViewController {
    
    /*!
     * @brief Show a simple dialof with an OK button. Used to display errors
     *
     * @param message Message to dsplay
     * @param title Optional dialog title
     *
     * @return True if session removed
     */
    func showOKDialog(message: String, title: String? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Localizations.okButtonTitle, style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
