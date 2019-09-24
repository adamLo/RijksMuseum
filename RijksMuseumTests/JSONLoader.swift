//
//  JSONLoader.swift
//  RijksMuseumTests
//
//  Created by Adam Lovastyik on 13/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation

class JSONLoader: NSObject {
    
    func load(jsonFile: String) -> Data? {
        
        let bundle = Bundle(for: type(of: self))
        
        if let url = bundle.url(forResource: jsonFile, withExtension: "json") {
            
            if let _data = try? Data(contentsOf: url) {
                return _data
            }
        }
        
        return nil
    }
    
    func parse(jsonFile: String) -> JSONObject? {
        
        do {
            if let _data = load(jsonFile: jsonFile), let jsonObject = try JSONSerialization.jsonObject(with: _data, options: []) as? JSONObject {
                
                return jsonObject
            }
        }
        catch {
            return nil
        }
        
        return nil
    }
}
