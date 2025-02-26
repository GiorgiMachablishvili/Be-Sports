//
//  AddWorkoutViewController.swift
//  Betus
//
//  Created by Gio's Mac on 01.12.24.
//

import UIKit
import SnapKit
import Alamofire

protocol AddWorkoutViewControllerDelegate: AnyObject {
    func shouldHideMainBottomButtonView(_ hide: Bool)
}

class AddWorkoutViewController: UIViewController, ImageViewDelegate {

    weak var delegate: AddWorkoutViewControllerDelegate?

    private weak var imageCell: ImageViewCell?

    var totalTimeInSeconds: Int = 0
    var tasks: [Task] = []

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = UIColor.blackBackgroundColor
        return view
    }()

    lazy var userInfoButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 44 * Constraint.xCoeff, height: 44 * Constraint.yCoeff))
        view.setImage(UIImage(named: "userProfile"), for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.setImage(UIImage(named: "userProfile")?.resize(to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)), for: .normal)
        view.addTarget(self, action: #selector(didPressUserInfoButton), for: .touchUpInside)
        return view
    }()

    lazy var rightButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 44 * Constraint.xCoeff, height: 44 * Constraint.yCoeff))
        view.setImage(UIImage(named: "arrow-left-1"), for: .normal)
        view.backgroundColor = UIColor.redColor
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.setImage(UIImage(named: "arrow-left-1")?.resize(to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)), for: .normal)
        view.addTarget(self, action: #selector(didPressRightButton), for: .touchUpInside)
        return view
    }()

    lazy var darkOverlay: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isHidden = true
        return view
    }()

    lazy var addTaskView: AddTaskView = {
        let view = AddTaskView()
        view.layer.cornerRadius = 32
        view.isHidden = true
        view.delegate = self
        return view
    }()

    private lazy var taskView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 16
        view.isHidden = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupConstraint()
        setupHierarchy()
        configureCompositionLayout()
        view.backgroundColor = UIColor.blackBackgroundColor

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        setupTapToDismissKeyboard()
    }

    func setup() {
        view.addSubview(collectionView)
        view.addSubview(userInfoButton)
        view.addSubview(rightButton)
        view.addSubview(darkOverlay)
        view.addSubview(addTaskView)
        view.addSubview(taskView)
    }

    func setupConstraint() {
        collectionView.snp.remakeConstraints { make in
            make.top.equalTo(userInfoButton.snp.bottom).offset(5 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom)
        }

        userInfoButton.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(80 * Constraint.yCoeff)
            make.leading.equalTo(view.snp.leading).offset(20 * Constraint.xCoeff)
            make.width.height.equalTo(44 * Constraint.xCoeff)
        }

        rightButton.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(80 * Constraint.yCoeff)
            make.trailing.equalTo(view.snp.trailing).offset(-20 * Constraint.xCoeff)
            make.width.height.equalTo(44 * Constraint.xCoeff)
        }

        darkOverlay.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        addTaskView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).offset(20)
            make.height.equalTo(343 * Constraint.yCoeff)
        }
    }

    func setupHierarchy() {
        collectionView.register(ImageViewCell.self, forCellWithReuseIdentifier: String(describing: ImageViewCell.self))
        collectionView.register(NameViewCell.self, forCellWithReuseIdentifier: String(describing: NameViewCell.self))
        collectionView.register(WorkLevelViewCell.self, forCellWithReuseIdentifier: String(describing: WorkLevelViewCell.self))
        collectionView.register(DescriptionViewCell.self, forCellWithReuseIdentifier: String(describing: DescriptionViewCell.self))
        collectionView.register(TaskViewCell.self, forCellWithReuseIdentifier: String(describing: TaskViewCell.self))
        collectionView.register(AddTaskViewButtonCell.self, forCellWithReuseIdentifier: String(describing: AddTaskViewButtonCell.self))
    }

    func convertTimerToSeconds(_ timerString: String) -> Int {
        let components = timerString.split(separator: ":").compactMap { Int($0) }
        guard components.count == 3 else { return 0 }
        let hours = components[0]
        let minutes = components[1]
        let seconds = components[2]
        return (hours * 3600) + (minutes * 60) + seconds
    }

    @objc func didPressUserInfoButton() {
        let profileView = ProfileViewController()
        navigationController?.pushViewController(profileView, animated: true)
    }

    @objc func didPressRightButton() {
        let isGuestUser = UserDefaults.standard.bool(forKey: "isGuestUser")

        if isGuestUser {
            // Show an alert prompting the user to register
            let alert = UIAlertController(
                title: "Registration Required",
                message: "You need to register to save workouts. Please sign up or log in to continue.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }

        let workoutImageString = workoutImage()
        let userIdString = userId()
        let selectedLevelString = selectedLevel()
        let workoutNameString = workoutName()
        let workoutDetailsString = workoutDetails()

        let parameters: [String: Any] = [
            "task_count": tasks.count,
            "level": selectedLevelString,
            "completers": [],
            "name": workoutNameString,
            "details": workoutDetailsString,
            "user_id": userIdString,
            "tasks": tasks.map { task in
                [
                    "time": task.time,
                    "task_name": task.title,
                    "task_description": task.description
                ]
            },
            "image": workoutImageString
        ]
        //        print("Parameters: \(parameters)")

        //MARK: url
        let url = "https://be-sport.org/api/v1/workouts/"
        NetworkManager.shared.showProgressHud(true, animated: true)
        NetworkManager.shared.post(url: url, parameters: parameters, headers: nil) { [weak self] (result: Result<Workouts>) in
            NetworkManager.shared.showProgressHud(false, animated: false)
            switch result {
            case .success(let workout):
                NotificationCenter.default.post(
                    name: NSNotification.Name(
                        "workout.view.observer"
                    ),
                    object: nil
                )
                DispatchQueue.main.async { [weak self] in
                    self?.tabBarController?.selectedIndex = 0
                }
                self?.resetAllFields()
                print("Workout saved successfully: \(workout)")
            case .failure(let error):
                print("Error saving workout: \(error.localizedDescription)")
            }
        }
        if let workoutID = UserDefaults.standard.value(forKey: "userId") as? String {
            print("Workout ID: \(workoutID)")
        } else {
            print("Workout ID not found or not stored as a single value.")
        }
    }
    // Helper: Show an alert to the user
    private func showAlert(title: String, description: String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func shouldHideMainBottomButtonView(_ hide: Bool) {
        delegate?.shouldHideMainBottomButtonView(hide)
    }

    func workoutImage() -> String {
        //MARK: workout image
        let indexPath = IndexPath(item: 0, section: 0)
        guard let imageCell = collectionView.cellForItem(at: indexPath) as? ImageViewCell,
              let imageWorkout = imageCell.workoutImage.image else {
            return ""
        }
        guard let imageData = imageWorkout.jpegData(compressionQuality: 0.8) else {
            print("Error: Unable to convert image to data")
            return ""
        }
        let imageBase64String = imageData.base64EncodedString()
        return imageBase64String
    }

    func userId() -> String {
        //MARK: user id
        guard let userId = UserDefaults.standard.value(forKey: "userId") else {
            return ""
        }
        return userId as! String
    }

    func selectedLevel() -> String {
        //MARK: selected level
        let indexPathLevel = IndexPath(item: 0, section: 2)
        guard collectionView.indexPathsForVisibleItems.contains(indexPathLevel) else {
            print("IndexPath for WorkLevelViewCell is not visible")
            return ""
        }
        guard let visibleCell = collectionView.cellForItem(at: indexPathLevel) as? WorkLevelViewCell else {
            print("WorkLevelViewCell is not visible")
            return ""
        }
        let selectedLevel = visibleCell.getSelectedLevel()
        return selectedLevel
    }

    func workoutName() -> String {
        //MARK: workout name
        let indexPathName = IndexPath(item: 0, section: 1)
        guard let nameCell = collectionView.cellForItem(at: indexPathName) as? NameViewCell else { return ""}
        guard let workoutName = nameCell.nameWorkoutTextfield.text else { return ""}
        return workoutName
    }

    func workoutDetails() -> String {
        //MARK: workout details
        let indexPathDetails = IndexPath(item: 0, section: 3)
        guard let detailsCell = collectionView.cellForItem(at: indexPathDetails) as? DescriptionViewCell else { return ""}
        guard let workoutDetails = detailsCell.descriptionWorkoutTextfield.text else { return ""}
        return workoutDetails
    }

    private func resetAllFields() {
        // Clear tasks array
        tasks.removeAll()
        totalTimeInSeconds = 0

        // Reset image
        if let imageCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? ImageViewCell {
            imageCell.updateUserImageAfterPressRightButton()
        }

        // Reset workout name
        if let nameCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 1)) as? NameViewCell {
            nameCell.nameWorkoutTextfield.text = ""
        }

        // Reset workout level
        if let levelCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 2)) as? WorkLevelViewCell {
            levelCell.resetLevelSelection()
        }

        // Reset workout details
        if let detailsCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 3)) as? DescriptionViewCell {
            detailsCell.descriptionWorkoutTextfield.text = ""
        }

        // Reset task input fields
        addTaskView.nameWorkoutAddTextfield.text = ""
        addTaskView.timerAddTextfield.text = ""
        addTaskView.descriptionWorkoutAddTextfield.text = ""

        // Reload collection view to reflect changes
        collectionView.reloadData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

//MARK: ProfileView configure layout
extension AddWorkoutViewController {
    func configureCompositionLayout() {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in

            switch sectionIndex {
            case 0:
                return self?.imageViewLayout()
            case 1:
                return self?.nameViewLayout()
            case 2:
                return self?.workoutViewLayout()
            case 3:
                return self?.descriptionViewLayout()
            case 4:
                return self?.taskViewLayout()
            case 5:
                return self?.addTaskViewButtonLayout()
            default:
                return self?.defaultLayout()
            }
        }
        self.collectionView.setCollectionViewLayout(layout, animated: false)
    }

    func imageViewLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(287 * Constraint.yCoeff))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(287 * Constraint.yCoeff)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: 10 * Constraint.yCoeff,
            leading: 0 * Constraint.xCoeff,
            bottom: 0 * Constraint.yCoeff,
            trailing: 0 * Constraint.xCoeff
        )
        return section
    }

    func nameViewLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44 * Constraint.yCoeff)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44 * Constraint.yCoeff)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: 10 * Constraint.yCoeff,
            leading: 0 * Constraint.xCoeff,
            bottom: 0 * Constraint.yCoeff,
            trailing: 0 * Constraint.xCoeff
        )
        return section
    }

    func workoutViewLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(41 * Constraint.yCoeff)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(41 * Constraint.yCoeff)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: 10 * Constraint.yCoeff,
            leading: 0 * Constraint.xCoeff,
            bottom: 0 * Constraint.yCoeff,
            trailing: 0 * Constraint.xCoeff
        )
        return section
    }

    func descriptionViewLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44 * Constraint.yCoeff)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44 * Constraint.yCoeff)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: 10 * Constraint.yCoeff,
            leading: 0 * Constraint.xCoeff,
            bottom: 10 * Constraint.yCoeff,
            trailing: 0 * Constraint.xCoeff
        )
        return section
    }

    func addTaskViewButtonLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(84 * Constraint.yCoeff)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(84 * Constraint.yCoeff)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: 0 * Constraint.yCoeff,
            leading: 0 * Constraint.xCoeff,
            bottom: 0 * Constraint.yCoeff,
            trailing: 0 * Constraint.xCoeff
        )
        return section
    }

    func taskViewLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(160 * Constraint.yCoeff)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(160 * Constraint.yCoeff)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: 10 * Constraint.yCoeff,
            leading: 10 * Constraint.xCoeff,
            bottom: 10 * Constraint.yCoeff,
            trailing: 10 * Constraint.xCoeff
        )
        return section
    }

    func defaultLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.7),
            heightDimension: .absolute(200 * Constraint.yCoeff)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered

        return section
    }
}

extension AddWorkoutViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        case 4:
            return tasks.count
        case 5:
            return 1
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: ImageViewCell.self),
                for: indexPath) as? ImageViewCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: NameViewCell.self),
                for: indexPath) as? NameViewCell else {
                return UICollectionViewCell()
            }
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: WorkLevelViewCell.self),
                for: indexPath) as? WorkLevelViewCell else {
                return UICollectionViewCell()
            }
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: DescriptionViewCell.self),
                for: indexPath
            ) as? DescriptionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        case 4:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: TaskViewCell.self),
                for: indexPath
            ) as? TaskViewCell else {
                return UICollectionViewCell()
            }
            let task = tasks[indexPath.row]
            cell.configure(task: task)
            cell.didTapOnDeleteButton = { [weak self] in
                self?.tasks.remove(at: indexPath.row)
                collectionView.reloadData()
            }
            //            cell.delegate = self
            return cell

        case 5:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: AddTaskViewButtonCell.self),
                for: indexPath
            ) as? AddTaskViewButtonCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension AddWorkoutViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        let bottomOffsetThreshold: CGFloat = 120.0  * Constraint.yCoeff

        if scrollView.contentOffset.y + frameHeight >= contentHeight {
            scrollView.contentInset.bottom = bottomOffsetThreshold
        } else {
            scrollView.contentInset.bottom = 0
        }
    }
}

extension AddWorkoutViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentImagePicker(_ picker: UIImagePickerController, for cell: ImageViewCell) {
        imageCell = cell
        present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let imageCell = imageCell else { return }

        if let editedImage = info[.editedImage] as? UIImage {
            imageCell.updateUserImage(editedImage)
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageCell.updateUserImage(originalImage)
        }

        picker.dismiss(animated: true, completion: nil)
        self.imageCell = nil
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        self.imageCell = nil
    }
}

extension AddWorkoutViewController: AddTaskViewDelegate {
    func didPressAddButton(taskName: String, timer: String, description: String) {
        darkOverlay.isHidden = true
        addTaskView.isHidden = true
        taskView.isHidden = true

        let timeInSeconds = convertTimerToSeconds(timer)
        tasks.append(.init(title: taskName, description: description, time: timeInSeconds, id: UUID().uuidString))
        collectionView.reloadData()

        delegate?.shouldHideMainBottomButtonView(false)
    }

    func didPressCancelButton() {
        darkOverlay.isHidden = true
        addTaskView.isHidden = true
        taskView.isHidden = false
        delegate?.shouldHideMainBottomButtonView(false)
    }
}

// MARK: - Keyboard Handling
extension AddWorkoutViewController {
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let activeField = findFirstResponder() as? UIView else { return }

        let keyboardHeight = keyboardFrame.height
        let bottomOfTextField = activeField.convert(activeField.bounds, to: view).maxY
        let visibleAreaHeight = view.bounds.height - keyboardHeight

        if bottomOfTextField > visibleAreaHeight {
            let overlap = bottomOfTextField - visibleAreaHeight
            UIView.animate(withDuration: 0.3) {
                self.view.transform = CGAffineTransform(translationX: 0, y: -overlap - 20 * Constraint.yCoeff)
            }
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
        }
    }

    private func setupTapToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func findFirstResponder() -> UIResponder? {
        for subview in view.subviews {
            if subview.isFirstResponder {
                return subview
            }
            if let responder = subview.findFirstResponder() {
                return responder
            }
        }
        return nil
    }
}

extension UIView {
    func findFirstResponder() -> UIResponder? {
        if self.isFirstResponder {
            return self
        }
        for subview in self.subviews {
            if let responder = subview.findFirstResponder() {
                return responder
            }
        }
        return nil
    }
}

extension AddWorkoutViewController: AddTaskViewCellDelegate {
    func toggleTaskViewVisibility(hidden: Bool) {
        taskView.isHidden = hidden
        configureCompositionLayout()
        collectionView.reloadData()
        if let taskCell = collectionView.visibleCells.compactMap({ $0 as? TaskViewCell }).first {
            taskCell.taskView.isHidden = hidden
        }
    }
}
