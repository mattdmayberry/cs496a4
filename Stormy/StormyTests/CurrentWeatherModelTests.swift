//
//  CurrentWeatherModelTests.swift
//  Stormy
//
//  Created by Ben Goertz on 12/18/15.
//  Copyright © 2015 Ben Goertz. All rights reserved.
//

import XCTest
@testable import Stormy

class CurrentWeatherModelTests: XCTestCase {
	
	func testCurrentWeatherCreation() {
		let filePath = NSBundle.mainBundle().pathForResource("weatherJSONblobTest", ofType: "json")!
		let jsonData = NSData(contentsOfFile: filePath)
		let weatherDictionary: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(jsonData!, options: []) as! NSDictionary
		let currentWeather = CurrentWeatherModel(weatherDictionary: weatherDictionary)
		
		// All the values in the model should match the test JSON blob
		XCTAssertEqualWithAccuracy(currentWeather.temperature, 53.77, accuracy: DBL_EPSILON)
		XCTAssertEqualWithAccuracy(currentWeather.humidity, 0.76, accuracy: DBL_EPSILON)
		XCTAssertEqualWithAccuracy(currentWeather.precipProbability, 0, accuracy: DBL_EPSILON)
		XCTAssertEqual(currentWeather.summary, "Mostly Cloudy")
	}
}
