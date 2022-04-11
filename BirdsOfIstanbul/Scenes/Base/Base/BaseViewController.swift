//
//  BaseViewController.swift
//  BirdsOfIstanbul
//
//  Created by Can Koz on 2.03.2022.
//

import UIKit

protocol Skippable {}

class BaseViewController: UIViewController {
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if self is Skippable {
            if let index = self.navigationController?.viewControllers.firstIndex(of: self) {
                self.navigationController?.viewControllers.remove(at: index)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .systemGreen
    }
    
    func showLoading() {
        if !(navigationController?.visibleViewController is LoadingViewController) {
            let loadingViewController = LoadingViewController.instantiateToPresent()
            navigationController?.present(loadingViewController, animated: false)
        }
    }
    
    func hideLoading() {
        if (navigationController?.visibleViewController is LoadingViewController) {
            navigationController?.dismiss(animated: false, completion: nil)
        }
    }
    
    func showPredicting() {
        if !(navigationController?.visibleViewController is LoadingViewController) {
            let loadingViewController = LoadingViewController.instantiateToPresent()
            navigationController?.present(loadingViewController, animated: false)
            loadingViewController.prepareToPredict()
        }
        
    }
    
    func presentAlert(title: String, message: String, buttonTitle: String){
        DispatchQueue.main.async {
            let alertVC = AlertViewController(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
}
