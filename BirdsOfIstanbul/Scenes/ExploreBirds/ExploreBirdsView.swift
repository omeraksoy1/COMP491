//
//  ExploreBirdsView.swift
//  BirdsOfIstanbul
//
//  Created by Omer Faruk Aksoy on 13.03.2022.
//

import SwiftUI

struct ExploreBirdsView: View {
    
    @State var searchWord = ""
    
    var body: some View {
        
        VStack {
            
            VStack {
                Text("Explore Birds")
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .font(.largeTitle)
                    .padding()
                
                HStack(spacing: 15) {
                    
                    TextField("Search", text: $searchWord)
                        .padding(.leading, 20)
                    
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.gray)
                        //.padding(.trailing, 10)
                 }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .frame(width: 360, height: 45)
                .background(Color.primary.opacity(0.08))
                .cornerRadius(10)
                
                Spacer()
            }
            
        }
    }
}

struct ExploreBirdsView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreBirdsView()
    }
}
