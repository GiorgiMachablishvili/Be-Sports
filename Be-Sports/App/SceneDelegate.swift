import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        PremiumManager.shared.start()
        setupInitialRootViewController()
        window?.makeKeyAndVisible()
    }

    private func setupInitialRootViewController() {
        if let userId = UserDefaults.standard.string(forKey: "userId"), !userId.isEmpty {
            let mainViewController = MainViewControllerTab()
            UserDefaults.standard.setValue(false, forKey: "isGuestUser")
            let navigationController = UINavigationController(rootViewController: mainViewController)
            changeRootViewController(navigationController)
        } else {
            let signInViewController = SignInView()
            let navigationController = UINavigationController(rootViewController: signInViewController)
            changeRootViewController(navigationController)
        }
    }

    private func presentWelcomeScreen() {
        let vc = WelcomeScreen()
        vc.modalPresentationStyle = .fullScreen
        guard let rootVC = window?.rootViewController else { return }
        rootVC.present(vc, animated: true)
    }

    func changeRootViewController(_ rootViewController: UIViewController, animated: Bool = true) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate,
              let window = sceneDelegate.window else { return }
        if animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = rootViewController
            })
        } else {
            window.rootViewController = rootViewController
        }
        window.makeKeyAndVisible()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        presentWelcomeScreen()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
