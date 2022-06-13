//
//  ChangePasswordViewController.swift
//  BirdsOfIstanbul
//
//  Created by Can Koz on 13.04.2022.
//

import UIKit
import FirebaseAuth

class ChangePasswordViewController: BaseViewController {

    @IBOutlet weak var firstPasswordTextField: UITextField!
    @IBOutlet weak var secondPasswordTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
    }

    @IBAction func confirmButtonTapped(_ sender: Any) {
        guard let firstText = firstPasswordTextField.text,
              let secondText = secondPasswordTextField.text else {
                  presentAlert(title: "Error", message: "Something went wrong.", buttonTitle: "OK")
                  return
              }
        showLoading()
        if !firstText.isEmpty && !secondText.isEmpty && (firstText == secondText) && firstText.count > 5 {
            let user = Auth.auth().currentUser
            user?.updatePassword(to: firstText, completion: { [weak self] error in
                self?.hideLoading()
                if error == nil {
                    self?.navigationController?.popToRootViewController(animated: true)
                    self?.presentAlert(title: "Success", message: "Password changed.", buttonTitle: "OK")
                } else {
                    self?.presentAlert(title: "Error", message: "Something went wrong.", buttonTitle: "OK")
                }
            })
        } else {
            hideLoading()
            presentAlert(title: "Info", message: "Make sure that the passwords match and have more than 6 characters.", buttonTitle: "OK")
        }
    }
    
}
