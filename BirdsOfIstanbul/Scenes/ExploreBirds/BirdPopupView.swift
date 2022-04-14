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
            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            
            Link("Read more on Wikipedia", destination: URL(string: bird.link)!)
                .padding(.bottom)
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
