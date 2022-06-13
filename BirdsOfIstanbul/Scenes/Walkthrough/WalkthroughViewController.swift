////
////  WalkthroughViewController.swift
////  BirdsOfIstanbul
////
////  Created by Can Koz on 2.03.2022.
////
//
//import UIKit
//import SwiftUI
//import FirebaseAuth
//
//class WalkthroughViewController: BaseViewController {
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationItem.hidesBackButton = true
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//
//    @IBAction func didTappedSoundID(_ sender: Any) {
//        let recordingVC = RecordingViewController()
//        navigationController?.pushViewController(recordingVC, animated: true)
//    }
//
//    @IBAction func exploreBirdsPressed(_ sender: Any) {
//        let exploreBirdsView = ExploreBirdsView()
//        let viewController = UIHostingController(rootView: exploreBirdsView)
//        navigationController?.pushViewController(viewController, animated: true)
//    }
//
//    @IBAction func didTappedSignOut(_ sender: Any) {
//        do {
//            try Auth.auth().signOut()
//        } catch {
//            presentAlert(title: "Error", message: "Authorization server error.", buttonTitle: "OK")
//        }
//
//    }
//
//    func loadWithImport(with file: Record) {
//
//    }
//}
//
//struct WalkthroughUIViewController: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> WalkthroughViewController {
//        let viewController = WalkthroughViewController.instantiate()
//        viewController.navigationController?.navigationItem.hidesBackButton = true
//
//        return viewController
//    }
//
//    func updateUIViewController(_ uiViewController: WalkthroughViewController, context: Context) {
//    }
//
//    typealias UIViewControllerType = WalkthroughViewController
//}
