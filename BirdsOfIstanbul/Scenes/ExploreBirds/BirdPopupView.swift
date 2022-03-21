//
//  BirdPopupView.swift
//  BirdsOfIstanbul
//
//  Created by Andrew Bond on 3/21/22.
//

import SwiftUI

struct BirdPopupView: View {
    var bird: Bird

    
    var body: some View {
        VStack {
            Image(bird.image).resizable()
                .aspectRatio(contentMode: .fit)
            
            Text(bird.name).fontWeight(.bold).font(.title)
            ScrollView(.vertical, showsIndicators: false, content: {
                Text(bird.description).font(.caption)
            })
            Link("Read more on Wikipedia", destination: URL(string: bird.link)!)
        }
    }
}

/*
struct BirdPopupView_Previews: PreviewProvider {
    static var previews: some View {
        BirdPopupView()
    }
}
*/
