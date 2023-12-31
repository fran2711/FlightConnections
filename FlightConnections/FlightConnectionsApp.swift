//
//  FlightConnectionsApp.swift
//  FlightConnections
//
//  Created by Francisco Lucena on 17/8/23.
//

import SwiftUI

@main
struct FlightConnectionsApp: App {
   
    var body: some Scene {
        WindowGroup {
//            ContentView()
            let dataSource = FlightConnectionsAPI()
            let originFlightsViewViewModel = OriginFlightsViewModel(dataSource: dataSource)
            OriginFlightsView(viewModel: originFlightsViewViewModel)
        }
    }
}

