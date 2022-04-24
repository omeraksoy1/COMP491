//
//  DetailedObservationView.swift
//  BirdsOfIstanbul
//
//  Created by Omer Faruk Aksoy on 21.04.2022.
//

import SwiftUI
import AVFoundation

struct DetailedObservationView: View {
    
    var observation: Observation
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Spectrogram")
                    .padding()
                
                Spacer()
                
                Button(action: { playSelectedRecording(recording: observation.recording) }) {
                    Text("Play")
                }
                
                Spacer()
                
                Text("Map")
                
                Spacer()
                
            }
                
            .navigationTitle(observation.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

var audioSpectrogram = AudioSpectrogram()
var player: AVAudioPlayer!

private func playSelectedRecording(recording: Record) {
    //isButtonsDeactivated(value: true)
    //audioSpectrumView.isHidden = false
    let resource = recording.path
    guard let url = URL(string: resource) else { return }
    
    do {
        let rawAudio = DataLoader.loadAudioSamplesArrayOf(Float.self, atUrl: url)
        var intRawAudio = [Int16]()
        for data in rawAudio! {
            intRawAudio.append(Int16(data))
        }
        audioSpectrogram.rawAudioData = intRawAudio
        audioSpectrogram.frequencyDomainValues = [Float](repeating: 0, count: AudioSpectrogram.bufferCount * AudioSpectrogram.sampleCount)
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
        player.prepareToPlay()
        //player.delegate = self
        audioSpectrogram.isHidden = false
        player.play()
    } catch {
        //presentAlert(title: "Error", message: "Please check device hardware.", buttonTitle: "OK")
        print("An error occurred")
    }
}


/*
struct DetailedObservationView_Previews: PreviewProvider {
    static var observation: Observation  = Observation(name: "name", location: "location", timestamp: "timestamp", prediction: "prediction")
    static var previews: some View {
        DetailedObservationView(observation: observation)
    }
}
*/
