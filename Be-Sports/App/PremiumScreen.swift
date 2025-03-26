import UIKit
import WebKit

final class PremiumScreen: UIViewController {
    private let webView = WKWebView()
    private let endpoint: String

    init(endpoint: String) {
        self.endpoint = endpoint
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupWebView()
        loadPremiumPage()
    }

    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.url))
    }

    private func setupWebView() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)
    }

    private func loadPremiumPage() {
        if let url = URL(string: "https://be-sport.org/\(endpoint)") {
            webView.load(URLRequest(url: url))
        }
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?) {
        guard keyPath == #keyPath(WKWebView.url),
              let urlString = webView.url?.absoluteString else { return }

        if urlString.contains("#finish") {
            dismiss(animated: true)
        } else if urlString.contains("#restore") {
            PremiumManager.shared.restorePurchases { [weak self] success in
                if success {
                    self?.showSuccessAlert()
                }
            }
        } else if urlString.contains("#monthly") {
            PremiumManager.shared.buyMonthly { [weak self] success in
                if success {
                    self?.showSuccessAlert()
                }
            }
        } else if urlString.contains("#yearly") {
            PremiumManager.shared.buyYearly { [weak self] success in
                if success {
                    self?.showSuccessAlert()
                }
            }
        }
    }

    private func showSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "Premium activated successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
}
