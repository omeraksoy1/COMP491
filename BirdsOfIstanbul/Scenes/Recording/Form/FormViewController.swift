//
//  FormViewController.swift
//  BirdsOfIstanbul
//
//  Created by Can Koz on 10.04.2022.
//

import UIKit
import MapKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import SwiftUI

class FormViewController: BaseViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionsTableView: UITableView!
    @IBOutlet weak var continueButton: UIButton!
    
    var isButtonEnabled = false {
        didSet {
            continueButton.isEnabled = isButtonEnabled
        }
    }
    let answers = ["a) on the ground" ,"b) in a lake" ,"d) on a tree", "e) behind/in a bush", "f) on a building (windows, balcony etc.)", "g) on a street light or an electric pole)", "h) other", "i) cannot see / do not know"]
    
    var storage: Storage?
    var childName: String?
    var longitude: CLLocationDegrees?
    var latitude: CLLocationDegrees?
    var timestamp: String?
    
    
    let group = DispatchGroup()
    
    var selectedCell: QuestionTableViewCell?
    
    private var finishedClassification = false
    private var classification = ""
    
    public var audioURL: String?
    
    func getURL() async {
        let auth = Auth.auth()
        let db = Firestore.firestore()
        var documents: [QueryDocumentSnapshot] = []
        
        do {
            while self.audioURL == nil {
                let snapshot = try await db.collection(auth.currentUser!.uid).getDocuments()
                documents = snapshot.documents
                for document in documents {
                    guard let time = document.get("time") as? String,
                          let url = document.get("audioURL") as? String else {return}
                    print(url)
                    self.audioURL = url
                    if(time == self.timestamp) {
                        break
                    }
                }
            }
            
        } catch {
            print("There was an error")
        }
        while self.audioURL == nil {
            for document in documents {
                guard let time = document.get("time") as? String,
                      let url = document.get("audioURL") as? String else {return}
                print(url)
                self.audioURL = url
                if(time == self.timestamp) {
                    break
                }
            }
            
        }
        group.leave()
    }
    
    func classify(){
        guard let url = URL(string: "https://europe-central2-comp491-model.cloudfunctions.net/ast_model") else {
            exit(EXIT_FAILURE)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //self.audioURL = "https://firebasestorage.googleapis.com/v0/b/birdsofistanbul-d3c13.appspot.com/o/song3.wav?alt=media&token=7518f6b4-630a-4cad-971e-2ac46c49ff00"
        
        let body: [String: AnyHashable] = [
            "url": self.audioURL!
        ]
        let data = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        print("Serialized JSON object")
        request.httpBody = data
        print("Setup HTTP body of request")
        let task = URLSession.shared.dataTask(with: request) { data, r, error in
            guard let data = data, error == nil else {
                exit(EXIT_FAILURE)
            }
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                //let response = try JSONSerialization.jsonObject(with: data)
                guard let jsonResponse = response as? [String: Any] else {
                    print("Error while getting json object")
                    exit(EXIT_FAILURE)
                }
                print(jsonResponse)
                self.classification = jsonResponse["result"] as! String
                self.finishedClassification = true
                
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        group.enter()
        
        sleep(5)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionsTableView.delegate = self
        questionsTableView.dataSource = self
        continueButton.roundCorners()
        navigationController?.navigationBar.isHidden = true
        questionsTableView.register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTableViewCell")
        questionsTableView.allowsMultipleSelection = false
        questionsTableView.reloadData()
    }
    
    func waitForFinish() {
        classify()
        while(finishedClassification == false) {
            continue
        }
        if classification == "" {
            print("Classification error")
            let vc = RecordingViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
        
            print(classification)
            
            if let bird = birds.first(where: {$0.name == classification}) {
                let birdPopupView = BirdPopupView(bird: bird)
                let vc = UIHostingController(rootView: birdPopupView)
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let bird = birds[0]
                let birdPopupView = BirdPopupView(bird: bird)
                let vc = UIHostingController(rootView: birdPopupView)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        /*var bird: Bird? = nil
        for b in loadBirds() {
            if b.name == classification {
                bird = b
                break
            }
        }
        
        print(classification)
        if bird == nil {
            bird = loadBirds()[0]
        }*/
        
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        showPredicting()
        var birdPlace = String()
        if let manuelEntry = selectedCell?.otherTextfield.text,
           let selectedAnswer = selectedCell?.questionLabel.text {
            birdPlace = manuelEntry.isEmpty ? selectedAnswer : manuelEntry
        }
        
        guard let storage = storage,
              let childName = childName else {
            return
        }
        
        let auth = Auth.auth()
        let db = Firestore.firestore()
        let pathReference = storage.reference(withPath: childName)
        //var downloadURL: URL?
        
        pathReference.downloadURL { downloadUrl, error in
            if error != nil {
                
            } else {
                if auth.currentUser?.uid != nil {
                    db.collection(auth.currentUser!.uid).addDocument(data: ["location" :
                                                                                ["Latitude" : self.latitude,
                                                                                 "Longitude" : self.longitude],
                                                                            "time" : String().getCurrentTime(),
                                                                            "audioURL" : downloadUrl!.absoluteString,
                                                                            "place": birdPlace])
                    self.hideLoading()
                    self.audioURL = downloadUrl!.absoluteString
                    self.waitForFinish()
                    
                    //let prediction = PredictionViewController()
                    //self.navigationController?.pushViewController(prediction, animated: true)
                } else {
                    return
                }
            }
        }
    }
    
}

extension FormViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = questionsTableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as! QuestionTableViewCell
        let text = answers[indexPath.row]
        cell.configure(text: text)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! QuestionTableViewCell
        if cell.questionLabel.text == "h) other" {
            cell.showTextfield()
        }
        selectedCell = cell
        self.isButtonEnabled = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! QuestionTableViewCell
        if cell.questionLabel.text == "h) other" {
            cell.otherTextfield.isHidden = true
        }
    }
}
