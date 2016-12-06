//
//  AppDelegate.swift
//  Umbrella
//
//  Created by Jon Rexeisen on 10/13/15.
//  Copyright © 2015 The Nerdery. All rights reserved.
//

import UIKit
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // for setting status bar color to light
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        // setup first time setting to fahrenheit
        
        if (UserDefaults.standard.value(forKey: "firstTime") == nil)
        {
            UserDefaults.standard.setValue(true, forKey: "isEnglish")
            
            UserDefaults.standard.setValue(false, forKey: "firstTime")
            
            UserDefaults.standard.setValue("90210", forKey: "zipCode")
        }
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

}

