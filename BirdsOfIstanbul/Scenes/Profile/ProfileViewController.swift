//
//  ProfileViewController.swift
//  BirdsOfIstanbul
//
//  Created by Can Koz on 13.04.2022.
//

import UIKit
import FirebaseAuth

class ProfileViewController: BaseViewController {

    @IBOutlet weak var userMail: UILabel!
    
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var signoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeButton.layer.cornerRadius = 8
        signoutButton.layer.cornerRadius = 8
        userMail.text = Auth.auth().currentUser?.email
        // Do any additional setup after loading the view.
    }


    @IBAction func didTappedChangePassword(_ sender: Any) {
        let vc = ChangePasswordViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTappedSignout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            presentAlert(title: "Error", message: "Authorization server error.", buttonTitle: "OK")
        }
    }
}
