

import UIKit
import SnapKit

protocol ImageViewDelegate: AnyObject {
    func presentImagePicker(_ picker: UIImagePickerController, for cell: ImageViewCell)
}

class ImageViewCell: UICollectionViewCell {

    weak var delegate: ImageViewDelegate?

    lazy var workoutImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 16
        view.contentMode = .center
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "userImageHolder")
        view.isUserInteractionEnabled = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraint()

        tapGestureForUserImageView()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(workoutImage)
    }

    private func setupConstraint() {
        workoutImage.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(5 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(12 * Constraint.xCoeff)
            make.height.equalTo(287 * Constraint.yCoeff)
        }
    }

    private func tapGestureForUserImageView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapUserImageView))
        workoutImage.addGestureRecognizer(tapGesture)
        workoutImage.isUserInteractionEnabled = true
    }

    @objc private func didTapUserImageView() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = delegate as? (UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        delegate?.presentImagePicker(imagePicker, for: self)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            workoutImage.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            workoutImage.image = originalImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func updateUserImage(_ image: UIImage) {
        workoutImage.image = image
    }

    func updateUserImageAfterPressRightButton() {
        workoutImage.image = UIImage(named: "userImageHolder")
    }
}
