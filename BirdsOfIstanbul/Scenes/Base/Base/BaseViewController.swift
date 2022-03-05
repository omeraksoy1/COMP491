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
        navigationController?.navigationBar.tintColor = .green
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
}
