//
//  FlightConnection.swift
//  FlightConnections
//
//  Created by Francisco Lucena on 17/8/23.
//

import Foundation

public struct FlightConnections: Codable {
    let connections: [Connection]
}

public struct Connection: Codable {
    let from: String
    let to: String
    let coordinates: ConnectionCoordinates
    let price: Int

}

extension Connection: Identifiable, Hashable {
    public var id: String {
        return UUID().uuidString
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    public static func == (lhs: Connection, rhs: Connection) -> Bool {
        return lhs.id == rhs.id
    }
}

struct ConnectionCoordinates: Codable {
    let from: CoordinatesLatitudeLongitude
    let to: CoordinatesLatitudeLongitude
    
}

struct CoordinatesLatitudeLongitude: Codable {
    var latitude: Double
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "long"
    }
}
