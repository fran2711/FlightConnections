//
//  FlightConnectionsTests.swift
//  FlightConnectionsTests
//
//  Created by Francisco Lucena on 17/8/23.
//

import XCTest
@testable import FlightConnections

final class FlightConnectionsTests: XCTestCase {
    
    func testFlightConnectionAPI() async {
        let mockedFlightConnection = FlighConnectionsMockAPI()
        var flightConnectionsResponse: FlightConnectionResponse?
        do {
            flightConnectionsResponse = try await mockedFlightConnection.fetchFlightConnections()
        } catch {
            XCTFail()
        }
        
        XCTAssert(flightConnectionsResponse?.connections != nil)
    }

}
