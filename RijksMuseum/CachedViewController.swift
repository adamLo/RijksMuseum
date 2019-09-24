//
//  CachedViewController.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 13/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation
import UIKit

/*!
 * @brief Base controller for view controller that display cached data and need to breloaded periodically
 */
class CachedViewController: UIViewController {
    
    // MARK: - Controller Lifecyce
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        startReloadTimer()
        
        if isCacheEmpty() {
            refreshCache()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        stopReloadTimer()
    }
    
    // MARK: - Timer
    
    /// Time interval for cache reloading
    internal let reloadInterval: TimeInterval = 5 * 60 // Reload caches every 5 minutes
    
    /// Timer that reloads cache on fire
    internal var reloadTimer: Timer?
    
    /*!
     * @brief Start reload timer. Call when view is about to appear
     */
    internal func startReloadTimer() {
    
        stopReloadTimer()
        reloadTimer = Timer.scheduledTimer(timeInterval: reloadInterval, target: self, selector: #selector(timerFired(_:)), userInfo: nil, repeats: true)
    }
    
    /*!
     *  @brief Stop reload timer. Call when view is about to disappear
     */
    internal func stopReloadTimer() {
        
        reloadTimer?.invalidate()
        reloadTimer = nil
    }
    
    @objc func timerFired(_ timer: Timer) {
        
        refreshCache()
    }
    
    /*!
     * @brief Stub to reload cache. Overwrite in subclasses
     */
    internal func refreshCache() {
        // Override this function to reload cache
    }
    
    /*!
     * @brief Tells if cache is empty. Used to determine whether cache needs to reloaded on startup. Overwrite in subclasses
     *
     * @return True if cache is empty
     */
    internal func isCacheEmpty() -> Bool {
        return true
    }
}
