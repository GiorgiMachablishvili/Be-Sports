import UIKit
import SnapKit
import AuthenticationServices
import Alamofire
import ProgressHUD
import StoreKit

class ProfileViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var leftButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(named: "backArrow"), for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.setImage(
            UIImage(named: "backArrow")?.resize(
                to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)
            ),
            for: .normal
        )
        view.addTarget(self, action: #selector(pressLeftButton), for: .touchUpInside)
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10 * Constraint.yCoeff
        return stack
    }()
    
    // Removed restorePurchasesButton & activatePremiumButton for this version
    
    private lazy var termsOfUseButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setTitle("Terms of use", for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 16)
        view.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(pressTermsOfUserButton), for: .touchUpInside)
        return view
    }()
    
    private lazy var privacyPolicyButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setTitle("Privacy policy", for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 16)
        view.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(pressPrivacyPolicyButton), for: .touchUpInside)
        return view
    }()
    
    private lazy var supportButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setTitle("Support", for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 16)
        view.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(pressSupportButton), for: .touchUpInside)
        return view
    }()
    
    private lazy var rateUsButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setTitle("Rate Us", for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 16)
        view.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(pressRateUsButton), for: .touchUpInside)
        return view
    }()
    
    private lazy var deleteAccountButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setTitle("Delete Account", for: .normal)
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 16)
        view.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(pressDeleteAccountButton), for: .touchUpInside)
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
        view.imageEdgeInsets = UIEdgeInsets(
            top: 16 * Constraint.yCoeff,
            left: -5 * Constraint.xCoeff,
            bottom: 16 * Constraint.yCoeff,
            right: 0
        )
        view.titleEdgeInsets = .zero
        view.addTarget(self, action: #selector(clickSignInWithAppleButton), for: .touchUpInside)
        view.isHidden = true
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blackBackgroundColor
        view.applyGradientBackground()
        
        setupViews()
        setupConstraints()
        hiddenOrUnhidden()
        
        navigationItem.hidesBackButton = true
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        view.addSubview(leftButton)
        
        // Scroll hierarchy
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        // Add your buttons to the stackView
        stackView.addArrangedSubview(termsOfUseButton)
        stackView.addArrangedSubview(privacyPolicyButton)
        stackView.addArrangedSubview(supportButton)
        stackView.addArrangedSubview(rateUsButton)
        stackView.addArrangedSubview(deleteAccountButton)
        stackView.addArrangedSubview(signInWithAppleButton)
        // Removed in-app purchase buttons
    }
    
    private func setupConstraints() {
        leftButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20 * Constraint.yCoeff)
            make.leading.equalToSuperview().offset(20 * Constraint.xCoeff)
            make.width.height.equalTo(44 * Constraint.xCoeff)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(leftButton.snp.bottom).offset(20 * Constraint.yCoeff)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20 * Constraint.yCoeff)
            make.leading.equalTo(contentView.snp.leading).offset(12 * Constraint.xCoeff)
            make.trailing.equalTo(contentView.snp.trailing).offset(-12 * Constraint.xCoeff)
            make.bottom.equalTo(contentView.snp.bottom).offset(-20 * Constraint.yCoeff)
        }
        
        let buttonHeight = 59 * Constraint.yCoeff
        let buttonWidth = 366 * Constraint.xCoeff
        
        [
            termsOfUseButton,
            privacyPolicyButton,
            supportButton,
            rateUsButton,
            deleteAccountButton,
            signInWithAppleButton
        ].forEach { button in
            button.snp.makeConstraints { make in
                make.width.equalTo(buttonWidth)
                make.height.equalTo(buttonHeight)
            }
        }
    }
    
    // MARK: - Show/Hide
    
    func hiddenOrUnhidden() {
        let isGuestUser = UserDefaults.standard.bool(forKey: "isGuestUser")
        deleteAccountButton.isHidden = isGuestUser
        signInWithAppleButton.isHidden = !isGuestUser
    }
    
    // MARK: - Actions
    
    @objc private func pressLeftButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func pressTermsOfUserButton() {
        let termsURL = "https://be-sport.org/terms"
        let webViewController = WebViewController(urlString: termsURL)
        navigationController?.present(webViewController, animated: true)
    }
    
    @objc private func pressPrivacyPolicyButton() {
        let url = "https://be-sport.org/privacy"
        let webViewController = WebViewController(urlString: url)
        navigationController?.present(webViewController, animated: true)
    }
    
    @objc private func pressSupportButton() {
        let url = "https://be-sport.org/support"
        let webViewController = WebViewController(urlString: url)
        navigationController?.present(webViewController, animated: true)
    }
    
    @objc private func pressRateUsButton() {
        if let windowScene = view.window?.windowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    
    @objc private func pressDeleteAccountButton() {
        let alertController = UIAlertController(
            title: "Delete Account",
            message: "Are you sure you want to delete your account? This action cannot be undone.",
            preferredStyle: .alert
        )
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteAccount()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    private func deleteAccount() {
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? String else {
            return
        }
        let url = "https://be-sport.org/api/v1/users/\(userId)"
        
        NetworkManager.shared.delete(url: url, parameters: nil, headers: nil) {
            [weak self] (result: Result<EmptyResponse>) in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    UserDefaults.standard.removeObject(forKey: "userId")
                    UserDefaults.standard.setValue(true, forKey: "isGuestUser")
                    self?.navigateToSignInView()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(
                        title: "Error",
                        message: "Failed to delete account. \(error.localizedDescription)"
                    )
                }
            }
        }
    }
    
    private func navigateToSignInView() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            let signInViewController = SignInView()
            let navController = UINavigationController(rootViewController: signInViewController)
            sceneDelegate.changeRootViewController(navController)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Apple Sign In
extension ProfileViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        UserDefaults.standard.setValue(credential.user, forKey: "AccountCredential")
        createUser()
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        print("Authorization failed:", error.localizedDescription)
        showAlert(title: "Sign In Failed", message: error.localizedDescription)
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    private func createUser() {
        NetworkManager.shared.showProgressHud(true, animated: true)
        let pushToken = UserDefaults.standard.string(forKey: "PushToken") ?? ""
        let appleToken = UserDefaults.standard.string(forKey: "AccountCredential") ?? ""
        
        let parameters: [String: Any] = [
            "push_token": pushToken,
            "auth_token": appleToken
        ]
        
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
                    print("User created:", userInfo)
                    UserDefaults.standard.setValue(userInfo.id, forKey: "userId")
                    
                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        let mainViewController = MainViewControllerTab()
                        let navigationController = UINavigationController(rootViewController: mainViewController)
                        sceneDelegate.changeRootViewController(navigationController)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
                print("Error creating user:", error)
            }
        }
    }
    
    @objc private func clickSignInWithAppleButton() {
        let authorizationProvider = ASAuthorizationAppleIDProvider()
        let request = authorizationProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}
