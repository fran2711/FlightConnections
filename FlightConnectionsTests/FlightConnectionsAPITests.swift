//
//  FlightConnectionsTests.swift
//  FlightConnectionsTests
//
//  Created by Francisco Lucena on 17/8/23.
//

import XCTest
@testable import FlightConnections

final class FlightConnectionsAPITests: XCTestCase {
    
    func testFlightConnectionAPI() async {
        let mockedFlightConnection = FlighConnectionsMockAPI()
        var flightConnectionsResponse: FlightConnections?
        do {
            flightConnectionsResponse = try await mockedFlightConnection.fetchFlightConnections()
        } catch {
            XCTFail()
        }
        
        XCTAssert(flightConnectionsResponse?.connections != nil)
    }

}
