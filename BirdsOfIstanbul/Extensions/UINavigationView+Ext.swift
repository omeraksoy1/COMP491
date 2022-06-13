//
//  UINavigationView+Ext.swift
//  BirdsOfIstanbul
//
//  Created by Can Koz on 25.03.2022.
//

import UIKit
import SwiftUI

extension UINavigationController: UINavigationControllerDelegate {
    convenience init(rootView: AnyView) {
        let hostingView = UIHostingController(rootView: rootView)
        self.init(rootViewController: hostingView)
        self.delegate = self
    }

    public func pushView(view: AnyView) {
        let hostingView = UIHostingController(rootView: view)
        self.pushViewController(hostingView, animated: true)
    }

    public func popView() {
        self.popViewController(animated: true)
    }

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.navigationBar.isHidden = true
    }
}
