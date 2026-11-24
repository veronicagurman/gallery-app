//
//  SceneDelegate.swift
//  GalleryApp
//
//  Created by Veronica Gurman on 18.11.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard scene is UIWindowScene else { return }
        guard let galleryNavigation = window?.rootViewController as? UINavigationController else { return }

        galleryNavigation.tabBarItem = UITabBarItem(
            title: "Gallery",
            image: UIImage(systemName: "photo.on.rectangle"),
            tag: 0
        )

        let favoritesNavigation = UINavigationController(
            rootViewController: FavoritesViewController()
        )
        favoritesNavigation.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "star"),
            tag: 1
        )

        let tabBarController = UITabBarController()
        window?.rootViewController = nil
        tabBarController.viewControllers = [galleryNavigation, favoritesNavigation]
        window?.rootViewController = tabBarController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
       
    }

    func sceneWillResignActive(_ scene: UIScene) {
   
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
       
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }

}
