//
//  WalkthroughViewController.swift
//  BirdsOfIstanbul
//
//  Created by Can Koz on 2.03.2022.
//

import UIKit
import SwiftUI

class WalkthroughViewController: BaseViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTappedSoundID(_ sender: Any) {
        let recordingVC = RecordingViewController()
        navigationController?.pushViewController(recordingVC, animated: true)
    }
    
    @IBAction func exploreBirdsPressed(_ sender: Any) {
        let exploreBirdsView = ExploreBirdsView()
        let viewController = UIHostingController(rootView: exploreBirdsView)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
