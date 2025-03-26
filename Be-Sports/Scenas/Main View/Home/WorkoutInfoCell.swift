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
        view.setImage(
            UIImage(named: "heart")?.resize(
                to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)
            ),
            for: .normal
        )
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
    
    // MARK: - Premium Badge
    private lazy var premiumBadgeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        return view
    }()
    
    
    
    
    var isLiked = false

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
        doNotBeInteractionEnabledLikeButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    // Make sure the gradient layer always has the correct size
    override func layoutSubviews() {
        super.layoutSubviews()
        
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
        
        // Add premium badge to the cell
        workoutImage.addSubview(premiumBadgeView)
        
        
    }

    private func setupConstraints() {
        workoutImage.snp.remakeConstraints { make in
            make.centerX.equalTo(snp.centerX)
            make.height.equalTo(236 * Constraint.xCoeff)
            make.width.equalTo(366 * Constraint.xCoeff)
        }

        workoutInfoView.snp.remakeConstraints { make in
            make.bottom.equalTo(workoutImage.snp.bottom).offset(-8 * Constraint.xCoeff)
            make.leading.trailing.equalToSuperview().inset(8 * Constraint.xCoeff)
            make.height.equalTo(144 * Constraint.yCoeff)
        }

        likeViewButton.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(8 * Constraint.yCoeff)
            make.trailing.equalTo(snp.trailing).offset(-8 * Constraint.xCoeff)
            make.height.equalTo(44 * Constraint.yCoeff)
            make.width.equalTo(66 * Constraint.xCoeff)
        }
        
        // Premium badge constraints (top-left corner on the workout image)
        premiumBadgeView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(12)
            make.height.equalTo(28)
            make.width.equalTo(80)
        }
        
        
    }

    // MARK: - Button Interaction
    func doNotBeInteractionEnabledLikeButton() {
        let isGuestUser = UserDefaults.standard.bool(forKey: "isGuestUser")
        likeViewButton.isUserInteractionEnabled = !isGuestUser
    }

    @objc func likeViewButtonTapped() {
        didTapOnLikeButton?()
    }

    // This updates the like-state UI
    private func updateLikeState(isSelected: Bool) {
        if isSelected {
            likeViewButton.setImage(
                UIImage(named: "heartFilled")?.resize(
                    to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)
                ),
                for: .normal
            )
            if let likes = Int(likeViewButton.title(for: .normal) ?? "0") {
                likeViewButton.setTitle("\(likes + 1)", for: .normal)
            }
        } else {
            likeViewButton.setImage(
                UIImage(named: "heart")?.resize(
                    to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)
                ),
                for: .normal
            )
            if let likes = Int(likeViewButton.title(for: .normal) ?? "0"), likes > 0 {
                likeViewButton.setTitle("\(likes - 1)", for: .normal)
            }
        }
    }

    // MARK: - Cell Configuration
    func configure(with data: Workouts, selectedLevel: String) {
        self.selectedLevel = selectedLevel

        workoutInfoView.workoutLevel.text = data.taskName
        workoutInfoView.taskView.taskNumberLabel.text = String(data.taskCount)
        workoutInfoView.timeView.remainingTime = Double(data.time)
        workoutInfoView.levelView.levelInfoLabel.text = data.level.rawValue
        workoutInfoView.ratingLabel.text = "\(data.rating)"

        // Set "likes" to the count of completers for now
        likeViewButton.setTitle("\(data.completers.count)", for: .normal)

        // Set image
        if let url = URL(string: data.image) {
            workoutImage.kf.setImage(with: url)
        }

        // Mark if workout is "liked"
        isLiked = data.isSelected
        updateLikeState(isSelected: data.isSelected)

        // Show or hide the premium badge
        premiumBadgeView.isHidden = !data.isPremium
    }
}
