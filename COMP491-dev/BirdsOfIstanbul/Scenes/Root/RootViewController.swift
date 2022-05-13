//
//  RootViewController.swift
//  BirdsOfIstanbul
//
//  Created by Can Koz on 2.03.2022.
//

import UIKit
import SwiftUI
import FirebaseAuth
class RootViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            if user != nil {
                let tabbar = TabBarController()
                self?.navigationController?.pushViewController(tabbar, animated: true)
            } else {
                let loginView = LoginView()
                let viewController = UIHostingController(rootView: loginView)
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}
