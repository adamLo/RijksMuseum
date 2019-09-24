//
//  Date.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 12/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation

/*!
 * @brief Extension to help date manipulations
 */
extension Date {
    
    static let oneDayInterval: TimeInterval = 24 * 60 * 60
    
    /// Returns start of day (00:00:00)
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    /// Returns end of day (23:59:59)
    var endOfDay: Date {
        return self.startOfDay.nextDay.addingTimeInterval(-1)
    }
    
    /// Returns next day same time
    var nextDay: Date {
        return self.addingTimeInterval(Date.oneDayInterval)
    }
}
