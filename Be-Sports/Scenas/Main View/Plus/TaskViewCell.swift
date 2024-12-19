//
//  TaskViewCell.swift
//  Betus
//
//  Created by Gio's Mac on 09.12.24.
//

import UIKit
import SnapKit

class TaskViewCell: UICollectionViewCell {

    var didTapOnDeleteButton: (() -> Void )?

    lazy var taskView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 18
        return view
    }()

    private lazy var nameLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = ""
        view.textColor = UIColor(hexString: "FFFFFF")
        view.font = UIFont.systemFont(ofSize: 14)
        return view
    }()

    private lazy var timerLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = ""
        view.textColor = UIColor(hexString: "FFFFFF")
        view.font = UIFont.systemFont(ofSize: 14)
        return view
    }()

    private lazy var descriptionLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = ""
        view.textColor = UIColor(hexString: "FFFFFF").withAlphaComponent(0.7)
        view.font = UIFont.systemFont(ofSize: 12)
        view.numberOfLines = 0
        return view
    }()

    lazy var deleteTaskViewButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 44 * Constraint.xCoeff, height: 44 * Constraint.yCoeff))
        view.setImage(UIImage(named: "xButton"), for: .normal)
        view.backgroundColor = .clear
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.addTarget(self, action: #selector(pressDeleteTaskViewButton), for: .touchUpInside)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        addSubview(taskView)
        taskView.addSubview(nameLabel)
        taskView.addSubview(timerLabel)
        taskView.addSubview(descriptionLabel)
        taskView.addSubview(deleteTaskViewButton)
    }

    func setupConstraint() {
        taskView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        nameLabel.snp.remakeConstraints { make in
            make.top.equalTo(taskView.snp.top).offset(20 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(20 * Constraint.xCoeff)
            make.height.equalTo(44)
        }

        timerLabel.snp.remakeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(20 * Constraint.xCoeff)
            make.height.equalTo(24)
        }

        descriptionLabel.snp.remakeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom).offset(10 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(20 * Constraint.xCoeff)
        }

        deleteTaskViewButton.snp.remakeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.trailing.equalTo(taskView.snp.trailing).offset(-20)
            make.width.height.equalTo(44)
        }
    }

    func configure(task: Task) {
        nameLabel.text = task.title
        timerLabel.text = formatSecondsToTime(task.time)
        descriptionLabel.text = task.description
    }

    private func formatSecondsToTime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    @objc func pressDeleteTaskViewButton(_ sender: UIButton) {
        didTapOnDeleteButton?()
    }
}
