//
//  ExploreBirdsView.swift
//  BirdsOfIstanbul
//
//  Created by Omer Faruk Aksoy on 13.03.2022.
//

import SwiftUI

struct ExploreBirdsView: View {
    
    @State var searchWord = ""
    init() {
        UITabBar.appearance().isTranslucent = true
        UINavigationBar.setAnimationsEnabled(true)
    }
    
    var body: some View {
            
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
            .padding(.horizontal)
            .padding(.vertical, 10)
            .frame(width: 360, height: 45)
            .background(Color.primary.opacity(0.08))
            .cornerRadius(10)
            .padding(.bottom)
            
            HStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.6))
                    .frame(height: 1)
            }
        
            ScrollView(.vertical, showsIndicators: true, content: {
                
                VStack {
                    ForEach(birds) {bird in
                        if searchWord == "" || bird.name.lowercased().contains(searchWord.lowercased()) {
                            BirdRowView(bird: bird)
                        }
                    }
                }
            })
            
        }.frame(maxWidth: .infinity)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
    }
}


struct ExploreBirdsView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreBirdsView()
    }
}

