//
//  Localizations.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 12/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

/*!
 * @brief Encapsulates localized copies
 */
import Foundation

    public struct Localizations {
        
        static let mainTitle            = NSLocalizedString("RijksMuseum", comment: "Main title")
        static let agendaTitle          = NSLocalizedString("Agenda", comment: "Agenda tab title")
        static let collectionsTitle     = NSLocalizedString("Collections", comment: "Collections title")
        
        static let expositionTypeTitle  = NSLocalizedString("Type: ", comment: "Exposition type title on agenda cell")
        static let groupTypeTitle       = NSLocalizedString("Groups: ", comment: "Group type title on agenda cell")
        static let periodTitle          = NSLocalizedString("Period: ", comment: "Period title on agenda cell")
        static let PriceTitle           = NSLocalizedString("Ticket price: ", comment: "Price title on agenda cell")
        
        static let dateStaticTitle      = NSLocalizedString("Date: ", comment: "Date title on agenda screen")
        static let datePickerTitle      = NSLocalizedString("Select date", comment: "Date selector title")
        
        static let okButtonTitle        = NSLocalizedString("OK", comment: "OK button title")
        static let cancelButtonTitle    = NSLocalizedString("Cancel", comment: "Cancel button title")
        
        static let artSearchTitle       = NSLocalizedString("Search:", comment: "Search title on collections screen")
        static let artSearchPlaceholder = NSLocalizedString("Enter artist or title", comment: "Seatrch placeholder on collections screen")
        
        static let offlineTitle         = NSLocalizedString("Your device seems offline", comment: "Network status title when offline")
    }
