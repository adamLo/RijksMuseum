//
//  URLRequest.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 10/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation

/*!
 * @brief Encapsulates http call methods
 */
public enum HTTPMethod: String {
    
    case post   = "POST"
    case patch  = "PATCH"
    case get    = "GET"
    case delete = "DELETE"
}

/*!
 * @brief Extension to help configuring URL requests
 */
extension URLRequest {
    
    /*!
     * @brief Configure URL request
     *
     * @param method HTTP method
     * @param data HTTP call body data
     * @param jsonContentType True if sending and expecting data in JSON format
     */
    mutating func configure(method: HTTPMethod, data: Data? = nil, jsonContentType: Bool = true) {
        
        httpMethod = method.rawValue
        
        if jsonContentType {
            addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        addValue("application/json", forHTTPHeaderField: "Accept")
                
        httpBody = data
    }
}
