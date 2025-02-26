//
//  WarningView.swift
//  Betus
//
//  Created by Gio's Mac on 27.11.24.
//

import UIKit
import SnapKit

protocol WarningViewDelegate: AnyObject {
    func didPressComplaintButton()
    func didPressDontWantToSeeUserAccountButton()
    func didPressSheWillFileAComlaintButton()
    func didPressCancelButton ()
}

class WarningView: UIView {

    weak var delegate: WarningViewDelegate?

    private var allWorkouts: [Workouts] = []
    

    private lazy var complaintButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 96 * Constraint.xCoeff, height: 41 * Constraint.yCoeff))
        view.setTitle("Complaint", for: .normal)
        view.backgroundColor = UIColor(hexString: "FFFFFF")
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 14)
        view.setTitleColor(UIColor(hexString: "#1D0840"), for: .normal)
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(pressComplaintButton), for: .touchUpInside)
        return view
    }()

    private lazy var askLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Do you really think this content violates the rules or contains violence, nudity, offence or anything else?"
        view.textAlignment = .center
        view.numberOfLines = 0
        view.font = UIFont.latoRegular(size: 14)
        view.textColor = UIColor(hexString: "FFFFFF")
        return view
    }()

    private lazy var dontWantToSeeUserAccountButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 358 * Constraint.xCoeff, height: 44 * Constraint.yCoeff))
        view.setTitle("I don't want to see this user's content", for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.2)
        view.layer.cornerRadius = 22
        view.titleLabel?.font = UIFont.latoRegular(size: 14)
        view.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.init(hexString: "FFFFFF").cgColor
        view.layer.borderWidth = 1
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(pressDontWantToSeeUserAccountButton), for: .touchUpInside)
        return view
    }()

    private lazy var sheWillFileAComlaintButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 358 * Constraint.xCoeff, height: 44 * Constraint.yCoeff))
        view.setTitle("Yeah, she'll file a complaint", for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.2)
        view.layer.cornerRadius = 22
        view.titleLabel?.font = UIFont.latoRegular(size: 14)
        view.setTitleColor(UIColor(hexString: "FFFFFF").withAlphaComponent(25), for: .normal)
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.init(hexString: "FFFFFF").cgColor
        view.layer.borderWidth = 1
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(pressSheWillFileAComlaintButton), for: .touchUpInside)
        return view
    }()

    private lazy var cancelButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 216 * Constraint.xCoeff, height: 44 * Constraint.yCoeff))
        view.setTitle("Cancel", for: .normal)
        view.backgroundColor = UIColor.redColor
        view.layer.cornerRadius = 22
        view.titleLabel?.font = UIFont.latoRegular(size: 14)
        view.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.init(hexString: "FFFFFF").cgColor
        view.layer.borderWidth = 1
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(pressCancelButton), for: .touchUpInside)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.blackBackgroundColor
        setup()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(complaintButton)
        addSubview(askLabel)
        addSubview(dontWantToSeeUserAccountButton)
        addSubview(sheWillFileAComlaintButton)
        addSubview(cancelButton)
    }

    private func setupConstraints() {
        complaintButton.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(16 * Constraint.yCoeff)
            make.centerX.equalToSuperview()
            make.width.equalTo(96 * Constraint.xCoeff)
            make.height.equalTo(41 * Constraint.yCoeff)
        }

        askLabel.snp.remakeConstraints { make in
            make.top.equalTo(complaintButton.snp.bottom).offset(20 * Constraint.yCoeff)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16 * Constraint.xCoeff)
            make.height.equalTo(34 * Constraint.yCoeff)
        }

        dontWantToSeeUserAccountButton.snp.remakeConstraints { make in
            make.top.equalTo(askLabel.snp.bottom).offset(48 * Constraint.yCoeff)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16 * Constraint.xCoeff)
            make.height.equalTo(44 * Constraint.yCoeff)
        }

        sheWillFileAComlaintButton.snp.remakeConstraints { make in
            make.top.equalTo(dontWantToSeeUserAccountButton.snp.bottom).offset(4 * Constraint.yCoeff)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16 * Constraint.xCoeff)
            make.height.equalTo(44 * Constraint.yCoeff)
        }

        cancelButton.snp.remakeConstraints { make in
            make.bottom.equalTo(snp.bottom).offset(-34 * Constraint.yCoeff)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(87 * Constraint.xCoeff)
            make.height.equalTo(44 * Constraint.yCoeff)
        }
    }

    @objc func pressComplaintButton() {
        delegate?.didPressComplaintButton()
    }

    @objc func pressDontWantToSeeUserAccountButton() {
        delegate?.didPressDontWantToSeeUserAccountButton()
    }

    @objc func pressSheWillFileAComlaintButton() {
        delegate?.didPressSheWillFileAComlaintButton()
    }

    @objc private func pressCancelButton() {
        delegate?.didPressCancelButton()
    }
}
