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
        
        // Override point for customization after application launch.
        
        // fatalError("Look at me first")
        // All the layout metrics are contained in the file called metrics.md located as a sibling of the AppDelegate.swift.
        // Reference screen shots are contained in the reference images folder located as a descendant of the Umbrella group
        
        // Our designer didn't use the actual degree symbol, but used the "ring above" symbol (option+K) ˚ instead
        // because he thought it looks better. You can use either ring above or the actual degree symbol (option-shift-8) °.
        // Throw a comment if you want on which you chose and why.
        
        // UIColors for the use for reference in the rest of the application
        let warmColor = UIColor(0xFF9800)
        let coolColor = UIColor(0x03A9F4)
        /*
        // Setup the request
        // var weatherRequest = WeatherRequest(APIKey: "324f2ac862fc9fea")
        
    
        
        // Here's your URL. Marshall this to the internet however you please.
        let url = weatherRequest.URL
        
        // Set the default zip code
        var defaultZipCode = "90210"
        
        // get the url based off of current zip code
        let weatherDataURL = HelperMethods.weatherURL(zipCode: defaultZipCode)
        
        // get weather data from api
        // let weatherData = HelperMethods.getWeatherData(url: weatherDataURL, completionHandler: <#T##(Data) -> Void#>)
        */
        // let data = HelperMethods.getWeatherData(url)
        
        // Here’s where to look for the information, because let’s be honest, you know how to read JSON
        // All values are as of October 13, 2015
        
        // Current Conditions
        // City         : current_observation.display_location.full
        // Temp         : current_observation.(temp_f || temp_c)
        // Condition    : current_observation.weather
        
        // Hourly information
        // Timestamp    : hourly_forecast.FCTTIME.(civil = string representation, epoch = date from 1970)
        // Icon         : hourly_forecast.icon
        // Temp         : hourly_forecast.temp.(english || metric)
        
        // How to use the icon name to get the URL. Solid icons are used for the daily highs and lows
        
        let solidIcon = "clear".nrd_weatherIconURL(highlighted: true)
        let outlineIcon = "clear".nrd_weatherIconURL()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

}

