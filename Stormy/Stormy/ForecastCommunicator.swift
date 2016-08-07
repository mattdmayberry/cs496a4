//
//  ForecastCommunicator.swift
//  Forecast
//
//  Created by Matthew D Mayberry on 7/31/16.
//

import Foundation

struct ForecastCommunicator {
    
    static func fetchWeatherResults(requestWeather: ForecastRequest, completionHandler: ((data: NSData) -> Void)?) -> () {
        guard let url = requestWeather.requestURL else {
            return
        }
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url) { data, response, error in
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200..<300:
                    print("HTTP Request is good.")
                    guard let data = data else {
                        break
                    }
                    completionHandler?(data: data)
                case 400:
                    print("Bad HTTP Request. Check that the API key is valid.")
                default:
                    print("HTTP Request failed.")
                }
            } else {
                print("Bad HTTP response. \(error)")
            }
        }
        
        task.resume()
    }
}