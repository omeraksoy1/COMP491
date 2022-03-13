//
//  BirdRowView.swift
//  BirdsOfIstanbul
//
//  Created by Omer Faruk Aksoy on 13.03.2022.
//

import SwiftUI

struct BirdRowView: View {
    var bird: Bird
    var body: some View {
        
        HStack(spacing: 15) {
            
            VStack(alignment: .leading, spacing: 8, content: {
                Text(bird.name)
                    .fontWeight(.bold)
                Text(bird.description)
                    .font(.caption)
            })
                .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
            
            Image(bird.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
        }
        .frame(height: 100)
        .padding(.leading)
        
    }
}

struct BirdRowView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreBirdsView()
    }
}
