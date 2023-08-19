//
//  APIFlightConnectionsDataSource.swift
//  FlightConnections
//
//  Created by Francisco Lucena on 17/8/23.
//

import Foundation

protocol FlightConnectionsDataSource {
    func fetchFlightConnections() async throws -> FlightConnections?
}

class FlightConnectionsAPI: FlightConnectionsDataSource {
    let flightUrl = "https://raw.githubusercontent.com/TuiMobilityHub/ios-code-challenge/master/connections.json"
    
    func fetchFlightConnections() async throws -> FlightConnections? {
        let response = try await API.data(url: flightUrl, method: .GET)
        return try response?.decodedResponse(FlightConnections.self)
    }
    
}

class FlighConnectionsMockAPI: FlightConnectionsDataSource {
    func fetchFlightConnections() async throws -> FlightConnections? {
        return loadJson(filename: "FlightConnectionsMock",
                        with: FlightConnections.self)
    }
}
