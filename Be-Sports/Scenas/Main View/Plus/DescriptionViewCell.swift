//
//  DescriptionViewCell.swift
//  Betus
//
//  Created by Gio's Mac on 09.12.24.
//

import UIKit
import SnapKit

class DescriptionViewCell: UICollectionViewCell {

    lazy var descriptionWorkoutTextfield: UITextField = {
        let view = UITextField(frame: .zero)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.font = UIFont.latoRegular(size: 14)
        view.layer.cornerRadius = 16
        view.textColor = UIColor(hexString: "FFFFFF")
        let placeholderText = "  Description of the workout"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hexString: "#FFFFFF").withAlphaComponent(0.4),
            .font: UIFont.latoRegular(size: 14)
        ]
        view.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 1))
        view.leftView = paddingView
        view.leftViewMode = .always
        return view
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraint()

        setupTapToDismissKeyboard()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        addSubview(descriptionWorkoutTextfield)
    }

    func setupConstraint() {
        descriptionWorkoutTextfield.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(5 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(10 * Constraint.xCoeff)
            make.height.greaterThanOrEqualTo(44 * Constraint.yCoeff)
        }
    }
    
    private func setupTapToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        endEditing(true)
    }
}
