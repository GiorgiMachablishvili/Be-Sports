

import UIKit
import WebKit

final class WelcomeScreen: UIViewController {
    
    private let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupWebView()
        loadWelcomePage()
    }

    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.url))
    }

    private func setupWebView() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)
    }

    private func loadWelcomePage() {
        // If user is premium, pass ?isPremium=True to your web page.
        // The page can hide monthly/yearly buttons and only show “Restore”.
        let isPremium = UserDefaults.standard.bool(forKey: "isPremium")
        var urlString = "https://be-sport.org/welcome"
        if isPremium {
            urlString += "?isPremium=True"
        }
        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }

    // MARK: - KVO on WebView URL for hash changes (#finish, #monthly, etc.)
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?) {
        guard
            keyPath == #keyPath(WKWebView.url),
            let urlString = webView.url?.absoluteString
        else { return }

        switch true {
        case urlString.contains("#finish"):
            dismiss(animated: true)

        case urlString.contains("#restore"):
            PremiumManager.shared.restorePurchases { [weak self] success in
                if success {
                    self?.handlePremiumUnlocked()
                }
            }

        case urlString.contains("#monthly"):
            PremiumManager.shared.buyMonthly { [weak self] success in
                if success {
                    self?.handlePremiumUnlocked()
                }
            }

        case urlString.contains("#yearly"):
            PremiumManager.shared.buyYearly { [weak self] success in
                if success {
                    self?.handlePremiumUnlocked()
                }
            }

        default:
            break
        }
    }

    // MARK: - Handle Premium Unlock

    // Called whenever subscription or restore was successful
    private func handlePremiumUnlocked() {
        // 1) Update user as Premium on the device
        //    (PremiumManager likely already set `isPremium = true` in UserDefaults)
        // 2) Update user in your backend
        updateUserToPremiumInBackend { [weak self] _ in
            // 3) Show success
            self?.showSuccessAlert()
        }
    }

    private func showSuccessAlert() {
        let alert = UIAlertController(
            title: "Success",
            message: "Premium activated successfully.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.dismiss(animated: true)
        })
        present(alert, animated: true)
    }

    // MARK: - Backend Update

    // Example: PUT /api/v1/users/{userId} with is_premium = true
    private func updateUserToPremiumInBackend(completion: @escaping (Bool) -> Void) {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            completion(false)
            return
        }

        let url = "https://be-sport.org/api/v1/users/\(userId)"
        let params: [String: Any] = ["is_premium": true]

        NetworkManager.shared.put(url: url, parameters: params, headers: nil) { (result: Result<UserInfo>) in
            switch result {
            case .success(let userInfo):
                print("Updated user to premium in backend: \(userInfo)")
                completion(true)
            case .failure(let error):
                print("Failed to update user in backend: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
}
