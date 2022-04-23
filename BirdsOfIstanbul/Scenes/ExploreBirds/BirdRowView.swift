//
//  BirdRowView.swift
//  BirdsOfIstanbul
//
//  Created by Omer Faruk Aksoy on 13.03.2022.
//

import SwiftUI

struct BirdRowView: View, Identifiable {
    let id: UUID
    var bird: Bird
    
    init(id: UUID = UUID(), bird: Bird) {
        self.bird = bird
        self.id = id
    }
    
    var body: some View {
        
        NavigationLink(destination: BirdPopupView(bird: bird)) {
        
            HStack(spacing: 15) {
                
                VStack(alignment: .leading, spacing: 8, content: {
                    Text(bird.name)
                        .fontWeight(.bold)
                    Text(bird.description)
                        .font(.caption)
                        .lineLimit(2)
                        //.multilineTextAlignment(.center)
                })
                    .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
                
                Image(bird.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            }
            .frame(height: 100)
            .padding(.leading)
        
        }.buttonStyle(PlainButtonStyle())
        
    }
}

/*
struct BirdRowView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreBirdsView()
    }
}
*/
