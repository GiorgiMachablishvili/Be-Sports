//
//  WorkLevelViewCell.swift
//  Betus
//
//  Created by Gio's Mac on 09.12.24.
//

import UIKit
import SnapKit

class WorkLevelViewCell: UICollectionViewCell {
    lazy var easyWorkoutLevelsButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 65 * Constraint.xCoeff, height: 41 * Constraint.yCoeff))
        view.setTitle("Easy Level", for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 14)
        view.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.addTarget(self, action: #selector(pressEasyLevelWorkoutButton), for: .touchUpInside)
        return view
    }()

    lazy var advancedWorkoutLevelsButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 65 * Constraint.xCoeff, height: 41 * Constraint.yCoeff))
        view.setTitle("Advanced Level", for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 14)
        view.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.addTarget(self, action: #selector(pressAdvanceLevelWorkoutButton), for: .touchUpInside)
        return view
    }()

    lazy var difficultWorkoutLevelsButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 65 * Constraint.xCoeff, height: 41 * Constraint.yCoeff))
        view.setTitle("Difficult Level", for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 14)
        view.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.addTarget(self, action: #selector(pressDifficultLevelWorkoutButton), for: .touchUpInside)
        return view
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraint()

        easyWorkoutLevelsButton.backgroundColor = UIColor.redColor

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        addSubview(easyWorkoutLevelsButton)
        addSubview(advancedWorkoutLevelsButton)
        addSubview(difficultWorkoutLevelsButton)
    }

    func setupConstraint() {
        easyWorkoutLevelsButton.snp.remakeConstraints { make in
            make.centerY.equalTo(advancedWorkoutLevelsButton.snp.centerY)
            make.trailing.equalTo(advancedWorkoutLevelsButton.snp.leading).offset(-8 * Constraint.xCoeff)
            make.width.equalTo(115 * Constraint.xCoeff)
            make.height.equalTo(41 * Constraint.yCoeff)
        }

        advancedWorkoutLevelsButton.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(5 * Constraint.yCoeff)
            make.centerX.equalTo(snp.centerX)
            make.width.equalTo(115 * Constraint.xCoeff)
            make.height.equalTo(41 * Constraint.yCoeff)
        }

        difficultWorkoutLevelsButton.snp.remakeConstraints { make in
            make.centerY.equalTo(advancedWorkoutLevelsButton.snp.centerY)
            make.leading.equalTo(advancedWorkoutLevelsButton.snp.trailing).offset(8 * Constraint.xCoeff)
            make.width.equalTo(115 * Constraint.xCoeff)
            make.height.equalTo(41 * Constraint.yCoeff)
        }
    }

    @objc func pressEasyLevelWorkoutButton() {
        resetButtonImages()
        easyWorkoutLevelsButton.backgroundColor = UIColor.redColor
    }

    @objc func pressAdvanceLevelWorkoutButton() {
        resetButtonImages()
        advancedWorkoutLevelsButton.backgroundColor = UIColor.redColor
    }

    @objc func pressDifficultLevelWorkoutButton() {
        resetButtonImages()
        difficultWorkoutLevelsButton.backgroundColor = UIColor.redColor
    }

    private func resetButtonImages() {
        easyWorkoutLevelsButton.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        advancedWorkoutLevelsButton.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        difficultWorkoutLevelsButton.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
    }

    func getSelectedLevel() -> String {
        if easyWorkoutLevelsButton.backgroundColor == UIColor.redColor {
            return "Easy"
        } else if advancedWorkoutLevelsButton.backgroundColor == UIColor.redColor {
            return "Advance"
        } else if difficultWorkoutLevelsButton.backgroundColor == UIColor.redColor {
            return "Difficult"
        } else {
            return "Unknown"
        }
    }

    func resetLevelSelection() {
        resetButtonImages()
        easyWorkoutLevelsButton.backgroundColor = UIColor.redColor
    }
}
