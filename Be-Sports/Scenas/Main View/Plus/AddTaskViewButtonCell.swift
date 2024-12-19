//
//  AddTaskViewButtonCell.swift
//  Betus
//
//  Created by Gio's Mac on 09.12.24.
//

import UIKit
import SnapKit

protocol AddTaskViewCellDelegate: AnyObject {
    func toggleTaskViewVisibility(hidden: Bool)
}

class AddTaskViewButtonCell: UICollectionViewCell {
    
    weak var delegate: AddTaskViewCellDelegate?
    
    private lazy var addTaskViewButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(named: "addTask"), for: .normal)
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 26
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
            make.height.equalTo(84 * Constraint.yCoeff)
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
