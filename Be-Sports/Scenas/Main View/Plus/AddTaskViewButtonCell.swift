

import UIKit
import SnapKit

protocol AddTaskViewCellDelegate: AnyObject {
    func toggleTaskViewVisibility(hidden: Bool)
}

class AddTaskViewButtonCell: UICollectionViewCell {
    
    weak var delegate: AddTaskViewCellDelegate?
    
//    private lazy var addTaskViewButton: UIButton = {
//        let view = UIButton(frame: .zero)
//        view.setImage(UIImage(named: "addTask"), for: .normal)
//        view.contentMode = .scaleAspectFit
//        view.layer.cornerRadius = 26
//        view.addTarget(self, action: #selector(pressAddTaskButton), for: .touchUpInside)
//        return view
//    }()

    private lazy var addTaskViewButton: UIButton = {
        let view = UIButton(type: .system)

        // Set the button title
        view.setTitle("Add Task", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        view.contentHorizontalAlignment = .left

        // Set the image
        let plusImage = UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal)
        view.setImage(plusImage, for: .normal)
        view.contentMode = .scaleAspectFit

        // Set button properties
        view.backgroundColor = UIColor(hexString: "#FFFFFF").withAlphaComponent(0.05)
        view.layer.cornerRadius = 26
        view.clipsToBounds = true

        // Adjust the content spacing
//        view.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -20)
//        view.titleEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)

        view.semanticContentAttribute = .forceRightToLeft
        view.imageEdgeInsets = UIEdgeInsets(top: 0, left: 235, bottom: 0, right: 0)
        view.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)

        // Set button action
        view.addTarget(self, action: #selector(pressAddTaskButton), for: .touchUpInside)

        return view
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraint()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubview(addTaskViewButton)
    }
    
    func setupConstraint() {
        addTaskViewButton.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(10 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(12 * Constraint.xCoeff)
            make.height.equalTo(74 * Constraint.yCoeff)
        }
    }
    
    @objc func pressAddTaskButton() {
        guard let delegate = delegate as? AddWorkoutViewController else { return }
        delegate.addTaskView.nameWorkoutAddTextfield.text = ""
        delegate.addTaskView.timerAddTextfield.text = ""
        delegate.addTaskView.descriptionWorkoutAddTextfield.text = ""
        
        delegate.darkOverlay.isHidden = false
        delegate.addTaskView.isHidden = false
        delegate.shouldHideMainBottomButtonView(true)
        
        delegate.addTaskView.configure(taskName: "", timer: "", description: "")
        delegate.shouldHideMainBottomButtonView(true)
    }
}
