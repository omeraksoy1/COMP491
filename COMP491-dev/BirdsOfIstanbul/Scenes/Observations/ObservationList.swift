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
    var location: [String] // temporarily declared as string
    var timestamp: String // temporarily declared as string
    var prediction: String // predicted species of bird
    var recording: Record // to store the recording we download from the db
    
}

var tempObservations: [Observation] = []

func loadObservations() -> [Observation] {
    
    let fileName = "10:10:10.wav"
    
    let recording = Record(
        path: getDocumentsDirectory().appendingPathComponent(fileName).absoluteString,
        title: String().getCurrentTime(),
        dataKey: fileName
        )
    tempObservations.append(Observation(name: "test obs 3", location: ["x3", "y3"],
                                        timestamp: "10 a.m.", prediction: "Eurasian Siskin", recording: recording))
    
    tempObservations.append(Observation(name: "test obs", location: ["x1", "y1"],
                                        timestamp: "10 a.m.", prediction: "Eurasian Siskin", recording: recording))
    tempObservations.append(Observation(name: "test obs 2", location: ["x2", "y2"],
                                        timestamp: "10 a.m.", prediction: "Eurasian Siskin", recording: recording))
    
    return tempObservations
    
}

/*func loadObs() -> [Observation] {
    getDocumentsDirectory()
}*/


var observations: [Observation] = loadObservations()
