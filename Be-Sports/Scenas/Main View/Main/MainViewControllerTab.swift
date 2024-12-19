//
//  MainViewController.swift
//  Betus
//
//  Created by Gio's Mac on 12.12.24.
//

import UIKit

class MainViewControllerTab: UITabBarController,  UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#101538")
        self.delegate = self

        // Instantiate the three view controllers
        let workoutsViewVC = WorkoutViewController()
        let likedWorkoutVC = LikedWorkoutViewController()
        let addWorkoutsVC = AddWorkoutViewController()

        // Create Navigation Controllers for each (optional for navigation stack)
        let workouts = UINavigationController(rootViewController: workoutsViewVC)
        let likeWorkouts = UINavigationController(rootViewController: likedWorkoutVC)
        let addedWorkouts = UINavigationController(rootViewController: addWorkoutsVC)

        workouts.navigationBar.isHidden = true
        likeWorkouts.navigationBar.isHidden = true
        addedWorkouts.navigationBar.isHidden = true

        // Configure tab bar items
        workouts.tabBarItem = UITabBarItem(title: nil, image: resizeImage(named: "home", size: CGSize(width: 30, height: 30)), tag: 0)
        likeWorkouts.tabBarItem = UITabBarItem(title: nil, image: resizeImage(named: "heart", size: CGSize(width: 30, height: 30)), tag: 1)
        addedWorkouts.tabBarItem = UITabBarItem(title: nil, image: resizeImage(named: "plus", size: CGSize(width: 30, height: 30)), tag: 2)

        // Assign view controllers to the Tab Bar
        viewControllers = [workouts, likeWorkouts, addedWorkouts]

        workouts.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 30, bottom: -6, right: -30)
        likeWorkouts.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        addedWorkouts.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: -30, bottom: -6, right: 30)

        // Style the Tab Bar (optional)
        tabBar.tintColor = .yellow
        tabBar.unselectedItemTintColor = .white // Color for unselected tabs
        tabBar.barTintColor = UIColor(hexString: "#101538")
        tabBar.backgroundColor = UIColor(hexString: "#101538")
        tabBar.isTranslucent = false
    }

    private func resizeImage(named: String, size: CGSize) -> UIImage? {
        guard let image = UIImage(named: named) else { return nil }
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
