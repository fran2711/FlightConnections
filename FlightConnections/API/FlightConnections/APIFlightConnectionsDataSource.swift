//
//  APIFlightConnectionsDataSource.swift
//  FlightConnections
//
//  Created by Francisco Lucena on 17/8/23.
//

import Foundation

protocol FlightConnectionsDataSource {
    func fetchFlightConnections() async throws -> FlightConnectionResponse?
}

class FlightConnectionsAPI: FlightConnectionsDataSource {
    let flightUrl = "https://raw.githubusercontent.com/TuiMobilityHub/ios-code-challenge/master/connections.json"
    
    func fetchFlightConnections() async throws -> FlightConnectionResponse? {
        let response = try await API.data(url: flightUrl, method: .GET)
        return try response?.decodedResponse(FlightConnectionResponse.self)
    }
    
}

class FlighConnectionsMockAPI: FlightConnectionsDataSource {
    func fetchFlightConnections() async throws -> FlightConnectionResponse? {
        return loadJson(filename: "FlightConnectionsMock",
                        with: FlightConnectionResponse.self)
    }
}
