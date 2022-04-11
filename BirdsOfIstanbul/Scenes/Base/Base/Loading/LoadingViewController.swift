//
//  LoadingViewController.swift
//  BirdsOfIstanbul
//
//  Created by Can Koz on 2.03.2022.
//

import UIKit
import NVActivityIndicatorView

class LoadingViewController: BaseViewController {

    @IBOutlet weak var bottomText: UILabel!
    @IBOutlet private weak var loadingContainerView: UIView!
    @IBOutlet weak var indicatorView: NVActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        bottomText.text = "Loading"
        loadingContainerView.roundCorners(radius: 12)
        indicatorView.type = .circleStrokeSpin
        indicatorView.color = .systemGreen
        indicatorView.startAnimating()
    }
    
    func prepareToPredict() {
        bottomText.text = "Predicting"
        indicatorView.color = .systemRed
    }
       
}

extension LoadingViewController {
    static func instantiateToPresent() -> LoadingViewController {
        let loadingViewController: LoadingViewController = LoadingViewController.instantiate()
        loadingViewController.modalPresentationStyle = .overCurrentContext
        return loadingViewController
    }
}
