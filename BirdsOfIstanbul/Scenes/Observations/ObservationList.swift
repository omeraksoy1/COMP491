//
//  ObservationList.swift
//  BirdsOfIstanbul
//
//  Created by Omer Faruk Aksoy on 21.04.2022.
//

import Foundation

struct Observation: Identifiable {
    
    var id = UUID().uuidString;
    var name: String // file name
    var location: String // temporarily declared as string
    var timestamp: String // temporarily declared as string
    var prediction: String? // predicted species of bird
    //var recording: Record // to store the recording we download from the db
    
}

var tempObservations: [Observation] = []

func loadObservations() -> [Observation] {
    tempObservations.append(Observation(name: "test obs", location: "test location",
                                        timestamp: "10 a.m.", prediction: "Eurasian Siskin"))
    tempObservations.append(Observation(name: "test obs 2", location: "test location 2",
                                        timestamp: "10 a.m.", prediction: "Eurasian Siskin"))
    tempObservations.append(Observation(name: "test obs 3", location: "test location 3",
                                        timestamp: "10 a.m.", prediction: "Eurasian Siskin"))
    
    return tempObservations
    
}


var observations: [Observation] = loadObservations()
