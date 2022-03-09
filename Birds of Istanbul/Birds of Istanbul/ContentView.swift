//
//  ContentView.swift
//  Birds of Istanbul
//
//  Created by Omer Faruk Aksoy on 28.02.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            
            VStack(spacing: 10) {
                BasicButton(title: "Sound ID", textColor: .white, backgroundColor: .blue)
                BasicButton(title: "Explore Birds", textColor: .white, backgroundColor: .blue)
            }
            
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
