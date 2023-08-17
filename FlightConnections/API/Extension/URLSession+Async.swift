//
//  URLSession+Async.swift
//  FlightConnections
//
//  Created by Francisco Lucena on 17/8/23.
//

import Foundation

extension URLSession {
    func data(with request: URLRequest) async throws -> (Data?, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                guard let response = response else {
                    if let error = error as? URLError {
                        return continuation.resume(throwing: error)
                    }
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }
                continuation.resume(returning: (data, response))
            }
            task.resume()
        }
    }
}
