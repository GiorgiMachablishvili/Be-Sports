//
//  HomeHeaderViewCell.swift
//  Betus
//
//  Created by Gio's Mac on 26.11.24.
//

import UIKit
import SnapKit

protocol HomeHeaderViewDelegate: AnyObject {
    func didPressUserInfoButton()
    func filterWorkouts(by level: Workouts.Level)
    func searchWorkouts(with searchText: String)
}

class HomeHeaderView: UICollectionReusableView {

    weak var delegate: HomeHeaderViewDelegate?

    private lazy var userInfoButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 44 * Constraint.xCoeff, height: 44 * Constraint.yCoeff))
        view.setImage(UIImage(named: "userProfile"), for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.setImage(UIImage(named: "userProfile")?.resize(to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)), for: .normal)
        view.addTarget(self, action: #selector(pressUserInfoButton), for: .touchUpInside)
        return view
    }()

    private lazy var searchButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 44 * Constraint.xCoeff, height: 44 * Constraint.yCoeff))
        view.setImage(UIImage(named: "searchImage"), for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.setImage(UIImage(named: "searchImage")?.resize(to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)), for: .normal)
        view.isHidden = false
        view.addTarget(self, action: #selector(pressSearchButton), for: .touchUpInside)
        return view
    }()

    private lazy var backButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 44 * Constraint.xCoeff, height: 44 * Constraint.yCoeff))
        view.setImage(UIImage(named: "backArrow"), for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.setImage(UIImage(named: "backArrow")?.resize(to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)), for: .normal)
        view.isHidden = true
        view.addTarget(self, action: #selector(pressBackButton), for: .touchUpInside)
        return view
    }()

    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar(frame: .zero)
        view.layer.cornerRadius = 22
        view.placeholder = "Search"
        view.backgroundColor = .clear
        view.tintColor = UIColor(hexString: "FFFFFF")
        view.isHidden = true
        view.searchBarStyle = .minimal
        view.delegate = self
        if let textField = view.value(forKey: "searchField") as? UITextField {
            let placeholderTextColor = UIColor.lightGray
            textField.attributedPlaceholder = NSAttributedString(
                string: "Search",
                attributes: [NSAttributedString.Key.foregroundColor: placeholderTextColor]
            )
            textField.textColor = UIColor(hexString: "FFFFFF")
            if let iconView = textField.leftView as? UIImageView {
                iconView.tintColor = UIColor.lightGray
                iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
            }
        }
        return view
    }()

    private lazy var allWorkoutLevelsButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 65 * Constraint.xCoeff, height: 41 * Constraint.yCoeff))
        view.setTitle("All", for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 14)
        view.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(clickAllWorkoutButton), for: .touchUpInside)
        return view
    }()

    private lazy var easyWorkoutLevelsButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 65 * Constraint.xCoeff, height: 41 * Constraint.yCoeff))
        view.setTitle("Easy", for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 14)
        view.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(clickEasyWorkoutButton), for: .touchUpInside)
        return view
    }()

    private lazy var advancedWorkoutLevelsButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 65 * Constraint.xCoeff, height: 41 * Constraint.yCoeff))
        view.setTitle("Advance", for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 14)
        view.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(clickAdvancedButton), for: .touchUpInside)
        return view
    }()
    
    private lazy var difficultWorkoutLevelsButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 65 * Constraint.xCoeff, height: 41 * Constraint.yCoeff))
        view.setTitle("Difficult", for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 14)
        view.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(clickDifficultButton), for: .touchUpInside)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
        allWorkoutLevelsButton.backgroundColor = UIColor(hexString: "E5D820")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(userInfoButton)
        addSubview(searchButton)
        addSubview(backButton)
        addSubview(searchBar)
        addSubview(allWorkoutLevelsButton)
        addSubview(easyWorkoutLevelsButton)
        addSubview(advancedWorkoutLevelsButton)
        addSubview(difficultWorkoutLevelsButton)
    }

    private func setupConstraints() {
        userInfoButton.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(10 * Constraint.yCoeff)
            make.leading.equalTo(snp.leading).offset(12 * Constraint.xCoeff)
            make.width.height.equalTo(44 * Constraint.xCoeff)
        }

        searchButton.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(10 * Constraint.yCoeff)
            make.trailing.equalTo(snp.trailing).offset(-12 * Constraint.xCoeff)
            make.width.height.equalTo(44 * Constraint.yCoeff)
        }

        backButton.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(10 * Constraint.yCoeff)
            make.leading.equalTo(snp.leading).offset(12 * Constraint.xCoeff)
            make.width.height.equalTo(44 * Constraint.xCoeff)
        }

        searchBar.snp.remakeConstraints { make in
            make.centerY.equalTo(backButton.snp.centerY)
            make.leading.equalTo(backButton.snp.trailing).offset(4 * Constraint.xCoeff)
            make.width.equalTo(318 * Constraint.xCoeff)
            make.height.equalTo(44 * Constraint.yCoeff)
        }

        allWorkoutLevelsButton.snp.remakeConstraints { make in
            make.top.equalTo(userInfoButton.snp.bottom).offset(10 * Constraint.yCoeff)
            make.leading.equalTo(snp.leading).offset(2 * Constraint.xCoeff)
            make.width.equalTo(65 * Constraint.xCoeff)
            make.height.equalTo(41 * Constraint.yCoeff)
        }

        easyWorkoutLevelsButton.snp.remakeConstraints { make in
            make.centerY.equalTo(allWorkoutLevelsButton.snp.centerY)
            make.leading.equalTo(allWorkoutLevelsButton.snp.trailing).offset(4 * Constraint.xCoeff)
            make.width.equalTo(77 * Constraint.xCoeff)
            make.height.equalTo(41 * Constraint.yCoeff)
        }

        advancedWorkoutLevelsButton.snp.remakeConstraints { make in
            make.centerY.equalTo(allWorkoutLevelsButton.snp.centerY)
            make.leading.equalTo(easyWorkoutLevelsButton.snp.trailing).offset(4 * Constraint.xCoeff)
            make.width.equalTo(110 * Constraint.xCoeff)
            make.height.equalTo(41 * Constraint.yCoeff)
        }

        difficultWorkoutLevelsButton.snp.remakeConstraints { make in
            make.centerY.equalTo(allWorkoutLevelsButton.snp.centerY)
            make.leading.equalTo(advancedWorkoutLevelsButton.snp.trailing).offset(4 * Constraint.xCoeff)
            make.width.equalTo(98 * Constraint.xCoeff)
            make.height.equalTo(41 * Constraint.yCoeff)
        }
    }

    private func resetButtonImages() {
        allWorkoutLevelsButton.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        easyWorkoutLevelsButton.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        advancedWorkoutLevelsButton.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        difficultWorkoutLevelsButton.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
    }

    @objc private func clickAllWorkoutButton() {
        resetButtonImages()
        allWorkoutLevelsButton.backgroundColor = UIColor(hexString: "E5D820")
        delegate?.filterWorkouts(by: .all)
    }

    @objc private func clickEasyWorkoutButton() {
        resetButtonImages()
        easyWorkoutLevelsButton.backgroundColor = UIColor(hexString: "E5D820")
        delegate?.filterWorkouts(by: .easy)
    }

    @objc private func clickAdvancedButton() {
        resetButtonImages()
        advancedWorkoutLevelsButton.backgroundColor = UIColor(hexString: "E5D820")
        delegate?.filterWorkouts(by: .advance)
    }

    @objc private func clickDifficultButton() {
        resetButtonImages()
        difficultWorkoutLevelsButton.backgroundColor = UIColor(hexString: "E5D820")
        delegate?.filterWorkouts(by: .difficult)
    }

    @objc private func pressUserInfoButton() {
        delegate?.didPressUserInfoButton()
    }

    @objc private func pressBackButton() {
        searchBar.isHidden = true
        searchButton.isHidden = false
        userInfoButton.isHidden = false
        backButton.isHidden = true

    }

    @objc private func pressSearchButton() {
        searchBar.isHidden = false
        searchButton.isHidden = true
        userInfoButton.isHidden = true
        backButton.isHidden = false
    }
}

extension HomeHeaderView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.searchWorkouts(with: searchText)
    }
}
