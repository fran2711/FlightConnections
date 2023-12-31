//
//  APIFlightConnectionsDataSource.swift
//  FlightConnections
//
//  Created by Francisco Lucena on 17/8/23.
//

import SwiftUI

@MainActor
class OriginFlightsViewModel: OriginFlightsVM {

    @Published var flightOrigin: String = "N/A"
    @Published var flightDestination: String = "N/A"
    @Published var price: String = ""
    @Published var cityOriginList: [String] = []
    @Published var cityDestinationList: [String] = []
    
    @Published private var connectionsList: [Connection] = []
    @Published private (set) var loading: Bool = false
    @Published var alert: AlertUIModel? = nil
    
    let dataSource: FlightConnectionsDataSource
    
    init(dataSource: FlightConnectionsDataSource) {
        self.dataSource = dataSource
    }
    
    func handle(event: OriginFlightsEvent) {
        switch event {
        case .onAppear:
            self.loading = true
            fetchFlightConnections()
        case .connectionDestinationSelected(let destination):
            self.flightDestination = destination
        case .connectionOriginSelected(let origin):
            self.flightOrigin = origin
        case .searchFlights:
            searchFligths()
        case .showPrice:
            self.alert = AlertUIModel(title: "Price", message: "Flight total price is \(price)", action: .default(title: "Ok", action: {}))
        }
    }
    
    func fetchFlightConnections() {
        Task {
            defer { self.loading = false }
            do {
                guard let connections = try await dataSource.fetchFlightConnections()?.connections else {
                    return
                }
                connectionsList = connections
                cityOriginList = getCitiesArray(connections: connections, isOrigin: true)
                cityDestinationList = getCitiesArray(connections: connections, isOrigin: false)
            } catch {
                self.alert = AlertUIModel(title: "Error", message: error.localizedDescription,
                                          actions:
                                            [.default(title: "Retry",
                                                      action: { self.fetchFlightConnections() }),
                                             .cancel(action: .none)])
            }
        }
    }
    
    
    func getCitiesArray(connections: [Connection], isOrigin: Bool) -> [String] {
        var cities: [String] = []
        connections.forEach { connection in
            var city: String = ""
            isOrigin ? (city = connection.from) : (city = connection.to)
            cities.append(city)
        }
        return Array(Set(cities))
    }
    
    
    func searchFligths() {
        
        if flightOrigin == flightDestination {
            self.alert = AlertUIModel(title: "Error",message: "Origin and destination cities can't be the same", action: .default(title: "Ok", action: {}))
            return
        }
        
        var finalConnection: [Connection] = []
        let originConnectionsArray = connectionsList.filter({ $0.from == flightOrigin })
        let destinationConnectionsArray = connectionsList.filter( { $0.to == flightDestination })
        let oneFlight = originConnectionsArray.filter({ $0.from == flightOrigin && $0.to == flightDestination })
        
        if !oneFlight.isEmpty {
            finalConnection = oneFlight
        } else {
            if originConnectionsArray.count == 1 {
               let origin = originConnectionsArray
                finalConnection.append(contentsOf: origin)
            } else if originConnectionsArray.count > 1 {
                finalConnection.append(contentsOf: getOrigin(originConnectionsArray: originConnectionsArray, destinationConnectionsArray: destinationConnectionsArray))
            }
            
            while finalConnection.last?.to != flightDestination {
                finalConnection.append(contentsOf: getDestinationAndScales(finalConnection: finalConnection, destinationConnectionsArray: destinationConnectionsArray))
            }
        }
        price = finalConnection.map({ ($0.price) }).reduce(0, +).toString
        self.handle(event: .showPrice)
    }
    
    
    func getOrigin(originConnectionsArray: [Connection], destinationConnectionsArray: [Connection]) -> [Connection] {
        var finalConnection: [Connection] = []
        let originConnections = connectionsList.filter { connection in
            return originConnectionsArray.contains(where: { scale in
                return connection.from == scale.to
            })
        }
        
        let scales = originConnections.filter { connection in
            return destinationConnectionsArray.contains { destination in
                return connection.to == destination.from || connection.from == destination.from
            }
        }
        
        let origin = originConnectionsArray.filter({ origin in
            return scales.contains { scaleConnection in
                return origin.to == scaleConnection.from
            }
        })
        finalConnection.append(contentsOf: origin)
        if scales.count == 1 {
            finalConnection.append(contentsOf: scales)
        }
        
        return finalConnection
    }
    
    
    func getDestinationAndScales(finalConnection: [Connection], destinationConnectionsArray: [Connection]) -> [Connection] {
        var connectionsArray: [Connection] = []
        let lastConnection = finalConnection.last?.to
        let array = connectionsList.filter({ $0.from == lastConnection })
        
        let scales = array.filter({ connection in
            connection.from == lastConnection
        })
        
        let finalDestinationOrigin = destinationConnectionsArray.map({ $0.from })
        
        if scales.count > 1 {
            let scale = scales.filter { connection in
                return finalDestinationOrigin.contains { scale in
                    return connection.to == scale || (connection.from == scale && connection.to == flightDestination)
                }
            }
            connectionsArray.append(contentsOf: scale)
        } else {
            connectionsArray.append(contentsOf: scales)
        }
        
        return connectionsArray
    }
}
