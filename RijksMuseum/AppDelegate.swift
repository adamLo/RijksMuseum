//
//  AppDelegate.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 10/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, NetworkActivityProtocol {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize persistence
        Persistence.shared.setupCoreDataPersistentStore()
        
        // Initialize networking
        let session = NetworkURLSession()
        Network.shared.session = session
        Network.shared.persistence = Persistence.shared
        Network.shared.activityDelegate = self
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    // MARK: - Network Activity
    
    /// Keeps track of number of active network calls
    private var activityCount = 0
    
    /*!
     *  @brief Show network activity indicator. Called on start of a network call.
     */
    func showNetworkActivityIndicator() {
        
        DispatchQueue.main.async {
            
            if self.activityCount == 0 {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            
            self.activityCount += 1
        }
    }

    /*!
     *  @brief Hide network activity indicator. Called on end of a network call.
     */
    func hideNetworkActivityIndicator() {
        
        DispatchQueue.main.async {
            
            self.activityCount = max(self.activityCount - 1, 0)
            
            if self.activityCount == 0 {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }

}
