//
//  UIFont+Extension.swift
//  Betus
//
//  Created by Gio's Mac on 25.11.24.
//


import UIKit

extension UIFont {
    //MARK: font extension
    static func koronaOneRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "KronaOne-Regular", size: size) ?? .systemFont(ofSize: size)
    }

    static func latoBlack(size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Black", size: size) ?? .systemFont(ofSize: size)
    }

    static func latoBlackItalic(size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-BlackItalic", size: size) ?? .systemFont(ofSize: size)
    }

    static func latoBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Bold", size: size) ?? .systemFont(ofSize: size)
    }

    static func latoBoldItalic(size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-BoldItalic", size: size) ?? .systemFont(ofSize: size)
    }

    static func latoItalic(size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Italic", size: size) ?? .systemFont(ofSize: size)
    }

    static func latoLight(size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Light", size: size) ?? .systemFont(ofSize: size)
    }

    static func latoLightItalic(size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-LightItalic", size: size) ?? .systemFont(ofSize: size)
    }

    static func latoRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Regular", size: size) ?? .systemFont(ofSize: size)
    }

    static func latoThin(size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Thin", size: size) ?? .systemFont(ofSize: size)
    }

    static func latoThinItalic(size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-ThinItalic", size: size) ?? .systemFont(ofSize: size)
    }
}
