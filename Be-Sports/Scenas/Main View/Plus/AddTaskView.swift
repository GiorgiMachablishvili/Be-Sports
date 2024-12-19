//
//  AddTaskView.swift
//  Betus
//
//  Created by Gio's Mac on 27.11.24.
//

import UIKit
import SnapKit

protocol AddTaskViewDelegate: AnyObject {
    func didPressCancelButton()
    func didPressAddButton(taskName: String, timer: String, description: String)
}

class AddTaskView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    weak var delegate: AddTaskViewDelegate?

    private lazy var timerPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()

    private var hours = Array(0...23)
    private var minutesAndSeconds = Array(0...59)
    private var selectedTime = (hours: 0, minutes: 0, seconds: 0)

    lazy var nameWorkoutAddTextfield: UITextField = {
        let view = UITextField(frame: .zero)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.font = UIFont.latoRegular(size: 14)
        view.textColor = UIColor(hexString: "FFFFFF")
        let placeholderText = "  Name Workout"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hexString: "#FFFFFF").withAlphaComponent(0.4),
            .font: UIFont.latoRegular(size: 14)
        ]
        view.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 1))
        view.leftView = paddingView
        view.leftViewMode = .always
        return view
    }()

    lazy var timerAddTextfield: UITextField = {
        let view = UITextField(frame: .zero)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.font = UIFont.latoRegular(size: 14)
        view.textColor = UIColor(hexString: "FFFFFF")
        view.textAlignment = .center
        let placeholderText = "00:00:00"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hexString: "#FFFFFF").withAlphaComponent(0.4),
            .font: UIFont.latoRegular(size: 14)
        ]
        view.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        view.leftViewMode = .always
        view.inputView = timerPicker
        return view
    }()

    lazy var timerPickerToolbar: UIToolbar = {
        let view = UIToolbar()
        view.sizeToFit()
        view.barStyle = .default
        view.tintColor = UIColor(hexString: "#FFFFFF")
        view.barTintColor = UIColor(hexString: "#101538")
        return view
    }()

    lazy var descriptionWorkoutAddTextfield: UITextField = {
        let view = UITextField(frame: .zero)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.font = UIFont.latoRegular(size: 14)
        view.textColor = UIColor(hexString: "FFFFFF")
        let placeholderText = "  Description of the workout"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hexString: "#FFFFFF").withAlphaComponent(0.4),
            .font: UIFont.latoRegular(size: 14)
        ]
        view.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 1))
        view.leftView = paddingView
        view.leftViewMode = .always
        return view
    }()

    private lazy var cancelButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 131 * Constraint.xCoeff, height: 41 * Constraint.yCoeff))
        view.setTitle("Cancel", for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.2)
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 16)
        view.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.init(hexString: "#101538").cgColor
        view.layer.borderWidth = 1
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(pressCancelButton), for: .touchUpInside)
        return view
    }()

    private lazy var addButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 131 * Constraint.xCoeff, height: 41 * Constraint.yCoeff))
        view.setTitle("Add", for: .normal)
        view.backgroundColor = UIColor(hexString: "#E5D820")
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 16)
        view.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.init(hexString: "#FFFFFF").withAlphaComponent(0.4).cgColor
        view.layer.borderWidth = 1
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(pressAddButton), for: .touchUpInside)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hexString: "##101538")
        setup()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(nameWorkoutAddTextfield)
        addSubview(timerAddTextfield)
        addSubview(descriptionWorkoutAddTextfield)
        addSubview(cancelButton)
        addSubview(addButton)
    }

    private func setupConstraints() {
        nameWorkoutAddTextfield.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(32 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(12 * Constraint.xCoeff)
            make.height.equalTo(54 * Constraint.yCoeff)
        }

        timerAddTextfield.snp.remakeConstraints { make in
            make.top.equalTo(nameWorkoutAddTextfield.snp.bottom).offset(10 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(12 * Constraint.xCoeff)
            make.height.equalTo(54 * Constraint.yCoeff)
        }

        descriptionWorkoutAddTextfield.snp.remakeConstraints { make in
            make.top.equalTo(timerAddTextfield.snp.bottom).offset(10 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(12 * Constraint.xCoeff)
            make.height.equalTo(54 * Constraint.yCoeff)
        }

        cancelButton.snp.remakeConstraints { make in
            make.bottom.equalTo(snp.bottom).offset(-32 * Constraint.yCoeff)
            make.leading.equalTo(snp.leading).offset(76 * Constraint.xCoeff)
            make.width.equalTo(115 * Constraint.xCoeff)
            make.height.equalTo(54 * Constraint.yCoeff)
        }

        addButton.snp.remakeConstraints { make in
            make.bottom.equalTo(snp.bottom).offset(-32 * Constraint.yCoeff)
            make.trailing.equalTo(snp.trailing).offset(-76 * Constraint.xCoeff)
            make.width.equalTo(115 * Constraint.xCoeff)
            make.height.equalTo(54 * Constraint.yCoeff)
        }
    }

    @objc private func pressCancelButton() {
        delegate?.didPressCancelButton()
    }

    @objc private func pressAddButton() {
        let taskName = nameWorkoutAddTextfield.text ?? ""
        let timer = timerAddTextfield.text ?? ""
        let description = descriptionWorkoutAddTextfield.text ?? ""
        delegate?.didPressAddButton(taskName: taskName, timer: timer, description: description)
    }

    func configure(taskName: String, timer: String, description: String) {
        nameWorkoutAddTextfield.text = taskName
        timerAddTextfield.text = timer
        descriptionWorkoutAddTextfield.text = description
    }
}

// MARK: - UIPickerViewDelegate and UIPickerViewDataSource
extension AddTaskView {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return hours.count
        case 1, 2: return minutesAndSeconds.count
        default: return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return "\(hours[row])h"
        case 1: return "\(minutesAndSeconds[row])m"
        case 2: return "\(minutesAndSeconds[row])s"
        default: return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0: selectedTime.hours = hours[row]
        case 1: selectedTime.minutes = minutesAndSeconds[row]
        case 2: selectedTime.seconds = minutesAndSeconds[row]
        default: break
        }
        timerAddTextfield.text = String(format: "%02d:%02d:%02d", selectedTime.hours, selectedTime.minutes, selectedTime.seconds)
    }
}
