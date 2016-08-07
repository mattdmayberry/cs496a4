//
//  ForecastRequest.swift
//  Forecast
//
//  Created by Matthew D Mayberry on 7/31/16.
//

import Foundation
import CoreLocation

struct ForecastRequest {
    let cLat: CLLocationDegrees
    let cLon: CLLocationDegrees
    
    var stringLatLon: String {
        return "/\(cLat),\(cLon)"
    }
    
    
    var apiKey: String {
        get {
            guard let filePath = NSBundle.mainBundle().pathForResource("keys", ofType: "plist") else { return "" }
            let keys = NSDictionary(contentsOfFile: filePath)
            guard let apiKey = keys?["ForecastAPI"] as? String else { return "NotAValidKey" }
            return apiKey
        }
    }
    
    var baseURLString: String {
        return "https://api.forecast.io/forecast/" + "e7d8d21f3e7c1c515d68fba89aa058ba"
    }
    
    var requestURLString: String {
        return baseURLString + stringLatLon
    }
    
    var requestURL: NSURL? {
        return NSURL(string: requestURLString)
    }
}

// This is a pattern I picked up from Joe Masilotti
// https://github.com/suite22/PackageTracker/commit/e64876c68b0d910207eb8798c407845188d2e4a1
extension ForecastRequest: Equatable { }
func ==(lhs: ForecastRequest, rhs: ForecastRequest) -> Bool {
    return lhs.cLat == rhs.cLat && lhs.cLon == rhs.cLon
}