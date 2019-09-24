//
//  MainViewController.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 12/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import UIKit
import Reachability

/*!
 * @brief main view controller that holds tabs for events and collections
 */
class MainViewController: UITabBarController {

    // MARK: - Controller LifeCycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupUI()
        addNetworkStatusView()
        addReachabilityObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        title = Localizations.mainTitle
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        title = nil
    }
    
    deinit {
        
        removeReachabilityObserver()
    }
    
    // MARK: - UI customization
    
    private func setupUI() {

        setupTabs()
    }
    
    private func setupTabs() {
        
        tabBar.tintColor = UIColor.black
        
        if let items = tabBar.items {
            
            if items.count > 0 {
                
                items[0].title = Localizations.agendaTitle
                items[0].image = Images.agendaIcon
                
                if items.count > 1 {
                    
                    items[1].title = Localizations.collectionsTitle
                    items[1].image = Images.collectionsIcon
                }
            }
        }
    }

    // MARK: - Network status
    
    /// Displays a small red banner on top when device is not connected to network
    private var networkStatusView: UIView!
    
    private func addNetworkStatusView() {
        
        let height: CGFloat = 20
        
        networkStatusView = UIView(frame: CGRect(x: 0, y: -height, width: view.bounds.size.width, height: height))
        networkStatusView.backgroundColor = UIColor.red.withAlphaComponent(0.75)
        networkStatusView.autoresizingMask = [.flexibleWidth]
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: networkStatusView.frame.size.width, height: networkStatusView.frame.size.height))
        title.backgroundColor = UIColor.clear
        title.textColor = UIColor.white
        title.font = UIFont.defaultFont(style: .bold, size: .base)
        title.text = Localizations.offlineTitle
        title.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        title.textAlignment = .center
        networkStatusView.addSubview(title)
        
        view.addSubview(networkStatusView)
    }
    
    private var isNetworkStatusAnimationInProgress = false
    
    private func toggleNetworkStatusView(visible: Bool) {
        
        guard !isNetworkStatusAnimationInProgress else {return}
        
        var frame = networkStatusView.frame
        
        guard (frame.origin.y < 0 && visible) || (frame.origin.y > 0 && !visible) else {return}
        
        isNetworkStatusAnimationInProgress = true
        
        frame.origin.y = visible ? (navigationController?.navigationBar.frame.size.height ?? 0) + UIApplication.shared.statusBarFrame.height : -networkStatusView.frame.size.height
        
        UIView.animate(withDuration: 0.25, animations: {
            self.networkStatusView.frame = frame
        }) { (_) in
            self.isNetworkStatusAnimationInProgress = false
        }
    }
    
    private func addReachabilityObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabililityNotificationReceived(_:)), name: Notification.Name.reachabilityChanged, object: nil)
    }
    
    @objc func reachabililityNotificationReceived(_ notification: Notification) {
        
        if let _reachability = notification.object as? Reachability {
            toggleNetworkStatusView(visible: _reachability.connection == .none)
        }
    }
    
    private func removeReachabilityObserver() {
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: nil)
    }
}
