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
        let coreDataManager = CoreDataManager()
        coreDataManager.save()
    }
}
