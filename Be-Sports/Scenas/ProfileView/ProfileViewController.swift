//
//  ProfileViewController.swift
//  Betus
//
//  Created by Gio's Mac on 26.11.24.
//

import UIKit
import SnapKit
import AuthenticationServices
import Alamofire
import ProgressHUD
import StoreKit

class ProfileViewController: UIViewController {
    private lazy var leftButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 44 * Constraint.xCoeff, height: 44 * Constraint.yCoeff))
        view.setImage(UIImage(named: "backArrow"), for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.setImage(UIImage(named: "backArrow")?.resize(to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)), for: .normal)
        view.addTarget(self, action: #selector(pressLeftButton), for: .touchUpInside)
        return view
    }()
    
    private lazy var userDeleteButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 44 * Constraint.xCoeff, height: 44 * Constraint.yCoeff))
        view.setImage(UIImage(named: "profileDelete"), for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.setImage(UIImage(named: "userProfile")?.resize(to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)), for: .normal)
        return view
    }()
    
    private lazy var termsOfUseButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 366 * Constraint.xCoeff, height: 59 * Constraint.yCoeff))
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
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 366 * Constraint.xCoeff, height: 59 * Constraint.yCoeff))
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
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 366 * Constraint.xCoeff, height: 59 * Constraint.yCoeff))
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
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 366 * Constraint.xCoeff, height: 59 * Constraint.yCoeff))
        view.setTitle("Rate US", for: .normal)
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
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 366 * Constraint.xCoeff, height: 59 * Constraint.yCoeff))
        view.setTitle("Delete Account", for: .normal)
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 16)
        view.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(pressDeleteAccountButton), for: .touchUpInside)
        view.isHidden = false
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
        view.isHidden = true
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#101538")
        view.applyGradientBackground()
        setup()
        setupConstraints()
        
        hiddenOrUnhidden()
        
        self.navigationItem.hidesBackButton = true
    }
    
    private func setup() {
        view.addSubview(leftButton)
        view.addSubview(userDeleteButton)
        view.addSubview(termsOfUseButton)
        view.addSubview(privacyPolicyButton)
        view.addSubview(supportButton)
        view.addSubview(rateUsButton)
        view.addSubview(deleteAccountButton)
        view.addSubview(signInWithAppleButton)
    }
    
    private func setupConstraints() {
        leftButton.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(80 * Constraint.yCoeff)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.width.height.equalTo(44 * Constraint.xCoeff)
        }
        
        userDeleteButton.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(80 * Constraint.yCoeff)
            make.trailing.equalTo(view.snp.trailing).offset(-20 * Constraint.xCoeff)
            make.width.height.equalTo(44 * Constraint.xCoeff)
        }
        
        termsOfUseButton.snp.remakeConstraints { make in
            make.top.equalTo(userDeleteButton.snp.bottom).offset(185 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(12 * Constraint.xCoeff)
            make.height.equalTo(59 * Constraint.yCoeff)
        }
        
        privacyPolicyButton.snp.remakeConstraints { make in
            make.top.equalTo(termsOfUseButton.snp.bottom).offset(10 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(12 * Constraint.xCoeff)
            make.height.equalTo(59 * Constraint.yCoeff)
        }
        
        supportButton.snp.remakeConstraints { make in
            make.top.equalTo(privacyPolicyButton.snp.bottom).offset(10 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(12 * Constraint.xCoeff)
            make.height.equalTo(59 * Constraint.yCoeff)
        }
        
        rateUsButton.snp.remakeConstraints { make in
            make.top.equalTo(supportButton.snp.bottom).offset(10 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(12 * Constraint.xCoeff)
            make.height.equalTo(59 * Constraint.yCoeff)
        }
        
        deleteAccountButton.snp.remakeConstraints { make in
            make.top.equalTo(rateUsButton.snp.bottom).offset(10 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(12 * Constraint.xCoeff)
            make.height.equalTo(59 * Constraint.yCoeff)
        }
        
        signInWithAppleButton.snp.remakeConstraints { make in
            make.top.equalTo(rateUsButton.snp.bottom).offset(10 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(12 * Constraint.xCoeff)
            make.height.equalTo(59 * Constraint.yCoeff)
        }
    }
    
    func hiddenOrUnhidden() {
        let isGuestUser = UserDefaults.standard.bool(forKey: "isGuestUser")
        deleteAccountButton.isHidden = isGuestUser
        signInWithAppleButton.isHidden = !isGuestUser
        
    }
    
    @objc private func pressLeftButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func pressTermsOfUserButton() {
        let termsURL = "https://be-sport.org/terms"
        let webViewController = WebViewController(urlString: termsURL)
        navigationController?.present(webViewController, animated: true)
    }
    
    @objc private func pressPrivacyPolicyButton() {
        let termsURL = "https://be-sport.org/privacy"
        let webViewController = WebViewController(urlString: termsURL)
        navigationController?.present(webViewController, animated: true)    }
    
    @objc private func pressSupportButton() {
        let termsURL = "https://be-sport.org/support"
        let webViewController = WebViewController(urlString: termsURL)
        navigationController?.present(webViewController, animated: true)    }
    
    @objc private func pressRateUsButton() {
        if let windowScene = view.window?.windowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    
    @objc private func pressDeleteAccountButton() {
        // Create an alert to confirm account deletion
        let alertController = UIAlertController(
            title: "Delete Account",
            message: "Are you sure you want to delete your account? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        // Add a "Delete" action
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteAccount()
        }
        
        // Add a "Cancel" action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        // Present the alert
        present(alertController, animated: true)
    }
    
    // Function to delete the account
    private func deleteAccount() {
        // Check if the user ID exists in UserDefaults
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? String else {
            return
        }
        
        // Define the API endpoint for deleting the account
        let url = "https://be-sport.org/api/v1/users/\(userId)"

        // Show a loading indicator
        //        ProgressHUD.show("Deleting account...")
        
        // Make the network request
        NetworkManager.shared.delete(url: url, parameters: nil, headers: nil) { [weak self] (result: Result<EmptyResponse>) in
            //            DispatchQueue.main.async {
            //                // Hide the loading indicator
            //                ProgressHUD.dismiss()
            //            }
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    // Clear user session data
                    UserDefaults.standard.removeObject(forKey: "userId")
                    UserDefaults.standard.setValue(true, forKey: "isGuestUser")
                    
                    // Redirect to the sign-in view
                    self?.navigateToSignInView()
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    // Show an error alert
                    self?.showAlert(title: "Error", message: "Failed to delete account. \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Navigate to the sign-in view
    private func navigateToSignInView() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            let signInViewController = SignInView()
            let navController = UINavigationController(rootViewController: signInViewController)
            sceneDelegate.changeRootViewController(navController)
        }
    }
    
    // Function to display alerts
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func clickSignInWithAppleButton() {
        //        // Simulating tokens for testing
        //        let mockPushToken = "mockPushTokenTest2"
        //        let mockAppleToken = "mockAppleTokenTest2"
        //
        //        // Store mock tokens in UserDefaults
        //        UserDefaults.standard.setValue(mockPushToken, forKey: "PushToken")
        //        UserDefaults.standard.setValue(mockAppleToken, forKey: "AccountCredential")
        //
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

extension ProfileViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        UserDefaults.standard.setValue(credential.user, forKey: "AccountCredential")
        createUser()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Authorization failed: \(error.localizedDescription)")
        showAlert(title: "Sign In Failed", description: error.localizedDescription)
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

