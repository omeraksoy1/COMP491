//
//  PredictionViewController.swift
//  BirdsOfIstanbul
//
//  Created by Can Koz on 10.04.2022.
//

import UIKit

class PredictionViewController: BaseViewController {
    
    let answers = ["yes" ,"no" ,"not sure"]
    var isButtonEnabled = false {
        didSet {
            submitButton.isEnabled = isButtonEnabled
        }
    }
    
    @IBOutlet weak var birdImageView: UIImageView!
    @IBOutlet weak var birdDescriptionText: UITextView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionsTableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.roundCorners()
        questionsTableView.delegate = self
        questionsTableView.dataSource = self
        questionsTableView.register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTableViewCell")
        questionsTableView.allowsMultipleSelection = false
        questionsTableView.reloadData()
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        showLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.hideLoading()
            let recording = RecordingViewController()
            self.navigationController?.pushViewController(recording, animated: true)
        }
    }
}

extension PredictionViewController: UITableViewDelegate, UITableViewDataSource {
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
        if cell.questionLabel.text == "no" {
            cell.showTextfield()
        }
        self.isButtonEnabled = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! QuestionTableViewCell
        if cell.questionLabel.text == "no" {
            cell.otherTextfield.isHidden = true
        }
    }
}
