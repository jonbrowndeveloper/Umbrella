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
    static func weatherURL(zipCode: String) ->  URL
    {
        // use a more global variable if the API key needs to be changed frequently
        let APIKey = "324f2ac862fc9fea"
        
        // combine URL
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
