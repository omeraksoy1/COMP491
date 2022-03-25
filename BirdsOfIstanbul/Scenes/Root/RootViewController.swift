//
//  RootViewController.swift
//  BirdsOfIstanbul
//
//  Created by Can Koz on 2.03.2022.
//

import UIKit
import SwiftUI

class RootViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let loginView = LoginView()
        let viewController = UIHostingController(rootView: loginView)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
