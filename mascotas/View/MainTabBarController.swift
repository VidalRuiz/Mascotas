//
//  MainTabBarController.swift
//  mascotas
//
//  Created by ruizvi | VIDAL RUIZ VARGAS on 26/04/25.
//

// MainTabBarController.swift
import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    private func setupTabs() {
        let homeVC = HomeViewController()
        let mascotasVC = MascotasListViewController()
        let responsablesVC = ResponsablesListViewController()
        
        homeVC.title = "Inicio"
        mascotasVC.title = "Mascotas"
        responsablesVC.title = "Responsables"
        
        let nav1 = UINavigationController(rootViewController: homeVC)
        let nav2 = UINavigationController(rootViewController: mascotasVC)
        let nav3 = UINavigationController(rootViewController: responsablesVC)
        
        nav1.tabBarItem = UITabBarItem(title: "Inicio", image: UIImage(systemName: "house.fill"), tag: 0)
        nav2.tabBarItem = UITabBarItem(title: "Mascotas", image: UIImage(systemName: "pawprint.fill"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Responsables", image: UIImage(systemName: "person.3.fill"), tag: 2)
        
        viewControllers = [nav1, nav2, nav3]
    }
}
