//
//  WorkoutInfoCell.swift
//  Betus
//
//  Created by Gio's Mac on 25.11.24.
//

import UIKit
import SnapKit
import Kingfisher

class WorkoutInfoCell: UICollectionViewCell {
    var selectedLevel: String?
    var workout: Workouts?
    var likes: LikeResponse?

    var didTapOnLikeButton: (() -> Void)?

    lazy var workoutImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleToFill
        view.backgroundColor = .gray
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var workoutInfoView: WorkoutInfoView = {
        let view = WorkoutInfoView()
        view.layer.cornerRadius = 26
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.4)
        view.layer.masksToBounds = true
        return view
    }()

    lazy var likeViewButton: NonPropagatingButton = {
        let view = NonPropagatingButton(type: .system)
        view.setTitle("44", for: .normal)
        view.setImage(UIImage(named: "heart")?.resize(to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)), for: .normal)
        view.tintColor = UIColor(hexString: "FFFFFF")
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.3)
        view.layer.cornerRadius = 22
        view.imageView?.contentMode = .scaleAspectFit
        view.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8 * Constraint.xCoeff)
        view.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8 * Constraint.xCoeff, bottom: 0, right: 0)
        view.addTarget(self, action: #selector(likeViewButtonTapped), for: .touchUpInside)
        return view
    }()
    
    var isLiked = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let convertedPoint = likeViewButton.convert(point, from: self)
        if likeViewButton.bounds.contains(convertedPoint) {
            return likeViewButton
        }
        return super.hitTest(point, with: event)
    }

    private func setup() {
        contentView.addSubview(workoutImage)
        workoutImage.addSubview(workoutInfoView)
        workoutImage.addSubview(likeViewButton)
    }

    private func setupConstraints() {
        workoutImage.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        workoutInfoView.snp.remakeConstraints { make in
            make.bottom.equalTo(workoutImage.snp.bottom).offset(-8 * Constraint.xCoeff)
            make.leading.trailing.equalToSuperview().inset(8 * Constraint.xCoeff)
            make.height.equalTo(116 * Constraint.yCoeff)
        }

        likeViewButton.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(8 * Constraint.yCoeff)
            make.trailing.equalTo(snp.trailing).offset(-8 * Constraint.xCoeff)
            make.height.equalTo(44 * Constraint.yCoeff)
            make.width.equalTo(66 * Constraint.xCoeff)
        }
    }

//    func doNotBeInteractionEnabledLikeButton() {
//        let isGuestUser = UserDefaults.standard.bool(forKey: "isGuestUser")
//        likeViewButton.isUserInteractionEnabled = isGuestUser
//    }

    @objc func likeViewButtonTapped() {
        didTapOnLikeButton?()
    }

    private func updateLikeState(isSelected: Bool) {
        if isSelected {
            likeViewButton.setImage(UIImage(named: "heartFilled")?.resize(to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)), for: .normal)
            if let likes = Int(likeViewButton.title(for: .normal) ?? "0") {
                likeViewButton.setTitle("\(likes + 1)", for: .normal)
            }
        } else {
            likeViewButton.setImage(UIImage(named: "heart")?.resize(to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)), for: .normal)
            if let likes = Int(likeViewButton.title(for: .normal) ?? "0"), likes > 0 {
                likeViewButton.setTitle("\(likes - 1)", for: .normal)
            }
        }
    }

    func configure(with data: Workouts, selectedLevel: String) {
        self.selectedLevel = selectedLevel

        workoutInfoView.workoutLevel.text = data.taskName
        workoutInfoView.taskView.taskNumberLabel.text = String(data.taskCount)
        workoutInfoView.timeView.remainingTime = Double(data.time)
        workoutInfoView.levelView.levelInfoLabel.text = data.level.rawValue
        isLiked = data.isSelected

        likeViewButton.setTitle("\(data.completers.count)", for: .normal)

        if let url = URL(string: data.image) {
            workoutImage.kf.setImage(with: url)
        }
        updateLikeState(isSelected: data.isSelected)
    }
}
