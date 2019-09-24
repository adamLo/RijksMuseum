//
//  NetworkURLSession.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 10/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation
import Reachability

/*!
 * @brief Network session implementation to handle real-life connection
 */
class NetworkURLSession: NetworkSessionProtocol {
    
    static let shared = NetworkURLSession()
    
    private let hostReachability: Reachability?
    
    init() {
        
        hostReachability = Reachability(hostname: Network.Configuration.hostName)
        
        if hostReachability != nil {
            do {
                try hostReachability!.startNotifier()
                hostReachability!.whenReachable = { _ in
                    NetworkOperationQueue.shared.startPendingCalls()
                }
            }
            catch let error {
                print("Error starting reachability: \(error)")
            }
        }
    }
    
    private lazy var session: URLSession = {
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: Network.shared, delegateQueue: nil)
        return session
    }()
    
    func startDataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) {
        
        let task = session.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
    
    var isServerReachable: Bool {
        
        if let _reachability = hostReachability, _reachability.connection != .none {
            return true
        }
        return false
    }
}
