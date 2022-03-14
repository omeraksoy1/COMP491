//
//  RootViewController.swift
//  BirdsOfIstanbul
//
//  Created by Can Koz on 2.03.2022.
//

import UIKit

class RootViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let walkthroughViewController = WalkthroughViewController.instantiate()
        navigationController?.pushViewController(walkthroughViewController, animated: true)
    }
}
