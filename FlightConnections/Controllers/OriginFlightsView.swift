//
//  OriginFlightsView.swift
//  FlightConnections
//
//  Created by Francisco Lucena on 17/8/23.
//

import SwiftUI

public enum OriginFlightsEvent {
    case onAppear
    case connectionOriginSelected(origin: String)
    case connectionDestinationSelected(destination: String)
    case searchFlights
    case showPrice
}

@MainActor
public protocol OriginFlightsVM: ObservableObject {
    var loading: Bool { get }
    var alert: AlertUIModel? { get set }
    
    var cityOriginList: [String] { get }
    var cityDestinationList: [String] { get }
    var flightOrigin: String { get }
    var flightDestination: String { get }
    var price: String { get }
    
    func handle(event: OriginFlightsEvent)
}

public struct OriginFlightsView<ViewModel: OriginFlightsVM>: View {
    
    @StateObject var viewModel: ViewModel
    @State private var originSelected = ""
    @State private var destinationSelected = ""
    
    public init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        
        NavigationStack {
            VStack(spacing: 16) {
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 40) {
                        VStack {
                            Text("ORIGIN")
                            ForEach(viewModel.cityOriginList, id: \.self) { connection in
                                ConnectionView(city: connection, action: {
                                    viewModel.handle(event: .connectionOriginSelected(origin: connection))
                                }).frame(maxWidth: .infinity)
                                
                                Divider()
                            }
                        }
                        
                        VStack {
                            Text("DESTINATION")
                            ForEach(viewModel.cityDestinationList, id: \.self) { connection in
                                ConnectionView(city: connection, action: {
                                    viewModel.handle(event: .connectionDestinationSelected(destination: connection))
                                    
                                })
                                
                                Divider()
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                
                Text("Flight origin: \(viewModel.flightOrigin) and destination: \(viewModel.flightDestination)").font(.title2)
                
                Button("Search Flights") {
                    viewModel.handle(event: .searchFlights)
                }
                .font(.title2)
                
            }
            .padding(16)
        }
        .background(Color.white.ignoresSafeArea())
        .loading(loading: viewModel.loading)
        .alert(model: $viewModel.alert)
        .onAppear {
            viewModel.handle(event: .onAppear)
        }
    }
}

#if DEBUG
class MockOriginFlightsVM: OriginFlightsVM {
    var alert: AlertUIModel? = nil
    var cityOriginList: [String] = ["London", "Tokio", "Los Angeles"]
    var cityDestinationList: [String] = ["Tokio", "Porto", "Singapur"]
    var flightOrigin: String = "London"
    var flightDestination: String = "Paris"
    var price: String = "500"
    
    let loading: Bool = false
    
    func handle(event: OriginFlightsEvent) { }
}

extension OriginFlightsView where ViewModel == MockOriginFlightsVM {
    static var mock: OriginFlightsView {
        .init(viewModel: MockOriginFlightsVM())
    }
}

struct OriginFlightsView_Previews: PreviewProvider {
    static var previews: some View {
        OriginFlightsView.mock
    }
}
#endif
