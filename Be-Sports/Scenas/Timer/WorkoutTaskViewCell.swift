//
//  WorkoutTaskViewCell.swift
//  Betus
//
//  Created by Gio's Mac on 10.12.24.
//

import UIKit
import SnapKit

class WorkoutTaskViewCell: UICollectionViewCell {
    private lazy var taskView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 18
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = ""
        view.textColor = UIColor(hexString: "#FFFFFF")
        view.font = UIFont.latoRegular(size: 14)
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = ""
        view.textColor = UIColor(hexString: "#FFFFFF").withAlphaComponent(0.4)
        view.font = UIFont.latoRegular(size: 12)
        view.numberOfLines = 0
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(taskView)
        taskView.addSubview(nameLabel)
        taskView.addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        taskView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(taskView.snp.top).offset(20)
            make.leading.equalTo(taskView.snp.leading).offset(20)
            make.height.equalTo(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalTo(taskView.snp.leading).offset(20)
        }
    }
    
    func configure(with data: Task) {
        nameLabel.text = data.title
        descriptionLabel.text = data.description
    }
}
