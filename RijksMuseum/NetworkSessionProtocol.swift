//
//  NetworkSessionProtocol.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 10/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation

typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

/*!
 * @brief Protool to define Network session. Can be real NSURLSession or mock for testing
 */
protocol NetworkSessionProtocol {
    
    /*!
     * @brief Starts a data task to retrieve data from given URL request
     *
     * @param request Preconfigured URL request
     * @param completionhandler Competion Handler
     */
    func startDataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult)

    /// Tells whether API host is reachable (device connected to network)
    var isServerReachable: Bool {get}    
}
