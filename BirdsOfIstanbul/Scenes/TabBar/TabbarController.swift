//
//  TabbarController.swift
//  BirdsOfIstanbul
//
//  Created by Can Koz on 13.04.2022.
//

import UIKit
import SwiftUI

class TabBarController: UITabBarController {
    
    var importedRecords: Record?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .systemGreen
        tabBar.barTintColor = .white
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.backgroundColor = .white
        navigationItem.hidesBackButton = true
        viewControllers = [createRecordNC(), createObservationsNC(), createExploreNC(), createAccountNC()]
    }
    
    func createRecordNC() -> UINavigationController {
        let vc = RecordingViewController()
        vc.tabBarItem = UITabBarItem(title: "Recording", image: UIImage(named: "record")?.resizeImage(targetSize: CGSize(width: 28, height: 28)), tag: 0)
        return UINavigationController(rootViewController: vc)
    }
    
    func createObservationsNC() -> UINavigationController {
        let vc = ObservationsViewController()
        vc.tabBarItem = UITabBarItem(title: "Observation", image: UIImage(named: "observation")?.resizeImage(targetSize: CGSize(width: 25, height: 25)), tag: 1)
        return UINavigationController(rootViewController: vc)
    }
    
    func createExploreNC() -> UINavigationController {
        let exploreBirdsView = ExploreBirdsView()
        let vc = UIHostingController(rootView: exploreBirdsView)
        vc.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(named: "explore")?.resizeImage(targetSize: CGSize(width: 28, height: 28)), tag: 2)
        return UINavigationController(rootViewController: vc)
    }
    
    func createAccountNC() -> UINavigationController {
        let vc = ProfileViewController()
        vc.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile")?.resizeImage(targetSize: CGSize(width: 25, height: 25)), tag: 3)
        return UINavigationController(rootViewController: vc)
    }
}
