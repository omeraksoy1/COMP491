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
        navigationController?.navigationBar.isHidden = true // removes whitespace caused by navigation bar (IMPORTANT)
        navigationController?.navigationItem.hidesBackButton = true
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            if !(self.navigationController?.visibleViewController is LoadingViewController) {
                let loadingViewController = LoadingViewController.instantiateToPresent()
                self.navigationController?.present(loadingViewController, animated: false)
            }
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            if (self.navigationController?.visibleViewController is LoadingViewController) {
                self.navigationController?.dismiss(animated: false, completion: nil)
            }
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
