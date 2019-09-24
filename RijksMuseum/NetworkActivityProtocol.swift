//
//  NetworkActivityProtocol.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 10/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation

/*!
 * @brief Protocol to hep showing and hiding network activity. Can be implemented by UIApplication or mock for testing
 */
protocol NetworkActivityProtocol {
    
    func showNetworkActivityIndicator()
    func hideNetworkActivityIndicator()
}
