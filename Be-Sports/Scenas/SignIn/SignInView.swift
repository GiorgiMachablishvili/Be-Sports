

import UIKit
import SnapKit
import AuthenticationServices
import Alamofire
import ProgressHUD


class SignInView: UIViewController {

    private lazy var singInLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Sign IN"
        view.textColor = UIColor.init(hexString: "FFFFFF")
        view.font = UIFont.latoBold(size: 24)
        view.textAlignment = .center
        return view
    }()

    private lazy var singInInfoLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Log in with your Apple ID to swiftly and safely access all the features of our game!"
        view.textColor = UIColor.init(hexString: "FFFFFF").withAlphaComponent(0.4)
        view.font = UIFont.latoBold(size: 14)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()

    private lazy var signInWithAppleButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setTitle("Sign In with Apple", for: .normal)
        view.setTitleColor(UIColor(hexString: "000000"), for: .normal)
        view.backgroundColor = UIColor(hexString: "FFFFFF")
        view.layer.cornerRadius = 16
        view.layer.borderColor = UIColor(hexString: "FFFFFF").cgColor
        view.layer.borderWidth = 1
        view.setImage(UIImage(named: "appleLogo"), for: .normal)
        view.imageView?.contentMode = .scaleAspectFit
        view.imageEdgeInsets = UIEdgeInsets(top: 16 * Constraint.yCoeff, left: -5 * Constraint.xCoeff, bottom: 16 * Constraint.yCoeff, right: 0)
        view.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.addTarget(self, action: #selector(clickSignInWithAppleButton), for: .touchUpInside)
        return view
    }()


    private lazy var logInAsGuestButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setTitle("log in as guest", for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 16
        view.layer.borderColor = UIColor.init(hexString: "FFFFFF").withAlphaComponent(0.4).cgColor
        view.layer.borderWidth = 1
        view.addTarget(self, action: #selector(clickLogInAsGuestButton), for: .touchUpInside)
        return view
    }()

    private lazy var termsButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setTitle("Terms", for: .normal)
        view.setTitleColor(UIColor(hexString: "FFFFFF").withAlphaComponent(0.4), for: .normal)
        view.titleLabel?.font = UIFont.latoRegular(size: 10)
        view.backgroundColor = .clear
        view.addTarget(self, action: #selector(clickTermsButton), for: .touchUpInside)
        return view
    }()

    private lazy var termsLine: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.backgroundColor = UIColor(hexString: "FFFFFF").withAlphaComponent(0.4)
        return view
    }()

    private lazy var andLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "and"
        view.textColor = UIColor(hexString: "FFFFFF").withAlphaComponent(0.4)
        view.font = UIFont.latoRegular(size: 10)
        view.textAlignment = .center
        return view
    }()

    private lazy var privacyPolicyButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setTitle("Privacy Policy", for: .normal)
        view.setTitleColor(UIColor(hexString: "FFFFFF").withAlphaComponent(0.4), for: .normal)
        view.titleLabel?.font = UIFont.latoRegular(size: 10)
        view.backgroundColor = .clear
        view.addTarget(self, action: #selector(clickPrivacyPolicyButton), for: .touchUpInside)
        return view
    }()

    private lazy var privacyLine: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.backgroundColor = UIColor(hexString: "FFFFFF").withAlphaComponent(0.4)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupConstraints()
        view.backgroundColor = UIColor.init(hexString: "101538")
//        view.backgroundColor = UIColor(hexString: "#170C0C")
        view.applyGradientBackground()
    }

    private func setup() {
        view.addSubview(singInLabel)
        view.addSubview(singInInfoLabel)
        view.addSubview(signInWithAppleButton)
        view.addSubview(logInAsGuestButton)
        view.addSubview(termsButton)
        view.addSubview(andLabel)
        view.addSubview(privacyPolicyButton)
        view.addSubview(termsLine)
        view.addSubview(privacyLine)


    }

    private func setupConstraints() {
        singInLabel.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(384 * Constraint.yCoeff)
            make.centerX.equalToSuperview()
            make.height.equalTo(29 * Constraint.yCoeff)
        }

        singInInfoLabel.snp.remakeConstraints { make in
            make.top.equalTo(singInLabel.snp.bottom).offset(12 * Constraint.xCoeff)
            make.leading.trailing.equalToSuperview().inset(47 * Constraint.yCoeff)
        }

        signInWithAppleButton.snp.remakeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-127 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(37 * Constraint.xCoeff)
            make.height.equalTo(59 * Constraint.yCoeff)
        }

        logInAsGuestButton.snp.remakeConstraints { make in
            make.top.equalTo(signInWithAppleButton.snp.bottom).offset(8 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(37 * Constraint.xCoeff)
            make.height.equalTo(59 * Constraint.yCoeff)
        }

        termsButton.snp.remakeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(134 * Constraint.xCoeff)
            make.top.equalTo(logInAsGuestButton.snp.bottom).offset(12 * Constraint.yCoeff)
            make.width.equalTo(30 * Constraint.xCoeff)
            make.height.equalTo(12 * Constraint.yCoeff)
        }

        termsLine.snp.remakeConstraints { make in
            make.top.equalTo(termsButton.snp.bottom).offset(2 * Constraint.xCoeff)
            make.leading.equalTo(view.snp.leading).offset(134 * Constraint.xCoeff)
            make.width.equalTo(30 * Constraint.xCoeff)
            make.height.equalTo(1 * Constraint.yCoeff)
        }

        andLabel.snp.remakeConstraints { make in
            make.leading.equalTo(termsButton.snp.trailing).offset(5  * Constraint.xCoeff)
            make.top.equalTo(logInAsGuestButton.snp.bottom).offset(12 * Constraint.yCoeff)
            make.width.equalTo(25 * Constraint.xCoeff)
            make.height.equalTo(12 * Constraint.yCoeff)
        }

        privacyPolicyButton.snp.remakeConstraints { make in
            make.leading.equalTo(andLabel.snp.trailing).offset(5 * Constraint.xCoeff)
            make.top.equalTo(logInAsGuestButton.snp.bottom).offset(12 * Constraint.yCoeff)
            make.width.equalTo(65 * Constraint.xCoeff)
            make.height.equalTo(12 * Constraint.yCoeff)
        }

        privacyLine.snp.remakeConstraints { make in
            make.top.equalTo(privacyPolicyButton.snp.bottom).offset(2)
            make.leading.equalTo(andLabel.snp.trailing).offset(5 * Constraint.xCoeff)
            make.width.equalTo(65 * Constraint.xCoeff)
            make.height.equalTo(1 * Constraint.yCoeff)
        }
    }

    @objc func clickTermsButton() {
        let termsURL = "https://be-sport.org/terms"
        let webViewController = WebViewController(urlString: termsURL)
        navigationController?.present(webViewController, animated: true)
    }

    @objc func clickPrivacyPolicyButton() {
        let termsURL = "https://be-sport.org/privacy"
        let webViewController = WebViewController(urlString: termsURL)
        navigationController?.present(webViewController, animated: true)
    }

    // MARK: - Button Actions
    @objc func clickLogInAsGuestButton() {
        UserDefaults.standard.setValue(true, forKey: "isGuestUser")

        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "AccountCredential")

        let mainVC = MainViewControllerTab()
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(mainVC, animated: true)
    }

    @objc func clickSignInWithAppleButton() {
        //        // Simulating tokens for testing
        //        let mockPushToken = "mockPushTokenTest2"
        //        let mockAppleToken = "mockAppleTokenTest2"

        //        // Store mock tokens in UserDefaults
        //        UserDefaults.standard.setValue(mockPushToken, forKey: "PushToken")
        //        UserDefaults.standard.setValue(mockAppleToken, forKey: "AccountCredential")

        //        // Call createUser to simulate user creation
        //        createUser()

        let authorizationProvider = ASAuthorizationAppleIDProvider()
        let request = authorizationProvider.createRequest()
        request.requestedScopes = [.email, .fullName]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }

    private func createUser() {
        NetworkManager.shared.showProgressHud(true, animated: true)

        let pushToken = UserDefaults.standard.string(forKey: "PushToken") ?? ""
        let appleToken = UserDefaults.standard.string(forKey: "AccountCredential") ?? ""

        // Prepare parameters
        let parameters: [String: Any] = [
            "push_token": pushToken,
            "auth_token": appleToken
        ]

        // Make the network request
        NetworkManager.shared.post(
            url: "https://be-sport.org/api/v1/users/",
            parameters: parameters,
            headers: nil
        ) { [weak self] (result: Result<UserInfo>) in
            guard let self = self else { return }

            DispatchQueue.main.async {
                NetworkManager.shared.showProgressHud(false, animated: false)
                UserDefaults.standard.setValue(false, forKey: "isGuestUser")
            }

            switch result {
            case .success(let userInfo):
                DispatchQueue.main.async {
                    print("User created: \(userInfo)")
                    UserDefaults.standard.setValue(userInfo.id, forKey: "userId")
                    print("Received User ID: \(userInfo.id)")

                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        let mainViewController = MainViewControllerTab()
                        let navigationController = UINavigationController(rootViewController: mainViewController)
                        sceneDelegate.changeRootViewController(navigationController)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", description: error.localizedDescription)
                }
                print("Error: \(error)")
            }
        }
    }

    private func showAlert(title: String, description: String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension SignInView: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        UserDefaults.standard.setValue(credential.user, forKey: "AccountCredential")

        createUser()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Authorization failed: \(error.localizedDescription)")
//        showAlert(title: "Sign In Failed", description: error.localizedDescription)
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}


