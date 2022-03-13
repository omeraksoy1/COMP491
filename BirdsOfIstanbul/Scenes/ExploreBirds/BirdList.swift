//
//  BirdList.swift
//  BirdsOfIstanbul
//
//  Created by Omer Faruk Aksoy on 13.03.2022.
//

import Foundation
import SwiftUI

struct Bird: Identifiable {
    
    var id = UUID().uuidString;
    var name: String
    var description: String
    var image: String
    
}

var birds = [
    Bird(name: "Gull", description: "Test description 1", image: "gull"),
    Bird(name: "Dove", description: "Test description 2", image: "dove"),
    Bird(name: "Eurasian Blackbird", description: "Test description 3", image: "eurasianBlackbird"),
    Bird(name: "European Robin", description: "Test description 4", image: "europeanRobin"),
    Bird(name: "European Starling", description: "Test description 4", image: "europeanStarling")
]
