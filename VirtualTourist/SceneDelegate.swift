//
//  SceneDelegate.swift
//  VirtualTourist
//
//  Created by Isabella Bencardino on 12/05/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Initialize Root View Controller
        let rootViewController = UIStoryboard(name: "Main", bundle: .main).instantiateInitialViewController { coder in
            let mainNavigationVC = UINavigationController(coder: coder)

            guard let travelLocationVC = mainNavigationVC?.viewControllers.first as? TravelLocationViewController else {
                fatalError("Root view controller is not correct on Storyboard")
            }

            // inject view model on first view controller
            travelLocationVC.viewModel = TravelLocationViewModel()
            return mainNavigationVC
        }

        // Initialize Window
        window = UIWindow(windowScene: windowScene)

        // Configure Window
        window?.rootViewController = rootViewController

        // Make Window Key Window
        window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

}
