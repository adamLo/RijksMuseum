//
//  MockNetworkURLSession.swift
//  RijksMuseumTests
//
//  Created by Adam Lovastyik on 13/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation

class MockNetworkURLSession: NetworkSessionProtocol {
    
    let loader = JSONLoader()

    func startDataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) {
        
        var data: Data?
        
        if let url = request.url?.absoluteURL {
            
            if request.httpMethod == HTTPMethod.get.rawValue && url.pathComponents.count > 2, url.pathComponents[url.pathComponents.count - 2] == Network.Configuration.agenda {
                data = loader.load(jsonFile: "agendas")
            }
            if request.httpMethod == HTTPMethod.get.rawValue && url.lastPathComponent == Network.Configuration.collecton {
                data = loader.load(jsonFile: "artobjects")
            }
        }
        
        completionHandler(data, nil, nil)
    }
    
    var isServerReachable: Bool = true {
        didSet {
            if !oldValue && isServerReachable {
                NetworkOperationQueue.shared.startPendingCalls()
            }
        }
    }
}
