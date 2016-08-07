//
//  ForecastManager.swift
//  Forecast
//
//  Created by Matthew D Mayberry on 7/31/16.
//

import Foundation

typealias RequestCompletion = (CurrentWeatherModel) -> Void

struct ForecastManager {

    func fetchWeatherResults(requestInfo: ForecastRequest, completionHandler: RequestCompletion?) {
        
        ForecastCommunicator.fetchWeatherResults(requestInfo) { (data) -> Void in
            do {
                let weatherDictionary: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary
                let currentWeather = CurrentWeatherModel(weatherDictionary: weatherDictionary)
                print("Current time of NEW API call: ", currentWeather.currentTime)
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler?(currentWeather)
                }
            } catch {
                print(error)
            }
        }
    }
}