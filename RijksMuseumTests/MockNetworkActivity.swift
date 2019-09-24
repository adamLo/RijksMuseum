//
//  MockNetworkActivity.swift
//  RijksMuseumTests
//
//  Created by Adam Lovastyik on 13/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation

class MockNetworkActivity: NetworkActivityProtocol {
    
    private(set) var isNetworkActivityInProgress = false
    
    private var activityCount = 0
    
    func showNetworkActivityIndicator() {
        
        if activityCount == 0 {
            isNetworkActivityInProgress = true
        }
        
        activityCount += 1
    }
    
    func hideNetworkActivityIndicator() {
        
        activityCount = max(activityCount - 1, 0)
        
        if activityCount == 0 {
            isNetworkActivityInProgress = false
        }
    }
}
