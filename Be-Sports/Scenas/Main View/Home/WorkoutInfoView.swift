

import UIKit
import SnapKit

class WorkoutInfoView: UIView {

    lazy var workoutLevel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = UIFont.latoBold(size: 16)
        view.textColor = UIColor(hexString: "FFFFFF")
        view.textAlignment = .left
        view.text = "Workout Hard"
        return view
    }()

    lazy var ratingImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "star")
        view.contentMode = .scaleAspectFit
        return view
    }()

    lazy var ratingLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = UIFont.latoBold(size: 14)
        view.textColor = UIColor(hexString: "FFFFFF")
        view.textAlignment = .left
        view.text = "0.0"
        return view
    }()

    lazy var taskView: TaskView = {
        let view = TaskView()
        view.layer.cornerRadius = 16
        return view
    }()

    lazy var timeView: TimeView = {
        let view = TimeView()
        view.layer.cornerRadius = 16
        return view
    }()

    lazy var levelView: LevelView = {
        let view = LevelView()
        view.layer.cornerRadius = 16
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearBlur(withAlpha: 0.5)

        setup()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(workoutLevel)
        addSubview(ratingImage)
        addSubview(ratingLabel)
        addSubview(taskView)
        addSubview(timeView)
        addSubview(levelView)
    }

    private func setupConstraints() {
        workoutLevel.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(20 * Constraint.yCoeff)
            make.leading.equalTo(snp.leading).offset(20 * Constraint.xCoeff)
            make.height.equalTo(19 * Constraint.yCoeff)
        }

        ratingImage.snp.remakeConstraints { make in
            make.top.equalTo(workoutLevel.snp.bottom).offset(8 * Constraint.yCoeff)
            make.leading.equalTo(snp.leading).offset(20 * Constraint.xCoeff)
            make.height.width.equalTo(20 * Constraint.yCoeff)
        }

        ratingLabel.snp.remakeConstraints { make in
            make.centerY.equalTo(ratingImage)
            make.leading.equalTo(ratingImage.snp.trailing).offset(4 * Constraint.xCoeff)
        }

        taskView.snp.remakeConstraints { make in
            make.top.equalTo(ratingImage.snp.bottom).offset(8 * Constraint.yCoeff)
            make.trailing.equalTo(timeView.snp.leading).offset(-4 * Constraint.xCoeff)
            make.height.equalTo(51 * Constraint.yCoeff)
            make.width.equalTo(100 * Constraint.xCoeff)
        }

        timeView.snp.remakeConstraints { make in
            make.centerY.equalTo(taskView.snp.centerY)
            make.centerX.equalTo(snp.centerX)
            make.height.equalTo(51 * Constraint.yCoeff)
            make.width.equalTo(100 * Constraint.xCoeff)
        }

        levelView.snp.remakeConstraints { make in
            make.centerY.equalTo(taskView.snp.centerY)
            make.leading.equalTo(timeView.snp.trailing).offset(4 * Constraint.xCoeff)
            make.height.equalTo(51 * Constraint.yCoeff)
            make.width.equalTo(100 * Constraint.xCoeff)
        }
    }
}
