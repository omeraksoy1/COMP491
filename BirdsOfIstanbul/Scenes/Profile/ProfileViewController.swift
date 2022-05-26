//
//  ProfileViewController.swift
//  BirdsOfIstanbul
//
//  Created by Can Koz on 13.04.2022.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: BaseViewController {

    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var userMail: UILabel!
    @IBOutlet weak var creditsButton: UIButton!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var signoutButton: UIButton!
    @IBOutlet weak var dataLabel: UILabel!
    
    var userFiles = [String]()
    var userFilesTotalSize: Int64 = 0
    
    var documents: [QueryDocumentSnapshot]? {
        didSet {
            
        }
    }
    
    
    var size: Double = 0 {
        didSet {
            DispatchQueue.main.async {
                let rounded = Double(round(1000 * (self.size / 1000000)) / 1000)
                self.dataLabel.text = "You have \(self.documents?.count ?? 0 ) recordings which hold \(rounded) MB space on our servers."
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        size = 0
        Task {
            await downloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeButton.layer.cornerRadius = 8
        signoutButton.layer.cornerRadius = 8
        creditsButton.layer.cornerRadius = 8
        appImageView.layer.cornerRadius = 25
        userMail.text = Auth.auth().currentUser?.email
        // Do any additional setup after loading the view.
    }


    @IBAction func didTappedChangePassword(_ sender: Any) {
        let vc = ChangePasswordViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTappedSignout(_ sender: Any)
    {
        DispatchQueue.main.async {
            do {
                try Auth.auth().signOut()
            } catch {
                self.presentAlert(title: "Error", message: "Authorization server error.", buttonTitle: "OK")
            }
        }
        
    }
    
    @IBAction func didTappedCredits(_ sender: Any) {
        let vc = CreditsViewController.instantiate()
        self.present(vc, animated: true, completion: nil)
    }
    
    func downloadData() async {
        showLoading()
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
            
            guard let downloadURL = document.get("audioURL") else { return }
            let storageRef = storage.reference(forURL: downloadURL as! String)
            storageRef.getData(maxSize: 10 * 1024 * 1024) { data, err in
                self.size += Double(data?.count ?? 0)
            }
        }
        self.documents = documents
        self.hideLoading()
    }
}
