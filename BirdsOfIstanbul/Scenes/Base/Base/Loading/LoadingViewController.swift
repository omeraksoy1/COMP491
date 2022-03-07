//
//  LoadingViewController.swift
//  BirdsOfIstanbul
//
//  Created by Can Koz on 2.03.2022.
//

import UIKit
import NVActivityIndicatorView

class LoadingViewController: BaseViewController {

    @IBOutlet private weak var bottomText: UILabel!
    @IBOutlet private weak var loadingContainerView: UIView!
    @IBOutlet private weak var indicatorView: NVActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        bottomText.text = "Yükleniyor"
        loadingContainerView.roundCorners(radius: 12)
        indicatorView.type = .circleStrokeSpin
        indicatorView.color = .systemGreen
        indicatorView.startAnimating()
    }
       
}

extension LoadingViewController {
    static func instantiateToPresent() -> LoadingViewController {
        let loadingViewController: LoadingViewController = LoadingViewController.instantiate()
        loadingViewController.modalPresentationStyle = .overCurrentContext
        return loadingViewController
    }
}
