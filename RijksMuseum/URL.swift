//
//  URL.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 10/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation

/*!
 * @brief Extension on URL to help with parameters
 */
extension URL {
    
    /*!
     * @brief Appends a query item to the url
     *
     * @param name Query item name
     * @param value Query item value
     *
     * @return URL with new item appended
     */
    func appendQueryItem(with name: String, value: String) -> URL {
        
        let queryItem = URLQueryItem(name: name, value: value)
        
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        if urlComponents.queryItems != nil {
            urlComponents.queryItems?.append(queryItem)
        }
        else {
            urlComponents.queryItems = [queryItem]
        }
        
        let url = urlComponents.url!
        
        return url
    }
}
