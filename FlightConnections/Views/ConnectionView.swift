//
//  ConnectionView.swift
//  FlightConnections
//
//  Created by Francisco Lucena on 19/8/23.
//

import SwiftUI

struct ConnectionView: View {
    var city: String
    let action: () -> Void
    var body: some View {
        VStack {
            Button {
                action()
            } label: {
                Text(city)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .foregroundColor(.black)
            .font(.title2)
        }
        .padding(16)
    }
}

struct ConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionView(city: "London", action: {})
    }
}
