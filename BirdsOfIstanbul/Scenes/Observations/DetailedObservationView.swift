//
//  DetailedObservationView.swift
//  BirdsOfIstanbul
//
//  Created by Omer Faruk Aksoy on 21.04.2022.
//

import SwiftUI

struct DetailedObservationView: View {
    
    var observation: Observation
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Spectrogram")
                    .padding()
                
                Spacer()
                
                Text("Play button")
                
                Spacer()
                
                Text("Map")
                
                Spacer()
                
            }
                
            .navigationTitle(observation.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DetailedObservationView_Previews: PreviewProvider {
    static var observation: Observation  = Observation(name: "name", location: "location", timestamp: "timestamp", prediction: "prediction")
    static var previews: some View {
        DetailedObservationView(observation: observation)
    }
}

