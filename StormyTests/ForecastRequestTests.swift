//
//  StormyTests.swift
//  StormyTests
//
//  Created by Ben Goertz on 9/15/15.
//  Copyright © 2015 Ben Goertz. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Stormy

class ForecaseRequestTests: XCTestCase {
    
    func testForecastRequestReturnsProperURL() {
        // given
        
        // Test location for Powell's downtown in Portland.
        let cLat: CLLocationDegrees = 45.5228658
        let cLon: CLLocationDegrees = -122.6800825
        
        let forecastRequestInfo = ForecastRequest(cLat: cLat, cLon: cLon)
        
        let apiKey = forecastRequestInfo.apiKey
        
        let expectedURLString = "https://api.forecast.io/forecast/" + apiKey + "/\(cLat),\(cLon)"
        
        let expectedURL = NSURL(string: expectedURLString)

        // when
        let resultURL = forecastRequestInfo.requestURL
        
        // then
        XCTAssertEqual(resultURL, expectedURL, "We built a valid API URL request.")
    }
}
