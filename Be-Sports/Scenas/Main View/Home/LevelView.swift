//
//  LevelView.swift
//  Betus
//
//  Created by Gio's Mac on 25.11.24.
//

import UIKit
import SnapKit

class LevelView: UIView {

    private lazy var levelLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Level"
        view.textColor = UIColor(hexString: "#FFFFFF66")
        view.textAlignment = .center
        view.font = UIFont.latoRegular(size: 14)
        return view
    }()

    lazy var levelInfoLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Hard"
        view.textColor = UIColor(hexString: "FFFFFF")
        view.textAlignment = .center
        view.font = UIFont.latoBold(size: 18)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearBlur(withAlpha: 0.2)
        setup()
        setupConstraints()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setup() {
        addSubview(levelLabel)
        addSubview(levelInfoLabel)
    }

    private func setupConstraints() {
        levelLabel.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(8 * Constraint.yCoeff)
            make.centerX.equalTo(snp.centerX)
            make.height.equalTo(17 * Constraint.yCoeff)

        }

        levelInfoLabel.snp.remakeConstraints { make in
            make.bottom.equalTo(snp.bottom).offset(-8 * Constraint.yCoeff)
            make.centerX.equalTo(snp.centerX)
            make.height.equalTo(14 * Constraint.yCoeff)
        }

    }
}
