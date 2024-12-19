//
//  WorkoutViewController.swift
//  Betus
//
//  Created by Gio's Mac on 25.11.24.
//

import UIKit
import SnapKit

class WorkoutViewController: UIViewController {

    private var workouts: [Workouts] = []
    private var likes: [Workouts] = []
    private var like: [LikeResponse] = []
    private var allWorkouts: [Workouts] = []
    private var displayedWorkouts: [Workouts] = []
    private var selectedLevel: Workouts.Level = .all
    private var searchWorkItem: DispatchWorkItem?
    var receivedWorkoutDetails: String?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width - 24 * Constraint.xCoeff, height: 287 * Constraint.yCoeff)
        layout.minimumLineSpacing = 10
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 120 * Constraint.yCoeff)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10 * Constraint.yCoeff, right: 0)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        view.register(HomeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeHeaderView")
        view.register(WorkoutInfoCell.self, forCellWithReuseIdentifier: "WorkoutInfoCell")
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#101538")
        view.applyGradientBackground()
        setup()
        setupConstraints()

        //MARK: addWorkout from AddWorkoutViewController
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(
                    didTapObserver
                ),
                name: NSNotification.Name (
                    "workout.view.observer"
                ),
                object: nil
            )

        //MARK: unlikes from LikedWorkoutViewController
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(
                    pressTapObserver
                ),
                name: NSNotification.Name (
                    "unLikeWorkout.view.observer"
                ),
                object: nil
            )

        //MARK: press pressDontWantToSeeUserAccountButton from WarningView
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(
                    didTapUserId
                ),
                name: NSNotification.Name (
                    "blockUserId.view.observer"
                ),
                object: nil
            )

        //MARK: press pressDontWantToSeeUserAccountButton from WarningView
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(
                    didTapBlockPost
                ),
                name: NSNotification.Name (
                    "blockPost.view.observer"
                ),
                object: nil
            )
        selectedLevel = .all
        fetchWorkoutCurrentUserInfo()
        collectionView.reloadData()
    }

    private func setup() {
        view.addSubview(collectionView)
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12 * Constraint.xCoeff)
            make.top.equalTo(view.snp.top).offset(10 * Constraint.yCoeff)
            make.bottom.equalTo(view.snp.bottom).offset(-5 * Constraint.yCoeff)
        }
    }

    //    deinit {
    //        NotificationCenter.default
    //            .removeObserver(
    //                self,
    //                name:  NSNotification.Name(
    //                    "com.did.tap.observer"
    //                ),
    //                object: nil
    //            )
    //    }

    private func fetchWorkoutCurrentUserInfo() {
        let url = "https://be-sport.org/api/v1/workouts"
        NetworkManager.shared.get(url: url, parameters: nil, headers: nil) { [weak self] (result: Result<[Workouts]>) in
            switch result {
            case .success(let workouts):
                print("Fetched workouts count: \(workouts.count)")
                self?.allWorkouts = workouts
                self?.displayedWorkouts = workouts

                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    private func postLikeState(userId: String, workoutId: String) {
        let url = "https://be-sport.org/api/v1/workouts/selected?user_id=\(userId)&workout_id=\(workoutId)"
        NetworkManager.shared.post(url: url, parameters: nil, headers: nil) { [weak self] (result: Result<[Workouts]>) in
            switch result {
            case .success(let response):
                guard let selectedLevel = self?.selectedLevel else { return }
                self?.displayedWorkouts = response
//                self?.allWorkouts = response

                self?.filterWorkouts(by: selectedLevel)
                NotificationCenter.default.post(
                    name: NSNotification.Name(
                        "likeWorkout.view.observer"
                    ),
                    object: nil
                )
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
                print("like successed")
            case .failure(let error):
                print("Error updating like: \(error)")
            }
        }
    }

    @objc private func pressTapObserver() {
        self.displayedWorkouts.removeAll()
        fetchWorkoutCurrentUserInfo()
    }

    @objc private func didTapObserver() {
        self.allWorkouts.removeAll()
        self.displayedWorkouts.removeAll()
        fetchWorkoutCurrentUserInfo()
    }

    @objc private func didTapUserId() {
        self.allWorkouts.removeAll()
        self.displayedWorkouts.removeAll()
        fetchWorkoutCurrentUserInfo()
    }

    @objc private func didTapBlockPost() {
        self.allWorkouts.removeAll()
        self.displayedWorkouts.removeAll()
        fetchWorkoutCurrentUserInfo()
    }
}

extension WorkoutViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        let bottomOffsetThreshold: CGFloat = 80.0 * Constraint.yCoeff

        if scrollView.contentOffset.y + frameHeight >= contentHeight {
            scrollView.contentInset.bottom = bottomOffsetThreshold
        } else {
            scrollView.contentInset.bottom = 0
        }
    }
}

extension WorkoutViewController: HomeHeaderViewDelegate {
    func didPressUserInfoButton() {
        let profileView = ProfileViewController()
        navigationController?.pushViewController(profileView, animated: true)
    }

    func filterWorkouts(by level: Workouts.Level) {
        selectedLevel = level
        displayedWorkouts = []
        guard level != .all else {
            self.displayedWorkouts = self.allWorkouts
            self.collectionView.reloadData()
            return
        }
        self.displayedWorkouts = self.allWorkouts.filter {
            $0.level.rawValue.lowercased() == level.rawValue.lowercased()
        }
        self.collectionView.reloadData()
    }

    func searchWorkouts(with searchText: String) {
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }

            if searchText.isEmpty {
                self.displayedWorkouts = self.allWorkouts
            } else {
                self.displayedWorkouts = self.allWorkouts.filter { workout in
                    workout.details.lowercased().contains(searchText.lowercased())
                }
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: workItem)
    }
}

extension WorkoutViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedWorkouts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WorkoutInfoCell.self), for: indexPath) as? WorkoutInfoCell else {
            return UICollectionViewCell()
        }
        let workout = displayedWorkouts[indexPath.row]
        let selectedLevel = workout.level.rawValue
        cell.configure(with: workout, selectedLevel: selectedLevel)

        cell.didTapOnLikeButton = { [weak self] in
            guard let self = self else { return }

            if cell.isLiked {
                self.displayedWorkouts[indexPath.row] = self.displayedWorkouts[indexPath.row].copyWith(isSelected: true, likeCount: workout.likeCount + 1)
            } else {
                self.displayedWorkouts[indexPath.row] = self.displayedWorkouts[indexPath.row].copyWith(isSelected: false, likeCount: workout.likeCount - 1)
            }

            self.collectionView.reloadItems(at: [indexPath])

            self.postLikeState(userId: workout.userId ?? "", workoutId: workout.id)
        }
        return cell
        //        let workout = displayedWorkouts[indexPath.row]
        //        let selectedLevel = workout.level.rawValue
        //        cell.configure(with: workout, selectedLevel: selectedLevel)
        //        cell.didTapOnLikeButton = { [weak self]  in
        //            self?.postLikeState(userId: workout.userId ?? "", workoutId: workout.id)
        //        }
        //        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "HomeHeaderView",
                for: indexPath
            ) as! HomeHeaderView
            header.delegate = self
            return header
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? WorkoutInfoCell,
              let selectedImage = cell.workoutImage.image else { return }
        let selectedWorkout = displayedWorkouts[indexPath.row]
        let hardWorkoutVC = HardWorkoutViewController()
        let likeNumber = cell.likeViewButton.title(for: .normal)

        hardWorkoutVC.workoutImage.image = selectedImage
        hardWorkoutVC.workoutData = selectedWorkout
        hardWorkoutVC.likeViewButton.setTitle(likeNumber, for: .normal)
        hardWorkoutVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(hardWorkoutVC, animated: true)
    }
}

extension Workouts {
    func copyWith(isSelected: Bool, likeCount: Int) -> Workouts {
        return Workouts(
            taskName: self.taskName,
            taskCount: self.taskCount,
            level: self.level,
            completers: self.completers,
            details: self.details,
            id: self.id,
            image: self.image,
            userId: self.userId,
            isSelected: isSelected,
            likeCount: likeCount,
            tasks: self.tasks
        )
    }
}
