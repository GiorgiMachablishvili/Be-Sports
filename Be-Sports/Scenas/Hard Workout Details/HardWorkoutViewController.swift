//
//  HardWorkoutViewController.swift
//  Betus
//
//  Created by Gio's Mac on 27.11.24.
//

import UIKit
import SnapKit

class HardWorkoutViewController: UIViewController {

    var workoutData: Workouts?
    private var blockedUserId: [Workouts] = []
    private var blockedPost: [Workouts] = []

    private var blockedWorkoutIds: Set<String> = []
    private var blockedUserIds: Set<String> = []

    lazy var leftButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 44 * Constraint.xCoeff, height: 44 * Constraint.yCoeff))
        view.setImage(UIImage(named: "backArrow"), for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.2)
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.layer.borderColor = UIColor.init(hexString: "FFFFFF").cgColor
        view.layer.borderWidth = 1
        view.setImage(UIImage(named: "backArrow")?.resize(to: CGSize(width: 16, height: 16)), for: .normal)
        view.addTarget(self, action: #selector(pressLeftButton), for: .touchUpInside)
        return view
    }()

    lazy var warningButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 44 * Constraint.xCoeff, height: 44 * Constraint.yCoeff))
        view.setImage(UIImage(named: "danger"), for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.2)
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.layer.borderColor = UIColor.init(hexString: "FFFFFF").cgColor
        view.layer.borderWidth = 1
        view.setImage(UIImage(named: "danger")?.resize(to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)), for: .normal)
        view.addTarget(self, action: #selector(pressWarningButton), for: .touchUpInside)
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Hard Workout"
        view.textAlignment = .center
        view.font = UIFont.latoRegular(size: 16)
        view.textColor = UIColor(hexString: "FFFFFF")
        return view
    }()

    private lazy var workoutLevelLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Level Difficult"
        view.textAlignment = .center
        view.font = UIFont.latoRegular(size: 12)
        view.textColor = UIColor(hexString: "FFFFFF").withAlphaComponent(40)
        return view
    }()

    lazy var likeViewButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("0", for: .normal)
        view.setImage(UIImage(named: "heart")?.resize(to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)), for: .normal)
        view.tintColor = UIColor(hexString: "FFFFFF")
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16 * Constraint.yCoeff, weight: .bold)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.2)
        view.layer.cornerRadius = 16
        view.imageView?.contentMode = .scaleAspectFit
        view.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8 * Constraint.xCoeff)
        view.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8 * Constraint.xCoeff, bottom: 0, right: 0)
        //        view.addTarget(self, action: #selector(likeViewButtonTapped), for: .touchUpInside)
        return view
    }()

    lazy var workoutImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleToFill
        view.image = UIImage(systemName: "figure.australian.football.circle")
        view.layer.cornerRadius = 26
        return view
    }()

    private lazy var workoutDetailsYellowButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 131 * Constraint.xCoeff, height: 41 * Constraint.yCoeff))
        view.setTitle("Workout details", for: .normal)
        view.backgroundColor = UIColor.redColor
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 16)
        view.setTitleColor(UIColor(hexString: "#1D0840"), for: .normal)
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.blackBackgroundColor.cgColor
        view.layer.borderWidth = 6
        view.imageView?.contentMode = .scaleAspectFit
        return view
    }()

    lazy var workoutInfoView: WorkoutInfoView = {
        let view = WorkoutInfoView()
        view.layer.cornerRadius = 26
        view.layer.borderColor = UIColor.init(hexString: "FFFFFF").cgColor
        view.layer.borderWidth = 1
        return view
    }()

    private lazy var workoutDetailsWhiteButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 131 * Constraint.xCoeff, height: 41 * Constraint.yCoeff))
        view.setTitle("Workout details", for: .normal)
        view.backgroundColor = UIColor(hexString: "#FFFFFF")
        view.layer.cornerRadius = 22
        view.titleLabel?.font = UIFont.latoRegular(size: 16)
        view.setTitleColor(UIColor(hexString: "#1D0840"), for: .normal)
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.blackBackgroundColor.cgColor
        view.layer.borderWidth = 6
        view.imageView?.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var reminderLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Don't miss new goals and levels in our football game - turn on notifications and keep your finger on the pulse! .  Don't miss notifi tions the"
        view.textAlignment = .center
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.2)
        view.numberOfLines = 0
        view.layer.cornerRadius = 22
        view.font = UIFont.latoRegular(size: 14)
        view.layer.borderColor = UIColor.init(hexString: "FFFFFF").cgColor
        view.layer.borderWidth = 1
        view.textColor = UIColor(hexString: "FFFFFF").withAlphaComponent(40)
        return view
    }()

    private lazy var startWorkoutButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 216 * Constraint.xCoeff, height: 60 * Constraint.yCoeff))
        view.setTitle("Start This Workout", for: .normal)
        view.backgroundColor = UIColor.redColor
        view.layer.cornerRadius = 26
        view.titleLabel?.font = UIFont.latoRegular(size: 16)
        view.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.init(hexString: "#FFFFFF").cgColor
        view.layer.borderWidth = 1
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(pressStartWorkoutButton), for: .touchUpInside)
        return view
    }()

    private lazy var darkOverlay: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isHidden = true
        return view
    }()

    private lazy var warningView: WarningView = {
        let view = WarningView()
        view.layer.cornerRadius = 32
        view.isHidden = true
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackBackgroundColor

        view.applyGradientBackground()
        setup()
        setupConstraints()
        configureWithData()

//        blockUserWithId()
//        blockWorkoutWithId()

        self.navigationItem.hidesBackButton = true
    }

    private func setup() {
        view.addSubview(leftButton)
        view.addSubview(warningButton)
        view.addSubview(titleLabel)
        view.addSubview(workoutLevelLabel)
        view.addSubview(likeViewButton)
        view.addSubview(workoutImage)
        view.addSubview(workoutInfoView)
        view.addSubview(workoutDetailsYellowButton)
        view.addSubview(reminderLabel)
        view.addSubview(workoutDetailsWhiteButton)
        view.addSubview(startWorkoutButton)
        view.addSubview(darkOverlay)
        view.addSubview(warningView)
    }

    private func setupConstraints() {
        leftButton.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(80 * Constraint.yCoeff)
            make.leading.equalTo(view.snp.leading).offset(20 * Constraint.xCoeff)
            make.width.height.equalTo(44 * Constraint.xCoeff)
        }

        warningButton.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(80 * Constraint.yCoeff)
            make.leading.equalTo(leftButton.snp.trailing).offset(4 * Constraint.xCoeff)
            make.width.height.equalTo(44 * Constraint.xCoeff)
        }

        titleLabel.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(63 * Constraint.yCoeff)
            make.centerX.equalToSuperview()
            make.height.equalTo(19 * Constraint.yCoeff)
        }

        workoutLevelLabel.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4 * Constraint.yCoeff)
            make.centerX.equalToSuperview()
            make.height.equalTo(14 * Constraint.yCoeff)
        }

        likeViewButton.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(80 * Constraint.yCoeff)
            make.trailing.equalTo(view.snp.trailing).offset(-20 * Constraint.xCoeff)
            make.height.equalTo(44 * Constraint.yCoeff)
            make.width.equalTo(66 * Constraint.xCoeff)
        }

        workoutImage.snp.remakeConstraints { make in
            make.top.equalTo(leftButton.snp.bottom).offset(10 * Constraint.yCoeff)
            make.centerX.equalToSuperview()
            make.width.equalTo(366 * Constraint.xCoeff)
            make.height.equalTo(287 * Constraint.yCoeff)
        }

        workoutInfoView.snp.remakeConstraints { make in
            make.top.equalTo(workoutImage.snp.bottom).offset(10 * Constraint.yCoeff)
            make.centerX.equalToSuperview()
            make.width.equalTo(366 * Constraint.xCoeff)
            make.height.equalTo(145 * Constraint.yCoeff)
        }

        workoutDetailsYellowButton.snp.remakeConstraints { make in
            make.top.equalTo(workoutImage.snp.bottom).offset(-23 * Constraint.yCoeff)
            make.bottom.equalTo(workoutInfoView.snp.top).offset(28 * Constraint.yCoeff)
            make.centerX.equalToSuperview()
            make.width.equalTo(131 * Constraint.xCoeff)
        }

        reminderLabel.snp.remakeConstraints { make in
            make.top.equalTo(workoutInfoView.snp.bottom).offset(10 * Constraint.yCoeff)
            make.centerX.equalToSuperview()
            make.width.equalTo(366 * Constraint.xCoeff)
            make.height.equalTo(111 * Constraint.yCoeff)
        }

        workoutDetailsWhiteButton.snp.remakeConstraints { make in
            make.top.equalTo(workoutInfoView.snp.bottom).offset(-23 * Constraint.yCoeff)
            make.bottom.equalTo(reminderLabel.snp.top).offset(28 * Constraint.yCoeff)
            make.centerX.equalToSuperview()
            make.width.equalTo(131 * Constraint.xCoeff)
        }

        startWorkoutButton.snp.remakeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-48 * Constraint.yCoeff)
            make.centerX.equalToSuperview()
            make.width.equalTo(216 * Constraint.xCoeff)
            make.height.equalTo(59 * Constraint.yCoeff)
        }

        darkOverlay.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        warningView.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(357 * Constraint.yCoeff)
        }
    }

    @objc private func pressStartWorkoutButton() {
        let timerVC = TimerViewController(tasks: workoutData?.tasks ?? [])

        if let taskCountText = workoutInfoView.taskView.taskNumberLabel.text,
           let taskCount = Int(taskCountText) {
            timerVC.taskCount = taskCount
        }

        if let workoutId = workoutData?.id {
            timerVC.currentWorkoutId = workoutId
        }

        if let taskTimeText = workoutInfoView.timeView.timerLabel.text {
            let timeComponents = taskTimeText.split(separator: ":").compactMap { Int($0) }
            if timeComponents.count == 3 {
                let hours = timeComponents[0]
                let minutes = timeComponents[1]
                let seconds = timeComponents[2]

                timerVC.remainingTime = TimeInterval(hours * 3600 + minutes * 60 + seconds)
                timerVC.duration = timerVC.remainingTime
            }
        }

        timerVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(timerVC, animated: true)
    }

    @objc private func pressLeftButton() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func pressWarningButton() {
        darkOverlay.isHidden = false
        warningView.isHidden = false
    }


    private func configureWithData() {
        if let image = workoutImage.image {
            workoutImage.image = image
        }

        if let workout = workoutData {
            titleLabel.text = workout.taskName
            workoutLevelLabel.text = "Level \(workout.level.rawValue)"

            workoutInfoView.workoutLevel.text = workout.taskName
            workoutInfoView.taskView.taskNumberLabel.text = String(workout.taskCount)
            workoutInfoView.timeView.remainingTime = Double(workout.time)
            workoutInfoView.levelView.levelInfoLabel.text = workout.level.rawValue
        }
    }

    func blockUserWithId() {
        guard let userId = UserDefaults.standard.value(forKey: "userId") else { return }
        guard let workoutUserID = UserDefaults.standard.value(forKey: "id") else {return }

        let url = "https://be-sport.org/api/v1/users/report?blocker_id=\(userId)&blocked_id=\(workoutUserID)"

        NetworkManager.shared.showProgressHud(true, animated: true)
        NetworkManager.shared.post(url: url, parameters: nil, headers: nil) { [weak self] (result: Result<[BlockedWorkouts]>) in
            NetworkManager.shared.showProgressHud(false, animated: false)
            switch result {
            case .success(let blockedId):
                
                NotificationCenter.default.post(
                    name: NSNotification.Name(
                        "blockUserId.view.observer"
                    ),
                    object: nil
                )
                DispatchQueue.main.async { [weak self] in
                    self?.tabBarController?.selectedIndex = 0
                    self?.darkOverlay.isHidden = true
                    self?.warningView.isHidden = true
                    self?.navigationController?.popViewController(animated: false)
                }
                print("Workout saved successfully: \(blockedId)")
            case .failure(let error):
                print("Error saving workout: \(error.localizedDescription)")
            }
        }
    }

    func blockWorkoutWithId() {
        guard let userId = UserDefaults.standard.value(forKey: "userId") else { return }
        guard let workoutUserID = workoutData?.id else { return }

        let url = "https://be-sport.org/api/v1/workouts/report?user_id=\(userId)&workout_id=\(workoutUserID)"

        NetworkManager.shared.showProgressHud(true, animated: true)
        NetworkManager.shared.post(url: url, parameters: nil, headers: nil) { [weak self] (result: Result<BlockedWorkouts>) in
            NetworkManager.shared.showProgressHud(false, animated: false)
            switch result {
            case .success(let blockedWorkouts):
                NotificationCenter.default.post(
                    name: NSNotification.Name(
                        "blockPost.view.observer"
                    ),
                    object: nil
                )
                DispatchQueue.main.async { [weak self] in
                    self?.tabBarController?.selectedIndex = 0
                    self?.darkOverlay.isHidden = true
                    self?.warningView.isHidden = true
                    self?.navigationController?.popViewController(animated: false)
                }
                print("Workout saved successfully: \(blockedWorkouts)")
            case .failure(let error):
                print("Error saving workout: \(error.localizedDescription)")
            }
        }
    }
}

extension HardWorkoutViewController: WarningViewDelegate {
    func didPressComplaintButton() {
        let termsURL = ""
        let webViewController = WebViewController(urlString: termsURL)
        navigationController?.present(webViewController, animated: true)
    }

    func didPressDontWantToSeeUserAccountButton() {
        let alert = UIAlertController(
            title: nil,
            message: "Do you want to block this User?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
            self?.blockUserWithId()
        }))

        present(alert, animated: true, completion: nil)
    }

    func didPressSheWillFileAComlaintButton() {
        let alert = UIAlertController(
            title: nil,
            message: "Do you want to block this Workout?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
            guard let self = self, var workout = self.workoutData else { return }
            self.likeViewButtonTapped()

            self.blockWorkoutWithId()

//            let updatedWorkout = workout.copyWith(isSelected: true, likeCount: max(workout.likeCount - 1, 0))
//
//            self.workoutData = updatedWorkout
//            self.updateLikeState(isSelected: updatedWorkout.isSelected)
//
//            NotificationCenter.default.post(
//                name: NSNotification.Name(
//                    "unLikeWorkout.view.observer"
//                ),
//                object: nil
//            )
        }))

        present(alert, animated: true, completion: nil)
    }

    func didPressCancelButton() {
        darkOverlay.isHidden = true
        warningView.isHidden = true
    }

    @objc func likeViewButtonTapped() {
//        let currentLikes = Int(likeViewButton.title(for: .normal) ?? "0") ?? 0
//        if currentLikes > 0 {
//            likeViewButton.setTitle("\(currentLikes - 1)", for: .normal)
//            likeViewButton.setImage(UIImage(named: "heart")?.resize(to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)), for: .normal)
//        }

        // Notify other components to update their UI, if necessary
        NotificationCenter.default.post(
            name: NSNotification.Name("unLikeWorkout.view.observer"),
            object: nil
        )
    }

    private func updateLikeState(isSelected: Bool) {
        let currentLikes = Int(likeViewButton.title(for: .normal) ?? "0") ?? 0
        if currentLikes > 0 {
            likeViewButton.setTitle("\(currentLikes - 1)", for: .normal)
            likeViewButton.setImage(UIImage(named: "heart")?.resize(to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)), for: .normal)
        }
    }
}

