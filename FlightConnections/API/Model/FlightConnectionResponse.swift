//
//  FlightConnection.swift
//  FlightConnections
//
//  Created by Francisco Lucena on 17/8/23.
//

import Foundation

struct FlightConnectionResponse: Decodable {
    let connections: [FlightConnection]
}

struct FlightConnection: Decodable {
    let from: String
    let to: String
    let coordinates: ConnectionCoordinates
    let price: Int
}

struct ConnectionCoordinates: Decodable {
    let from: CoordinatesLatitudeLongitude
    let to: CoordinatesLatitudeLongitude
    
}

struct CoordinatesLatitudeLongitude: Decodable {
    var latitude: Double?
    var longitude: Double?
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "long"
    }
}
