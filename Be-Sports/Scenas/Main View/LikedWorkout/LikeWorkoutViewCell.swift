

import UIKit
import SnapKit
import Kingfisher

class LikeWorkoutViewCell: UICollectionViewCell {
    var didTapOnLikeButton: (() -> Void)?

    lazy var workoutImageLikeView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleToFill
        view.image = UIImage(systemName: "figure.australian.football.circle")
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.isHidden = false
        return view
    }()

    lazy var workoutInfoView: WorkoutInfoView = {
        let view = WorkoutInfoView()
        view.layer.cornerRadius = 26
        view.isHidden = false
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
        addSubview(workoutImageLikeView)
        workoutImageLikeView.addSubview(workoutInfoView)
        workoutImageLikeView.addSubview(likeViewButton)
    }

    private func setupConstraints() {
        workoutImageLikeView.snp.remakeConstraints { make in
            make.centerX.equalTo(snp.centerX)
            make.height.equalTo(236 * Constraint.xCoeff)
            make.width.equalTo(366 * Constraint.xCoeff)
        }

        workoutInfoView.snp.remakeConstraints { make in
            make.bottom.equalTo(workoutImageLikeView.snp.bottom).offset(-8 * Constraint.yCoeff)
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

    @objc func likeViewButtonTapped() {
        updateLikeState()
        didTapOnLikeButton?()
    }
    
    private func updateLikeState() {
        let currentLikes = Int(likeViewButton.title(for: .normal) ?? "0") ?? 0
        if currentLikes > 0 {
            likeViewButton.setTitle("\(currentLikes - 1)", for: .normal)
            likeViewButton.setImage(UIImage(named: "heart")?.resize(to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)), for: .normal)
        }

        NotificationCenter.default.post(
                name: NSNotification.Name("unLikeWorkout.view.observer"),
                object: nil
            )
    }

    func configure(with data: Workouts) {
        workoutInfoView.workoutLevel.text = data.taskName
        workoutInfoView.taskView.taskNumberLabel.text = String(data.taskCount)
        workoutInfoView.timeView.remainingTime = Double(data.time)
        workoutInfoView.levelView.levelInfoLabel.text = data.level.rawValue
        likeViewButton.setTitle("\(data.likeCount)", for: .normal)

        let buttonImage = data.isSelected ? "heartFilled" : "heart"
        likeViewButton.setImage(UIImage(named: buttonImage)?.resize(to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)), for: .normal)

        if let url = URL(string: data.image) {
            workoutImageLikeView.kf.setImage(with: url)
        }
//        updateLikeState()
    }
}
