//
//  Forecast
//
//  Created by Matthew D Mayberry on 7/31/16.
//

import XCTest
import CoreLocation
@testable import Forecast

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
