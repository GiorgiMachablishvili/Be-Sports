//
//  WebViewController.swift
//  Betus
//
//  Created by Gio's Mac on 13.12.24.
//

import UIKit
import WebKit
import SnapKit

class WebViewController: UIViewController {
    private let webView = WKWebView()
    private let urlString: String

    private lazy var closeButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(named: "xButton"), for: .normal)
        view.backgroundColor = .blackBackgroundColor
        view.layer.cornerRadius = 22
        view.addTarget(self, action: #selector(pressCloseButton), for: .touchUpInside)
        return view
    }()

    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupConstraints()
        loadURL()
    }

    private func setup() {
        view.addSubview(webView)
        webView.addSubview(closeButton)
    }

    private func setupConstraints() {
        webView.snp.remakeConstraints{ make in
            make.edges.equalToSuperview()
        }

        closeButton.snp.remakeConstraints { make in
            make.top.equalTo(webView.snp.top).offset(20 * Constraint.yCoeff)
            make.trailing.equalTo(webView.snp.trailing).offset(-20 * Constraint.xCoeff)
            make.height.width.equalTo(40 * Constraint.yCoeff)
        }
    }

    private func loadURL() {
        guard let url = URL(string: urlString) else {
            showAlert(title: "Error", message: "Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc func pressCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}
