//
//  TaskView.swift
//  Betus
//
//  Created by Gio's Mac on 25.11.24.
//

import UIKit
import SnapKit

class TaskView: UIView {

    private lazy var taskLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Task"
        view.textColor = UIColor(hexString: "#FFFFFF66")
        view.textAlignment = .center
        view.font = UIFont.latoRegular(size: 14)
        return view
    }()

    lazy var taskNumberLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "5"
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
        addSubview(taskLabel)
        addSubview(taskNumberLabel)
    }

    private func setupConstraints() {
        taskLabel.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(8 * Constraint.yCoeff)
            make.centerX.equalTo(snp.centerX)
            make.height.equalTo(17 * Constraint.yCoeff)

        }
        
        taskNumberLabel.snp.remakeConstraints { make in
            make.bottom.equalTo(snp.bottom).offset(-8 * Constraint.yCoeff)
            make.centerX.equalTo(snp.centerX)
            make.height.equalTo(14 * Constraint.yCoeff)
        }

    }

}
