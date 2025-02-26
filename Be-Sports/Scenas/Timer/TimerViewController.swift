//
//  TimerViewController.swift
//  Betus
//
//  Created by Gio's Mac on 26.11.24.
//

import UIKit
import SnapKit

class TimerViewController: UIViewController {
    private var timer: Timer?
    var duration: TimeInterval = 0
    var remainingTime: TimeInterval = 0 {
        didSet {
            updateTimeLabel()
        }
    }
    private var isTimerRunning = false
    
    var tasks: [Task] = []
    var hardWorkoutView = HardWorkoutViewController()
    var taskCount: Int = 0
    var currentWorkoutId: String = ""
    var taskCountFromWorkouts: Workouts?
    
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 342 * Constraint.xCoeff, height: 103 * Constraint.yCoeff)
        layout.minimumLineSpacing = 10
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        view.register(WorkoutTaskViewCell.self, forCellWithReuseIdentifier: "WorkoutTaskViewCell")
        return view
    }()
    
    lazy var leftButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 44 * Constraint.xCoeff, height: 44 * Constraint.yCoeff))
        view.setImage(UIImage(named: "backArrow"), for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.2)
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.layer.borderColor = UIColor.init(hexString: "FFFFFF").cgColor
        view.layer.borderWidth = 1
        view.setImage(UIImage(named: "backArrow")?.resize(to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)), for: .normal)
        view.addTarget(self, action: #selector(pressLeftButton), for: .touchUpInside)
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
    
    private lazy var likeViewButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("44", for: .normal)
        view.setImage(UIImage(named: "heart")?.resize(to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)), for: .normal)
        view.tintColor = UIColor(hexString: "FFFFFF")
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.2)
        view.layer.cornerRadius = 16
        view.imageView?.contentMode = .scaleAspectFit
        view.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8 * Constraint.xCoeff)
        view.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8 * Constraint.xCoeff, bottom: 0, right: 0)
        //        view.addTarget(self, action: #selector(likeViewButtonTapped), for: .touchUpInside)
        return view
    }()
    
    
    private lazy var circularProgressView: CircularProgressView = {
        let view = CircularProgressView()
        view.trackColor = UIColor.lightGray
        view.progressColor = UIColor.redColor
        view.setProgress(to: 1.0)
        return view
    }()
    
    lazy var timeLabel: UILabel = {
        let view = UILabel()
        let hours = Int(remainingTime) / 3600
        let minutes = (Int(remainingTime) % 3600) / 60
        let seconds = Int(remainingTime) % 60
        view.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        view.font = UIFont.boldSystemFont(ofSize: 32)
        view.textColor = UIColor(hexString: "FFFFFF")
        view.textAlignment = .center
        return view
    }()
    
    private lazy var startButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 216 * Constraint.xCoeff, height: 60 * Constraint.yCoeff))
        view.setTitle("Play", for: .normal)
        view.backgroundColor = UIColor.redColor
        view.layer.cornerRadius = 26
        view.titleLabel?.font = UIFont.latoRegular(size: 16)
        view.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.init(hexString: "#FFFFFF").cgColor
        view.layer.borderWidth = 1
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(didPressStartButton), for: .touchUpInside)
        return view
    }()
    
    init(tasks: [Task]) {
        self.tasks = tasks
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackBackgroundColor
        view.applyGradientBackground()
        setup()
        setupConstraints()
        
        self.navigationItem.hidesBackButton = true
    }
    
    private func setup() {
        view.addSubview(collectionView)
        view.addSubview(leftButton)
        view.addSubview(titleLabel)
        view.addSubview(likeViewButton)
        view.addSubview(circularProgressView)
        view.addSubview(timeLabel)
        view.addSubview(startButton)
    }
    
    private func setupConstraints() {
        leftButton.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(80 * Constraint.yCoeff)
            make.leading.equalTo(view.snp.leading).offset(20 * Constraint.xCoeff)
            make.width.height.equalTo(44 * Constraint.xCoeff)
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(63 * Constraint.yCoeff)
            make.centerX.equalToSuperview()
            make.height.equalTo(19 * Constraint.yCoeff)
        }
        
        likeViewButton.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(80 * Constraint.yCoeff)
            make.trailing.equalTo(view.snp.trailing).offset(-20 * Constraint.xCoeff)
            make.height.equalTo(44 * Constraint.yCoeff)
            make.width.equalTo(66 * Constraint.xCoeff)
        }
        
        circularProgressView.snp.remakeConstraints { make in
            make.top.equalTo(leftButton.snp.bottom).offset(104 * Constraint.yCoeff)
            make.centerX.equalTo(view.snp.centerX)
            make.width.height.equalTo(300 * Constraint.xCoeff)
        }
        
        timeLabel.snp.remakeConstraints { make in
            make.centerX.equalTo(circularProgressView.snp.centerX)
            make.centerY.equalTo(circularProgressView.snp.centerY)
        }
        
        collectionView.snp.remakeConstraints { make in
            make.bottom.equalTo(startButton.snp.top).offset(-16 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(24 * Constraint.xCoeff)
            make.height.equalTo(103 * Constraint.yCoeff)
        }
        
        startButton.snp.remakeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-48 * Constraint.yCoeff)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(115 * Constraint.xCoeff)
            make.height.equalTo(59 * Constraint.yCoeff)
        }
    }
    
    @objc private func didPressStartButton() {
        if startButton.title(for: .normal) == "Complete" {
            let mainViewController = MainViewControllerTab()
            navigationController?.pushViewController(mainViewController, animated: true)
        } else if isTimerRunning {
            pauseTimer()
        } else {
            startTimer()
        }
    }
    
    private func startTimer() {
        isTimerRunning = true
        startButton.setTitle("Pause", for: .normal)
        startButton.backgroundColor = UIColor.clearBlur(withAlpha: 0.2)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.remainingTime > 0 {
                self.remainingTime -= 1
                let progress = self.remainingTime / self.duration
                self.circularProgressView.setProgress(to: progress)
                self.updateTimeLabel()
            } else {
                self.timer?.invalidate()
                self.isTimerRunning = false
                self.startButton.setTitle("Complete", for: .normal)
                self.startButton.backgroundColor = UIColor.redColor
            }
        }
    }
    
    private func pauseTimer() {
        isTimerRunning = false
        startButton.setTitle("Play", for: .normal)
        startButton.backgroundColor = UIColor.redColor
        timer?.invalidate()
    }
    
    private func formatSecondsToHHMMSS(_ totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private func updateTimeLabel() {
        let hours = Int(remainingTime) / 3600
        let minutes = (Int(remainingTime) % 3600) / 60
        let seconds = Int(remainingTime) % 60
        timeLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    @objc private func pressLeftButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension TimerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkoutTaskViewCell", for: indexPath) as? WorkoutTaskViewCell else {
            return UICollectionViewCell()
        }
        let workInfoTask = tasks[indexPath.row]
        cell.configure(with: workInfoTask)
        return cell
    }
}
