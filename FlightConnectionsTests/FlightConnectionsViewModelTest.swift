//
//  FlightConnectionsViewModelTest.swift
//  FlightConnectionsTests
//
//  Created by Francisco Lucena on 20/8/23.
//

import XCTest
@testable import FlightConnections


final class FlightConnectionsViewModelTest: XCTestCase {
    
    let mockedFlightConnection = FlighConnectionsMockAPI()
   
    @MainActor func testViewModelFetchData() async {
        let viewModel = OriginFlightsViewModel(dataSource: mockedFlightConnection)
        let task = Task { viewModel.fetchFlightConnections() }
        await task.value
        XCTAssertNotNil(viewModel.cityOriginList)
    }
    
    @MainActor func testViewModelCityList() async {
        let viewModel = OriginFlightsViewModel(dataSource: mockedFlightConnection)
        guard let flightConnectionsResponse = try? await mockedFlightConnection.fetchFlightConnections()?.connections else {
            XCTFail()
            return
        }
        viewModel.cityOriginList = viewModel.getCitiesArray(connections: flightConnectionsResponse, isOrigin: true)

        XCTAssert(!viewModel.cityOriginList.isEmpty)
    }

}
