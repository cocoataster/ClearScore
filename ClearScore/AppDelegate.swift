//
//  AppDelegate.swift
//  ClearScore
//
//  Created by Eric Sans Alvarez on 02/11/2019.
//  Copyright © 2019 Eric Sans Alvarez. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        // Create view model and main controller. Wrap it inside a navigation controller
        
        let dashboardViewModel = DashboardViewModel(network: Network.manager)
        
        let dashboardViewController = DashboardViewController(dashboardViewModel)
        let navigationController = UINavigationController(rootViewController: dashboardViewController)
        
        window?.rootViewController = navigationController
        
        return true
    }
    
}

