//
//  ArtSearchView.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 12/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import UIKit

/*!
 * @brief Holds search components on collections screen
 */
class ArtSearchView: UICollectionReusableView {
    
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var queryTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    
    static let reuseId = "searchView"
    
    /// Called when user enters search query in input field and touches search or cancel
    var queryBlock: ((_ query: String?) -> ())?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        searchLabel.text = Localizations.artSearchTitle
        searchLabel.font = UIFont.defaultFont(style: .regular, size: .base)
        
        queryTextField.attributedPlaceholder = NSAttributedString(string: Localizations.artSearchPlaceholder, attributes: [
            NSAttributedString.Key.font: UIFont.defaultFont(style: .regular, size: .base),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ])
        queryTextField.font = UIFont.defaultFont(style: .regular, size: .base)
        
        cancelButton.setTitle(Localizations.cancelButtonTitle, for: .normal)
        cancelButton.titleLabel?.font = UIFont.defaultFont(style: .medium, size: .base)
    }
        
    @IBAction func queyDidEndOnExit(_ sender: UITextField) {
        
        if let text = sender.text {
            
            let _query = text.trimmingCharacters(in: .whitespacesAndNewlines)
            if !_query.isEmpty {
                queryBlock?(_query)
            }
        }
    }
    
    @IBAction func queryEditingChanged(_ sender: UITextField) {
        
        if sender.text?.isEmpty ?? true {
            queryBlock?(nil)
        }
    }
    
    @IBAction func cancelTouched(_ sender: Any) {
        
        queryTextField.text = nil
        queryTextField.resignFirstResponder()
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        queryBlock = nil
    }
}
