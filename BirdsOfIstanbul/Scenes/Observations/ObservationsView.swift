//
//  ObservationsView.swift
//  BirdsOfIstanbul
//
//  Created by Omer Faruk Aksoy on 21.04.2022.
//

import SwiftUI

struct ObservationsView: View {
    var body: some View {
        VStack {
            Text("Observations")
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .font(.largeTitle)
                .padding()
            
            ScrollView(.vertical, showsIndicators: false, content: {
                
                VStack {
                    ForEach(observations) {observation in
                        ObservationRowView(observation: observation)
                    }
                }
            })
        }
    }
}

struct ObservationsView_Previews: PreviewProvider {
    static var previews: some View {
        ObservationsView()
    }
}
