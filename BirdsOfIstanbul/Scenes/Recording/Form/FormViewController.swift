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

class FormViewController: BaseViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionsTableView: UITableView!
    @IBOutlet weak var continueButton: UIButton!
    
    var isButtonEnabled = false {
        didSet {
            continueButton.isEnabled = isButtonEnabled
        }
    }
    let answers = ["a) on the ground" ,"b) in a lake" ,"c) in city (what do you mean by this? see f, g below)", "d) on a tree", "e) behind/in a bush", "f) on a building (windows, balcony etc.)", "g) on a street light or an electric pole)", "h) other", "i) cannot see / do not know"]
    
    var storage: Storage?
    var childName: String?
    var longitude: CLLocationDegrees?
    var latitude: CLLocationDegrees?
    
    var selectedCell: QuestionTableViewCell?
    
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
                    
                    let prediction = PredictionViewController()
                    self.navigationController?.pushViewController(prediction, animated: true)
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
