//
//  UiColorGradiation+Exttention.swift
//  Betus
//
//  Created by Gio's Mac on 25.11.24.
//

import UIKit

//extension UIView {
//    /// Creates a gradient background view with a central yellow color (#E5D820) and blue at the corners.
//    /// - Parameters:
//    ///   - size: The size of the gradient view (default: `CGSize(width: 404, height: 258)`).
//    /// - Returns: A `UIView` with the specified gradient applied.
//    static func gradientViewWithCenterYellow(size: CGSize = CGSize(width: 404, height: 258)) -> UIView {
//        let gradientView = UIView(frame: CGRect(origin: .zero, size: size))
//
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = gradientView.bounds
//
//        // Define the colors
//        gradientLayer.colors = [
//            UIColor(red: 229/255, green: 216/255, blue: 32/255, alpha: 1).cgColor, // Yellow (#E5D820)
//            UIColor(red: 10/255, green: 15/255, blue: 55/255, alpha: 1).cgColor    // Blue
//        ]
//
//        // Define the radial gradient
//        if #available(iOS 13.0, *) {
//            gradientLayer.type = .radial
//        }
//
//        // Specify the locations for the gradient
//        gradientLayer.locations = [0.3, 1.0] // 30% yellow center, transitioning to blue in the corners
//
//        // Add the gradient to the view
//        gradientView.layer.addSublayer(gradientLayer)
//
//        return gradientView
//    }
//}

extension UIView {
    /// Applies a vertical gradient background with the specified colors.
//    func applyGradientBackground(
//        colors: [UIColor],
//        startPoint: CGPoint = CGPoint(x: -0.25, y: -0.45),
//        endPoint: CGPoint = CGPoint(x: 0.0, y: 0.4)
//    ) {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = self.bounds
//        gradientLayer.colors = colors.map { $0.cgColor }
//        gradientLayer.startPoint = startPoint
//        gradientLayer.endPoint = endPoint
//
//        // Ensure the gradient resizes with the view
//        gradientLayer.frame = self.bounds
//        gradientLayer.masksToBounds = true
//
//        // Remove any existing gradient layers to prevent duplicates
//        self.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
//
//        // Add the new gradient layer
//        self.layer.insertSublayer(gradientLayer, at: 0)
//    }

    /// Applies a vertical gradient background with the specified or default colors.
        func applyGradientBackground(
            colors: [UIColor] = [
                UIColor(red: 229/255, green: 216/255, blue: 32/255, alpha: 1),
                UIColor(red: 10/255, green: 15/255, blue: 55/255, alpha: 1)
            ],
            startPoint: CGPoint = CGPoint(x: -0.25, y: -0.45),
            endPoint: CGPoint = CGPoint(x: 0.0, y: 0.4)
        ) {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds
            gradientLayer.colors = colors.map { $0.cgColor }
            gradientLayer.startPoint = startPoint
            gradientLayer.endPoint = endPoint

            // Ensure the gradient resizes with the view
            gradientLayer.frame = self.bounds
            gradientLayer.masksToBounds = true

            // Remove any existing gradient layers to prevent duplicates
            self.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })

            // Add the new gradient layer
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
}

