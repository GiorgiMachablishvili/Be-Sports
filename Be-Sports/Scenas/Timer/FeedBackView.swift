

import UIKit
import SnapKit

class FeedBackView: UIView {

    var didPressSkipButton: (() -> Void)?
    var didPressLeaveAFeedbackButton: ((Int) -> Void)?
    var didSubmitRating: ((Int) -> Void)?

    private var selectedRating: Int = 0 {
        didSet {
            updateStarRating()
        }
    }

    private lazy var mainBackgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear.withAlphaComponent(0.3)
        return view
    }()

    private lazy var ratingView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(hexString: "#170C0C")
        view.layer.cornerRadius = 32  * Constraint.yCoeff
        return view
    }()

    private lazy var feedbackBackgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(hexString: "#FFFFFF")
        view.layer.cornerRadius = 20 * Constraint.yCoeff
        return view
    }()

    private lazy var feedbackLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Feedback"
        view.textColor = .blackBackgroundColor
        view.font = UIFont.latoThin(size: 14)
        view.textAlignment = .center
        return view
    }()

    private lazy var feedbackAskLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Do you really think this content violates the rules or contains violence, nudity, offence or anything else?"
        view.textColor = UIColor(hexString: "#FFFFFF").withAlphaComponent(0.3)
        view.font = UIFont.latoThin(size: 14)
        view.textAlignment = .center
        view.numberOfLines = 2
        return view
    }()

    private lazy var starStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()

    private lazy var stars: [UIButton] = {
        return (0..<5).map { index in
            let button = UIButton()
            button.tag = index + 1
            button.setImage(UIImage(systemName: "star"), for: .normal)
            button.setImage(UIImage(systemName: "star.fill"), for: .selected)
            button.tintColor = UIColor(hexString: "#D53729")
            button.addTarget(self, action: #selector(didTapStar(_:)), for: .touchUpInside)
            return button
        }
    }()

    private lazy var skipButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setTitle("Skip", for: .normal)
        view.titleLabel?.font = UIFont.latoBold(size: 16)
        view.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
        view.backgroundColor = .clear
        view.layer.cornerRadius = 22
        view.layer.borderColor = UIColor(hexString: "#FFFFFF").withAlphaComponent(0.6).cgColor
        view.layer.borderWidth = 1
        view.addTarget(self, action: #selector(pressSkipButton), for: .touchUpInside)
        return view
    }()

    private lazy var leaveAFeedbackButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setTitle("Leave a feedback", for: .normal)
        view.titleLabel?.font = UIFont.latoBold(size: 16)
        view.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
        view.backgroundColor = UIColor(hexString: "#D53729")
        view.layer.cornerRadius = 22
        view.layer.borderColor = UIColor(hexString: "#FFFFFF").withAlphaComponent(0.6).cgColor
        view.layer.borderWidth = 1
        view.addTarget(self, action: #selector(pressLeaveAFeedbackButton), for: .touchUpInside)
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
        addSubview(mainBackgroundView)
        addSubview(ratingView)
        addSubview(feedbackBackgroundView)
        addSubview(feedbackLabel)
        addSubview(feedbackAskLabel)
        ratingView.addSubview(starStackView)
        stars.forEach { starStackView.addArrangedSubview($0) }
        addSubview(skipButton)
        addSubview(leaveAFeedbackButton)
    }

    private func setupConstraints() {
        mainBackgroundView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        ratingView.snp.remakeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(280 * Constraint.yCoeff)
        }

        feedbackBackgroundView.snp.remakeConstraints { make in
            make.centerX.equalTo(ratingView)
            make.top.equalTo(ratingView.snp.top).offset(16 * Constraint.yCoeff)
            make.height.equalTo(41 * Constraint.yCoeff)
            make.width.equalTo(91 * Constraint.xCoeff)
        }

        feedbackLabel.snp.remakeConstraints { make in
            make.center.equalTo(feedbackBackgroundView)
        }

        feedbackAskLabel.snp.remakeConstraints { make in
            make.centerX.equalTo(ratingView)
            make.top.equalTo(feedbackBackgroundView.snp.bottom).offset(20 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(16 * Constraint.xCoeff)
        }

        starStackView.snp.makeConstraints { make in
            make.centerX.equalTo(ratingView)
            make.bottom.equalTo(skipButton.snp.top).offset(-24 * Constraint.yCoeff)
            make.width.equalTo(250 * Constraint.xCoeff)
            make.height.equalTo(44 * Constraint.yCoeff)
        }

        skipButton.snp.remakeConstraints { make in
            make.leading.equalTo(ratingView.snp.leading).offset(16 * Constraint.xCoeff)
            make.bottom.equalTo(ratingView.snp.bottom).offset(-32 * Constraint.yCoeff)
            make.height.equalTo(44 * Constraint.yCoeff)
            make.width.equalTo(175 * Constraint.xCoeff)
        }

        leaveAFeedbackButton.snp.remakeConstraints { make in
            make.trailing.equalTo(ratingView.snp.trailing).offset(-16 * Constraint.xCoeff)
            make.bottom.equalTo(ratingView.snp.bottom).offset(-32 * Constraint.yCoeff)
            make.height.equalTo(44 * Constraint.yCoeff)
            make.width.equalTo(175 * Constraint.xCoeff)
        }
    }

    @objc private func didTapStar(_ sender: UIButton) {
        selectedRating = sender.tag
    }

    private func updateStarRating() {
        for (index, button) in stars.enumerated() {
            button.isSelected = index < selectedRating
        }
    }

    @objc private func pressSkipButton() {
        didPressSkipButton?()
    }

    @objc private func pressLeaveAFeedbackButton() {
//        didPressLeaveAFeedbackButton?()
//        didSubmitRating?(selectedRating)

        if let submitRating = didSubmitRating {
                submitRating(selectedRating) // Ensure the rating is passed
            }
            didPressLeaveAFeedbackButton?(selectedRating)
    }
}
