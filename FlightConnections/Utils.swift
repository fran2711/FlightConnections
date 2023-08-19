//
//  Utils.swift
//  FlightConnections
//
//  Created by Francisco Lucena on 18/8/23.
//

import Foundation

func loadJson<T: Decodable>(filename fileName: String, with type: T.Type) -> T? {
    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            return try data.decodedResponse(type.self)
        } catch {
            print("error:\(error)")
        }
    }
    return nil
}

extension Int {
    var toString: String {
        String(self)
    }
}
