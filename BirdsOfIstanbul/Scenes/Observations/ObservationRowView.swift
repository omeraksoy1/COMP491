//
//  SingleObservation.swift
//  BirdsOfIstanbul
//
//  Created by Omer Faruk Aksoy on 21.04.2022.
//

import SwiftUI

struct ObservationRowView: View, Identifiable {
    let id: UUID
    var observation: Observation
    
    init(id: UUID = UUID(), observation: Observation) {
        self.id = id
        self.observation = observation
    }
    
    var body: some View {
        NavigationLink(destination: DetailedObservationView(observation: observation)) {
            
            HStack(spacing: 15) {
                
                VStack {
                    Text(observation.name)
                        .fontWeight(.bold)
                    Spacer()
                    Text(observation.location)
                        .font(.caption)
                }
                .frame(maxWidth: 300, maxHeight: 100, alignment: .leading)
                
                // duration? on the right hand side
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .padding(.trailing)
                
            }
            .padding()
        }
    }
}

/*
struct ObservationRowView_Previews: PreviewProvider {
    static var previews: some View {
        ObservationRowView()
    }
}*/

