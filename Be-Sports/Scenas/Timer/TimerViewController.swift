
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
    
    var rateWorkouts: RateWorkouts?

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
        view.setTitle("0", for: .normal)
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
        view.font = UIFont.latoBold(size: 32)
        view.textColor = UIColor(hexString: "FFFFFF")
        view.textAlignment = .center
        view.numberOfLines = 2
        return view
    }()

    private lazy var  timerHourLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "HOURS"
        view.textAlignment = .center
        view.font = UIFont.latoThin(size: 12)
        view.textColor = UIColor(hexString: "FFFFFF").withAlphaComponent(0.3)
        return view
    }()

    private lazy var  timerMinLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "MIN"
        view.textAlignment = .center
        view.font = UIFont.latoThin(size: 12)
        view.textColor = UIColor(hexString: "FFFFFF").withAlphaComponent(0.3)
        return view
    }()

    private lazy var  timerSecLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "SEC"
        view.textAlignment = .center
        view.font = UIFont.latoThin(size: 12)
        view.textColor = UIColor(hexString: "FFFFFF").withAlphaComponent(0.3)
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

    private lazy var feedBack: FeedBackView = {
        let view = FeedBackView()
        view.isHidden = true
        view.didPressSkipButton = { [weak self] in
            self?.goPageWithoutFeedback()
        }
        view.didPressLeaveAFeedbackButton = { [weak self] rating in
//            self?.leaveFeedback()
            self?.leaveFeedback(with: rating)
        }
        //TODO: brings star count
        view.didSubmitRating = { [weak self] rating in
            print("User submitted a rating of \(rating) stars")
//            self?.rateScore = rating
//            self?.leaveFeedback(with: rating)
        }
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

        if !currentWorkoutId.isEmpty {
            UserDefaults.standard.set(currentWorkoutId, forKey: "workoutId")
        } else {
            print("⚠️ Warning: currentWorkoutId is empty, UserDefaults not set.")
        }
    }
    
    private func setup() {
        view.addSubview(collectionView)
        view.addSubview(leftButton)
        view.addSubview(titleLabel)
        view.addSubview(likeViewButton)
        view.addSubview(circularProgressView)
        view.addSubview(timeLabel)
        view.addSubview(timerHourLabel)
        view.addSubview(timerMinLabel)
        view.addSubview(timerSecLabel)
        view.addSubview(startButton)
        view.addSubview(feedBack)
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
            make.leading.trailing.equalToSuperview().inset(12 * Constraint.xCoeff)
            make.height.equalTo(114 * Constraint.yCoeff)
        }
        
        timeLabel.snp.remakeConstraints { make in
            make.centerX.equalTo(circularProgressView.snp.centerX)
            make.centerY.equalTo(circularProgressView.snp.centerY)
        }

        timerHourLabel.snp.remakeConstraints { make in
            make.centerY.equalTo(timerMinLabel)
            make.trailing.equalTo(timerMinLabel.snp.leading).offset(-50 * Constraint.xCoeff)
        }

        timerMinLabel.snp.remakeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(3 * Constraint.yCoeff)
            make.centerX.equalToSuperview()
        }

        timerSecLabel.snp.remakeConstraints { make in
            make.centerY.equalTo(timerMinLabel)
            make.leading.equalTo(timerMinLabel.snp.trailing).offset(54 * Constraint.xCoeff)
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

        feedBack.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func didPressStartButton() {
        if startButton.title(for: .normal) == "Complete" {
            feedBack.isHidden = false
        } else if isTimerRunning {
            pauseTimer()
        } else {
            startTimer()
        }
    }

    private func goPageWithoutFeedback() {
        let mainViewController = MainViewControllerTab()
        navigationController?.pushViewController(mainViewController, animated: true)
//        // Navigate back to MainViewControllerTab
//        if let mainViewController = navigationController?.viewControllers.first(where: { $0 is MainViewControllerTab }) {
//            navigationController?.popToViewController(mainViewController, animated: true)
//        } else {
//            // If MainViewControllerTab is not in the stack, push it
//            let mainViewController = MainViewControllerTab()
//            navigationController?.setViewControllers([mainViewController], animated: true)
//        }
    }

    //TODO: add raitnig, feedback

    private func leaveFeedback(with score: Int) {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            print("Missing userId")
            return }

        let workoutUserID = currentWorkoutId.isEmpty ? UserDefaults.standard.string(forKey: "workoutId") ?? "" : currentWorkoutId
        guard !workoutUserID.isEmpty else {
            print("❌ Missing workoutUserID")
            return
        }


        let url = "https://be-sport.org/api/v1/workouts/\(workoutUserID)/rate?user_id=\(userId)"

        let parameters: [String: Any] = [
            "workout_id": workoutUserID,
            "score": score
        ]

        NetworkManager.shared.showProgressHud(true, animated: true)

        NetworkManager.shared.post(url: url, parameters: parameters, headers: nil) { [weak self] (result: Result<RateWorkouts>) in
            NetworkManager.shared.showProgressHud(false, animated: false)
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    let mainViewController = MainViewControllerTab()
                    self?.navigationController?.pushViewController(mainViewController, animated: true)
                }
                print("Workout rated successfully: \(response)")
            case .failure(let error):
                print("Error submitting rating: \(error.localizedDescription)")
            }
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
        timeLabel.text = String(format: "%02d   :   %02d   :   %02d", hours, minutes, seconds)
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
