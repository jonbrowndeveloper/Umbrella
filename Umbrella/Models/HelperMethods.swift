//
//  HelperMethods.swift
//  Umbrella
//
//  Created by Jon Brown on 11/26/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import UIKit
import Foundation

class HelperMethods: NSObject
{
    static func getWeatherData(url: URL, completionHandler handler: @escaping (_ data: Data) -> Void)
    {
        // highest priority asynch queue using weather url to get weather data
        DispatchQueue.global(qos: .userInteractive).async
        { () -> Void in
            if let weatherData = try? Data(contentsOf: url)
            {
                handler(weatherData)
            }
        }
    }
    
    static func weatherURL(zipCode: String) ->  URL
    {
        let APIKey = "324f2ac862fc9fea"
        
        var url: URL?
            {
            get {
                
                var urlComponents = URLComponents()
                urlComponents.scheme = "https"
                urlComponents.host = "api.wunderground.com"
                urlComponents.path = "/api/\(APIKey)/conditions/hourly/q/\(zipCode).json"
                
                return urlComponents.url
            }
        }
        
        return url!
    }
}
