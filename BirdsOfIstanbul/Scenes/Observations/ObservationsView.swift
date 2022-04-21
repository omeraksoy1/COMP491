//
//  ObservationsView.swift
//  BirdsOfIstanbul
//
//  Created by Omer Faruk Aksoy on 21.04.2022.
//

import SwiftUI
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

struct ObservationsView: View {
    var body: some View {
        VStack {
            Text("Observations")
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .font(.largeTitle)
                .padding()
            
            ScrollView(.vertical, showsIndicators: false, content: {
                
                VStack {
                    ForEach(observations) {observation in
                        ObservationRowView(observation: observation)
                    }
                }
            })
        }
    }
}

private func downloadFiles() async {
    let auth = Auth.auth()
    
    let db = Firestore.firestore()
    
    let storage = Storage.storage()
    
    var documents: [QueryDocumentSnapshot] = []
    
    do {
        let snapshot = try await db.collection(auth.currentUser!.uid).getDocuments()
        documents = snapshot.documents
    } catch {
        print("There was an error")
    }
    
    for document in documents {
        //let maxSize: Int64 = 1 * 1024 * 1024 // 1 MB for now
        
        guard let downloadURL = document.get("audioURL"),
              let timestamp = document.get("time") else { return }
        
        let storageRef = storage.reference(forURL: downloadURL as! String)
        let localURL = getDocumentsDirectory().appendingPathComponent("\(timestamp)")
        storageRef.write(toFile: localURL){ data, error in
            if error != nil {
                return
            } else {
                // implement conversion from downloaded data to WAV file
            }
        }
    }
    
}

private func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

struct ObservationsView_Previews: PreviewProvider {
    static var previews: some View {
        ObservationsView()
            .previewInterfaceOrientation(.portrait)
    }
}
