//
//  TimeView.swift
//  Betus
//
//  Created by Gio's Mac on 25.11.24.
//

import UIKit
import SnapKit

class TimeView: UIView {
    var remainingTime: TimeInterval = 0 {
        didSet {
            updateTimerLabel()
        }
    }
    var remainingTimeInt: Int {
        return Int(remainingTime)
    }

    private lazy var timeLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Time"
        view.textColor = UIColor(hexString: "#FFFFFF66")
        view.textAlignment = .center
        view.font = UIFont.latoRegular(size: 14)
        return view
    }()

    lazy var timerLabel: UILabel = {
        let view = UILabel()
        let hours = Int(remainingTimeInt) / 3600
        let minutes = (Int(remainingTimeInt) % 3600) / 60
        let seconds = Int(remainingTimeInt) % 60
        view.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        view.font = UIFont.boldSystemFont(ofSize: 18)
        view.textColor = UIColor(hexString: "FFFFFF")
        view.textAlignment = .center
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
        addSubview(timeLabel)
        addSubview(timerLabel)
    }

    private func setupConstraints() {
        timeLabel.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(8 * Constraint.yCoeff)
            make.centerX.equalTo(snp.centerX)
            make.height.equalTo(17 * Constraint.yCoeff)

        }

        timerLabel.snp.remakeConstraints { make in
            make.bottom.equalTo(snp.bottom).offset(-8 * Constraint.yCoeff)
            make.centerX.equalTo(snp.centerX)
            make.height.equalTo(14 * Constraint.yCoeff)
        }
    }

    private func updateTimerLabel() {
        let hours = remainingTimeInt / 3600
        let minutes = (remainingTimeInt % 3600) / 60
        let seconds = remainingTimeInt % 60
        timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
